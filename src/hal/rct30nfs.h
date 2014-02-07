//***************************************************************
//* For RCTimer NFS 30A all n-Channel FETs                      *
//* Original fuses are -U lfuse:w:0x2F:m -U hfuse:w:0xCA:m      *
//* By Nils Hogberg                                             *
//***************************************************************

#ifndef _RCT30NFS_H_
#define _RCT30NFS_H_

//*********************
// PORT B definitions *
//*********************
#define DbgLED          5
#define DbgStr          4
#define CnFET           1
#define rcp_in          0
#define PORTB_INIT      0
#define PORTB_DD        _BV(CnFET) | _BV(DbgLED) | _BV(DbgStr)
#define BRAKE_PB        0

inline void DebugLEDOn()     {PORTB |= _BV(DbgLED);}
inline void DebugLEDOff()    {PORTB &= ~_BV(DbgLED);}
inline void DebugLEDToggle() {PORTB ^= _BV(DbgLED);}

inline void DebugStrOn()     {PORTB |= _BV(DbgStr);}
inline void DebugStrOff()    {PORTB &= ~_BV(DbgStr);}
inline void DebugStrToggle() {PORTB ^= _BV(DbgStr);}

//*********************
// PORT C definitions *
//*********************
#define AnRef           1

#define PORTC_INIT      0
#define PORTC_DD        0
#define BRAKE_PC        0

//*********************
// PORT D definitions *
//*********************
#define c_comp          6
#define ApFET           4
#define AnFET           5
#define BpFET           3
#define BnFET           7
#define CpFET           2

#define PORTD_INIT      _BV(ApFET) | _BV(BpFET) | _BV(CpFET)
#define PORTD_DD        _BV(ApFET) | _BV(AnFET) | _BV(BpFET) | _BV(BnFET) | _BV(CpFET)
#define BRAKE_PD        0


inline void ApFETOn()  {PORTD &= ~_BV(ApFET);}
inline void ApFETOff() {PORTD |=  _BV(ApFET);}
inline void AnFETOn()  {PORTD |=  _BV(AnFET);}
inline void AnFETOff() {PORTD &= ~_BV(AnFET);}

inline void BpFETOn()  {PORTC &= ~_BV(BpFET);}
inline void BpFETOff() {PORTC |=  _BV(BpFET);}
inline void BnFETOn()  {PORTC |=  _BV(BnFET);}
inline void BnFETOff() {PORTC &= ~_BV(BnFET);}

inline void CpFETOn()  {PORTC &= ~_BV(CpFET);}
inline void CpFETOff() {PORTC |=  _BV(CpFET);}
inline void CnFETOn()  {PORTB |=  _BV(CnFET);}
inline void CnFETOff() {PORTB &= ~_BV(CnFET);}

#define mux_c           0
#define mux_a           6
#define mux_b           7

inline void ACInit() {
  ACMultiplexed();
  ACSR |= _BV(ACIC);
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

//#define BEMF_FILTER_DELAY_US 22

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

#endif // _RCT30NFS_H_

