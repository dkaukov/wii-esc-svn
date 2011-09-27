;**** **** **** **** ****
;
;Die Benutzung der Software ist mit folgenden Bedingungen verbunden:
;
;1. Da ich alles kostenlos zur Verf�gung stelle, gebe ich keinerlei Garantie
;   und �bernehme auch keinerlei Haftung f�r die Folgen der Benutzung.
;
;2. Die Software ist ausschlie�lich zur privaten Nutzung bestimmt. Ich
;   habe nicht gepr�ft, ob bei gewerblicher Nutzung irgendwelche Patentrechte
;   verletzt werden oder sonstige rechtliche Einschr�nkungen vorliegen.
;
;3. Jeder darf �nderungen vornehmen, z.B. um die Funktion seinen Bed�rfnissen
;   anzupassen oder zu erweitern. Ich w�rde mich freuen, wenn ich weiterhin als
;   Co-Autor in den Unterlagen erscheine und mir ein Link zur entprechenden Seite
;   (falls vorhanden) mitgeteilt wird.
;
;4. Auch nach den �nderungen sollen die Software weiterhin frei sein, d.h. kostenlos bleiben.
;
;!! Wer mit den Nutzungbedingungen nicht einverstanden ist, darf die Software nicht nutzen !!
.include "m8def.inc"


.equ	NO_POWER	 = 256-MIN_DUTY		; (POWER_OFF)
.equ    MAX_POWER        = 256-POWER_RANGE      ; (FULL_POWER)
.equ    CONTROL_TOT      = 50                   ; time = NUMBER x 64ms
.equ    CURRENT_ERR_MAX  = 3                    ; performs a reset after MAX errors

.equ	T1STOP	   = 0x00
.equ	T1CK8	   = 0x02
.equ	EXT0_DIS   = 0x00	; disable ext0int
.equ	EXT0_EN	   = 0x40	; enable ext0int

;**** **** **** **** ****
; Register Definitions
.def	i_sreg		 = r1	; status register save in interrupts
.def	tcnt0_power_on	 = r2	; timer0 counts nFETs are switched on
;.def	...              = r3	; 
;.def   ...              = r4   ; 
;.def   ...              = r5   ;
.def    tcnt0_pwroff     = r6   ; timer0 counts nFETs are switched off

.def	start_rcpuls_l	 = r7
.def	start_rcpuls_h	 = r8
.def	motor_count 	 = r9
;.def			 = r10
.def	control_timeout	 = r11
.def	current_err	 = r12	; counts consecutive current errors

.def	sys_control	 = r13
.def	t1_timeout	 = r14
.def	run_control	 = r15


.def	temp1	= r16			; main temporary
.def	temp2	= r17			; main temporary
.def	temp3	= r18			; main temporary
.def	temp4	= r19			; main temporary

.def	i_temp1	= r20			; interrupt temporary
.def	i_temp2	= r21			; interrupt temporary
.def	i_temp3	= r22			; interrupt temporary

.def	flags0	= r23	; state flags
	.equ	OCT1_PENDING	= 0	; if set, output compare interrunpt is pending
	.equ	UB_LOW 		= 1	; set if accu voltage low
	.equ	I_pFET_HIGH	= 2	; set if over-current detect
	.equ	GET_STATE	= 3	; set if state is to be send
	.equ	C_FET		= 4	; if set, C-FET state is to be changed
	.equ	A_FET		= 5	; if set, A-FET state is to be changed
	     ; if neither 1 nor 2 is set, B-FET state is to be changed
	.equ	I_OFF_CYCLE	= 6	; if set, current off cycle is active
	.equ	T1OVFL_FLAG	= 7	; each timer1 overflow sets this flag - used for voltage + current watch

.def	flags1	= r24	; state flags
	.equ	POWER_OFF	= 0	; switch fets on disabled
	.equ	FULL_POWER	= 1	; 100% on - don't switch off, but do OFF_CYCLE working
	.equ	CALC_NEXT_OCT1	= 2	; calculate OCT1 offset, when wait_OCT1_before_switch is called
	.equ	RC_PULS_UPDATED	= 3	; new rc-puls value available
	.equ	EVAL_RC_PULS	= 4	; if set, new rc puls is evaluated, while waiting for OCT1
	.equ	EVAL_SYS_STATE	= 5	; if set, overcurrent and undervoltage are checked
	.equ	EVAL_RPM	= 6	; if set, next PWM on should look for current
	.equ	EVAL_PWM	= 7	; if set, PWM should be updated

.def	flags2	= r25
	.equ	RPM_RANGE1	= 0	; if set RPM is lower than 1831 RPM
	.equ	RPM_RANGE2	= 1	; if set RPM is between 1831 RPM and 3662 RPM
	.equ	SCAN_TIMEOUT	= 2	; if set a startup timeout occurred
	.equ	POFF_CYCLE	= 3	; if set one commutation cycle is performed without power
	.equ	COMP_SAVE	= 4	; if set ACO was high
	.equ	STARTUP		= 5	; if set startup-phase is active
	.equ	RC_INTERVAL_OK	= 6	; 
	.equ	NO_SYNC		= 7	; 

; here the XYZ registers are placed ( r26-r31)

; ZH = new_duty		; PWM destination


;**** **** **** **** ****
; RAM Definitions
.dseg					;EEPROM segment
.org SRAM_START

tcnt1_sav_l:	.byte	1	; actual timer1 value
tcnt1_sav_h:	.byte	1
last_tcnt1_l:	.byte	1	; last timer1 value
last_tcnt1_h:	.byte	1
timing_l:	.byte	1	; holds time of 4 commutations 
timing_h:	.byte	1
timing_x:	.byte	1

timing_acc_l:	.byte	1	; holds the average time of 4 commutations 
timing_acc_h:	.byte	1
timing_acc_x:	.byte	1

rpm_l:		.byte	1	; holds the average time of 4 commutations 
rpm_h:		.byte	1
rpm_x:		.byte	1

wt_comp_scan_l:	.byte	1	; time from switch to comparator scan
wt_comp_scan_h:	.byte	1       
com_timing_l:	.byte	1	; time from zero-crossing to switch of the appropriate FET
com_timing_h:	.byte	1
wt_OCT1_tot_l:	.byte	1	; OCT1 waiting time
wt_OCT1_tot_h:	.byte	1
zero_wt_l:	.byte	1
zero_wt_h:	.byte	1
last_com_l:	.byte	1
last_com_h:	.byte	1

stop_rcpuls_l:	.byte	1
stop_rcpuls_h:	.byte	1
new_rcpuls_l:	.byte	1
new_rcpuls_h:	.byte	1

duty_offset:	.byte	1
goodies:	.byte	1
comp_state:	.byte	1
uart_command:	.byte	1

uart_data:	.byte	100		; only for debug requirements


;**** **** **** **** ****
; ATmega8 interrupts

