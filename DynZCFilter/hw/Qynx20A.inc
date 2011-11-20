.include "common.inc"

#define Typ "Qynx  20"

; PORT  definities *************************************************************

;PORT B

#define    CpFET           1      ; Aansturing FET plus
#define    BpFET           2      ; Aansturing FET plus
#define    ApFET           3      ; Aansturing FET plus

#define    INIT_PB         (1<<ApFET) + (1<<BpFET) + (1<< CpFET)
#define    DIR_PB          (1<<ApFET) + (1<<BpFET) + (1<< CpFET)
#define    BRAKE_PB        0

;PORT C

#define    AnFET           0      ; Aansturing FET massa
#define    BnFET           1      ; Aansturing FET massa 
#define    CnFET           2      ; Aansturing FET massa
#define    mux_a           3      ;
#define    mux_b           4      ;
#define    mux_c           5      ;

#define    INIT_PC         0
#define    DIR_PC          (1<<AnFET) + (1<<BnFET) + (1<< CnFET)
#define    BRAKE_PC        (1<<AnFET) + (1<<BnFET) + (1<< CnFET)

;PORT D

#define    DbgLED          2      ; LED
#define    rcp_in          3      ; INT1 PPM input
#define    c_comp          6


#define    INIT_PD         (1<<DbgLED) ; Led staat uit
#define    DIR_PD          (1<<DbgLED)
#define    BRAKE_PD        0

#define LED_UIT            sbi     PORTD,2 ; LED uit
#define LED_AAN            cbi     PORTD,2 ; LED aan

#define DbgLEDOn           sbi     PORTD,2
#define DbgLEDOff          cbi     PORTD,2

; FET Control *****************************************************************

#define ApFET_on           cbi     PORTB,3
#define ApFET_off          sbi     PORTB,3

#define BpFET_on           cbi     PORTB,2
#define BpFET_off          sbi     PORTB,2

#define CpFET_on           cbi     PORTB,1
#define CpFET_off          sbi     PORTB,1

#define AnFET_on           sbi     PORTC,0
#define AnFET_off          cbi     PORTC,0

#define BnFET_on           sbi     PORTC,1
#define BnFET_off          cbi     PORTC,1

#define CnFET_on           sbi     PORTC,2
#define CnFET_off          cbi     PORTC,2

; Comparator definitions ******************************************************

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
#define    F_CPU               16000000          ; 16Mhz oscilator 
#define    ZCF_CONST           7

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
#define    RPM_STEP_INITIAL    155
#define    RPM_STEP_MAX        200
#define    PCT_PWR_STARTUP     14
#define    PCT_PWR_MAX_STARTUP 20
#define    RPM_START_MIN_RPM   4200
#define    ENOUGH_GOODIES      20

;*************************
; Run settings           *
;*************************
#define    RPM_RUN_MIN_RPM     3200
