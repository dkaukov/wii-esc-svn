;**** **** **** **** ****
;
;Die Benutzung der Software ist mit folgenden Bedingungen verbunden:
;
;1. Da ich alles kostenlos zur Verfügung stelle, gebe ich keinerlei Garantie
;   und übernehme auch keinerlei Haftung für die Folgen der Benutzung.
;
;2. Die Software ist ausschließlich zur privaten Nutzung bestimmt. Ich
;   habe nicht geprüft, ob bei gewerblicher Nutzung irgendwelche Patentrechte
;   verletzt werden oder sonstige rechtliche Einschränkungen vorliegen.
;
;3. Jeder darf Änderungen vornehmen, z.B. um die Funktion seinen Bedürfnissen
;   anzupassen oder zu erweitern. Ich würde mich freuen, wenn ich weiterhin als
;   Co-Autor in den Unterlagen erscheine und mir ein Link zur entprechenden Seite
;   (falls vorhanden) mitgeteilt wird.
;
;4. Auch nach den Änderungen sollen die Software weiterhin frei sein, d.h. kostenlos bleiben.
;
;!! Wer mit den Nutzungbedingungen nicht einverstanden ist, darf die Software nicht nutzen !!

.include "Mystery20A.inc"
.include "pwm_rc_200.inc"

#if defined(_include_ppm_inc_)
  .include "ppm.inc"
#endif 


.equ    NO_POWER         = 256 - PWR_PCT_TO_VAL(PCT_PWR_MIN)    ; (POWER_OFF)
.equ    MAX_POWER        = 256 - POWER_RANGE                    ; (FULL_POWER)
.equ    CONTROL_TOT      = 50                                   ; time = NUMBER x 64ms
.equ    CURRENT_ERR_MAX  = 3                                    ; performs a reset after MAX errors

.equ    T1STOP           = 0x00
.equ    T1CK8            = 0x02
.equ    CLK_SCALE        = F_CPU / 8000000

;**** **** **** **** ****
; Register Definitions
.def    i_sreg           = r1   ; status register save in interrupts
;.def   ...              = r2   ; 
.def    temp5            = r3   ; 
.def    temp6            = r4   ; 
;.def   ...              = r5   
.def    tcnt0_power_on   = r6   ; timer0 counts nFETs are switched on  
.def    tcnt0_pwroff     = r7   ; timer0 counts nFETs are switched off
.def    start_rcpuls_l   = r8
.def    start_rcpuls_h   = r9
.def    TCNT1L_shadow    = r10
.def    TCNT1H_shadow    = r11
.def    control_timeout  = r12  ; 

.def    sys_control      = r13
.def    t1_timeout       = r14
;.def   ...              = r15


.def    temp1            = r16  ; main temporary
.def    temp2            = r17  ; main temporary
.def    temp3            = r18  ; main temporary
.def    temp4            = r19  ; main temporary

.def    i_temp1          = r20  ; interrupt temporary
.def    i_temp2          = r21  ; interrupt temporary
.def    i_temp3          = r22  ; interrupt temporary

.def    flags0  = r23   ; state flags
        .equ    OCT1_PENDING    = 0     ; if set, output compare interrunpt is pending
        .equ    OCT1_MSB        = 1     ; 
        .equ    I_pFET_HIGH     = 2     ; set if over-current detect
        .equ    B_FET           = 3     ; if set, A-FET state is to be changed
        .equ    C_FET           = 4     ; if set, C-FET state is to be changed
        .equ    A_FET           = 5     ; if set, A-FET state is to be changed
;        .equ    ...            = 6     ; 
        .equ    T1OVFL_FLAG     = 7     ; each timer1 overflow sets this flag - used for voltage + current watch

.def    flags1  = r24   ; state flags
        .equ    POWER_OFF       = 0     ; switch fets on disabled
        .equ    FULL_POWER      = 1     ; 100% on - don't switch off, but do OFF_CYCLE working
        .equ    NO_COMM         = 2     ; !(FULL_POWER or !PWM_OFF_CYCLE)
        .equ    RC_PULS_UPDATED = 3     ; new rc-puls value available
        .equ    PWM_OFF_CYCLE   = 4     ; if set, current off cycle is active
;        .equ                   = 5     ; 
;        .equ                   = 6     ; 
;        .equ                   = 7     ; 

.def    flags2  = r25
        .equ    RPM_RANGE1      = 0     ; 
        .equ    RPM_RANGE2      = 1     ; 
        .equ    SCAN_TIMEOUT    = 2     ; if set a startup timeout occurred
;       .equ    ...             = 3     ; 
        .equ    RUN_MIN_RPM     = 4     ; 
        .equ    STARTUP         = 5     ; if set startup-phase is active
        .equ    RC_INTERVAL_OK  = 6     ; 
        .equ    NO_SYNC         = 7     ; 

; here the XYZ registers are placed ( r26-r31)

; ZH = new_duty         ; PWM destination


;**** **** **** **** ****
; RAM Definitions
.dseg                                   ;EEPROM segment
.org SRAM_START

last_tcnt1_l:   .byte   1       ; last timer1 value
last_tcnt1_h:   .byte   1
timing_l:       .byte   1       ; holds time of 4 commutations 
timing_h:       .byte   1
timing_x:       .byte   1

zc_blanking_time_l: .byte   1   ; time from switch to comparator scan
zc_blanking_time_h: .byte   1       
com_timing_l:   .byte   1       ; time from zero-crossing to switch of the appropriate FET
com_timing_h:   .byte   1
strt_zc_wait_time_x:  .byte   1 
strt_zc_wait_time_h:  .byte   1
zc_wait_time_l: .byte   1
zc_wait_time_h: .byte   1

stop_rcpuls_l:  .byte   1
stop_rcpuls_h:  .byte   1
new_rcpuls_l:   .byte   1
new_rcpuls_h:   .byte   1

goodies:        .byte   1

uart_data:      .byte   100             ; only for debug requirements


;**** **** **** **** ****
; ATmega8 interrupts