;.equ	INT0addr=$001	; External Interrupt0 Vector Address
;.equ	INT1addr=$002	; External Interrupt1 Vector Address
;.equ	OC2addr =$003	; Output Compare2 Interrupt Vector Address
;.equ	OVF2addr=$004	; Overflow2 Interrupt Vector Address
;.equ	ICP1addr=$005	; Input Capture1 Interrupt Vector Address
;.equ	OC1Aaddr=$006	; Output Compare1A Interrupt Vector Address
;.equ	OC1Baddr=$007	; Output Compare1B Interrupt Vector Address
;.equ	OVF1addr=$008	; Overflow1 Interrupt Vector Address
;.equ	OVF0addr=$009	; Overflow0 Interrupt Vector Address
;.equ	SPIaddr =$00a	; SPI Interrupt Vector Address
;.equ	URXCaddr=$00b	; USART Receive Complete Interrupt Vector Address
;.equ	UDREaddr=$00c	; USART Data Register Empty Interrupt Vector Address
;.equ	UTXCaddr=$00d	; USART Transmit Complete Interrupt Vector Address
;.equ	ADCCaddr=$00e	; ADC Interrupt Vector Address
;.equ	ERDYaddr=$00f	; EEPROM Interrupt Vector Address
;.equ	ACIaddr =$010	; Analog Comparator Interrupt Vector Address
;.equ	TWIaddr =$011	; Irq. vector address for Two-Wire Interface
;.equ	SPMaddr =$012	; SPM complete Interrupt Vector Address
;.equ	SPMRaddr =$012	; SPM complete Interrupt Vector Address
;-----bko-----------------------------------------------------------------

;**** **** **** **** ****
.cseg
.org 0
;**** **** **** **** ****

;-----bko-----------------------------------------------------------------
; reset and interrupt jump table
		rjmp	reset
		rjmp	ext_int0
		nop	; ext_int1
		nop	; t2oc_int
		nop	; t2ovfl_int
		nop	; icp1
		rjmp	t1oca_int
		nop	; t1ocb_int
		rjmp	t1ovfl_int
		rjmp	t0ovfl_int
		nop	; spi_int
		nop	; urxc
		nop	; udre
		nop	; utxc
; not used	nop	; adc_int
; not used	nop	; eep_int
; not used	nop	; aci_int
; not used	nop	; wire2_int
; not used	nop	; spmc_int


version:	.db	0x0d, 0x0a
		.db	"bk",Typ,"410r06"
		.db	0x0d, 0x0a

;******************************************************************************
;* MACRO
;*	SetPWMi
;* DECRIPTION
;*	Set PWM immidiate
;* USAGE
;*	SetPWMi(val)
;* STATISTICS
;*      Register usage: none
;******************************************************************************
.macro SetPWMi
                push    temp1
                ldi     temp1, @0
                com     temp1
                rcall   set_pwm
;                rcall   eval_power_state
                pop     temp1
.endmacro


;-----bko-----------------------------------------------------------------
; init after reset

reset:		ldi	temp1, high(RAMEND)	; stack = RAMEND
		out	SPH, temp1
		ldi	temp1, low(RAMEND)
		out 	SPL, temp1

.if READ_CALIBRATION == 1
                ; oscillator calibration byte is written into the uppermost position
                ; of the eeprom - by the script 1n1p.e2s an ponyprog
                ;CLEARBUFFER
                ;LOAD-PROG 1n1p.hex
                ;PAUSE "Connect and powerup the circuit, are you ready?"
                ;READ-CALIBRATION 0x21FF DATA 3     # <EEProm 8Mhz
                ;ERASE-ALL
                ;WRITE&VERIFY-ALL
		ldi 	temp1,0x01
		out	EEARH,temp1
		ldi	temp1,$ff
		out	EEARL,temp1
		sbi	EECR,EERE
		in	temp1,EEDR
		out 	osccal ,temp1  ;schreiben
.endif

	; portB
		ldi	temp1, INIT_PB
		out	PORTB, temp1
		ldi	temp1, DIR_PB
		out	DDRB, temp1

	; portC
		ldi	temp1, INIT_PC
		out	PORTC, temp1
		ldi	temp1, DIR_PC
		out	DDRC, temp1

	; portD
		ldi	temp1, INIT_PD
		out	PORTD, temp1
		ldi	temp1, DIR_PD
		out	DDRD, temp1

	; timer0: PWM + beep control = 0x02 	; start timer0 with CK/8 (0.5�s/count)
		ldi	temp1, 0x02
		out	TCCR0, temp1

	; timer1: commutation control = 0x02	; start timer1 with CK/8 (0.5�s/count)
		ldi	temp1, T1CK8
		out	TCCR1B, temp1

	; reset state flags
		clr	flags0
		clr	flags1
		clr	flags2

	; clear RAM
		clr	XH
		ldi	XL, low (SRAM_START)
		clr	temp1
clear_ram:	st	X+, temp1
		cpi	XL, uart_data+1
		brlo	clear_ram

	; power off
		rcall	switch_power_off

	; reset rc puls timeout
		ldi	temp1, CONTROL_TOT*CLK_SCALE
		mov	control_timeout, temp1
		
		rcall	wait260ms	; wait a while
		rcall	wait260ms

		rcall	beep_f1
		rcall	wait30ms
		rcall	beep_f2
		rcall	wait30ms
		rcall	beep_f3
		rcall	wait30ms

control_start:	; init variables
                SetPWMi(MIN_DUTY-1)
		ldi	temp1, 0		; reset error counters
		mov	current_err,temp1
		mov	sys_control, temp1

	; init registers and interrupts
		ldi	temp1, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0)
		out	TIFR, temp1		; clear TOIE1,OCIE1A & TOIE0
		out	TIMSK, temp1		; enable TOIE1,OCIE1A & TOIE0 interrupts

		sei				; enable all interrupts

; init rc-puls
		ldi	temp1, (1<<ISC01)+(1<<ISC00)
		out	MCUCR, temp1		; set next int0 to rising edge
		ldi	temp1, EXT0_EN		; enable ext0int
		out	GIMSK, temp1
i_rc_puls1:	ldi	temp3, 10		; wait for this count of receiving power off
i_rc_puls2:	sbrs	flags1, RC_PULS_UPDATED
		rjmp	i_rc_puls2
		lds	temp1, new_rcpuls_l
		lds	temp2, new_rcpuls_h
		cbr	flags1, (1<<RC_PULS_UPDATED) ; rc impuls value is read out
		subi	temp1, low  (MIN_RC_PULS*CLK_SCALE)	; power off received ?
		sbci	temp2, high (MIN_RC_PULS*CLK_SCALE)
		brcc	i_rc_puls1		; no - reset counter
		dec	temp3			; yes - decrement counter
		brne	i_rc_puls2		; repeat until zero
		cli				; disable all interrupts
		rcall	beep_f4			; signal: rcpuls ready
		rcall	beep_f4
		rcall	beep_f4
		sei				; enable all interrupts

		ldi	temp1, 30
		sts	duty_offset, temp1

		rcall	set_all_timings

		rjmp	init_startup
		
;-----bko-----------------------------------------------------------------
; external interrupt0 = rc pulse input
ext_int0:	in	i_sreg, SREG
		clr	i_temp1			; disable extint edge may be changed
                out     GIMSK, i_temp1

; evaluate edge of this interrupt
		in	i_temp1, MCUCR
		sbrs	i_temp1, ISC00
		rjmp	falling_edge		; bit is clear = falling edge

