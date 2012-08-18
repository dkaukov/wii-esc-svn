/**
 * Wii ESC NG 2.0 - 2012
 * RC Receiver support. ->(RX)
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

uint16_t raw_ppm_data;
uint16_t ppm_edge_time;

#define PPM_HYST 0

inline uint16_t get_raw_ppm_data_no_block() {
  uint16_t res = raw_ppm_data;
  while (res != raw_ppm_data) res = raw_ppm_data;
  return res;
}

void filter_ppm_data() {
  uint16_t tmp = get_raw_ppm_data_no_block();
  if ((tmp > US_TO_TICKS(RCP_MIN)) && (tmp < US_TO_TICKS(RCP_MAX))) {
  #if (PPM_HYST > 0)
    if (tmp > rx.raw + (PPM_HYST)) rx.raw = tmp - (PPM_HYST - 1);
    if (tmp < rx.raw - (PPM_HYST)) rx.raw = tmp + (PPM_HYST - 1);
  #else
    rx.raw = tmp;
  #endif
  }
}

inline void init_ppm() {
  raw_ppm_data = US_TO_TICKS((RCP_MAX + RCP_MIN) / 2);
}

inline void rx_ppm_callback(uint16_t time, uint8_t state) {
  if (state) {
    ppm_edge_time = time;
  } else {
    uint16_t d_time = __interval(ppm_edge_time, time);
    raw_ppm_data = d_time;
  }
}

inline void RX_Init() {
  AttachPPM();
  init_ppm();
}

