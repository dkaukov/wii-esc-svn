/**
 * Wii ESC NG 2.0 - 2012
 * Atmega8 API RX input capture
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _M8_INT_H_
#define _M8_INT_H_

// RX input capture

#if (rcp_in == 2)
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
#endif

#if (rcp_in == 3)
ISR(INT1_vect) {
  uint16_t time = TCNT1;
  uint8_t state = (PIND & _BV(3));
  rx_ppm_callback(time, state);
}

inline void AttachPPM() {
  PORTD  |= _BV(3);
  MCUCR = (MCUCR & ~((1 << ISC10) | (1 << ISC11))) | (1 << ISC10);
  GICR |= (1 << INT1);
}
#endif

#endif
