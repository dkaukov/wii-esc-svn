#ifndef SDM_H_INCLUDED
#define SDM_H_INCLUDED

#define POWER_RANGE    1000 * CLK_SCALE

static int16_t sdm_err;

void sdm_reset() {
  sdm_err = 0;
  sdm_ref = 0;
  pwr_stage.sdm_state = 0;
}

void sdm() {
  int16_t err = sdm_ref;
  if (pwr_stage.sdm_state) err -= POWER_RANGE;
  sdm_err -= err;
  if (sdm_err < 0) {
    if (!pwr_stage.sdm_state) {
      pwr_stage.sdm_state = 1;
      set_pwm_on(pwr_stage.com_state);
    }
  } else {
    if (pwr_stage.sdm_state) {
      pwr_stage.sdm_state = 0;
      set_pwm_off(pwr_stage.com_state);
    }
  }
}

#endif // SDM_H_INCLUDED
