.equ    POWER_RANGE   = 125
.equ    MIN_RC_PULS   = 1000

; falling->rising intervals
.equ    MAX_INT_FR    = 25000
.equ    MIN_INT_FR    = 16

; rising->falling intervals
.equ    MAX_INT_RF    = 2200
.equ    MIN_INT_RF    = (MIN_RC_PULS-8)

.macro EvaluatePWC
		cbr	flags1, (1<<EVAL_RC_PULS)
		sbrs	flags1, RC_PULS_UPDATED
		rjmp	eval_rc_p90
		lds	temp1, new_rcpuls_l
		lds	temp2, new_rcpuls_h
		cbr	flags1, (1<<RC_PULS_UPDATED) ; rc impuls value is read out
		subi	temp1, low  (MIN_RC_PULS*CLK_SCALE)
		sbci	temp2, high (MIN_RC_PULS*CLK_SCALE)
		brcc	eval_rc_p00
		clr	temp1
		clr	temp2
eval_rc_p00:	lsr	temp2	; actual 0->1000
		ror	temp1
		lsr	temp2	; actual 0->500
		ror	temp1
		lsr	temp2	; actual 0->250
		ror	temp1
.if CLK_SCALE==2
		lsr	temp2	; actual 0->400
		ror	temp1
.endif
		; now 0->125
		mov	temp3, temp1		
		cpi	temp3, POWER_RANGE
		brcs	eval_rc_p10
		ldi	temp3, POWER_RANGE
eval_rc_p10:	tst	temp3
		breq	eval_rc_p20
		cpi	temp3, MIN_DUTY	; +20
		brcc	eval_rc_p20
		ldi	temp3, MIN_DUTY	; +20
eval_rc_p20:	mov	ZH, temp3
eval_rc_p90:	ret
.endmacro