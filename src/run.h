#ifndef RUN_H_INCLUDED
#define RUN_H_INCLUDED

static struct timer_small  timer_comm_delay;
static struct timer_small  timer_comm;
//static struct timer_small  timer_zc_blank;
//static struct timer_small  timer_zc_timeout;
static uint8_t             run_result;
static uint8_t             zc_recovery;

#define RUN_RES_OK         0
#define RUN_RES_TIMEOUT    1
#define RUN_RES_UNKNOWN    255

void run_init() {
  run_result = RUN_RES_UNKNOWN;
  zc_filter_run_reset();
  //!!!! Start to run
  timer_comm.last_systick = last_tick;
//  timer_zc_timeout.last_systick = start_systick;
  timer_comm.elapsed = est_comm_time >> 1;
  __hw_alarm_a_set(last_tick + est_comm_time + (est_comm_time >> 1));
  DebugStrToggle();
}

void run_power_control() {
  filter_ppm_data();
  int16_t tmp = rx.raw - (1000 * CLK_SCALE);
  if (tmp < PWR_PCT_TO_VAL(PCT_PWR_MIN)) tmp = 0;
  if (tmp > POWER_RANGE)                 tmp = POWER_RANGE;
  sdm_ref = tmp;
}

static PT_THREAD(thread_run(struct pt *pt, uint16_t dt)) {
  uint16_t t;
  PT_BEGIN(pt);
  for (;;) {
    if ((pwr_stage.com_state & 1)) {
      PT_YIELD(pt);
      PT_WAIT_UNTIL(pt,  zc_kickback_end(pwr_stage.com_state));
      DebugLEDToggle(); DebugLEDToggle();
      PT_WAIT_UNTIL(pt, __hw_alarm_a_expired() || zc_run_detected());
      if (__hw_alarm_a_expired()) {
        //power_off();
        //DebugStrToggle();
        //DebugLEDToggle();
        //next_comm_state();
        //next_comm_state();
        //change_comm_state(pwr_stage.com_state);
        //power_off();
        // __hw_alarm_a_set(est_comm_time << 1);
        //continue;
        //run_result = RUN_RES_TIMEOUT;
        //break;
        //DebugStrToggle();
      }
      DebugLEDToggle(); DebugLEDToggle();
      t = dt - 56;
      update_timing(t);
      timer_comm.last_systick =  t;
      timer_comm_delay.last_systick = t;
//      timer_zc_timeout.last_systick = t;
      timer_comm_delay.elapsed = est_comm_time >> 3;
      timer_comm.elapsed = est_comm_time >> 1;
      timer_comm.elapsed += timer_comm_delay.elapsed;
      __hw_alarm_a_set(t + est_comm_time + (est_comm_time >> 1));
      //DebugLEDToggle(); DebugLEDToggle();
      PT_WAIT_UNTIL(pt, timer_expired(&timer_comm_delay, dt));
      //DebugLEDToggle(); DebugLEDToggle();
    } else {
      run_power_control();
      if (est_comm_time > (RPM_TO_COMM_TIME(RPM_RUN_MIN_RPM) * 2 * CLK_SCALE)) {
        run_result = RUN_RES_OK;
        break;
      }
      PT_WAIT_UNTIL(pt, timer_expired(&timer_comm, dt));
    }
    next_comm_state();
    change_comm_state(pwr_stage.com_state);
    if (!pwr_stage.com_state) DebugStrToggle();
    DebugLEDToggle();
  }
  PT_END(pt);
}

uint8_t run() {
  uint8_t sdm_clk;
  uint16_t current_tick;
  struct pt thread_run_pt;
  PT_INIT(&thread_run_pt);
  run_init();
  do {
    current_tick = __systick();
    aco_sample();
    #if (CLK_SCALE == 2)
      if (sdm_clk++ & 0x01) sdm();
    #else
      sdm();
    #endif
  } while (PT_SCHEDULE(thread_run(&thread_run_pt, current_tick)));
  free_spin(); sdm_reset();
  return run_result;
}

#endif // RUN_H_INCLUDED
