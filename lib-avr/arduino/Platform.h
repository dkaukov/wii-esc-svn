#ifndef __PLATFORM_H__
#define __PLATFORM_H__

#include <inttypes.h>
#include <avr/pgmspace.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include "wiring.h"
#include "pins_arduino.h"

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

#if defined(USBCON)
  #define TX_RX_LED_INIT	DDRD |= (1<<5), DDRB |= (1<<0)
  #define TXLED0			PORTD |= (1<<5)
  #define TXLED1			PORTD &= ~(1<<5)
  #define RXLED0			PORTB |= (1<<0)
  #define RXLED1			PORTB &= ~(1<<0)
#endif /* if defined(USBCON) */

#endif
