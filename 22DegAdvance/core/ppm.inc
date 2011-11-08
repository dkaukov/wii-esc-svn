#if (rcp_in == 2)
  #define    micp_dis     0x00       ; disable ext0int
  #define    micp_en      (1<<INT0)  ; enable ext0int
  #define    micp_r_edge  (1<<ISC01)+(1<<ISC00)
  #define    micp_f_edge  (1<<ISC01)
  #define    micp_m_test  ISC00
  #define    __ext_int0   rjmp ext_int0_isr
  .macro __ext_int0_isr
    __ext_micp_isr
  .endmacro
#endif

#if (rcp_in == 3)
  #define    micp_dis     0x00       ; disable ext0int
  #define    micp_en      (1<<INT1)  ; enable ext0int
  #define    micp_r_edge  (1<<ISC11)+(1<<ISC10)
  #define    micp_f_edge  (1<<ISC11)
  #define    micp_m_test  ISC10
  #define    __ext_int1   rjmp ext_int1_isr
  .macro __ext_int1_isr
    __ext_micp_isr
  .endmacro
#endif


;-----bko-----------------------------------------------------------------
; external interrupt = rc pulse input
.macro __ext_micp_isr
                in      i_sreg, SREG
                ; evaluate edge of this interrupt
                in      i_temp1, MCUCR
                sbrs    i_temp1, micp_m_test
                rjmp    falling_edge                              ; bit is clear = falling edge
                ; should be rising edge - test rc impuls level state for possible jitter
                sbis    PIND, rcp_in
                rjmp    micp_exit                                 ; jump, if low state
                ; rc impuls is at high state
                ldi     i_temp1, micp_f_edge
                out     MCUCR, i_temp1                            ; set next int to falling edge
                ; get timer1 values
                in      i_temp1, TCNT1L
                in      i_temp2, TCNT1H
                sts     start_rcpuls_l, i_temp1
                sts     start_rcpuls_h, i_temp2
                ; test rcpulse interval
                cbr     flags2, (1<<RC_INTERVAL_OK)               ; preset to not ok
                lds     i_temp3, stop_rcpuls_l
                sub     i_temp1, i_temp3
                lds     i_temp3, stop_rcpuls_h
                sbc     i_temp2, i_temp3
                cpi     i_temp1, low (MAX_INT_FR*CLK_SCALE)
                ldi     i_temp3, high(MAX_INT_FR*CLK_SCALE)       ; test range high
                cpc     i_temp2, i_temp3
                brsh    micp_fail                                 ; through away
                cpi     i_temp1, low (MIN_INT_FR*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_FR*CLK_SCALE)       ; test range low
                cpc     i_temp2, i_temp3
                brlo    micp_fail                                 ; through away
                sbr     flags2, (1<<RC_INTERVAL_OK)               ; set to rc impuls value is ok !
                out     SREG, i_sreg
                reti
micp_fail:      
                out     SREG, i_sreg
                reti
falling_edge:   
                ; rc impuls is at low state
                sbic    PIND, rcp_in                              ; test level of rc impuls
                rjmp    micp_exit                                 ; seems to be a spike
                ldi     i_temp1, micp_r_edge
                out     MCUCR, i_temp1                            ; set next int to rising edge
                ; get timer1 values
                in      i_temp1, TCNT1L
                in      i_temp2, TCNT1H
                sts     stop_rcpuls_l, i_temp1                    ; prepare next interval evaluation
                sts     stop_rcpuls_h, i_temp2
                sbrs    flags2, RC_INTERVAL_OK
                rjmp    micp_exit
                cbr     flags2, (1<<RC_INTERVAL_OK)               ; flag is evaluated
                lds     i_temp3, start_rcpuls_l  
                sub     i_temp1, i_temp3
                lds     i_temp3, start_rcpuls_h
                sbc     i_temp2, i_temp3
                cpi     i_temp1, low (MAX_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MAX_INT_RF*CLK_SCALE)       ; test range high
                cpc     i_temp2, i_temp3
                brsh    micp_fail                                 ; through away
                cpi     i_temp1, low (MIN_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_RF*CLK_SCALE)       ; test range low
                cpc     i_temp2, i_temp3
                brlo    micp_fail                                 ; through away
                sbr     flags1, (1<<RC_PULS_UPDATED)              ; set to rc impuls value is ok !
                ; save impuls length
                movw    new_rcpuls_l:new_rcpuls_h, i_temp1:i_temp2
                ldi     i_temp1, CONTROL_TOT*CLK_SCALE
                mov     control_timeout, i_temp1
micp_exit:                
                out     SREG, i_sreg
                reti
.endm

.macro enable_input
                ldi     temp4, micp_en
                out     GIMSK, temp4                              
.endm 

.macro disable_input
                ldi     temp4, micp_dis
                out     GIMSK, temp4
.endm 

.macro init_input
                ldi     temp1, micp_r_edge
                out     MCUCR, temp1                              
                enable_input
.endm
                