;.equ   INT0addr=$001   ; External Interrupt0 Vector Address
;.equ   INT1addr=$002   ; External Interrupt1 Vector Address
;.equ   OC2addr =$003   ; Output Compare2 Interrupt Vector Address
;.equ   OVF2addr=$004   ; Overflow2 Interrupt Vector Address
;.equ   ICP1addr=$005   ; Input Capture1 Interrupt Vector Address
;.equ   OC1Aaddr=$006   ; Output Compare1A Interrupt Vector Address
;.equ   OC1Baddr=$007   ; Output Compare1B Interrupt Vector Address
;.equ   OVF1addr=$008   ; Overflow1 Interrupt Vector Address
;.equ   OVF0addr=$009   ; Overflow0 Interrupt Vector Address
;.equ   SPIaddr =$00a   ; SPI Interrupt Vector Address
;.equ   URXCaddr=$00b   ; USART Receive Complete Interrupt Vector Address
;.equ   UDREaddr=$00c   ; USART Data Register Empty Interrupt Vector Address
;.equ   UTXCaddr=$00d   ; USART Transmit Complete Interrupt Vector Address
;.equ   ADCCaddr=$00e   ; ADC Interrupt Vector Address
;.equ   ERDYaddr=$00f   ; EEPROM Interrupt Vector Address
;.equ   ACIaddr =$010   ; Analog Comparator Interrupt Vector Address
;.equ   TWIaddr =$011   ; Irq. vector address for Two-Wire Interface
;.equ   SPMaddr =$012   ; SPM complete Interrupt Vector Address
;.equ   SPMRaddr =$012  ; SPM complete Interrupt Vector Address
;-----bko-----------------------------------------------------------------
; helper macroses
#if !defined(__ext_int0)
 #define __ext_int0 reti 
 .macro __ext_int0_isr
 .endmacro
#endif

#if !defined(__ext_int1)
 #define __ext_int1 reti 
 .macro __ext_int1_isr
 .endmacro
#endif
;**** **** **** **** ****
.cseg
.org 0
;-----bko-----------------------------------------------------------------
; reset and interrupt jump table

                rjmp    reset
                __ext_int0          ; ext_int0
                __ext_int1          ; ext_int1
                reti                ; t2oc_int
                reti                ; t2ovfl_int
                reti                ; icp1
                rjmp    t1oca_int
                reti                ; t1ocb_int
                rjmp    t1ovfl_int
                rjmp    t0ovfl_int
                reti                ; spi_int
                reti                ; urxc
                reti                ; udre
                reti                ; utxc
                reti                ; adc_int
                reti                ; eep_int
                reti                ; aci_int
                reti                ; wire2_int
                reti                ; spmc_int


version:        .db     0x0d, 0x0a
                .db     "bk",Typ,"410r06"
                .db     0x0d, 0x0a

;******************************************************************************
;* MACRO
;*      SetPWMi
;* DECRIPTION
;*      Set PWM immidiate
;* USAGE
;*      SetPWMi(val)
;* STATISTICS
;*      Register usage: none
;******************************************************************************
.macro SetPWMi
                push    temp1
                push    temp2
                ldi     temp1, @0
                com     temp1
                rcall   set_pwm
                pop     temp2
                pop     temp1
.endmacro


;-----bko-----------------------------------------------------------------
; init after reset

reset:          ldi     temp1, high(RAMEND)     ; stack = RAMEND
                out     SPH, temp1
                ldi     temp1, low(RAMEND)
                out     SPL, temp1

#ifdef READ_CALIBRATION
                ; oscillator calibration byte is written into the uppermost position
                ; of the eeprom - by the script 1n1p.e2s an ponyprog
                ;CLEARBUFFER
                ;LOAD-PROG 1n1p.hex
                ;PAUSE "Connect and powerup the circuit, are you ready?"
                ;READ-CALIBRATION 0x21FF DATA 3     # <EEProm 8Mhz
                ;ERASE-ALL
                ;WRITE&VERIFY-ALL
                ldi     temp1,0x01
                out     EEARH,temp1
                ldi     temp1,$ff
                out     EEARL,temp1
                sbi     EECR,EERE
                in      temp1,EEDR
                out     osccal ,temp1  ;schreiben
#endif
#ifdef OVERCLOCK
                ldi     temp1,  $ff
                out     osccal, temp1  
#endif

        ; portB
                ldi     temp1, INIT_PB
                out     PORTB, temp1
                ldi     temp1, DIR_PB
                out     DDRB, temp1

        ; portC
                ldi     temp1, INIT_PC
                out     PORTC, temp1
                ldi     temp1, DIR_PC
                out     DDRC, temp1

        ; portD
                ldi     temp1, INIT_PD
                out     PORTD, temp1
                ldi     temp1, DIR_PD
                out     DDRD, temp1

        ; timer0: PWM + beep control = 0x02     ; start timer0 with CK/8 (0.5³s/count)
                ldi     temp1, 0x02
                out     TCCR0, temp1

        ; timer1: commutation control = 0x02    ; start timer1 with CK/8 (0.5³s/count)
                ldi     temp1, T1CK8
                out     TCCR1B, temp1

        ; reset state flags
                clr     flags0
                clr     flags1
                clr     flags2

        ; clear RAM
                clr     XH
                ldi     XL, low (SRAM_START)
                clr     temp1
clear_ram:      st      X+, temp1
                cpi     XL, uart_data+1
                brlo    clear_ram

        ; power off
                rcall   switch_power_off

        ; reset rc puls timeout
                ldi     temp1, CONTROL_TOT*CLK_SCALE
                mov     control_timeout, temp1
                
control_start:  ; init variables
                SetPWMi(PWR_PCT_TO_VAL(PCT_PWR_MIN)-1)
                clr     sys_control

        ; init registers and interrupts
                ldi     temp1, (1<<TOIE1)+(1<<OCIE1A)+(1<<TOIE0)
                out     TIFR, temp1             ; clear TOIE1,OCIE1A & TOIE0
                out     TIMSK, temp1            ; enable TOIE1,OCIE1A & TOIE0 interrupts

                sei                             ; enable all interrupts

                init_input
                rcall   set_all_timings

                rjmp    init_startup
