.include "common.inc"

#define Typ "Mystery 20"


;**** **** **** **** ****
; PORT  definitions
;**** **** **** **** ****

;*********************
; PORT D 
;*********************  
;#define                7     ;
#define c_comp          6     ;i common comparator input (AIN0)
#define AnFET           5     ;o
#define ApFET           4     ;o
;#define                3     ;
#define rcp_in          2     ;i r/c pulse input
;#define                1     ;
;#define                0     ;


#define INIT_PD         (1<<ApFET)
#define DIR_PD          (1<<ApFET)+(1<<AnFET)
#define BRAKE_PD        (1<<AnFET)


;*********************
; ADC definitions
;*********************

#define mux_c           0     ; ADC0
#define mux_a           6     ; ADC6
#define mux_b           7     ; ADC7
#define ACCU_MUX        2     ; ADC2 voltage control input 

;*********************
; PORT C definitions *
;*********************
#define AnRef           1
#define CpFET           3
#define BnFET           4
#define BpFET           5  


#define INIT_PC         (1<<AnRef)+(1<<CpFET)+(1<<BpFET)
#define DIR_PC          (1<<AnRef)+(1<<CpFET)+(1<<BnFET)+(1<<BpFET)
#define BRAKE_PC        (1<<BnFET)


;*********************
; PORT B definitions *
;*********************
;#define           7     
;#define           6     
#define    DbgLED  5;    (sck stk200 interface) 
;#define           4     (miso stk200 interface)
;#define           3     (mosi stk200 interface) 
;#define           2     
;#define           1     
#define    CnFET   0

#define INIT_PB         0
#define DIR_PB          (1<<CnFET)+(1<<DbgLED)
#define BRAKE_PB        (1<<CnFET)


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
#undef     MOT_BRAKE      
#undef     READ_CALIBRATION
#define    F_CPU           16000000              ; 16Mhz internal RC oscilator 
#define    ZCF_CONST       7

;*************************
; Timings                *
;*************************
#define    MIN_DUTY        3*POWER_RANGE/100     ; Min power 3%

#define    PWR_MAX_RPM1    POWER_RANGE/4
#define    PWR_MAX_RPM2    POWER_RANGE/2

#define    PWR_STARTUP     5*POWER_RANGE/100     ;  5%
#define    PWR_MAX_STARTUP 12*POWER_RANGE/100    ; 15%


#define    timeoutSTART    65000
#define    timeoutMIN      48000

#define    PWR_RANGE1      0x40  ; ( ~2400 RPM )
#define    PWR_RANGE2      0x20  ; ( ~4800 RPM )

#define    ENOUGH_GOODIES  60
