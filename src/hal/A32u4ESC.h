#ifndef A32U4ESC_H_INCLUDED
#define A32U4ESC_H_INCLUDED

//*********************
// PORT B definitions *
//*********************
#define DbgLED          1
#define DbgStr          3
#define BnFET           5
#define BpFET           6
#define PORTB_INIT      0
#define PORTB_DD        (1<<BnFET)+(1<<BpFET)+(1<<DbgLED)+(1<<DbgStr)

inline void DebugLEDOn()     {PORTB |= _BV(DbgLED);}
inline void DebugLEDOff()    {PORTB &= ~_BV(DbgLED);}
inline void DebugLEDToggle() {PORTB ^= _BV(DbgLED);}

inline void DebugStrOn()     {PORTB |= _BV(DbgStr);}
inline void DebugStrOff()    {PORTB &= ~_BV(DbgStr);}
inline void DebugStrToggle() {PORTB ^= _BV(DbgStr);}

//*********************
// PORT C definitions *
//*********************
#define CnFET           6
#define CpFET           7
#define PORTC_INIT      0
#define PORTC_DD        (1<<CnFET)+(1<<CpFET)

//*********************
// PORT D definitions *
//*********************
#define AnFET           6
#define ApFET           7
#define rcp_in          4
#define PORTD_INIT      0
#define PORTD_DD        (1<<ApFET)+(1<<AnFET)

inline void ApFETOn()  {PORTD |=  _BV(ApFET);}
inline void ApFETOff() {PORTD &= ~_BV(ApFET);}
inline void AnFETOn()  {PORTD |=  _BV(AnFET);}
inline void AnFETOff() {PORTD &= ~_BV(AnFET);}

inline void BpFETOn()  {PORTB |=  _BV(BpFET);}
inline void BpFETOff() {PORTB &= ~_BV(BpFET);}
inline void BnFETOn()  {PORTB |=  _BV(BnFET);}
inline void BnFETOff() {PORTB &= ~_BV(BnFET);}

inline void CpFETOn()  {PORTC |=  _BV(CpFET);}
inline void CpFETOff() {PORTC &= ~_BV(CpFET);}
inline void CnFETOn()  {PORTC |=  _BV(CnFET);}
inline void CnFETOff() {PORTC &= ~_BV(CnFET);}

#define mux_a           6
#define mux_b           5
#define mux_c           4

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
#if defined(USBCON)
	USBDevice.attach();
#endif
  TIMSK1 = 0;
  // Timer1
  TCCR1A = 0;
  TCCR1B = _BV(CS11);                 /* div 8 clock prescaler */
  PORTB = PORTB_INIT; DDRB = PORTB_DD;
  PORTC = PORTC_INIT; DDRC = PORTC_DD;
  PORTD = PORTD_INIT; DDRD = PORTD_DD;

  ACInit();
}


#endif // A32U4ESC_H_INCLUDED
