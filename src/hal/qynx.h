#ifndef _QYNX_H_
#define _QYNX_H_

//*********************
// PORT B definitions *
//*********************
#define    CpFET           1
#define    BpFET           2
#define    ApFET           3

#define    PORTB_INIT      (1<<ApFET) + (1<<BpFET) + (1<<CpFET)
#define    PORTB_DD        (1<<ApFET) + (1<<BpFET) + (1<<CpFET)
#define    BRAKE_PB        0

//*********************
// PORT C definitions *
//*********************
#define    AnFET           0
#define    BnFET           1
#define    CnFET           2

#define    PORTC_INIT      0
#define    PORTC_DD        (1<<AnFET) + (1<<BnFET) + (1<<CnFET)
#define    BRAKE_PC        (1<<AnFET) + (1<<BnFET) + (1<<CnFET)

//*********************
// PORT D definitions *
//*********************
#define    DbgLED          2
#define    rcp_in          3
#define    DbgStr          4
#define    c_comp          6

#define    PORTD_INIT      (1<<DbgLED) + (0<<rcp_in) + (1<<DbgStr) + (0<<c_comp)
#define    PORTD_DD        (1<<DbgLED) + (1<<DbgStr)
#define    BRAKE_PD        0


inline void DebugLEDOn()     {PORTD |= _BV(DbgLED);}
inline void DebugLEDOff()    {PORTD &=~_BV(DbgLED);}
inline void DebugLEDToggle() {PORTD ^= _BV(DbgLED);}

inline void DebugStrOn()     {PORTB |= _BV(DbgStr);}
inline void DebugStrOff()    {PORTB &=~_BV(DbgStr);}
inline void DebugStrToggle() {PORTB ^= _BV(DbgStr);}

//*********************
// FET Control        *
//*********************
inline void ApFETOn()  {PORTB &= ~_BV(ApFET);}
inline void ApFETOff() {PORTB |=  _BV(ApFET);}
inline void AnFETOn()  {PORTC |=  _BV(AnFET);}
inline void AnFETOff() {PORTC &= ~_BV(AnFET);}

inline void BpFETOn()  {PORTB &= ~_BV(BpFET);}
inline void BpFETOff() {PORTB |=  _BV(BpFET);}
inline void BnFETOn()  {PORTC |=  _BV(BnFET);}
inline void BnFETOff() {PORTC &= ~_BV(BnFET);}

inline void CpFETOn()  {PORTB &= ~_BV(CpFET);}
inline void CpFETOff() {PORTB |=  _BV(CpFET);}
inline void CnFETOn()  {PORTC |=  _BV(CnFET);}
inline void CnFETOff() {PORTC &= ~_BV(CnFET);}

//*********************
// ADC definitions    *
//*********************
#define    mux_a           3
#define    mux_b           4
#define    mux_c           5

inline void ACInit() {
  ACMultiplexed();
}

inline void ACPhaseA() {
   ACChannel(mux_a);
}

inline void ACPhaseB() {
   ACChannel(mux_b);
}

inline void ACPhaseC() {
   ACChannel(mux_c);
};

void Board_Idle() {
};

inline void Board_Init() {
  TIMSK = 0;
  // Timer1
  TCCR1A = 0;
  TCCR1B = _BV(CS11);                 /* div 8 clock prescaler */
  PORTB = PORTB_INIT; DDRB = PORTB_DD;
  PORTC = PORTC_INIT; DDRC = PORTC_DD;
  PORTD = PORTD_INIT; DDRD = PORTD_DD;

  ACInit();
}

#endif // _QYNX_H_
