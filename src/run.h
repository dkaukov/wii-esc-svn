#ifndef RUN_H_INCLUDED
#define RUN_H_INCLUDED

static struct timer_small  timer_comm_delay;
static struct timer_small  timer_comm;

#define RUN_RES_OK         0
#define RUN_RES_TIMEOUT    1
#define RUN_RES_UNKNOWN    255

void run_timing_control(uint16_t tick);
void run_power_control();
void run_init();

static PT_THREAD(thread_run(struct pt *pt, uint16_t dt)) {
  uint16_t t;
  PT_BEGIN(pt);
  for (;;) {
    if ((pwr_stage.com_state & 1)) {
      PT_YIELD(pt);
      PT_WAIT_UNTIL(pt, __hw_alarm_a_expired() || zc_kickback_end(pwr_stage.com_state));
      Debug_TraceMark();
      PT_YIELD(pt);
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
      t = dt - 56;
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
      PT_WAIT_UNTIL(pt, timer_expired(&timer_comm, dt));
    }
    next_comm_state();
    change_comm_state(pwr_stage.com_state);
    if (!pwr_stage.com_state) Debug_Trigger();
    Debug_TraceToggle();
    PT_YIELD(pt);
    run_power_control();
    PT_YIELD(pt);
    PT_YIELD(pt);
    PT_YIELD(pt);
  }
  PT_END(pt);
}

static uint8_t run() {
  uint8_t sdm_clk = 0;
  uint16_t current_tick;
  struct pt thread_run_pt;
  PT_INIT(&thread_run_pt);
  run_init();
  while (1) {
    current_tick = __systick();
    aco_sample();
    #if (TICKS_PER_US == 2)
      if (sdm_clk++ & 0x01) sdm();
    #else
      sdm();
    #endif
    if (!PT_SCHEDULE(thread_run(&thread_run_pt, current_tick))) break;
  };
  free_spin(); sdm_reset();
  return __result;
}

void run_init() {
  __result = RUN_RES_UNKNOWN;
  pwr_stage.recovery = 0;
  run_timing_control(last_tick);
}

void run_power_control() {
  filter_ppm_data();
  int16_t tmp = rx.raw - US_TO_TICKS(1000);
  if (tmp < PWR_PCT_TO_VAL(PCT_PWR_MIN)) tmp = 0;
  if (tmp > POWER_RANGE)                 tmp = POWER_RANGE;
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
}

#endif // RUN_H_INCLUDED
