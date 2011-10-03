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
                in      i_temp1, TCNT1L
                in      i_temp2, TCNT1H
                in      i_sreg, SREG
                sbis    PIND, rcp_in
                rjmp    falling_edge
                
                ldi     i_temp3, micp_f_edge
                out     MCUCR, i_temp3                            ; set next int to falling edge
                mov     start_rcpuls_l, i_temp1
                mov     start_rcpuls_h, i_temp2
                rjmp    micp_exit

micp_fail:      tst     control_timeout
                breq    micp_exit
                dec     control_timeout
                rjmp    micp_exit
                
falling_edge:
                ldi     i_temp3, micp_r_edge
                out     MCUCR, i_temp3                            ; set next int to rising edge
                
                sts     stop_rcpuls_l, i_temp1                    ; prepare next interval evaluation
                sts     stop_rcpuls_h, i_temp2
                sub     i_temp1, start_rcpuls_l
                sbc     i_temp2, start_rcpuls_h
                ; save impuls length
                sts     new_rcpuls_l, i_temp1
                sts     new_rcpuls_h, i_temp2
                cpi     i_temp1, low (MAX_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MAX_INT_RF*CLK_SCALE)       ; test range high
                cpc     i_temp2, i_temp3
                brsh    micp_fail                                 ; through away
                cpi     i_temp1, low (MIN_INT_RF*CLK_SCALE)
                ldi     i_temp3, high(MIN_INT_RF*CLK_SCALE)       ; test range low
                cpc     i_temp2, i_temp3
                brlo    micp_fail                                 ; through away
                sbr     flags1, (1<<RC_PULS_UPDATED)              ; set to rc impuls value is ok !
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
                