;-----bko-----------------------------------------------------------------
ext_int0_isr:   __ext_int0_isr
ext_int1_isr:   __ext_int1_isr
;-----bko-----------------------------------------------------------------
; output compare timer1 interrupt
t1oca_int:      in      i_sreg, SREG
                sbrc    flags0, OCT1_MSB 
                rjmp    t1oca_intmsb
                cbr     flags0, (1<<OCT1_PENDING) ; signal OCT1 passed
                in      TCNT1L_shadow, TCNT1L
                in      TCNT1H_shadow, TCNT1H
                out     SREG, i_sreg
                reti
t1oca_intmsb:                
                cbr     flags0, (1<<OCT1_MSB) 
                out     SREG, i_sreg
                reti                
;-----bko-----------------------------------------------------------------
; overflow timer1 / happens all 32768³s / 65536³s
t1ovfl_int:     in      i_sreg, SREG
                sbr     flags0, (1<<T1OVFL_FLAG)

                tst     t1_timeout
                breq    t1ovfl_10
                dec     t1_timeout

t1ovfl_10:      tst     control_timeout
                brne    t1ovfl_20
                clr     ZH
                rjmp    t1ovfl_99
t1ovfl_20:      dec     control_timeout

t1ovfl_99:      out     SREG, i_sreg
                reti
;-----bko-----------------------------------------------------------------
; timer0 overflow interrupt
t0ovfl_int:     
                in      i_sreg, SREG
                sbrc    flags1, PWM_OFF_CYCLE
                rjmp    t0_on_cycle
t0_off_cycle:   
                mov     i_temp1, tcnt0_pwroff
                cpi     i_temp1, 0xFF
                breq    t0_on_cycle_t1
                ;
                out     TCNT0, tcnt0_pwroff     ; reload t0
                ; We can just turn them all off as we only have one nFET on at a
                ; time, and interrupts are disabled during beeps.
                CnFET_off
                AnFET_off
                BnFET_off
                ; PWM state = off cycle
                sbr     flags1, (1<<PWM_OFF_CYCLE) + (1<<NO_COMM)
                out     SREG, i_sreg
                reti
t0_on_cycle_t1:
                ; Off-load last cycle 
                CnFET_off
                AnFET_off
                BnFET_off
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
t0_on_cycle:
                out     TCNT0, tcnt0_power_on   ; reload t0
                sbrc    flags1, POWER_OFF
                rjmp    t0_on_cycle_tcnt
                ; switch appropriate nFET on as soon as possible
                sbrc    flags0, C_FET           ; is Cn choppered ?
                CnFET_on                        ; Cn on
                sbrc    flags0, A_FET           ; is An choppered ?
                AnFET_on                        ; An on
                sbrc    flags0, B_FET           ; is Bn choppered ?
                BnFET_on                        ; Bn on
t0_on_cycle_tcnt:
                cbr     flags1, (1<<FULL_POWER) + (1<<NO_COMM) + (1<<PWM_OFF_CYCLE); PWM state = on cycle
                tst     tcnt0_pwroff
                brne    t0_on_cycle_not_full_power
                sbr     flags1, (1<<FULL_POWER) + (1<<PWM_OFF_CYCLE)
t0_on_cycle_not_full_power:
                out     SREG, i_sreg
                reti                   
;-----bko-----------------------------------------------------------------
; beeper: timer0 is set to 1³s/count
beep_f1:        ldi     temp4, 200
                ldi     temp2, 80
                rjmp    beep

beep_f2:        ldi     temp4, 180
                ldi     temp2, 100
                rjmp    beep

beep_f3:        ldi     temp4, 160
                ldi     temp2, 120
                rjmp    beep

beep_f4:        ldi     temp4, 100
                ldi     temp2, 200
                rjmp    beep

beep:           clr     temp1
                out     TCNT0, temp1
                BpFET_on                ; BpFET on
                AnFET_on                ; CnFET on
beep_BpCn10:    in      temp1, TCNT0
                cpi     temp1, 16*CLK_SCALE             ; 16us on
                brne    beep_BpCn10
                BpFET_off               ; BpFET off
                AnFET_off               ; CnFET off
                ldi     temp3, 8*CLK_SCALE              ; 2040us off
beep_BpCn12:    clr     temp1
                out     TCNT0, temp1
beep_BpCn13:    in      temp1, TCNT0
                cp      temp1, temp4
                brne    beep_BpCn13
                dec     temp3
                brne    beep_BpCn12
                dec     temp2
                brne    beep
                ret

wait30ms:       ldi     temp2, 15*CLK_SCALE
beep_BpCn20:    ldi     temp3, 8*CLK_SCALE
beep_BpCn21:    clr     temp1
                out     TCNT0, temp1
beep_BpCn22:    in      temp1, TCNT0
                cpi     temp1, 255
                brne    beep_BpCn22
                dec     temp3
                brne    beep_BpCn21
                dec     temp2
                brne    beep_BpCn20
                ret

        ; 256 periods = 261ms silence
wait260ms:      ldi     temp2, 127*CLK_SCALE    ; = 256
beep2_BpCn20:   ldi     temp3, 8*CLK_SCALE
beep2_BpCn21:   clr     temp1
                out     TCNT0, temp1
beep2_BpCn22:   in      temp1, TCNT0
                cpi     temp1, 255
                brne    beep2_BpCn22
                dec     temp3
                brne    beep2_BpCn21
                dec     temp2
                brne    beep2_BpCn20
                ret                
;-----bko-----------------------------------------------------------------
evaluate_rc_puls:
                EvaluatePWC
;-----bko-----------------------------------------------------------------
evaluate_sys_state:
                mov     temp1, sys_control      ; Build up sys_control to POWER_RANGE
                cpi     temp1, POWER_RANGE - 1
                breq    evaluate_sys_state_exit
                inc     sys_control             ; 
evaluate_sys_state_exit:                
                ret
