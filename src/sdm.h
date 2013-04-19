/**
 * Wii ESC NG 2.0 - 2013
 * Sigma-Delta Modulator
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

#ifndef SDM_H_INCLUDED
#define SDM_H_INCLUDED

static int16_t rcp_to_sdm(uint16_t rcp) {
  int16_t val = rcp - sdm_rt.sdm_left;
  if (sdm_rt.sdm_rev) val = -val;
  return val;
}

void sdm_reset() {
  sdm_rt.sdm_err = 0;
  sdm_ref = 0;
  pwr_stage.sdm_state = 0;
}

uint16_t pct_to_val(uint8_t pct) {
  return ((uint32_t)sdm_rt.sdm_top * pct) / 100;
}

static void sdm_setup_rt(uint16_t _min, uint16_t _max) {
  int16_t range = _max - _min;
  if (range < 0) {
    sdm_rt.sdm_rev = 1;
    range = -range;
  } else {
    sdm_rt.sdm_rev = 0;
  }
  int16_t shift = (range * PCT_PWR_MIN) / 100;
  sdm_rt.sdm_top = range + shift;
  sdm_rt.sdm_left = _min - shift;
  //
  sdm_rt.sdm_run_min   = shift;
  sdm_rt.sdm_start_min = pct_to_val(PCT_PWR_STARTUP);
  sdm_rt.sdm_start_max = pct_to_val(PCT_PWR_MAX_STARTUP);
}

void sdm() {
  int16_t err = sdm_ref;
  if (pwr_stage.sdm_state) err -= sdm_rt.sdm_top;
  sdm_rt.sdm_err -= err;
  if (sdm_rt.sdm_err < 0) {
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
