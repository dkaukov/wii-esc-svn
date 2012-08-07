#ifndef START_H_INCLUDED
#define START_H_INCLUDED

static struct timer_big      timer_start;

#define START_RES_OK         0
#define START_RES_TIMEOUT    1
#define START_RES_OFF        2
#define START_RES_UNKNOWN    255

void start_power_control() {
  filter_ppm_data();
  int16_t val = rx.raw - (1000 * CLK_SCALE);
  if (val < PWR_PCT_TO_VAL(PCT_PWR_MIN)) {
    sdm_ref = 0;
    return;
  }
  if (val < PWR_PCT_TO_VAL(PCT_PWR_STARTUP)) val = PWR_PCT_TO_VAL(PCT_PWR_STARTUP);
  else
  if (val > PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP)) val = PWR_PCT_TO_VAL(PCT_PWR_MAX_STARTUP);
  sdm_ref += (val - sdm_ref) >> 4;
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

static PT_THREAD(thread_start(struct pt *pt, uint16_t tick)) {
  uint8_t timeout;
  PT_BEGIN(pt);
  while (1) {
    timer_start.elapsed = timer_start.interval; //timer_start.last_systick = tick;
    PT_YIELD(pt);
    PT_WAIT_UNTIL(pt, (timeout = timer_expired(&timer_start, tick)) || zc_kickback_end(pwr_stage.com_state));
    Debug_TraceMark();
    zc_filter_start_reset();
    PT_WAIT_UNTIL(pt, (timeout = timer_expired(&timer_start, tick)) || zc_start_detected(pwr_stage.com_state));
    next_comm_state();
    change_comm_state(pwr_stage.com_state);
    start_power_control();
    start_timing_control();
    if (!timeout) {
      if (!(pwr_stage.com_state & 1)) {
        update_timing(tick);
        if (++good_com >= ENOUGH_GOODIES) {
          good_com = ENOUGH_GOODIES;
          if (est_comm_time <= (RPM_TO_COMM_TIME(RPM_START_MIN_RPM) * 2)) {
            __result = START_RES_OK;
            break;
          }
        }
      }
    } else good_com = 0;
    if (sdm_ref == 0) {__result = START_RES_OFF; break;}
    if (!pwr_stage.com_state) Debug_Trigger();
    Debug_TraceToggle();
  }
  PT_END(pt);
}

static uint8_t start() {
  struct pt thread_start_pt;
  uint16_t current_tick;
  PT_INIT(&thread_start_pt);
  start_init();
  do {
    current_tick = __systick();
    aco_sample();
    sdm();
    //if (pwr_stage.aco) DebugLEDOn(); else DebugLEDOff();
  } while (PT_SCHEDULE(thread_start(&thread_start_pt, current_tick)));
  return __result;
}

#endif // START_H_INCLUDED