;-----bko-----------------------------------------------------------------
;******************************************************************************
;* FUNCTION
;*      set_pwm
;* DECRIPTION
;*      Calculates tcnt0 values for ON and off cycles.
;*      Performs PWM correction.
;* USAGE
;*      temp1
;* STATISTICS
;*      Register usage: temp1, temp2
;******************************************************************************
set_pwm:
                mov     temp2, temp1
                subi    temp2, -(POWER_RANGE + 1)
                com     temp2  
                subi    temp2, -2               ; Make it shorter by 2 cycles
                cpi     temp1, 0xFE
                brcs    set_pwm_01
                ldi     temp1, 0xFF  - 2        ; Limit to 0xFF
set_pwm_01:
                subi    temp1, -2               ; Make it shorter by 2 cycles 
                movw    tcnt0_power_on:tcnt0_pwroff, temp1:temp2
                ret
;******************************************************************************
;* FUNCTION
;*      eval_power_state
;* DECRIPTION
;*      Evaluates current state
;* USAGE
;*      temp1
;* STATISTICS
;*      Register usage: none
;******************************************************************************
eval_power_state:
                cpi     temp1, MAX_POWER+1
                brsh    not_full_power
                cbr     flags1, (1<<POWER_OFF)
                rjmp    eval_power_state_exit
not_full_power: cpi     temp1, NO_POWER
                brlo    neither_full_nor_off
                sbr     flags1, (1<<POWER_OFF)
                rjmp    eval_power_state_exit
neither_full_nor_off:
                cbr     flags1, (1<<POWER_OFF)
eval_power_state_exit:    
                ret
;******************************************************************************
;* FUNCTION
;*      set_new_duty
;* DECRIPTION
;*     1) Evaluates duty cycle
;*     2) Limits power to sys_control
;*     3) Limits RPM ranges power
;* USAGE
;*      ZH (0 - POWER_RANGE - 1)
;* STATISTICS
;*      Register usage: temp1, temp2, temp3 
;******************************************************************************
.macro CheckRPMi
                cpi     temp3, LOW(RPM_TO_COMM_TIME(@0)*4*CLK_SCALE)             
                ldi     temp1, HIGH(RPM_TO_COMM_TIME(@0)*4*CLK_SCALE)
                cpc     temp4, temp1
                ldi     temp1, BYTE3(RPM_TO_COMM_TIME(@0)*4*CLK_SCALE)
                cpc     temp5, temp1
.endmacro

set_new_duty:   
                mov     temp6, ZH
                cp      temp6, sys_control      ; Limit PWM to sys_control
                brcs    set_new_duty_no_limit
                mov     temp6, sys_control
set_new_duty_no_limit:
                sbr     flags2, (1<<RPM_RANGE1) + (1<<RPM_RANGE2) + (1<<RUN_MIN_RPM)
                lds     temp4, timing_h
                lds     temp5, timing_x
                cpi     temp4, 0x0d*CLK_SCALE/2 ;  ~ 20.000 RPM
                ldi     temp1, 0x0
                cpc     temp5, temp1
                brcc    set_new_duty_low_ranges
                ; High RPM finish ASAP
set_new_duty_set_pwm:                
                mov     temp1, temp6
                com     temp1
                rcall   eval_power_state        ; evaluate power state
                rcall   set_pwm                 ; set new PWM
                ret                
set_new_duty_low_ranges:
                ; With low RPM we have more time for calculations. 
                ; We assume that  RUN_MIN_RPM < RPM_RUN_RANGE_02 < RPM_RUN_RANGE_02
                lds     temp3, timing_l
                ;  Check for range 02
                CheckRPMi(RPM_RUN_RANGE_02)
                brcs    set_new_duty_set_pwm
                cbr     flags2, (1<<RPM_RANGE2)
                ldi     temp2, PWR_PCT_TO_VAL(PCT_PWR_MAX_RPM_02)
                cp      temp2, temp6
                brcc    set_new_duty_range_01
                mov     temp6, temp2   
set_new_duty_range_01:
                ;  Check for range 01               
                CheckRPMi(RPM_RUN_RANGE_01)
                brcs    set_new_duty_set_pwm
                cbr     flags2, (1<<RPM_RANGE1)
                ldi     temp2, PWR_PCT_TO_VAL(PCT_PWR_MAX_RPM_01)
                cp      temp2, temp6
                brcc    set_new_duty_min_rpm
                mov     temp6, temp2   
set_new_duty_min_rpm:                
                ;  Check for minimum RPM
                CheckRPMi(RPM_RUN_MIN_RPM)
                brcs    set_new_duty_set_pwm
                cbr     flags2, (1<<RUN_MIN_RPM)
                rjmp    set_new_duty_set_pwm
                
;******************************************************************************
;* FUNCTION
;*      set_new_duty_strt
;* DECRIPTION
;*     1) Evaluates duty cycle
;*     2) Limits power to sys_control
;*     3) Constraints power in range: PWR_PCT_TO_VAL(PCT_PWR_STARTUP)..PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP)
;* USAGE
;*      ZH (0 - POWER_RANGE-1)
;* STATISTICS
;*      Register usage: temp1, temp2, temp3 
;******************************************************************************
set_new_duty_strt:   
                mov     temp6, ZH
                cp      temp6, sys_control      ; Limit PWM to sys_control
                brcs    set_new_duty_strt_01
                mov     temp6, sys_control
set_new_duty_strt_01:
                ldi     temp2, PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP)
                cp      temp2, temp6
                brcc    set_new_duty_strt_02
                mov     temp6, temp2   
set_new_duty_strt_02:
                ldi     temp2, PWR_PCT_TO_VAL(PCT_PWR_STARTUP)
                cp      temp6, temp2
                brcc    set_new_duty_strt_03
                mov     temp6, temp2
set_new_duty_strt_03:                
                mov     temp1, temp6
                com     temp1
                rcall   eval_power_state        ; evaluate power state
                rcall   set_pwm                 ; set new PWM
                ret                
