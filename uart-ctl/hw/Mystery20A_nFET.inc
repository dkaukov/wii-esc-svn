.include "common.inc"

#define Typ "Mystery 20"


;**** **** **** **** ****
; PORT  definitions
;**** **** **** **** ****

;*********************
; PORT D 
;*********************  
;.equ                   = 7     ;
.equ    c_comp          = 6     ;i common comparator input (AIN0)
.equ    AnFET           = 5     ;o
.equ    ApFET           = 4     ;o
;.equ                   = 3     ;
.equ    rcp_in          = 2     ;i r/c pulse input
;.equ                   = 1     ;
;.equ                   = 0     ;


.equ    INIT_PD         = (1<<ApFET)
.equ    DIR_PD      = (1<<ApFET)+(1<<AnFET)
.equ    BRAKE_PD        = (1<<AnFET)


;*********************
; ADC definitions
;*********************

.equ    mux_c           = 0     ; ADC0
.equ    mux_a           = 6     ; ADC6
.equ    mux_b           = 7     ; ADC7
.equ    ACCU_MUX        = 2     ; ADC2 voltage control input 

;*********************
; PORT C definitions *
;*********************
.equ    AnRef           = 1
.equ    CpFET           = 3
.equ    BnFET           = 4
.equ    BpFET           = 5  


.equ    INIT_PC         = (1<<AnRef)+(1<<CpFET)+(1<<BpFET)
.equ    DIR_PC          = (1<<AnRef)+(1<<CpFET)+(1<<BnFET)+(1<<BpFET)
.equ    BRAKE_PC        = (1<<BnFET)


;*********************
; PORT B definitions *
;*********************
;.equ           = 7     
;.equ           = 6     
.equ    DbgLED  = 5;    (sck stk200 interface) 
;.equ           = 4     (miso stk200 interface)
;.equ           = 3     (mosi stk200 interface) 
;.equ           = 2     
;.equ           = 1     
.equ    CnFET   = 0

.equ    INIT_PB         = 0
.equ    DIR_PB          = (1<<CnFET)+(1<<DbgLED)
.equ    BRAKE_PB        = (1<<CnFET)


#define DbgLEDOn        sbi     PORTB,5
#define DbgLEDOff       cbi     PORTB,5


;*********************
; FET Control        *
;*********************
#define ApFET_on        cbi     PORTD,4
#define ApFET_off       sbi     PORTD,4
#define AnFET_on        sbi     PORTD,5
#define AnFET_off       cbi     PORTD,5

#define BpFET_on        cbi     PORTC,5
#define BpFET_off       sbi     PORTC,5
#define BnFET_on        sbi     PORTC,4
#define BnFET_off       cbi     PORTC,4

#define CpFET_on        cbi     PORTC,3
#define CpFET_off       sbi     PORTC,3
#define CnFET_on        sbi     PORTB,0
#define CnFET_off       cbi     PORTB,0


;*************************
; Comparator definitions *
;*************************

.macro AcInit
  ACMultiplexed
.endmacro


.macro AcPhaseA
  ACChannel mux_a
.endmacro


.macro AcPhaseB
  ACChannel mux_b
.endmacro


.macro AcPhaseC
  ACChannel mux_c
.endmacro


;*************************
; Parameters             *
;*************************
.equ MOT_BRAKE        = 0
.equ CLK_SCALE        = 2                       ; 16Mhz external crystal
.equ READ_CALIBRATION = 0                       ;

;*************************
; Timings                *
;*************************
.equ    MIN_DUTY        = 3*POWER_RANGE/100     ; Min power 3%

.equ    PWR_MAX_RPM1    = POWER_RANGE/4
.equ    PWR_MAX_RPM2    = POWER_RANGE/2

.equ    PWR_STARTUP     = 5*POWER_RANGE/100     ;  5%
.equ    PWR_MAX_STARTUP = 12*POWER_RANGE/100    ; 15%


.equ    timeoutSTART    = 65000
.equ    timeoutMIN      = 48000

.equ    PWR_RANGE1      = 0x40  ; ( ~2400 RPM )
.equ    PWR_RANGE2      = 0x20  ; ( ~4800 RPM )

.equ    ENOUGH_GOODIES  = 60
