#ifndef _TGY_H_
#define _TGY_H_

//*********************
// PORT B definitions *
//*********************
#define DbgLED          5
#define DbgStr          4
#define AnFET           2
#define BnFET           1
#define CnFET           0

#define PORTB_INIT      0
#define PORTB_DD        _BV(AnFET) | _BV(BnFET) | _BV(CnFET) | _BV(DbgLED) | _BV(DbgStr)
#define BRAKE_PB        _BV(AnFET) | _BV(BnFET) | _BV(CnFET)

inline void DebugLEDOn()     {PORTB |= _BV(DbgLED);}
inline void DebugLEDOff()    {PORTB &= ~_BV(DbgLED);}
inline void DebugLEDToggle() {PORTB ^= _BV(DbgLED);}

inline void DebugStrOn()     {PORTB |= _BV(DbgStr);}
inline void DebugStrOff()    {PORTB &= ~_BV(DbgStr);}
inline void DebugStrToggle() {PORTB ^= _BV(DbgStr);}

//*********************
// PORT C definitions *
//*********************
#define PORTC_INIT      0
#define PORTC_DD        0
#define BRAKE_PC        0

//*********************
// PORT D definitions *
//*********************
#define ApFET           5
#define BpFET           4
#define CpFET           3
#define rcp_in          2
#define PORTD_INIT      0
#define PORTD_DD        (1<<ApFET)+(1<<BpFET)+(1<<CpFET)
#define BRAKE_PD        0

inline void ApFETOn()  {PORTD |=  _BV(ApFET);}
inline void ApFETOff() {PORTD &= ~_BV(ApFET);}
inline void AnFETOn()  {PORTB |=  _BV(AnFET);}
inline void AnFETOff() {PORTB &= ~_BV(AnFET);}

inline void BpFETOn()  {PORTD |=  _BV(BpFET);}
inline void BpFETOff() {PORTD &= ~_BV(BpFET);}
inline void BnFETOn()  {PORTB |=  _BV(BnFET);}
inline void BnFETOff() {PORTB &= ~_BV(BnFET);}

inline void CpFETOn()  {PORTD |=  _BV(CpFET);}
inline void CpFETOff() {PORTD &= ~_BV(CpFET);}
inline void CnFETOn()  {PORTB |=  _BV(CnFET);}
inline void CnFETOff() {PORTB &= ~_BV(CnFET);}

#define mux_a           5
#define mux_b           4

inline void ACInit() {
  ACSR |= _BV(ACIC);
}

inline void ACPhaseA() {
   ACChannel(mux_a);
   ACMultiplexed();
}

inline void ACPhaseB() {
   ACChannel(mux_b);
   ACMultiplexed();
}

inline void ACPhaseC() {
   ACNormal();
}

void Board_Idle() {
};

inline void Board_Init() {
  #if (BOARD == _TGY_16_)
  OSCCAL = 0xFF;
  #endif
  TIMSK = 0;
  // Timer1
  TCCR1A = 0;
  TCCR1B = _BV(CS11);                 /* div 8 clock prescaler */
  PORTB = PORTB_INIT; DDRB = PORTB_DD;
  PORTC = PORTC_INIT; DDRC = PORTC_DD;
  PORTD = PORTD_INIT; DDRD = PORTD_DD;

  ACInit();
}

#endif // _TGY_H_