;-----bko-----------------------------------------------------------------
set_all_timings:
                ldi     YL, high(RPM_TO_COMM_TIME(RPM_STEP_INITIAL)*CLK_SCALE)
                ldi     YH, byte3(RPM_TO_COMM_TIME(RPM_STEP_INITIAL)*CLK_SCALE)
                sts     strt_zc_wait_time_h, YL
                sts     strt_zc_wait_time_x, YH
                ldi     temp3, 0xff
                ldi     temp4, 0x1f
                sts     zc_blanking_time_l, temp3
                sts     zc_blanking_time_h, temp4
                sts     com_timing_l, temp3
                sts     com_timing_h, temp4
set_timing_v:   
                ldi     ZL, 0x02
                mov     temp5, ZL
                sts     timing_x, ZL
                ldi     temp4, 0xff
                sts     timing_h, temp4
                ldi     temp3, 0xff
                sts     timing_l, temp3
                ret
;-----bko-----------------------------------------------------------------
update_timing:  
                cli
                in      temp1, TCNT1L
                in      temp2, TCNT1H
                add     YL, temp1
                adc     YH, temp2
                out     OCR1AH, YH
                out     OCR1AL, YL
                sei
                sbr     flags0, (1<<OCT1_PENDING)
                sei  
                clr     temp6
        ; calculate this commutation time
                lds     temp3, last_tcnt1_l
                lds     temp4, last_tcnt1_h
                sts     last_tcnt1_l, temp1
                sts     last_tcnt1_h, temp2
                sub     temp1, temp3
                sbc     temp2, temp4
        ; calculate next waiting times - timing(-l-h-x) holds the time of 4 commutations
                lds     temp3, timing_l
                lds     temp4, timing_h
                lds     temp5, timing_x

                movw    YL, temp3               ; copy timing to Y
                lsr     temp5                   ; build a quarter
                ror     YH
                ror     YL
                lsr     temp5
                ror     YH                      ; temp5 no longer needed (should be 0)
                ror     YL

                lds     temp5, timing_x         ; reload original timing_x

                sub     temp3, YL               ; subtract quarter from timing
                sbc     temp4, YH
                sbc     temp5, temp6

                add     temp3, temp1            ; .. and add the new time
                adc     temp4, temp2
                adc     temp5, temp6

                sbrs    flags2, NO_SYNC
                rjmp    update_t_insync

                add     temp3, temp1            ; .. and add the new time again
                adc     temp4, temp2
                adc     temp5, temp6
                
update_t_insync:
        ; limit RPM to 120.000
                cpi     temp3, 0x4c             ; 0x14c = 120.000 RPM
                ldi     temp1, 0x1
                cpc     temp4, temp1
                cpc     temp5, temp6
                brcc    update_t90

                tst     sys_control
                breq    update_t90
                dec     sys_control             ; limit by reducing power

update_t90:     sts     timing_l, temp3
                sts     timing_h, temp4
                sts     timing_x, temp5
                ldi     temp2, 3
                cp      temp5, temp2            ; limit range to 0x2ffff
                brcs    update_t99
                rcall   set_timing_v
update_t99:
                lsr     temp5                   
                ror     temp4
                ror     temp3
                lsr     temp5
                ror     temp4
                ror     temp3
                lsr     temp4                     ; x always 0 at this stage (0x2ffff / 4 = 0xBFFF)
                ror     temp3
                mov     temp1, temp3
                mov     temp2, temp4
                lsr     temp4
                ror     temp3
                sts     zc_blanking_time_l, temp3 ; save for zero crossing blanking time (15 deg) 
                sts     zc_blanking_time_h, temp4
                sts     com_timing_l, temp3       ; save for timing advance delay (15 deg)
                sts     com_timing_h, temp4
                add     temp1, temp3
                adc     temp2, temp4
                sts     zc_wait_time_l, temp1     ; save for zero crossing timeout (30 + 15 = 45 deg)
                sts     zc_wait_time_h, temp2    
                ret               
;-----bko-----------------------------------------------------------------
calc_next_timing:
                lds     YL, com_timing_l
                lds     YH, com_timing_h
                rjmp    update_timing
                
wait_for_commutation:
                sbrc    flags2, NO_SYNC
                rjmp    wait_for_commutation_no_sync
wait_for_commutation_loop:
                sbrc    flags0, OCT1_PENDING
                rjmp    wait_for_commutation_loop
set_zc_blanking_time:
                lds     YH, zc_blanking_time_h
                lds     YL, zc_blanking_time_l
                cli
                add     YL, TCNT1L_shadow
                adc     YH, TCNT1H_shadow
                out     OCR1AH, YH
                out     OCR1AL, YL
                sei
                sbr     flags0, (1<<OCT1_PENDING)
                ret
wait_for_commutation_no_sync:
                cli
                in      TCNT1L_shadow, TCNT1L
                in      TCNT1H_shadow, TCNT1H
                sei
                rjmp    set_zc_blanking_time
;-----bko-----------------------------------------------------------------
wait_for_zc_blank:
                sbrc    flags2, NO_SYNC
                rjmp    wait_for_zc_blank_no_sync
        ; don't waste time while waiting - do some controls
                sbrc    flags1, RC_PULS_UPDATED
                rcall   evaluate_rc_puls
                rcall   set_new_duty
wait_for_zc_blank_loop:      
                sbrs    flags1, RC_PULS_UPDATED
                rjmp    wait_for_zc_blank_loop2
                rcall   evaluate_rc_puls
                rcall   set_new_duty
wait_for_zc_blank_loop2:                
                sbrc    flags0, OCT1_PENDING
                rjmp    wait_for_zc_blank_loop
set_zc_wait_time:
        ; set ZC timeout
                lds     YH, zc_wait_time_h
                lds     YL, zc_wait_time_l
                cli
                add     YL, TCNT1L_shadow
                adc     YH, TCNT1H_shadow
                out     OCR1AH, YH
                out     OCR1AL, YL
                sei
                sbr     flags0, (1<<OCT1_PENDING)
                ret
wait_for_zc_blank_no_sync:                
                sbrc    flags0, OCT1_PENDING
                rjmp    wait_for_zc_blank_no_sync
                rjmp    set_zc_wait_time                
;-----bko-----------------------------------------------------------------
start_timeout:  
                ldi     YL, 50*CLK_SCALE
                ldi     YH, 0
                rcall   update_timing
