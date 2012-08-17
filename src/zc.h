/**
 * Wii ESC NG 2.0 - 2012
 * Zero-Crossing Detector
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

#ifndef ZC_H_INCLUDED
#define ZC_H_INCLUDED

#define ZC_FILTER_START_CONST (9 * TICKS_PER_US)
#define ZC_PROCESSING_DELAY   (42)

register uint8_t zc_filter asm("r2");

const uint8_t PROGMEM zc_filter_table[64]=   {0 ,2 ,4 ,6 ,8 ,10,12,14,16,18,20,22,24,26,28,30,
                                              32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,
                                              0 ,2 ,4 ,6 ,8 ,10,12,14,16,18,1 ,22,1 ,26,28,30,
                                              32,34,36,38,1 ,42,44,46,1 ,1 ,1 ,54,56,58,60,62};

uint16_t timing_hst[4];

static uint16_t cubic_extrapolate(uint16_t y0, uint16_t y1, uint16_t y2, uint16_t y3) {
  int16_t a0 = y3 - y2 - y0 + y1;
  int16_t a1 = y0 - y1 - a0;
  int16_t a2 = y2 - y0;
  int16_t a3 = y1;
  return (a0 << 3) + (a1 << 2) + (a2 << 1) + a3;
}

uint16_t extrapolate_new_timing(uint16_t comm_time) {
  timing_hst[0] = timing_hst[1];
  timing_hst[1] = timing_hst[2];
  timing_hst[2] = timing_hst[3];
  timing_hst[3] = comm_time;
  return cubic_extrapolate(timing_hst[3], timing_hst[2], timing_hst[1], timing_hst[0]);
}

void update_timing(uint16_t tick) {
  uint16_t comm_time = __interval(last_tick, tick);
  last_tick = tick;
  est_comm_time = extrapolate_new_timing(last_comm_time + comm_time);
  last_comm_time = comm_time;
}

void correct_timing(uint16_t tick) {
  uint16_t comm_time = __interval(last_tick, tick);
  last_tick = tick;
  comm_time = comm_time >> 1;
  est_comm_time = comm_time;
  timing_hst[0] = comm_time;
  timing_hst[1] = comm_time;
  timing_hst[2] = comm_time;
  timing_hst[3] = comm_time;
  last_comm_time = comm_time >> 1;
}

inline void zc_filter_start_reset() {
  zc_filter = ZC_FILTER_START_CONST;
}

inline uint8_t zc_kickback_end(uint8_t state) {
  if (state & 1) {
    return !pwr_stage.aco;
  } else {
    return pwr_stage.aco;
  }
}

uint8_t zc_start_detected(uint8_t state) {
  if (state & 1) {
    if (pwr_stage.aco) zc_filter--; else zc_filter++;
  } else {
    if (!pwr_stage.aco) zc_filter--; else zc_filter++;
  }
  if (zc_filter > (ZC_FILTER_START_CONST)) zc_filter = ZC_FILTER_START_CONST;
  return (zc_filter == 0);
}

inline void zc_filter_run_reset() {
  zc_filter = 0;
}

__attribute__ ((noinline)) uint8_t zc_run_detected_lh() {
  uint8_t v = zc_filter;
  if (!pwr_stage.aco) v |= 0x01;
  v = pgm_read_byte(&zc_filter_table[v]);
  zc_filter = v;
  return (v & 0x01);
}

__attribute__ ((noinline)) uint8_t zc_run_detected_hl() {
  uint8_t v = zc_filter;
  if (pwr_stage.aco) v |= 0x01;
  v = pgm_read_byte(&zc_filter_table[v]);
  zc_filter = v;
  return (v & 0x01);
}

#endif // ZC_H_INCLUDED
