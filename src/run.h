#ifndef RUN_H_INCLUDED
#define RUN_H_INCLUDED

static struct timer_small  timer_comm_delay;
static struct timer_small  timer_comm;
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
  if ((tmp > (FAST_SDM * SDM_TOP / 100)) && (tmp < ((100 - FAST_SDM) * SDM_TOP / 100))) pwr_stage.sdm_fast = 0; else pwr_stage.sdm_fast = 1;
  if (sys_limit < SDM_TOP) sys_limit += 3;
  if (tmp > sys_limit) tmp = sys_limit;
  sdm_ref = tmp;
}

void run_timing_control(uint16_t tick) {
  timer_comm.last_systick = tick;
  timer_comm_delay.last_systick = tick;
  uint16_t tmp = est_comm_time >> 1;                //  60 deg
  timer_comm.elapsed = tmp;
  __hw_alarm_a_set(tick + est_comm_time + tmp);     // 180 deg
  tmp =  tmp >> 2;
  timer_comm.elapsed += tmp;                        //  75 deg
  timer_comm_delay.elapsed = tmp;                   //  15 deg
  timer_zc_blank.interval = tmp;
}

void run_init() {
  __result = RUN_RES_UNKNOWN;
  pwr_stage.recovery = 0;
  est_comm_time = est_comm_time < 1;
  pwr_stage.sdm_fast = 0;
  sys_limit = sdm_ref;
  run_timing_control(last_tick);
}

static PT_THREAD(thread_run(struct pt *pt, uint16_t dt)) {
  uint16_t t;
  PT_BEGIN(pt);
  for (;;) {
    if ((pwr_stage.com_state & 1)) {
      timer_zc_blank.last_systick = dt;
      timer_zc_blank.elapsed = timer_zc_blank.interval;
      PT_YIELD(pt);
      PT_WAIT_UNTIL(pt, timer_expired(&timer_zc_blank, dt));
      Debug_TraceMark();
      zc_filter_run_reset();
      PT_WAIT_UNTIL(pt, __hw_alarm_a_expired() || zc_run_detected());
      Debug_TraceMark();
      if (__hw_alarm_a_expired()) {
        if (pwr_stage.recovery) {
          __result = RUN_RES_TIMEOUT;
          break;
        }
        Debug_Trigger();
        // Power off and free spin
        free_spin(); sdm_reset();
        // Skip 2 states
        next_comm_state(2); set_ac_state(pwr_stage.com_state);
        // Set alarm on maximum
        __hw_alarm_a_set(dt + 0x3FFF);
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
      run_timing_control(t);
      PT_WAIT_UNTIL(pt, timer_expired(&timer_comm_delay, dt));
    } else {
      if (est_comm_time > (RPM_TO_COMM_TIME(RPM_RUN_MIN_RPM) * 2)) {
        __result = RUN_RES_OK;
        break;
      }
      PT_YIELD(pt);
      PT_WAIT_UNTIL(pt, timer_expired(&timer_comm, dt));
    }
    next_comm_state();
    change_comm_state(pwr_stage.com_state);
    if (!pwr_stage.com_state) Debug_Trigger();
    Debug_TraceToggle();
    run_power_control();
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
    #ifdef BEMF_FILTER_DELAY_US
      sdm();
    #else
      if ((pwr_stage.sdm_fast) || (sdm_clk++ & 0x01)) sdm();
    #endif
    if (!PT_SCHEDULE(thread_run(&thread_run_pt, __systick()))) break;
  };
  free_spin(); sdm_reset();
  return __result;
}

#endif // RUN_H_INCLUDED
