/**
 * MultiWii NG 0.1 - 2012
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

#define PPM_HYST 2

inline uint16_t get_raw_ppm_data_no_block() {
  uint16_t res = raw_ppm_data;
  while (res != raw_ppm_data) res = raw_ppm_data;
  return res;
}

void filter_ppm_data() {
  uint16_t tmp = get_raw_ppm_data_no_block();
  if ((tmp > 900*CLK_SCALE) && (tmp < 2200*CLK_SCALE)) {
  #if (PPM_HYST > 0)
    if (tmp > rx.raw + (PPM_HYST)) rx.raw = tmp - (PPM_HYST - 1);
    if (tmp < rx.raw - (PPM_HYST)) rx.raw = tmp + (PPM_HYST - 1);
  #else
    rx.raw = tmp;
  #endif
  }
}

inline void init_ppm() {
  raw_ppm_data = 1500*CLK_SCALE;
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

inline void RX_loop_50hz() {
  filter_ppm_data();
}

inline void RX_loop_200hz() {
}