; should be rising edge - test rc impuls level state for possible jitter
		sbis	PIND, rcp_in
		rjmp	extint1_exit		; jump, if low state

; rc impuls is at high state
		ldi	i_temp1, (1<<ISC01)
		out	MCUCR, i_temp1		; set next int0 to falling edge

; get timer1 values
		in	i_temp1, TCNT1L
		in	i_temp2, TCNT1H
		mov	start_rcpuls_l, i_temp1
		mov	start_rcpuls_h, i_temp2
; test rcpulse interval
		cbr	flags2, (1<<RC_INTERVAL_OK) ; preset to not ok
		lds	i_temp3, stop_rcpuls_l
		sub	i_temp1, i_temp3
		lds	i_temp3, stop_rcpuls_h
		sbc	i_temp2, i_temp3
		cpi	i_temp1, low (MAX_INT_FR*CLK_SCALE)
		ldi	i_temp3, high(MAX_INT_FR*CLK_SCALE)	  ; test range high
		cpc	i_temp2, i_temp3
		brsh	extint1_fail		                  ; through away
                cpi     i_temp1, low (MIN_INT_FR*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_FR*CLK_SCALE)      ; test range low
		cpc	i_temp2, i_temp3
		brlo	extint1_fail		                  ; through away
		sbr	flags2, (1<<RC_INTERVAL_OK) ; set to rc impuls value is ok !
		rjmp	extint1_exit
extint1_fail:	tst	control_timeout
		breq	extint1_exit
                dec     control_timeout
		rjmp	extint1_exit
; rc impuls is at low state
falling_edge:   sbic    PIND, rcp_in            ; test level of rc impuls
		rjmp	extint1_exit		; seems to be a spike
		ldi	i_temp1, (1<<ISC01)+(1<<ISC00)
		out	MCUCR, i_temp1		; set next int0 to rising edge
		sbrc	flags1, RC_PULS_UPDATED
		rjmp	extint1_exit
; get timer1 values
		in	i_temp1, TCNT1L
		in	i_temp2, TCNT1H
		sts	stop_rcpuls_l, i_temp1	; prepare next interval evaluation
		sts	stop_rcpuls_h, i_temp2
		sbrs	flags2, RC_INTERVAL_OK
		rjmp	extint1_exit
                cbr     flags2, (1<<RC_INTERVAL_OK) ; flag is evaluated
		sub	i_temp1, start_rcpuls_l
		sbc	i_temp2, start_rcpuls_h
	; save impuls length
		sts	new_rcpuls_l, i_temp1
		sts	new_rcpuls_h, i_temp2
		cpi	i_temp1, low (MAX_INT_RF*CLK_SCALE)
		ldi	i_temp3, high(MAX_INT_RF*CLK_SCALE)	; test range high
		cpc	i_temp2, i_temp3
		brsh	extint1_fail		; through away
                cpi     i_temp1, low (MIN_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_RF*CLK_SCALE)    ; test range low
		cpc	i_temp2, i_temp3
		brlo	extint1_fail		; through away
		sbr	flags1, (1<<RC_PULS_UPDATED) ; set to rc impuls value is ok !
		ldi	i_temp1, CONTROL_TOT*CLK_SCALE
		mov	control_timeout, i_temp1
; enable int1 again -  also entry for spike detect
extint1_exit:   ldi     i_temp2, EXT0_EN
		out	GIMSK, i_temp2
		out	SREG, i_sreg
		reti
;-----bko-----------------------------------------------------------------
; output compare timer1 interrupt
t1oca_int:	in	i_sreg, SREG
		cbr	flags0, (1<<OCT1_PENDING) ; signal OCT1 passed
		out	SREG, i_sreg
		reti
;-----bko-----------------------------------------------------------------
; overflow timer1 / happens all 32768�s / 65536�s
t1ovfl_int:	in	i_sreg, SREG
		sbr	flags0, (1<<T1OVFL_FLAG)

		tst	t1_timeout
		breq	t1ovfl_10
		dec	t1_timeout

t1ovfl_10:	tst	control_timeout
		brne	t1ovfl_20
		clr	ZH
		rjmp	t1ovfl_99
t1ovfl_20:	dec	control_timeout

t1ovfl_99:	out	SREG, i_sreg
		reti
;-----bko-----------------------------------------------------------------
; timer0 overflow interrupt
t0ovfl_int:     in	i_sreg, SREG
;                DbgLEDOff
                sbrc    flags0, I_OFF_CYCLE
                rjmp    t0_on_cycle

t0_off_cycle:   
		out	TCNT0, tcnt0_pwroff	; reload t0
                ; mirror inverted ACO to bit-var
		sbr	flags2, (1<<COMP_SAVE)
		sbic	ACSR, ACO		
                cbr     flags2, (1<<COMP_SAVE)
                ; PWM state = off cycle
                sbr     flags0, (1<<I_OFF_CYCLE)
	        ; We can just turn them all off as we only have one nFET on at a
	        ; time, and interrupts are disabled during beeps.
		CnFET_off
		AnFET_off
                BnFET_off


                mov     i_temp1, tcnt0_pwroff
                cpi     i_temp1, 0
                breq    t0_on_cycle_t1
                cpi     i_temp1, 1
                breq    t0_on_cycle_t0

                out     SREG, i_sreg
                reti

t0_on_cycle_t1:
                nop
                nop                
                nop
                nop                
                nop
;                nop                
;                nop
;                nop                
                
                
t0_on_cycle_t0:
;                nop
;                nop      
;                nop
;                nop      
;                DbgLEDOn          


t0_on_cycle:
                sbrc    flags1, POWER_OFF
                rjmp    t0_on_cycle_tcnt
                ; switch appropriate nFET on as soon as possible
		sbrs	flags0, C_FET		; is Cn choppered ?
		rjmp	test_AnFET_on			; .. no - test An
		CnFET_on		        ; Cn on
		rjmp	t0_on_cycle_tcnt
test_AnFET_on:	sbrs	flags0, A_FET		; is An choppered ?
		rjmp	sw_BnFET_on			; .. no - Bn has to be choppered
		AnFET_on		        ; An on
		rjmp	t0_on_cycle_tcnt
sw_BnFET_on:    
                BnFET_on                        ; Bn on
t0_on_cycle_tcnt:
                cbr     flags0, (1<<I_OFF_CYCLE); PWM state = on cycle
                mov     i_temp1, tcnt0_power_on
                cbr     flags1, (1<<FULL_POWER)
                cpi     i_temp1, MAX_POWER
                brsh    t0_on_cycle_not_full_power
                sbr     flags1, (1<<FULL_POWER)
                sbr     flags0, (1<<I_OFF_CYCLE)
t0_on_cycle_not_full_power:
                out     TCNT0, tcnt0_power_on   ; reload t0
                out     SREG, i_sreg
                reti                   
;-----bko-----------------------------------------------------------------
; beeper: timer0 is set to 1�s/count
beep_f1:	ldi	temp4, 200
		ldi	temp2, 80
		rjmp	beep

beep_f2:	ldi	temp4, 180
		ldi	temp2, 100
		rjmp	beep

beep_f3:	ldi	temp4, 160
		ldi	temp2, 120
		rjmp	beep

