/**
 * Wii-ESC NG 1.0 - 2013
 * Main program file.
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

#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>
#include <pt.h>
#include <pt-sem.h>
#include "global.h"
#include "config.h"
#include "core.h"
#include "debug.h"
#include "rx.h"
#include "power_stage.h"
#include "sdm.h"
#include "zc.h"
#include "start.h"
#include "run.h"
#include "storage.h"
#include "config_data.h"

void setup_to_rt() {
  pwr_stage.braking_enabled = 0;
  if (cfg.braking) pwr_stage.braking_enabled = 1;
  timing_adv = cfg.timing_adv;
  rx_setup_rt();
  sdm_setup_rt(rx.rcp_start, US_TO_TICKS(cfg.rcp_full_us));
  pwr_stage.rev = 0;
  if (cfg.rev) pwr_stage.rev = 1;
}

void beep(uint8_t khz, uint8_t len) {
 uint16_t off = 10000 / khz;
 uint16_t cnt = khz * len;
 for (uint16_t i = 0; i < cnt; i++) {
   set_pwm_on(pwr_stage.com_state);
   __delay_us(6);
   set_pwm_off(pwr_stage.com_state);
   __delay_us(off);
 }
}

void startup_sound() {
  pwr_stage.com_state = 0; set_comm_state();
  for (uint8_t i = 0; i < 5; i++) {
    pwr_stage.com_state = i;
    change_comm_state(i);
    beep(6 + i, 10);
    __delay_ms(5);
  }
}

void wait_for(uint16_t low, uint16_t high, uint8_t cnt) {
  uint8_t _cnt = cnt;
  while (1) {
    uint16_t tmp = rx_get_frame();
    if ((tmp >= low) && (tmp <= high)) {
      if (!(--_cnt)) break;
    } else _cnt = cnt;
  }
}

uint16_t get_stable_ppm_value() {
  uint16_t tmp = rx_get_frame();
  uint16_t frame_min = tmp;
  uint16_t frame_max = tmp;
  for (uint8_t i = 0; i < 50; i++) {
    tmp = rx_get_frame();
    if (tmp > frame_max) frame_max = tmp;
    if (tmp < frame_min) frame_min = tmp;
    if ((frame_max - frame_min) > US_TO_TICKS(4)) return 0;
  }
  return (frame_max + frame_min) >> 1;
}

static void throttle_range_calibration_high() {
  uint16_t tmp;
  do {
    tmp = get_stable_ppm_value();
  } while (!tmp);
  cfg.rcp_full_us = tmp / TICKS_PER_US;
}

static void throttle_range_calibration_low() {
  uint16_t tmp;
  do {
    tmp = get_stable_ppm_value();
  } while (!tmp);
  cfg.rcp_start_us = (tmp / TICKS_PER_US);
}

static void throttle_range_calibration_apply_correction() {
  uint16_t reserve = ((cfg.rcp_full_us - cfg.rcp_start_us) * 4) / 100;
  cfg.rcp_full_us  -= reserve;
  cfg.rcp_start_us += reserve;
}

void wait_for_arm() {
  wait_for(rx.rcp_min, rx.rcp_start, 50);
}

void wait_for_power_on() {
  wait_for(rx.rcp_start + US_TO_TICKS(cfg.rcp_deadband_us), rx.rcp_max, 15);
}

void check_for_stick_cal() {
  if (!cfg.stick_cal_dis) {
    wait_for(rx.rcp_min, rx.rcp_max, 10);
    if ((rx_get_frame() > rx.rcp_stick_cal)) {
      throttle_range_calibration_high();
      beep(10, 10); __delay_ms(200); beep(10, 10);
      wait_for(rx.rcp_min, rx.rcp_stick_cal, 25);
      throttle_range_calibration_low();
      throttle_range_calibration_apply_correction();
      write_storage();
      setup_to_rt();
    }
  }
}

void calibrate_osc() {
#if defined(RCP_CAL) && defined(INT_OSC)
  if (rx.rcp_cal == 0) return;
  while (rx_get_frame() > rx.rcp_cal) {
    uint8_t tmp = OSCCAL;
    if (!(--tmp)) break;
    OSCCAL = tmp;
    rx_get_frame();
  }
  while (rx_get_frame() < rx.rcp_cal) {
    uint8_t tmp = OSCCAL;
    if ((++tmp) == 0) break;
    OSCCAL = tmp;
    rx_get_frame();
  }
#endif
}

void setup() {
  cli();
  Board_Init();
  PowerStage_Init();
  RX_Init();
  Debug_Init();
  Storage_Init();
  sei();
  sdm_reset();
  setup_to_rt();
  __delay_ms(250);
  startup_sound();
  check_for_stick_cal();
  calibrate_osc();
}

void loop() {
  wait_for_arm();
  set_comm_state(); beep(12, 50);
  for (;;) {
    free_spin(); sdm_reset();
    if (pwr_stage.braking_enabled) brake();
    wait_for_power_on();
    free_spin();
    if (start() == START_RES_OK) {
      if (run() != RUN_RES_OK) break;
    }
  };
}