start_timeout_loop:                
                sbrc    flags0, OCT1_PENDING
                rjmp    start_timeout_loop      ; ZC blanking interval
                lds     YL, strt_zc_wait_time_h
                lds     YH, strt_zc_wait_time_x
                clr     temp6
                cli
                mov     temp1, TCNT1L_shadow
                mov     temp2, TCNT1H_shadow
                add     temp1, temp6
                adc     temp2, YL
                out     OCR1AH, temp2
                out     OCR1AL, temp1
                sbr     flags0, (1<<OCT1_PENDING)
                tst     YH
                breq    start_timeout_no_msb
                sbr     flags0, (1<<OCT1_MSB)                
start_timeout_no_msb:                
                sei
                subi    YL, 3
                sbci    YH, 0
                cpi     YL, high(RPM_TO_COMM_TIME(RPM_STEP_MAX)*CLK_SCALE)
                ldi     temp1, byte3(RPM_TO_COMM_TIME(RPM_STEP_MAX)*CLK_SCALE)
                cpc     YH, temp1
                brcc    start_timeout_no_lim
                ldi     YL, high(RPM_TO_COMM_TIME(RPM_STEP_INITIAL)*CLK_SCALE)         
                ldi     YH, byte3(RPM_TO_COMM_TIME(RPM_STEP_INITIAL)*CLK_SCALE)         
start_timeout_no_lim:
                sts     strt_zc_wait_time_h, YL
                sts     strt_zc_wait_time_x, YH
                ret
;-----bko-----------------------------------------------------------------
switch_power_off:
                ldi     ZH, PWR_PCT_TO_VAL(PCT_PWR_MIN)-1          ; ZH is new_duty
                SetPWMi(PWR_PCT_TO_VAL(PCT_PWR_MIN)-1)

                ldi     temp1, 0                ; reset limiter
                mov     sys_control, temp1

                ldi     temp1, INIT_PB          ; all off
                out     PORTB, temp1
                ldi     temp1, INIT_PC          ; all off
                out     PORTC, temp1
                ldi     temp1, INIT_PD          ; all off
                out     PORTD, temp1

                sbr     flags1, (1<<POWER_OFF)  ; disable power on
                sbr     flags2, (1<<STARTUP)
                ret                             ; motor is off
;-----bko-----------------------------------------------------------------
motor_brake:
#ifdef MOT_BRAKE
                ldi     temp2, 40               ; 40 * 0.065ms = 2.6 sec
                ldi     temp1, BRAKE_PB         ; all N-FETs on
                out     PORTB, temp1
                ldi     temp1, BRAKE_PC         ; all N-FETs on
                out     PORTC, temp1
                ldi     temp1, BRAKE_PD         ; all N-FETs on
                out     PORTD, temp1
mot_brk10:      sbrs    flags0, T1OVFL_FLAG
                rjmp    mot_brk10
                cbr     flags0, (1<<T1OVFL_FLAG)
                push    temp2
                rcall   evaluate_rc_puls
                pop     temp2
                cpi     ZH, PWR_PCT_TO_VAL(PCT_PWR_MIN)+3          ; avoid jitter detect
                brcs    mot_brk20
                rjmp    mot_brk90
mot_brk20:
                dec     temp2
                brne    mot_brk10
mot_brk90:
                ldi     temp1, INIT_PB          ; all off
                out     PORTB, temp1
                ldi     temp1, INIT_PC          ; all off
                out     PORTC, temp1
                ldi     temp1, INIT_PD          ; all off
                out     PORTD, temp1
#endif
                ret

no_sync_poff:
                sbr     flags1, (1<<POWER_OFF)
                ldi     temp1, INIT_PB          ; all off
                out     PORTB, temp1
                ldi     temp1, INIT_PC          ; all off
                out     PORTC, temp1
                ldi     temp1, INIT_PD          ; all off
                out     PORTD, temp1
                DbgLEDOn
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
                ldi     temp1, PWR_PCT_TO_VAL(PCT_PWR_STARTUP)      ; set limiter
                mov     sys_control, temp1
                SetPWMi(PWR_PCT_TO_VAL(PCT_PWR_STARTUP)*1/4);
                rcall   com6com1
                rcall   com1com2
                BpFET_on
                rcall   wait64ms
                rcall   wait64ms
                SetPWMi(PWR_PCT_TO_VAL(PCT_PWR_STARTUP)*2/4);
                rcall   wait64ms
                SetPWMi(PWR_PCT_TO_VAL(PCT_PWR_STARTUP)*3/4);
                rcall   wait64ms
                SetPWMi(PWR_PCT_TO_VAL(PCT_PWR_STARTUP));
                BpFET_off               
                rcall   com2com3
                ret                
;-----bko-----------------------------------------------------------------
; **** startup loop ****
init_startup:   rcall   switch_power_off
                rcall   motor_brake
wait_for_power_on:
                ;DbgLEDOn

                rcall   evaluate_rc_puls
                ;cpi     ZH, PWR_PCT_TO_VAL(PCT_PWR_MIN) + 1
                ;brcs    wait_for_power_on
                AcInit
                ;rcall   pre_align
                ;DbgLEDOn

                cbr     flags2, (1<<NO_SYNC) 
                cbr     flags2, (1<<SCAN_TIMEOUT)
                ldi     temp1, 0
                sts     goodies, temp1
                ldi     temp1, 47*CLK_SCALE; ~ 3 sec
                mov     t1_timeout, temp1
                rcall   set_all_timings
                rcall   start_timeout
                rjmp    start3
;-----bko-----------------------------------------------------------------
; **** start control loop ****

; state 1 = B(p-on) + C(n-choppered) - comparator A evaluated
; out_cA changes from low to high
start1:         
                rcall   wait_for_low_strt
                rcall   wait_for_high_strt
;                rcall   wait_for_test
                sbrs    flags0, OCT1_PENDING
                sbr     flags2, (1<<SCAN_TIMEOUT)
                rcall   com1com2
                rcall   start_timeout

; state 2 = A(p-on) + C(n-choppered) - comparator B evaluated
; out_cB changes from high to low
                rcall   wait_for_high_strt
                rcall   wait_for_low_strt