beep_f4:	ldi	temp4, 100
		ldi	temp2, 200
		rjmp	beep

beep:		clr	temp1
		out	TCNT0, temp1
		BpFET_on		; BpFET on
		AnFET_on		; CnFET on
beep_BpCn10:	in	temp1, TCNT0
		cpi	temp1, 32*CLK_SCALE		; 32�s on
		brne	beep_BpCn10
		BpFET_off		; BpFET off
		AnFET_off		; CnFET off
		ldi	temp3, 8*CLK_SCALE		; 2040�s off
beep_BpCn12:	clr	temp1
		out	TCNT0, temp1
beep_BpCn13:	in	temp1, TCNT0
		cp	temp1, temp4
		brne	beep_BpCn13
		dec	temp3
		brne	beep_BpCn12
		dec	temp2
		brne	beep
		ret

wait30ms:	ldi	temp2, 15*CLK_SCALE
beep_BpCn20:	ldi	temp3, 8*CLK_SCALE
beep_BpCn21:	clr	temp1
		out	TCNT0, temp1
beep_BpCn22:	in	temp1, TCNT0
		cpi	temp1, 255
		brne	beep_BpCn22
		dec	temp3
		brne	beep_BpCn21
		dec	temp2
		brne	beep_BpCn20
		ret

	; 256 periods = 261ms silence
wait260ms:	ldi	temp2, 127*CLK_SCALE	; = 256
beep2_BpCn20:	ldi	temp3, 8*CLK_SCALE
beep2_BpCn21:	clr	temp1
		out	TCNT0, temp1
beep2_BpCn22:	in	temp1, TCNT0
		cpi	temp1, 255
		brne	beep2_BpCn22
		dec	temp3
		brne	beep2_BpCn21
		dec	temp2
		brne	beep2_BpCn20
                ret                
;-----bko-----------------------------------------------------------------
tcnt1_to_temp:	ldi	temp4, EXT0_DIS		; disable ext0int
		out	GIMSK, temp4
		ldi	temp4, T1STOP		; stop timer1
		out	TCCR1B, temp4
		ldi	temp4, T1CK8		; preload temp with restart timer1
		in	temp1, TCNT1L		;  - the preload cycle is needed to complete stop operation
		in	temp2, TCNT1H
		out	TCCR1B, temp4
		ret				; !!! ext0int stays disabled - must be enabled again by caller
	; there seems to be only one TEMP register in the AVR
	; if the ext0int interrupt falls between readad LOW value while HIGH value is captured in TEMP and
	; read HIGH value, TEMP register is changed in ext0int routine
;-----bko-----------------------------------------------------------------
evaluate_rc_puls:
                EvaluatePWC
;-----bko-----------------------------------------------------------------
evaluate_sys_state:
		cbr	flags1, (1<<EVAL_SYS_STATE)
		sbrs	flags0, T1OVFL_FLAG
		rjmp	eval_sys_s99

	; do it not more often as every 32�s
		cbr	flags0, (1<<T1OVFL_FLAG)

	; control current
eval_sys_i:	rjmp	eval_sys_i_ok

		mov	i_temp1, current_err
		cpi	i_temp1, CURRENT_ERR_MAX
		brcc	panic_exit
		inc	current_err
		rjmp	eval_sys_ub

eval_sys_i_ok:	tst	current_err
		breq	eval_sys_ub
		dec	current_err

eval_sys_ub:	
eval_sys_s99:	ret

panic_exit:	; !!!!!! OVERCURRENT !!!!!!!!
		cli
		rjmp	reset
;-----bko-----------------------------------------------------------------
;******************************************************************************
;* FUNCTION
;*	set_pwm
;* DECRIPTION
;*	Calculates tcnt0 values for ON and off cycles.
;*	Performs PWM correction.
;* USAGE
;*	temp1
;* STATISTICS
;*	Register usage: temp1
;******************************************************************************
set_pwm:
;                inc     temp1                   ; Make it shorter by 3 cycles
;                inc     temp1
;                inc     temp1
                mov     tcnt0_power_on, temp1
                subi    temp1, -POWER_RANGE     
                com     temp1   
                inc     temp1            
                inc     temp1            
                mov     tcnt0_pwroff, temp1
                ret

;******************************************************************************
;* FUNCTION
;*	eval_power_state
;* DECRIPTION
;*	Evaluates current state
;* USAGE
;*	temp1
;* STATISTICS
;*	Register usage: none
;******************************************************************************
eval_power_state:
                cpi     temp1, MAX_POWER+1
                brsh    not_full_power
                ; FULL POWER
;		sbr	flags1, (1<<FULL_POWER)	; tcnt0_power_on = MAX_POWER means FULL_POWER
                cbr     flags1, (1<<POWER_OFF)
                ;DbgLEDOn
		rjmp	eval_power_state_exit
not_full_power:	cpi	temp1, NO_POWER
		brlo	neither_full_nor_off
	; POWER OFF
;		cbr	flags1, (1<<FULL_POWER)	; tcnt0_power_on = NO_POWER means power off
                sbr     flags1, (1<<POWER_OFF)
                ;DbgLEDOff
		rjmp	eval_power_state_exit
neither_full_nor_off:
;		cbr	flags1, (1<<FULL_POWER)	; tcnt0_power_on = MAX_POWER means FULL_POWER
                cbr     flags1, (1<<POWER_OFF)
                ;DbgLEDOff
eval_power_state_exit:    
                sbrc    flags2, POFF_CYCLE
		sbr	flags1, (1<<POWER_OFF)
                ret
;******************************************************************************
;* FUNCTION
;*	set_new_duty
;* DECRIPTION
;*     1) Evaluates duty cycle
;*     2) Limits power to sys_control
;*     3) Limits starup power
;*     4) Limits RPM ranges power
;*     5) Increments sys_control up to POWER_RANGE
;* USAGE
;*      ZH (0-POWER_RANGE)
;* STATISTICS
;*      Register usage: temp1, temp2, temp3 
;******************************************************************************
set_new_duty:   
                mov     temp1, ZH
		mov	temp2, sys_control	; Limit PWM to sys_control
		cp	temp1, temp2
		brcs	set_new_duty10
		mov	temp1, temp2
                cpi     temp2, POWER_RANGE
		breq	set_new_duty10
                inc     sys_control             ; Build up sys_control to POWER_RANGE
set_new_duty10: lds     temp2, timing_x
                tst     temp2
                brne    set_new_duty12
                lds     temp2, timing_h         ; get actual RPM reference high
                cpi     temp2, PWR_RANGE1*CLK_SCALE ; lower range1 ?
                brcs    set_new_duty20          ; on carry - test next range ; lower as range1
set_new_duty12: sbr     flags2, (1<<RPM_RANGE1)
                sbr     flags2, (1<<RPM_RANGE2)
                ldi     temp2, PWR_MAX_RPM1     ; higher than range1 power max ?
                cp      temp1, temp2
                brcs    set_new_duty40          ; on carry - not higher, no restriction
                mov     temp1, temp2            ; low (range1) RPM - set PWR_MAX_RPM1
                rjmp    set_new_duty40          ; higher as range1
set_new_duty20: cpi     temp2, PWR_RANGE2*CLK_SCALE; lower range2 ?
                brcs    set_new_duty30          ; on carry - not lower, no restriction
