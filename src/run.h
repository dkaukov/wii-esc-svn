/**
 * Wii ESC NG 2.0 - 2012
 * Run loop
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

#ifndef RUN_H_INCLUDED
#define RUN_H_INCLUDED

static struct timer_small  timer_comm_delay;
static struct timer_small  timer_comm_timeout;
static struct timer_small  timer_zc_blank;
static int16_t sys_limit;

#define RUN_RES_OK         0
#define RUN_RES_TIMEOUT    1
#define RUN_RES_UNKNOWN    255

#define FAST_SDM           18

void run_power_control() {
  filter_ppm_data();
  int16_t tmp = RCP_TO_SDM(rx.raw);
  if (tmp < PWR_PCT_TO_VAL(PCT_PWR_MIN)) tmp = 0;
  if (tmp > SDM_TOP)                     tmp = SDM_TOP;
  if (sys_limit < SDM_TOP) sys_limit += 5;
  if (tmp > sys_limit) tmp = sys_limit;
  if ((tmp > (FAST_SDM * SDM_TOP / 100)) && (tmp < ((100 - FAST_SDM) * SDM_TOP / 100))) pwr_stage.sdm_fast = 0; else pwr_stage.sdm_fast = 1;
  sdm_ref = tmp;
}

void run_timing_control(uint16_t tick) {
  timer_comm_delay.last_systick = tick;
  timer_comm_timeout.last_systick = tick;
  uint16_t tmp = est_comm_time;                     // 120 deg
  timer_comm_timeout.elapsed = tmp;                 // 120 deg
  tmp =  tmp >> 3;
  timer_comm_delay.elapsed = tmp;                   //  15 deg
  timer_zc_blank.elapsed = tmp >> 1;
}

void run_init() {
  __result = RUN_RES_UNKNOWN;
  pwr_stage.recovery = 0;
  pwr_stage.sdm_fast = 0;
  sys_limit = sdm_ref;
  run_timing_control(last_tick);
}

static PT_THREAD(thread_run(struct pt *pt, uint16_t dt)) {
  uint16_t t;
  uint8_t timeout;
  PT_BEGIN(pt);
  while (1) {
    PT_YIELD(pt);
    PT_WAIT_UNTIL(pt, timer_expired(&timer_zc_blank, dt));
    Debug_TraceMark();
    zc_filter_run_reset();
    if ((pwr_stage.com_state & 1)) {
      PT_WAIT_UNTIL(pt, (timeout = timer_expired(&timer_comm_timeout, dt)) || zc_run_detected_lh());
    } else {
      PT_WAIT_UNTIL(pt, (timeout = timer_expired(&timer_comm_timeout, dt)) || zc_run_detected_hl());
    }
    Debug_TraceMark();
    if (timeout) {
      if (pwr_stage.recovery) {
        __result = RUN_RES_TIMEOUT;
        break;
      }
      Debug_Trigger();
      // Power off and free spin
      free_spin(); sdm_reset();
      // Skip 3 states
      next_comm_state(3); set_ac_state(pwr_stage.com_state);
      // Set alarm on maximum
      timer_comm_timeout.last_systick = dt;
      timer_comm_timeout.elapsed = 0x3FFF;
      // Set blanking interval
      timer_zc_blank.last_systick = dt;
      timer_zc_blank.elapsed = est_comm_time >> 3;
      //
      pwr_stage.recovery = 1;
      continue;
    }
    #ifdef BEMF_FILTER_DELAY_US
    t = dt - (ZC_PROCESSING_DELAY + US_TO_TICKS(BEMF_FILTER_DELAY_US));
    #else
    t = dt - (ZC_PROCESSING_DELAY);
    #endif
    if (pwr_stage.recovery) {
      correct_timing(t);
      pwr_stage.recovery = 0;
    } else update_timing(t);
    PT_YIELD(pt);
    run_timing_control(last_tick);
    PT_YIELD(pt);
    PT_WAIT_UNTIL(pt, timer_expired(&timer_comm_delay, dt));
    if (est_comm_time > (RPM_TO_COMM_TIME(RPM_RUN_MIN_RPM) * 2)) {
      __result = RUN_RES_OK;
      break;
    }
    next_comm_state();
    change_comm_state(pwr_stage.com_state);
    if (!pwr_stage.com_state) Debug_Trigger();
    Debug_TraceToggle();
    run_power_control();
    timer_zc_blank.last_systick = dt;
  }
  PT_END(pt);
}

static uint8_t run() {
  uint8_t sdm_clk = 0;
  struct pt thread_run_pt;
  PT_INIT(&thread_run_pt);
  run_init();
  while (1) {
    aco_sample();
    if ((pwr_stage.sdm_fast) || (sdm_clk++ & 0x01)) sdm();
    if (!PT_SCHEDULE(thread_run(&thread_run_pt, __systick()))) break;
  };
  free_spin(); sdm_reset();
  return __result;
}

#endif // RUN_H_INCLUDED
