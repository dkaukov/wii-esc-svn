.include "common.inc"

#define Typ "Plush 30"

;**** **** **** **** ****
; PORT  definitions
;**** **** **** **** ****

;*********************
; PORT D 
;*********************  
#define mux_c           7     ;i <plus> comparator input (AIN0)
#define c_comp          6     ;i common comparator input (AIN0)
#define ApFET           5     ;o
#define BpFET           4     ;o
#define CpFET           3     ;o
#define rcp_in          2     ;i r/c pulse input

#define INIT_PD         0
#define DIR_PD          (1<<ApFET)+(1<<BpFET)+(1<<CpFET)
#define BRAKE_PD        0

#define ApFET_on        sbi     PORTD,5
#define ApFET_off       cbi     PORTD,5
#define BpFET_on        sbi     PORTD,4
#define BpFET_off       cbi     PORTD,4
#define CpFET_on        sbi     PORTD,3
#define CpFET_off       cbi     PORTD,3


;*********************
; PORT C definitions *
;*********************
#define mux_a           5     ; ADC5 phase input
#define mux_b           4     ; ADC4 phase input
;#define                3     ; ADC3
;#define                2     ; ADC2
#define temp_adc        1     ; ADC1 temperature control input 
#define accu_adc        0     ; ADC0 voltage control input 

;*********************
; ADC only
;*********************
;#define                7     ; ADC7
;#define                6     ; ADC6

#define INIT_PC         0
#define DIR_PC          0
#define BRAKE_PC        0


;*********************
; PORT B definitions *
;*********************
;#define                7     
;#define                6     
#define  DbgLED         5;    (sck stk200 interface) 
;#define                4     (miso stk200 interface)
;#define                3     (mosi stk200 interface) 
;#define                2     
;#define                1     
;#define                0

#define AnFET           2     ;o
#define BnFET           1     ;o
#define CnFET           0     ;o

#define INIT_PB         0
#define DIR_PB          (1<<AnFET)+(1<<BnFET)+(1<<CnFET)+(1<<DbgLED)
#define BRAKE_PB        (1<<AnFET)+(1<<BnFET)+(1<<CnFET)

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
#undef     MOT_BRAKE      
#undef     READ_CALIBRATION
#define    F_CPU               8000000           ; 8Mhz internal RC oscilator 
#define    ZCF_CONST           6
           
;*************************
; Power settings         *
;*************************
#define    PCT_PWR_MIN         3                 ; Min power 3%

;*************************
; Power curve            *
;*************************
PWR_CURVE_POINT(01, 3500, 25)
PWR_CURVE_POINT(02, 7000, 50)

;*************************
; Startup settings       *
;*************************
#define    RPM_STEP_INITIAL    90
#define    RPM_STEP_MAX        180
#define    PCT_PWR_STARTUP     14
#define    PCT_PWR_MAX_STARTUP 20
#define    RPM_START_MIN_RPM   4000
#define    ENOUGH_GOODIES      20

;*************************
; Run settings           *
;*************************
#define    RPM_RUN_MIN_RPM     3000


