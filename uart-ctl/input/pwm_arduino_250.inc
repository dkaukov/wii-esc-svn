.include "ppm.inc"

.equ    POWER_RANGE   = 250
.equ    MIN_RC_PULS   = 18

; falling->rising intervals
.equ    MAX_INT_FR    = 2200
.equ    MIN_INT_FR    = 16

; rising->falling intervals
.equ    MAX_INT_RF    = 2200
.equ    MIN_INT_RF    = 16

.macro EvaluatePWC
                cbr     flags1, (1<<EVAL_RC_PULS)
                sbrs    flags1, RC_PULS_UPDATED
                rjmp    eval_rc_p90
                lds     temp1, new_rcpuls_l
                lds     temp2, new_rcpuls_h
                cbr     flags1, (1<<RC_PULS_UPDATED) ; rc impuls value is read out
eval_rc_p00:    lsr     temp2   
                ror     temp1
                lsr     temp2   
                ror     temp1
                lsr     temp2   
                ror     temp1
.if CLK_SCALE==2
                lsr     temp2   
                ror     temp1
.endif
                mov     temp3, temp1
                cpi     temp3, POWER_RANGE
                brcs    eval_rc_p10
                ldi     temp3, POWER_RANGE
eval_rc_p10:    cpi     temp3, MIN_DUTY 
                brcc    eval_rc_p20
                ldi     temp3, 0
eval_rc_p20:    mov     ZH, temp3
eval_rc_p90:    ret
.endmacro