;                rcall   wait_for_test
                sbrs    flags0, OCT1_PENDING
                sbr     flags2, (1<<SCAN_TIMEOUT)
                rcall   com2com3
                rcall   start_timeout

; state 3 = A(p-on) + B(n-choppered) - comparator C evaluated
; out_cC changes from low to high
start3:
                rcall   wait_for_low_strt
                rcall   wait_for_high_strt
;                rcall   wait_for_test
                sbrs    flags0, OCT1_PENDING
                sbr     flags2, (1<<SCAN_TIMEOUT)
                rcall   com3com4
                rcall   start_timeout

; state 4 = C(p-on) + B(n-choppered) - comparator A evaluated
; out_cA changes from high to low
                rcall   wait_for_high_strt
                rcall   wait_for_low_strt
;                rcall   wait_for_test
                sbrs    flags0, OCT1_PENDING
                sbr     flags2, (1<<SCAN_TIMEOUT)
                rcall   com4com5
                rcall   start_timeout

; state 5 = C(p-on) + A(n-choppered) - comparator B evaluated
; out_cB changes from low to high
                rcall   wait_for_low_strt
                rcall   wait_for_high_strt
;                rcall   wait_for_test
                sbrs    flags0, OCT1_PENDING
                sbr     flags2, (1<<SCAN_TIMEOUT)
                rcall   com5com6
                rcall   evaluate_sys_state
                rcall   evaluate_rc_puls
                rcall   set_new_duty_strt
                rcall   start_timeout

; state 6 = B(p-on) + A(n-choppered) - comparator C evaluated
; out_cC changes from high to low
                rcall   wait_for_high_strt
                rcall   wait_for_low_strt
;                rcall   wait_for_test
                sbrs    flags0, OCT1_PENDING
                sbr     flags2, (1<<SCAN_TIMEOUT)
                rcall   com6com1
                ; no throttle 
                ;cpi     ZH, PWR_PCT_TO_VAL(PCT_PWR_MIN)
                ;brcs    init_startup
                ; timeout 
                tst     t1_timeout
                breq    init_startup
                
                lds     temp1, goodies
                sbrc    flags2, SCAN_TIMEOUT
                clr     temp1
                inc     temp1
                sts     goodies,  temp1
                cbr     flags2, (1<<SCAN_TIMEOUT)
                cpi     temp1, ENOUGH_GOODIES
                brcs    s6_start1
                ; We need some rotations without lost sync, to be able to trust timing..
                lds     temp1, timing_h 
                cpi     temp1, HIGH(RPM_TO_COMM_TIME(RPM_START_MIN_RPM)*4*CLK_SCALE) 
                lds     temp1, timing_x
                ldi     temp2, BYTE3(RPM_TO_COMM_TIME(RPM_START_MIN_RPM)*4*CLK_SCALE) 
                cpc     temp1, temp2
                brcs    start_to_run
s6_start1:      
                rcall   start_timeout            
                rjmp    start1                  ; go back to state 1

start_to_run:
                ldi     temp1, PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP)
                mov     sys_control, temp1

                rcall   calc_next_timing
                rcall   wait_for_commutation    ; needed to align phases 
                rcall   wait_for_zc_blank       ; the ZC timeout should start at: ZC + comm_time + zc_blank_time

                ;DbgLEDOff

                cbr     flags2, (1<<NO_SYNC) 
                cbr     flags2, (1<<STARTUP)
                rjmp    run1                    ; running state begins
                
;-----bko-----------------------------------------------------------------
; **** running control loop ****
; run 1 = B(p-on) + C(n-choppered) - comparator A evaluated
; out_cA changes from low to high
run1:           
                rcall   wait_for_low
                sbrs    flags0, OCT1_PENDING
                rjmp    run1_fail
                rcall   wait_for_high
                sbrc    flags0, OCT1_PENDING
                rjmp    run1_1
run1_fail:             
                sbr     flags2, (1<<NO_SYNC) 
                rcall   no_sync_poff
run1_1:                
                rcall   calc_next_timing
                rcall   wait_for_commutation
                rcall   com1com2
                rcall   wait_for_zc_blank
                cbr     flags2, (1<<NO_SYNC) 
; run 2 = A(p-on) + C(n-choppered) - comparator B evaluated
; out_cB changes from high to low
run2:
                rcall   wait_for_high
                sbrs    flags0, OCT1_PENDING
                rjmp    run2_fail
                rcall   wait_for_low
                sbrc    flags0, OCT1_PENDING
                rjmp    run2_1
run2_fail:
                sbr     flags2, (1<<NO_SYNC) 
                rcall   no_sync_poff
run2_1:                
                rcall   calc_next_timing
                rcall   wait_for_commutation
                rcall   com2com3
                rcall   wait_for_zc_blank
                cbr     flags2, (1<<NO_SYNC) 
; run 3 = A(p-on) + B(n-choppered) - comparator C evaluated
; out_cC changes from low to high
run3:           rcall   wait_for_low
                sbrs    flags0, OCT1_PENDING
                rjmp    run3_fail
                rcall   wait_for_high
                sbrc    flags0, OCT1_PENDING
                rjmp    run3_1                
run3_fail:                
                sbr     flags2, (1<<NO_SYNC) 
                rcall   no_sync_poff
run3_1:                
                rcall   calc_next_timing
                rcall   wait_for_commutation
                rcall   com3com4
                rcall   wait_for_zc_blank
                cbr     flags2, (1<<NO_SYNC) 
; run 4 = C(p-on) + B(n-choppered) - comparator A evaluated
; out_cA changes from high to low
run4:           rcall   wait_for_high
                sbrs    flags0, OCT1_PENDING
                rjmp    run4_fail
                rcall   wait_for_low
                sbrc    flags0, OCT1_PENDING
                rjmp    run4_1
run4_fail:                
                sbr     flags2, (1<<NO_SYNC) 
                rcall   no_sync_poff
run4_1:        
                rcall   calc_next_timing
                rcall   wait_for_commutation
                rcall   com4com5
                rcall   wait_for_zc_blank
                cbr     flags2, (1<<NO_SYNC) 
