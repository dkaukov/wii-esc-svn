/**
 * Wii ESC NG 2.0 - 2012
 * Startup Loop
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

#ifndef START_H_INCLUDED
#define START_H_INCLUDED

static struct timer_big      timer_start;

#define START_RES_OK         0
#define START_RES_TIMEOUT    1
#define START_RES_OFF        2
#define START_RES_UNKNOWN    255

void start_power_control() {
  filter_ppm_data();
  int16_t val = RCP_TO_SDM(rx.raw);
  if (val < PWR_PCT_TO_VAL(PCT_PWR_MIN)) {
    sdm_ref = 0;
    return;
  }
  if (val < PWR_PCT_TO_VAL(PCT_PWR_STARTUP)) val = PWR_PCT_TO_VAL(PCT_PWR_STARTUP);
  else
  if (val > PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP)) val = PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP);
  sdm_ref += (val - sdm_ref) >> 2;
}

void start_timing_control() {
  timer_start.interval -= 40;
  if (timer_start.interval < RPM_TO_COMM_TIME(RPM_STEP_MAX))
    timer_start.interval = RPM_TO_COMM_TIME(RPM_STEP_MAX);
}

void start_init() {
  good_com = 0; sdm_ref = PWR_PCT_TO_VAL(PCT_PWR_STARTUP);
  timer_start.interval = RPM_TO_COMM_TIME(RPM_STEP_INITIAL);
  __result = START_RES_UNKNOWN;
  Debug_Init();
}
uint8_t start_wait_for_zc() {
  while (1) {
    aco_sample();
    sdm();
    if (timer_expired(&timer_start, __systick())) return 0;
    if (zc_start_detected(pwr_stage.com_state)) return 1;
    aco_sample();
    if (zc_start_detected(pwr_stage.com_state)) return 1;
  }
 }

static uint8_t start() {
  start_init();
  while (1) {
    timer_start.elapsed = timer_start.interval;
    zc_filter_start_reset();
    if (start_wait_for_zc()) {
      if ((pwr_stage.com_state & 1)) {
        update_timing(__systick());
        if (++good_com >= ENOUGH_GOODIES) {
          good_com = ENOUGH_GOODIES;
          if ((est_comm_time <= RPM_TO_COMM_TIME(RPM_START_MIN_RPM) * 2)) {
            next_comm_state();
            change_comm_state(pwr_stage.com_state);
            return START_RES_OK;
          }
        }
      }
    }  else good_com = 0;
    next_comm_state();
    set_pwm_off(pwr_stage.com_state);
    pwr_stage.sdm_state = 0;
    change_comm_state(pwr_stage.com_state);
    if (!pwr_stage.com_state) start_power_control();
    start_timing_control();
    if (sdm_ref == 0) return START_RES_OFF;
    if (!pwr_stage.com_state) Debug_Trigger();
    Debug_TraceToggle();
    __delay_us(300);
  }
}

#endif // START_H_INCLUDED