set_new_duty22: cbr     flags2, (1<<RPM_RANGE1)
                sbr     flags2, (1<<RPM_RANGE2)
                ldi     temp2, PWR_MAX_RPM2     ; higher than range2 power max ?
                cp      temp1, temp2
                brcs    set_new_duty40          ; on carry - not higher, no restriction
                mov     temp1, temp2            ; low (range2) RPM - set PWR_MAX_RPM2
                rjmp    set_new_duty40          ; higher as range2
set_new_duty30: cbr     flags2, (1<<RPM_RANGE1)+(1<<RPM_RANGE2)  ; range limits are evaluated - look for STARTUP conditions
set_new_duty40: sbrs    flags2, STARTUP
                rjmp    set_new_duty50
                ldi     temp3, PWR_STARTUP      ; at least PWR_STARTUP ?
                cp      temp1, temp3
                brcc    set_new_duty42          ; on no carry - higher than PWR_STARTUP, test PWR_MAX_STARTUP
                ldi     temp1, PWR_STARTUP      ; lower - set to PWR_STARTUP
                rjmp    set_new_duty50
set_new_duty42: ldi     temp3, PWR_MAX_STARTUP  ; limit power in startup phase
                cp      temp1, temp3
                brcs    set_new_duty50          ; on carry - not higher, test range 2
                mov     temp1, temp3            ; set PWR_MAX_STARTUP limit
set_new_duty50: com     temp1                   ; down-count to up-count (T0)
                cli 
                rcall   eval_power_state        ; evaluate power state
                rcall   set_pwm                 ; set new PWM
                sei
                ret
;-----bko-----------------------------------------------------------------
evaluate_rpm:	cbr	flags1, (1<<EVAL_RPM)
		lds	temp3, rpm_x
		lds	temp2, rpm_h

		lds	temp1, rpm_l	; subtract 1/256
		sub	temp1, temp2
		sts	rpm_l, temp1
		lds	temp1, rpm_h
		sbc	temp1, temp3
		sts	rpm_h, temp1
		lds	temp1, rpm_x
		sbci	temp1, 0
		sts	rpm_x, temp1

		lds	temp3, timing_acc_x
		lds	temp2, timing_acc_h
		lds	temp1, timing_acc_l
		lsr	temp3		; make one complete commutation cycle
		ror	temp2
		ror	temp1
		lsr	temp3
		ror	temp2
		ror	temp1
	; temp3 is zero now - for sure !!
		sts	timing_acc_x, temp3
		sts	timing_acc_h, temp3
		sts	timing_acc_l, temp3
	; and add the result as 1/256
		lds	temp3, rpm_l
		add	temp3, temp1
		sts	rpm_l, temp3
		lds	temp3, rpm_h
		adc	temp3, temp2
		sts	rpm_h, temp3
		ldi	temp1, 0
		lds	temp3, rpm_x
		adc	temp3, temp1
		sts	rpm_x, temp3

		ret
;-----bko-----------------------------------------------------------------
set_all_timings:
		ldi	YL, low  (timeoutSTART)
		ldi	YH, high (timeoutSTART)
		sts	wt_OCT1_tot_l, YL
		sts	wt_OCT1_tot_h, YH
		ldi	temp3, 0xff
		ldi	temp4, 0x1f
		sts	wt_comp_scan_l, temp3
		sts	wt_comp_scan_h, temp4
		sts	com_timing_l, temp3
                sts     com_timing_h, temp4
set_timing_v:   
.if CLK_SCALE==1
                ldi     ZL, 0x01
.endif                
.if CLK_SCALE==2
                ldi     ZL, 0x03
.endif                
		sts	timing_x, ZL
		ldi	temp4, 0xff
		sts	timing_h, temp4
		ldi	temp3, 0xff
		sts	timing_l, temp3

		ret
;-----bko-----------------------------------------------------------------
update_timing:	rcall	tcnt1_to_temp
		sts	tcnt1_sav_l, temp1
		sts	tcnt1_sav_h, temp2
		add	temp1, YL
		adc	temp2, YH
		ldi	temp4, (1<<TOIE1)+(1<<TOIE0)
		out	TIMSK, temp4
		out	OCR1AH, temp2
		out	OCR1AL, temp1
		sbr	flags0, (1<<OCT1_PENDING)
		ldi	temp4, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0) ; enable interrupt again
		out	TIMSK, temp4
		ldi	temp4, EXT0_EN		; ext0int enable
		out	GIMSK, temp4		; enable ext0int

	; calculate next waiting times - timing(-l-h-x) holds the time of 4 commutations
		lds	temp1, timing_l
		lds	temp2, timing_h
		lds	ZL, timing_x

		sts	zero_wt_l, temp1	; save for zero crossing timeout
		sts	zero_wt_h, temp2
		tst	ZL
		breq	update_t00
		ldi	temp4, 0xff
		sts	zero_wt_l, temp4	; save for zero crossing timeout
		sts	zero_wt_h, temp4
update_t00:
		lsr	ZL			; build a quarter
		ror	temp2
		ror	temp1

		lsr	ZL
		ror	temp2
		ror	temp1
		lds	temp3, timing_l		; .. and subtract from timing
		lds	temp4, timing_h
		lds	ZL, timing_x
		sub	temp3, temp1
		sbc	temp4, temp2
		sbci	ZL, 0

		lds	temp1, tcnt1_sav_l	; calculate this commutation time
		lds	temp2, tcnt1_sav_h
		lds	YL, last_tcnt1_l
		lds	YH, last_tcnt1_h
		sts	last_tcnt1_l, temp1
		sts	last_tcnt1_h, temp2
		sub	temp1, YL
		sbc	temp2, YH
		sts	last_com_l, temp1
		sts	last_com_h, temp2

		add	temp3, temp1		; .. and add to timing
		adc	temp4, temp2
		ldi	temp2, 0
		adc	ZL, temp2

	; limit RPM to 120.000
		tst	ZL
		brne	update_t90
		tst	temp4
		breq	update_t10
		cpi	temp4, 0x01*CLK_SCALE
		brne	update_t90
		cpi	temp3, 0x4c*CLK_SCALE	; 120.000 RPM
		brcc	update_t90
	; set RPM to 120.000

update_t10:
                ldi     temp1, PWR_MAX_RPM2
                mov     sys_control, temp1

;update_t10:    ldi     temp4, 0x01*CLK_SCALE
;		ldi	temp3, 0x4c*CLK_SCALE
;		tst	run_control 
;		brne	update_t90		; just active
;		ldi	temp1, 0xff		; not active - reactivate
;		mov	run_control, temp1

update_t90:	sts	timing_l, temp3
		sts	timing_h, temp4
		sts	timing_x, ZL
.if CLK_SCALE==1
                cpi     ZL, 0x02                ; limit range to 0x1ffff
.endif                
.if CLK_SCALE==2                                
                cpi     ZL, 0x04                ; limit range to 0x3ffff
.endif                
		brcs	update_t99
		rcall	set_timing_v