; run 5 = C(p-on) + A(n-choppered) - comparator B evaluated
; out_cB changes from low to high
run5:           rcall   wait_for_low
                sbrs    flags0, OCT1_PENDING
                rjmp    run5_fail
                rcall   wait_for_high
                sbrc    flags0, OCT1_PENDING
                rjmp    run5_1                
run5_fail:                
                sbr     flags2, (1<<NO_SYNC) 
                rcall   no_sync_poff
run5_1:                
                rcall   calc_next_timing
                rcall   wait_for_commutation
                rcall   com5com6
                rcall   wait_for_zc_blank
                cbr     flags2, (1<<NO_SYNC) 
; run 6 = B(p-on) + A(n-choppered) - comparator C evaluated
; out_cC changes from high to low
run6:           rcall   wait_for_high
                sbrs    flags0, OCT1_PENDING
                rjmp    run6_fail
                rcall   wait_for_low
                sbrc    flags0, OCT1_PENDING
                rjmp    run6_1                
run6_fail:                
                sbr     flags2, (1<<NO_SYNC) 
                rcall   no_sync_poff
run6_1:                
                rcall   calc_next_timing
                rcall   wait_for_commutation
                rcall   com6com1
                rcall   evaluate_sys_state 
                rcall   wait_for_zc_blank
                cbr     flags2, (1<<NO_SYNC) 
run6_1_1:                
                sbrc    flags2, RUN_MIN_RPM
                rjmp    run1

run_to_start:   sbr     flags2, (1<<STARTUP)
                cpi     ZH, PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP) 
                brcs    run_to_start_2
                rjmp    restart_control
run_to_start_2:                
                rjmp    wait_for_power_on

restart_control:
                cli                             ; disable all interrupts
                rcall   switch_power_off
                rjmp    reset
;-----bko-----------------------------------------------------------------
; *** scan comparator utilities ***
filter_delay:  
                push    temp1
                ldi     temp1, 16*CLK_SCALE
filter_delay_loop: 
                dec     temp1
                brne    filter_delay_loop
                pop     temp1
                ret

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
                ldi     temp3, (8-ZCF_CONST) + 1
wait_for_low_loop:
                sbrs    flags0, OCT1_PENDING
                ret
                __wait_for_filter
                cp      temp2, temp3
                brcc    wait_for_low_loop
                ret
                               
wait_for_high:   
                ldi     temp1, 0x0
                ldi     temp2, 0
                ldi     temp3, ZCF_CONST
wait_for_high_loop:
                sbrs    flags0, OCT1_PENDING
                ret
                __wait_for_filter
                cp      temp2, temp3
                brcs    wait_for_high_loop
                ret

wait_for_high_strt:
                ldi     temp1, 0x0
                ldi     temp2, 0
                ldi     temp3, 5
wait_for_high_strt_loop:
                sbrs    flags0, OCT1_PENDING
                ret
                __wait_for_filter
                rcall   filter_delay
                cp      temp2, temp3
                brcs    wait_for_high_strt_loop
                ret

wait_for_low_strt:
                ldi     temp1, 0xFF
                ldi     temp2, 8
                ldi     temp3, (8-5) + 1
wait_for_low_strt_loop:
                sbrs    flags0, OCT1_PENDING
                ret
                __wait_for_filter
                rcall   filter_delay
                cp      temp2, temp3
                brcc    wait_for_low_strt_loop
                ret
                
wait_for_test:
                sbrs    flags0, OCT1_PENDING
                ret
                rjmp    wait_for_test
                ret
                
;-----bko-----------------------------------------------------------------
; *** commutation utilities ***
com1com2:       BpFET_off                             ; Bp off
                CpFET_off                             ; Cp off
                sbrs    flags1, POWER_OFF
                ApFET_on                              ; Ap on
                AcPhaseB
                ret

com2com3:       
                PwmCSEnter
                cbr     flags0, (1<<A_FET) + (1<<B_FET) + (1<<C_FET)   
                sbr     flags0, (1<<B_FET)            ; next nFET = BnFET
                sbrc    flags1, NO_COMM               ; 
                rjmp    c2_done                       ; .. yes - futhermore work is done in timer0 interrupt
                CnFET_off                             ; Cn off
                AnFET_off                             ; An off
                sbrs    flags1, POWER_OFF
                BnFET_on                              ; Bn on
c2_done:        
                PwmCSLeave
                AcPhaseC
                ret

com3com4:       ApFET_off                             ; Ap off
                BpFET_off                             ; Bp off
                sbrs    flags1, POWER_OFF
                CpFET_on                              ; Cp on
                AcPhaseA
                ret

com4com5:       
                PwmCSEnter 
                cbr     flags0, (1<<A_FET) + (1<<B_FET) + (1<<C_FET)   
                sbr     flags0, (1<<A_FET)            ; next nFET = AnFET
                sbrc    flags1, NO_COMM               ; 
                rjmp    c4_done                       ; .. yes - futhermore work is done in timer0 interrupt
                BnFET_off                             ; Bn off
                CnFET_off                             ; Cn off
                sbrs    flags1, POWER_OFF
                AnFET_on                              ; An on
c4_done:        
                PwmCSLeave
                AcPhaseB
                ret

com5com6:       CpFET_off                             ; Cp off
                ApFET_off                             ; Ap off
                sbrs    flags1, POWER_OFF
                BpFET_on                              ; Bp on
                AcPhaseC
                ret

com6com1:       
                PwmCSEnter
                cbr     flags0, (1<<A_FET) + (1<<B_FET) + (1<<C_FET)   
                sbr     flags0, (1<<C_FET)            ; next nFET = CnFET
                sbrc    flags1, NO_COMM               ; 
                rjmp    c6_done                       ; .. yes - futhermore work is done in timer0 interrupt
                AnFET_off                             ; An off
                BnFET_off                             ; Bn off
                sbrs    flags1, POWER_OFF
                CnFET_on                              ; Cn on
c6_done:        
                PwmCSLeave
                AcPhaseA
                ret

.exit
