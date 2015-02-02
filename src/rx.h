/**
 * Wii ESC NG 2.0 - 2013
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

volatile uint16_t raw_ppm_data;
uint16_t ppm_edge_time;
struct   timer_small timer_ppm_timeout_prescaler;

#define PPM_HYST 0

inline uint16_t get_raw_ppm_data_no_block() {
  uint16_t res = raw_ppm_data;
  while (res != raw_ppm_data) res = raw_ppm_data;
  return res;
}

void filter_ppm_data() {
  if (!rx.frame_received) return;
  uint16_t tmp = get_raw_ppm_data_no_block();
  if ((tmp >= rx.rcp_min) && (tmp <= rx.rcp_max)) {
  #if (PPM_HYST > 0)
    if (tmp > rx.raw + (PPM_HYST)) rx.raw = tmp - (PPM_HYST - 1);
    if (tmp < rx.raw - (PPM_HYST)) rx.raw = tmp + (PPM_HYST - 1);
  #else
    rx.raw = tmp;
  #endif
  }
}

static void ppm_timeout(uint16_t tick) {
  if (timer_expired(&timer_ppm_timeout_prescaler, tick)) {
    if (--rx.frame_received == 0) {
      rx.raw = 0;
      raw_ppm_data = 0;
    }
  }
}

inline void init_ppm() {
  raw_ppm_data = 0;
  cfg.rcp_cal_us = RCP_CAL;
  cfg.rcp_min_us = RCP_MIN;
  cfg.rcp_max_us = RCP_MAX;
  cfg.rcp_start_us = RCP_START;
  cfg.rcp_full_us = RCP_FULL;
  cfg.rcp_deadband_us = RCP_DEADBAND;
}

inline void rx_ppm_callback(uint16_t time, uint8_t state) {
  if (state) {
    ppm_edge_time = time;
  } else {
    uint16_t d_time = __interval(ppm_edge_time, time);
    raw_ppm_data = d_time;
    rx.frame_received = (RCP_TIMEOUT_MS * TICKS_PER_US) * 1000U / 0xFFFFU;
  }
}

uint16_t rx_get_frame() {
  rx.frame_received = 0; rx.raw = 0;
  while (rx.raw == 0) filter_ppm_data();
  return rx.raw;
}

static void rx_setup_rt() {
  rx.rcp_min = US_TO_TICKS(cfg.rcp_min_us);
  rx.rcp_max = US_TO_TICKS(cfg.rcp_max_us);
  rx.rcp_stick_cal =  (rx.rcp_min + rx.rcp_max) >> 1;
  rx.rcp_start = US_TO_TICKS(cfg.rcp_start_us);
  rx.rcp_cal = US_TO_TICKS(cfg.rcp_cal_us);
}

inline void RX_Init() {
  AttachPPM();
  init_ppm();
  timer_ppm_timeout_prescaler.interval = 0xFFFFU;
}

