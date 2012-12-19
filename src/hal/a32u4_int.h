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

#ifndef _A32U4_INT_H_
#define _A32U4_INT_H_

// RX input capture

#if (rcp_in == 4)
ISR(TIMER1_CAPT_vect) {
  uint16_t time = ICR1;
  uint8_t state = (TCCR1B & _BV(ICES1));
  if (state) TCCR1B &= ~_BV(ICES1); else TCCR1B |= _BV(ICES1);
  rx_ppm_callback(time, state);
}

inline void AttachPPM() {
  PORTD  |= _BV(4);
  TCCR1B |= _BV(ICES1);
  TIMSK1 |= _BV(ICIE1);
}
#endif


#endif