update_t99:	lds	temp1, timing_acc_l
		add	temp1, temp3
		sts	timing_acc_l, temp1
		lds	temp1, timing_acc_h
		adc	temp1, temp4
		sts	timing_acc_h, temp1
		lds	temp1, timing_acc_x
		adc	temp1, ZL
		sts	timing_acc_x, temp1

		lsr	ZL			; a 16th is the next wait before scan
		ror	temp4
		ror	temp3
		lsr	ZL
		ror	temp4
		ror	temp3
		lsr	ZL
		ror	temp4
		ror	temp3
		lsr	ZL
		ror	temp4
		ror	temp3
		sts	wt_comp_scan_l, temp3
		sts	wt_comp_scan_h, temp4

	; use the same value for commutation timing (15�)
		sts	com_timing_l, temp3
		sts	com_timing_h, temp4

		ret
;-----bko-----------------------------------------------------------------
calc_next_timing:
		lds	YL, wt_comp_scan_l	; holds wait-before-scan value
		lds	YH, wt_comp_scan_h
		rcall	update_timing

		ret

wait_OCT1_tot:	sbrc	flags0, OCT1_PENDING
		rjmp	wait_OCT1_tot

set_OCT1_tot:	AcInit

		lds	YH, zero_wt_h
		lds	YL, zero_wt_l
		rcall	tcnt1_to_temp
		add	temp1, YL
		adc	temp2, YH
		ldi	temp4, (1<<TOIE1)+(1<<TOIE0)
		out	TIMSK, temp4
		out	OCR1AH, temp2
		out	OCR1AL, temp1
		sbr	flags0, (1<<OCT1_PENDING)
		ldi	temp4, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0)
		out	TIMSK, temp4
		ldi	temp4, EXT0_EN		; ext0int enable
		out	GIMSK, temp4		; enable ext0int

		ret
;-----bko-----------------------------------------------------------------
wait_OCT1_before_switch:
		rcall	tcnt1_to_temp
		lds	YL, com_timing_l
		lds	YH, com_timing_h
		add	temp1, YL
		adc	temp2, YH
		ldi	temp3, (1<<TOIE1)+(1<<TOIE0)
		out	TIMSK, temp3
		out	OCR1AH, temp2
		out	OCR1AL, temp1
		sbr	flags0, (1<<OCT1_PENDING)
		ldi	temp3, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0)
		out	TIMSK, temp3
		ldi	temp4, EXT0_EN		; ext0int enable
		out	GIMSK, temp4		; enable ext0int

	; don't waste time while waiting - do some controls, if indicated
		sbrc	flags1, EVAL_RC_PULS
		rcall	evaluate_rc_puls
		sbrc	flags1, EVAL_SYS_STATE
		rcall	evaluate_sys_state

		sbrc	flags1, EVAL_PWM
		rcall	set_new_duty

		sbrc	flags1, EVAL_RPM
		rcall	evaluate_rpm

OCT1_wait:	sbrc	flags0, OCT1_PENDING
		rjmp	OCT1_wait
		ret
;-----bko-----------------------------------------------------------------
start_timeout:	lds	YL, wt_OCT1_tot_l
		lds	YH, wt_OCT1_tot_h
		rcall	update_timing

		in	temp1, TCNT1L
		andi	temp1, 0x0f
		sub	YH, temp1
		cpi	YH, high (timeoutMIN)
		brcc	set_tot2
		ldi	YH, high (timeoutSTART)		
set_tot2:
		sts	wt_OCT1_tot_h, YH

		rcall	sync_with_poweron	; wait at least 100+ microseconds
		rcall	sync_with_poweron	; for demagnetisation - one sync may be added

		ret
;-----bko-----------------------------------------------------------------
switch_power_off:
		ldi	ZH, MIN_DUTY-1		; ZH is new_duty
                SetPWMi(MIN_DUTY-1)

                ldi     temp1, 0                ; reset limiter
		mov	sys_control, temp1

                ldi     temp1, INIT_PB          ; all off
                out     PORTB, temp1
                ldi     temp1, INIT_PC          ; all off
                out     PORTC, temp1
                ldi     temp1, INIT_PD          ; all off
		out	PORTD, temp1

		sbr	flags1, (1<<POWER_OFF)	; disable power on
		cbr	flags2, (1<<POFF_CYCLE)
		sbr	flags2, (1<<STARTUP)
		ret				; motor is off
;-----bko-----------------------------------------------------------------
wait_if_spike:	ldi	temp1, 4*CLK_SCALE
wait_if_spike2:	dec	temp1
		brne	wait_if_spike2
		ret
;-----bko-----------------------------------------------------------------
sync_with_poweron:
		sbrc	flags0, I_OFF_CYCLE	; first wait for power on
		rjmp	sync_with_poweron
wait_for_poweroff:
		sbrs	flags0, I_OFF_CYCLE	; now wait for power off
		rjmp	wait_for_poweroff
		ret
;-----bko-----------------------------------------------------------------
motor_brake:
.if MOT_BRAKE == 1
		ldi	temp2, 40		; 40 * 0.065ms = 2.6 sec
		ldi	temp1, BRAKE_PB		; all N-FETs on
		out	PORTB, temp1
                ldi     temp1, BRAKE_PC         ; all N-FETs on
                out     PORTC, temp1
                ldi     temp1, BRAKE_PD         ; all N-FETs on
                out     PORTD, temp1
mot_brk10:	sbrs	flags0, T1OVFL_FLAG
		rjmp	mot_brk10
		cbr	flags0, (1<<T1OVFL_FLAG)
		push	temp2
		rcall	evaluate_rc_puls
		pop	temp2
		cpi	ZH, MIN_DUTY+3		; avoid jitter detect
		brcs	mot_brk20
		rjmp	mot_brk90
mot_brk20:
		dec	temp2
		brne	mot_brk10
mot_brk90:
		ldi     temp1, INIT_PB          ; all off
		out     PORTB, temp1
		ldi	temp1, INIT_PC		; all off
		out	PORTC, temp1
		ldi	temp1, INIT_PD		; all off
		out	PORTD, temp1
.endif	; MOT_BRAKE == 1
                ret


wait64ms:
                ldi     temp1, 1*CLK_SCALE
                mov     t1_timeout, temp1
wait120ms_wait_for_t1:    
                tst     t1_timeout
                brne    wait120ms_wait_for_t1
                ret

pre_align:      ldi     temp1, INIT_PB  ; all off
                out     PORTB, temp1
                ldi     temp1, INIT_PD  ; all off
                out     PORTD, temp1
                ldi     temp1, INIT_PC  ; all off
                out     PORTC, temp1
                ldi     temp1, 20*CLK_SCALE
pp_FETs_off_wt: dec     temp1
                brne    pp_FETs_off_wt
                cbr     flags1, (1<<POWER_OFF)  ; enable power
                ldi     temp1, PWR_STARTUP      ; set limiter
                mov     sys_control, temp1
                SetPWMi(PWR_STARTUP*1/4);
                rcall   com5com6
                rcall   com6com1
                rcall   wait64ms
                rcall   wait64ms
                SetPWMi(PWR_STARTUP*2/4);
                rcall   wait64ms
                SetPWMi(PWR_STARTUP*3/4);
                rcall   wait64ms
                SetPWMi(PWR_STARTUP);               
                ret                
