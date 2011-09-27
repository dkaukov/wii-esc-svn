.include "common.inc"

#define Typ "Plush 30"

;**** **** **** **** ****
; PORT  definitions
;**** **** **** **** ****

;*********************
; PORT D 
;*********************  
.equ    mux_c           = 7     ;i <plus> comparator input (AIN0)
.equ    c_comp          = 6     ;i common comparator input (AIN0)
.equ    ApFET           = 5     ;o
.equ    BpFET           = 4     ;o
.equ    CpFET           = 3     ;o
.equ    rcp_in          = 2     ;i r/c pulse input

.equ    INIT_PD         = 0
.equ    DIR_PD          = (1<<ApFET)+(1<<BpFET)+(1<<CpFET)
.equ    BRAKE_PD        = 0

#define ApFET_on        sbi     PORTD,5
#define ApFET_off       cbi     PORTD,5
#define BpFET_on        sbi     PORTD,4
#define BpFET_off       cbi     PORTD,4
#define CpFET_on        sbi     PORTD,3
#define CpFET_off       cbi     PORTD,3


;*********************
; PORT C definitions *
;*********************
.equ    mux_a           = 5     ; ADC5 phase input
.equ    mux_b           = 4     ; ADC4 phase input
;.equ                   = 3     ; ADC3
;.equ                   = 2     ; ADC2
.equ    temp_adc        = 1     ; ADC1 temperature control input 
.equ    accu_adc        = 0     ; ADC0 voltage control input 

;*********************
; ADC only
;*********************
;.equ                   = 7     ; ADC7
;.equ                   = 6     ; ADC6

.equ    INIT_PC         = 0
.equ    DIR_PC          = 0
.equ    BRAKE_PC        = 0


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
;.equ           = 0

.equ    AnFET           = 2     ;o
.equ    BnFET           = 1     ;o
.equ    CnFET           = 0     ;o

.equ    INIT_PB         = 0
.equ    DIR_PB          = (1<<AnFET)+(1<<BnFET)+(1<<CnFET)+(1<<DbgLED)
.equ    BRAKE_PB        = (1<<AnFET)+(1<<BnFET)+(1<<CnFET)

#define AnFET_on        sbi     PORTB,2
#define AnFET_off       cbi     PORTB,2
#define BnFET_on        sbi     PORTB,1
#define BnFET_off       cbi     PORTB,1
#define CnFET_on        sbi     PORTB,0
#define CnFET_off       cbi     PORTB,0

#define DbgLEDOn        sbi     PORTB,5
#define DbgLEDOff       cbi     PORTB,5

;*************************
; Comparator definitions *
;*************************

.macro AcInit
.endmacro


.macro AcPhaseA
  ACChannel mux_a
  ACMultiplexed
.endmacro


.macro AcPhaseB
  ACChannel mux_b
  ACMultiplexed
.endmacro


.macro AcPhaseC
  ACNormal
.endmacro


;*************************
; Parameters             *
;*************************
.equ MOT_BRAKE        = 0
.equ CLK_SCALE        = 1                       ; 8Mhz internal RC oscilator 
.equ READ_CALIBRATION = 1                       ; Calibrated  

;*************************
; Timings                *
;*************************
.equ    MIN_DUTY        = 3*POWER_RANGE/100     ; Min power 3%

.equ    PWR_MAX_RPM1    = POWER_RANGE/4
.equ    PWR_MAX_RPM2    = POWER_RANGE/2

.equ    PWR_STARTUP     = 5*POWER_RANGE/100     ;  5%
.equ    PWR_MAX_STARTUP = 12*POWER_RANGE/100    ; 15%

.equ    timeoutSTART    = 48000
.equ    timeoutMIN      = 36000

.equ    PWR_RANGE1      = 0x40      ; ( ~2400 RPM )
.equ    PWR_RANGE2      = 0x20

.equ    ENOUGH_GOODIES  = 60
