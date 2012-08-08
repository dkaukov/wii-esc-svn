#ifndef _M8_H_
#define _M8_H_

#include "WProgram.h"
#include <avr/pgmspace.h>

// Workaround for http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34734
#ifdef PROGMEM
  #undef PROGMEM
  #define PROGMEM __attribute__((section(".progmem.data")))
#endif

#undef PSTR
#define PSTR(s) (__extension__({static prog_char __c[] PROGMEM = (s); &__c[0];}))

// EEPROM
#include <nvram.h>

#define TICKS_PER_US (F_CPU / 8000000L)

// Delay support
void __delay_us(uint16_t __us) __attribute__ ((noinline));
void __delay_us(uint16_t __us) {
#if (TICKS_PER_US == 2)
  __us = (__us << 1) - 4;
#else
  __us = __us  - 4;
#endif
  uint16_t i_start = __systick();
  while (__interval(i_start) < __us) {};
};

void __delay_ms(uint16_t __ms) __attribute__ ((noinline));
void __delay_ms(uint16_t __ms) {
  while (__ms--) __delay_us(1000);
}

// RX input capture
ISR(INT0_vect) {
  uint16_t time = TCNT1;
  uint8_t state = (PIND & _BV(2));
  rx_ppm_callback(time, state);
}

inline void AttachPPM() {
  PORTD  |= _BV(2);
  MCUCR = (MCUCR & ~((1 << ISC00) | (1 << ISC01))) | (1 << ISC00);
  GICR |= (1 << INT0);
}

static inline void __hw_alarm_a_set(uint16_t ticks) {
  uint8_t __sreg = SREG;
  cli();
  OCR1A = ticks;
  SREG = __sreg;
  TIFR = _BV(OCF1A);
}
static inline uint8_t __hw_alarm_a_expired() {
  return TIFR & _BV(OCF1A);
}
static inline void __hw_alarm_b_set(uint16_t ticks) {
  uint8_t __sreg = SREG;
  cli();
  OCR1B = ticks;
  SREG = __sreg;
  TIFR = _BV(OCF1B);
}

static inline uint8_t __hw_alarm_b_expired() {
  return TIFR & _BV(OCF1B);
}

inline uint16_t __systick() {
  uint8_t __sreg = SREG;
  cli();
  uint16_t res = TCNT1;
  SREG = __sreg;
  return res;
}

inline uint16_t __interval(uint16_t i_start) {
  uint8_t __sreg = SREG;
  cli();
  uint16_t res = __interval(i_start, TCNT1);
  SREG = __sreg;
  return res;
}

inline uint16_t __interval(uint16_t i_start, uint16_t i_end) {
  return (i_end - i_start);
}

inline void ACMultiplexed() {
  ADCSRA &= ~_BV(ADEN);
  SFIOR |= _BV(ACME);
}

inline void ACChannel(uint8_t ch) {
  ADMUX = ch;
}

inline void ACNormal() {
  SFIOR &= ~_BV(ACME);
  ADCSRA |= _BV(ADEN);
}


#endif