;-----bko-----------------------------------------------------------------
; **** startup loop ****
init_startup:	rcall	switch_power_off
		rcall	motor_brake
wait_for_power_on:
                DbgLEDOn

                rcall   evaluate_rc_puls
		cpi	ZH, MIN_DUTY + 1
		brcs	wait_for_power_on
                AcInit
                rcall   pre_align

                DbgLEDOn

                cbr     flags2, (1<<SCAN_TIMEOUT)
		ldi	temp1, 0
		sts	goodies, temp1
		ldi	temp1, 40*CLK_SCALE; x 32msec
		mov	t1_timeout, temp1
		rcall	set_all_timings
		rcall	start_timeout
;-----bko-----------------------------------------------------------------
; **** start control loop ****

; state 1 = B(p-on) + C(n-choppered) - comparator A evaluated
; out_cA changes from low to high
start1:		sbrs	flags2, COMP_SAVE	; high ?
		rjmp	start1_2		; .. no - loop, while high

start1_0:	sbrc	flags0, OCT1_PENDING
		rjmp	start1_1
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start1_9
start1_1:	rcall	sync_with_poweron

		sbrc	flags2, COMP_SAVE	; high ?
		rjmp	start1_0		; .. no - loop, while high

; do the special 120� switch
		ldi	temp1, 0
		sts	goodies, temp1
		rcall	com1com2
		rcall	com2com3
		rcall	com3com4
		rcall	evaluate_rc_puls
		rcall	start_timeout
		rjmp	start4
	
start1_2:	sbrc	flags0, OCT1_PENDING
		rjmp	start1_3
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start1_9
start1_3:	rcall	sync_with_poweron
		sbrs	flags2, COMP_SAVE	; high ?
		rjmp	start1_2		; .. no - loop, while low

start1_9:
		rcall	com1com2
		rcall	start_timeout

; state 2 = A(p-on) + C(n-choppered) - comparator B evaluated
; out_cB changes from high to low

start2:		sbrc	flags2, COMP_SAVE
		rjmp	start2_2

start2_0:	sbrc	flags0, OCT1_PENDING
		rjmp	start2_1
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start2_9
start2_1:	rcall	sync_with_poweron
		sbrs	flags2, COMP_SAVE
		rjmp	start2_0
		rjmp	start2_9

start2_2:	sbrc	flags0, OCT1_PENDING
		rjmp	start2_3
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start2_9
start2_3:	rcall	sync_with_poweron
		sbrc	flags2, COMP_SAVE
		rjmp	start2_2

start2_9:
		rcall	com2com3
		rcall	evaluate_rc_puls
		rcall	start_timeout

; state 3 = A(p-on) + B(n-choppered) - comparator C evaluated
; out_cC changes from low to high

start3:		sbrs	flags2, COMP_SAVE
		rjmp	start3_2

start3_0:	sbrc	flags0, OCT1_PENDING
		rjmp	start3_1
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start3_9
start3_1:	rcall	sync_with_poweron
		sbrc	flags2, COMP_SAVE
		rjmp	start3_0
		rjmp	start3_9

start3_2:	sbrc	flags0, OCT1_PENDING
		rjmp	start3_3
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start3_9
start3_3:	rcall	sync_with_poweron
		sbrs	flags2, COMP_SAVE
		rjmp	start3_2

start3_9:
		rcall	com3com4
		rcall	set_new_duty
		rcall	start_timeout

; state 4 = C(p-on) + B(n-choppered) - comparator A evaluated
; out_cA changes from high to low

start4:		sbrc	flags2, COMP_SAVE
		rjmp	start4_2

start4_0:	sbrc	flags0, OCT1_PENDING
		rjmp	start4_1
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start4_9
start4_1:	rcall	sync_with_poweron
		sbrs	flags2, COMP_SAVE
		rjmp	start4_0
		rjmp	start4_9

start4_2:	sbrc	flags0, OCT1_PENDING
		rjmp	start4_3
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start4_9
start4_3:	rcall	sync_with_poweron
		sbrc	flags2, COMP_SAVE
		rjmp	start4_2

start4_9:
		rcall	com4com5
		rcall	start_timeout


; state 5 = C(p-on) + A(n-choppered) - comparator B evaluated
; out_cB changes from low to high


start5:		sbrs	flags2, COMP_SAVE
		rjmp	start5_2

start5_0:	sbrc	flags0, OCT1_PENDING
		rjmp	start5_1
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start5_9
start5_1:	rcall	sync_with_poweron
		sbrc	flags2, COMP_SAVE
		rjmp	start5_0
		rjmp	start5_9

start5_2:	sbrc	flags0, OCT1_PENDING
		rjmp	start5_3
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start5_9
start5_3:	rcall	sync_with_poweron
		sbrs	flags2, COMP_SAVE
		rjmp	start5_2

start5_9:
		rcall	com5com6
		rcall	evaluate_sys_state
		rcall	start_timeout

; state 6 = B(p-on) + A(n-choppered) - comparator C evaluated
; out_cC changes from high to low

start6:		sbrc	flags2, COMP_SAVE
		rjmp	start6_2

start6_0:	sbrc	flags0, OCT1_PENDING
		rjmp	start6_1
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start6_9
start6_1:	rcall	sync_with_poweron
		sbrs	flags2, COMP_SAVE
		rjmp	start6_0
		rjmp	start6_9

start6_2:	sbrc	flags0, OCT1_PENDING
		rjmp	start6_3
		sbr	flags2, (1<<SCAN_TIMEOUT)
		rjmp	start6_9
start6_3:	rcall	sync_with_poweron
		sbrc	flags2, COMP_SAVE
		rjmp	start6_2

start6_9:
		rcall	com6com1

		mov	temp1, tcnt0_power_on
		cpi	temp1, NO_POWER
		brne	s6_power_ok
		rjmp	init_startup

s6_power_ok:	tst	t1_timeout
		brne	s6_test_rpm
		rjmp	init_startup		;-) demich
		
s6_test_rpm:	lds	temp1, timing_x
		tst	temp1
		brne	s6_goodies
		lds	temp1, timing_h		; get actual RPM reference high
;		cpi	temp1, PWR_RANGE1*CLK_SCALE
		cpi	temp1, PWR_RANGE2*CLK_SCALE
		brcs	s6_run1

s6_goodies:	lds	temp1, goodies
		sbrc	flags2, SCAN_TIMEOUT
		clr	temp1
		inc	temp1
		sts	goodies,  temp1
		cbr	flags2, (1<<SCAN_TIMEOUT)
		cpi	temp1, ENOUGH_GOODIES
		brcs	s6_start1	

s6_run1:	ldi	temp1, 0xff
		mov	run_control, temp1

		rcall	calc_next_timing
		rcall	set_OCT1_tot

                DbgLEDOff

		cbr	flags2, (1<<STARTUP)
		rjmp	run1			; running state begins

s6_start1:	rcall	start_timeout		; need to be here for a correct temp1=comp_state
		rjmp	start1			; go back to state 1

;-----bko-----------------------------------------------------------------
; **** running control loop ****

; run 1 = B(p-on) + C(n-choppered) - comparator A evaluated
; out_cA changes from low to high

