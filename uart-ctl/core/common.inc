.macro ACMultiplexed
  cbi     ADCSRA, ADEN          ; disable ADC
  in      temp1, SFIOR
  sbr     temp1, (1<<ACME)      ; switch to comparator multiplexed
  out     SFIOR, temp1
.endmacro  

.macro ACNormal
   cbr  temp1, (1<<ACME)        ; set to AN1
   out  SFIOR, temp1
   sbi  ADCSRA, ADEN            ; enable ADC
.endmacro  

.macro ACChannel 
   ldi   temp1, @0              
   out   ADMUX, temp1
.endmacro  
   