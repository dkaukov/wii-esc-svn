.equ    EXT0_DIS   = 0x00       ; disable ext0int
.equ    EXT0_EN    = 0x40       ; enable ext0int

#define __ext_int0  rjmp ext_int0_isr
.macro __ext_int0_isr
  __ext_micp_isr
.endmacro

;-----bko-----------------------------------------------------------------
; external interrupt0 = rc pulse input
.macro __ext_micp_isr
                in      i_sreg, SREG
                clr     i_temp1                                   ; disable extint edge may be changed
                out     GIMSK, i_temp1

; evaluate edge of this interrupt
                in      i_temp1, MCUCR
                sbrs    i_temp1, ISC00
                rjmp    falling_edge                              ; bit is clear = falling edge

; should be rising edge - test rc impuls level state for possible jitter
                sbis    PIND, rcp_in
                rjmp    extint1_exit                              ; jump, if low state

; rc impuls is at high state
                ldi     i_temp1, (1<<ISC01)
                out     MCUCR, i_temp1                            ; set next int0 to falling edge

; get timer1 values
                in      i_temp1, TCNT1L
                in      i_temp2, TCNT1H
                mov     start_rcpuls_l, i_temp1
                mov     start_rcpuls_h, i_temp2
; test rcpulse interval
                cbr     flags2, (1<<RC_INTERVAL_OK)               ; preset to not ok
                lds     i_temp3, stop_rcpuls_l
                sub     i_temp1, i_temp3
                lds     i_temp3, stop_rcpuls_h
                sbc     i_temp2, i_temp3
                cpi     i_temp1, low (MAX_INT_FR*CLK_SCALE)
                ldi     i_temp3, high(MAX_INT_FR*CLK_SCALE)       ; test range high
                cpc     i_temp2, i_temp3
                brsh    extint1_fail                              ; through away
                cpi     i_temp1, low (MIN_INT_FR*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_FR*CLK_SCALE)       ; test range low
                cpc     i_temp2, i_temp3
                brlo    extint1_fail                              ; through away
                sbr     flags2, (1<<RC_INTERVAL_OK)               ; set to rc impuls value is ok !
                rjmp    extint1_exit
extint1_fail:   tst     control_timeout
                breq    extint1_exit
                dec     control_timeout
                rjmp    extint1_exit
                ; rc impuls is at low state
falling_edge:   sbic    PIND, rcp_in                              ; test level of rc impuls
                rjmp    extint1_exit                              ; seems to be a spike
                ldi     i_temp1, (1<<ISC01)+(1<<ISC00)
                out     MCUCR, i_temp1                            ; set next int0 to rising edge
                sbrc    flags1, RC_PULS_UPDATED
                rjmp    extint1_exit
                ; get timer1 values
                in      i_temp1, TCNT1L
                in      i_temp2, TCNT1H
                sts     stop_rcpuls_l, i_temp1                    ; prepare next interval evaluation
                sts     stop_rcpuls_h, i_temp2
                sbrs    flags2, RC_INTERVAL_OK
                rjmp    extint1_exit
                cbr     flags2, (1<<RC_INTERVAL_OK)               ; flag is evaluated
                sub     i_temp1, start_rcpuls_l
                sbc     i_temp2, start_rcpuls_h
                ; save impuls length
                sts     new_rcpuls_l, i_temp1
                sts     new_rcpuls_h, i_temp2
                cpi     i_temp1, low (MAX_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MAX_INT_RF*CLK_SCALE)       ; test range high
                cpc     i_temp2, i_temp3
                brsh    extint1_fail                              ; through away
                cpi     i_temp1, low (MIN_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_RF*CLK_SCALE)       ; test range low
                cpc     i_temp2, i_temp3
                brlo    extint1_fail                              ; through away
                sbr     flags1, (1<<RC_PULS_UPDATED)              ; set to rc impuls value is ok !
                ldi     i_temp1, CONTROL_TOT*CLK_SCALE
                mov     control_timeout, i_temp1
                ; enable int1 again -  also entry for spike detect
extint1_exit:   ldi     i_temp2, EXT0_EN
                out     GIMSK, i_temp2
                out     SREG, i_sreg
                reti
.endm

.macro enable_input
                ldi     temp4, EXT0_EN                            ; ext0int enable
                out     GIMSK, temp4                              ; enable ext0int
.endm 

.macro disable_input
                ldi     temp4, EXT0_DIS                           ; disable ext0int
                out     GIMSK, temp4
.endm 

.macro init_input
                ldi     temp1, (1<<ISC01)+(1<<ISC00)
                out     MCUCR, temp1                              ; set next int0 to rising edge
                enable_input
.endm
                