run1: 		rcall	wait_for_low
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_for_high
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		sbr	flags1, (1<<EVAL_RPM)
		rcall	wait_OCT1_before_switch
		rcall	com1com2
		rcall	calc_next_timing
		rcall	wait_OCT1_tot
		
; run 2 = A(p-on) + C(n-choppered) - comparator B evaluated
; out_cB changes from high to low

run2:		rcall	wait_for_high
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_for_low
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		sbr	flags1, (1<<EVAL_RC_PULS)
		rcall	wait_OCT1_before_switch
                rcall   com2com3
		rcall	calc_next_timing
		rcall	wait_OCT1_tot

; run 3 = A(p-on) + B(n-choppered) - comparator C evaluated
; out_cC changes from low to high

run3:		rcall	wait_for_low
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_for_high
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		sbr	flags1, (1<<EVAL_PWM)
		rcall	wait_OCT1_before_switch
		rcall	com3com4
		rcall	calc_next_timing
		rcall	wait_OCT1_tot

; run 4 = C(p-on) + B(n-choppered) - comparator A evaluated
; out_cA changes from high to low
run4:		rcall	wait_for_high
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_for_low
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_OCT1_before_switch
                rcall   com4com5
		rcall	calc_next_timing
		rcall	wait_OCT1_tot

; run 5 = C(p-on) + A(n-choppered) - comparator B evaluated
; out_cB changes from low to high

run5:		rcall	wait_for_low
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_for_high
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		sbr	flags1, (1<<EVAL_SYS_STATE)
		rcall	wait_OCT1_before_switch
		rcall	com5com6
		rcall	calc_next_timing
		rcall	wait_OCT1_tot

; run 6 = B(p-on) + A(n-choppered) - comparator C evaluated
; out_cC changes from high to low

run6:		rcall	wait_for_high
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_for_low
		sbrs	flags0, OCT1_PENDING
		rjmp	run_to_start
		rcall	wait_OCT1_before_switch
                rcall   com6com1
		rcall	calc_next_timing
		rcall	wait_OCT1_tot

;		rjmp	run6_2

		lds	temp1, timing_x
		tst	temp1
		breq	run6_2			; higher than 610 RPM if zero
.if CLK_SCALE==2                                
                dec     temp1
		breq	run6_2			; higher than 610 RPM if equ 1
.endif                
run_to_start:	sbr	flags2, (1<<STARTUP)
		cbr	flags2, (1<<POFF_CYCLE)
                sbrs    flags1, POWER_OFF
                rjmp    restart_control
                rjmp    wait_for_power_on

run6_2:		cbr	flags2, (1<<POFF_CYCLE)
		tst	run_control		; only once !
		breq	run6_9
		dec	run_control
		breq	run6_3			; poweroff if 0
		mov	temp1, run_control
		cpi	temp1, 1		; poweroff if 1
		breq	run6_3
		cpi	temp1, 2		; poweroff if 2
		brne	run6_9
run6_3:		sbr	flags2, (1<<POFF_CYCLE)

run6_9:
		rjmp	run1			; go back to run 1

restart_control:
		cli				; disable all interrupts
		rcall	switch_power_off
		rjmp	reset


;-----bko-----------------------------------------------------------------
; *** scan comparator utilities ***
.macro __wait_for_filter
                clc
                sbis    ACSR, ACO
                sec
                brcc    wait_for_filter_1
                inc     temp2
wait_for_filter_1:
                rol     temp1
                brcc    wait_for_filter_2
                dec     temp2
wait_for_filter_2:
.endmacro
                                
wait_for_low:   
                ldi     temp1, 0xFF
                ldi     temp2, 8
wait_for_low_loop:
                sbrs    flags0, OCT1_PENDING
                ret
                __wait_for_filter
                cpi     temp2, 4
                brcc    wait_for_low_loop
                ret
                               
wait_for_high:   
                ldi     temp1, 0x0
                ldi     temp2, 0
wait_for_high_loop:
                sbrs    flags0, OCT1_PENDING
                ret
                __wait_for_filter
                cpi     temp2, 5
                brcs    wait_for_high_loop
                ret
;-----bko-----------------------------------------------------------------
; *** commutation utilities ***
com1com2:	BpFET_off		              ; Bp off
		sbrs	flags1, POWER_OFF
		ApFET_on		              ; Ap on
		AcPhaseB
		ret

com2com3:	ldi	temp1, (1<<OCIE1A)+(1<<TOIE1) ; stop timer0 interrupt
		out	TIMSK, temp1		      ;  .. only ONE should change these values at the time
		nop
		cbr	flags0, (1<<A_FET)	      ; next nFET = BnFET
		cbr	flags0, (1<<C_FET)
		sbrc	flags1, FULL_POWER
		rjmp	c2_switch
		sbrc	flags0, I_OFF_CYCLE	      ; was power off ?
		rjmp	c2_done			      ; .. yes - futhermore work is done in timer0 interrupt
c2_switch:	CnFET_off		              ; Cn off
		sbrs	flags1, POWER_OFF
		BnFET_on		              ; Bn on
c2_done:	ldi	temp1, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0) ; let timer0 do his work again
		out	TIMSK, temp1
		AcPhaseC
		ret

com3com4:	ApFET_off		              ; Ap off
		sbrs	flags1, POWER_OFF
		CpFET_on		              ; Cp on
		AcPhaseA
		ret

com4com5:	ldi	temp1, (1<<OCIE1A)+(1<<TOIE1) ; stop timer0 interrupt
		out	TIMSK, temp1		      ;  .. only ONE should change these values at the time
		nop
		sbr	flags0, (1<<A_FET)	      ; next nFET = AnFET
		cbr	flags0, (1<<C_FET)
		sbrc	flags1, FULL_POWER
		rjmp	c4_switch
		sbrc	flags0, I_OFF_CYCLE	      ; was power off ?
		rjmp	c4_done			      ; .. yes - futhermore work is done in timer0 interrupt
c4_switch:	BnFET_off		              ; Bn off
		sbrs	flags1, POWER_OFF
		AnFET_on		              ; An on
c4_done:	ldi	temp1, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0) ; let timer0 do his work again
		out	TIMSK, temp1
		AcPhaseB
		ret

com5com6:	CpFET_off		              ; Cp off
		sbrs	flags1, POWER_OFF
		BpFET_on		              ; Bp on
		AcPhaseC
		ret

com6com1:	ldi	temp1, (1<<OCIE1A)+(1<<TOIE1) ; stop timer0 interrupt
		out	TIMSK, temp1		      ;  .. only ONE should change these values at the time
		nop
		cbr	flags0, (1<<A_FET)	      ; next nFET = CnFET
		sbr	flags0, (1<<C_FET)
		sbrc	flags1, FULL_POWER
		rjmp	c6_switch
		sbrc	flags0, I_OFF_CYCLE	      ; was power off ?
		rjmp	c6_done			      ; .. yes - futhermore work is done in timer0 interrupt
c6_switch:	AnFET_off		              ; An off
		sbrs	flags1, POWER_OFF
		CnFET_on		              ; Cn on
c6_done:	ldi	temp1, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0) ; let timer0 do his work again
		out	TIMSK, temp1
		AcPhaseA
		ret

.exit
