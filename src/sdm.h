/**
 * Wii ESC NG 2.0 - 2012
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

#define RCP_RANGE      US_TO_TICKS(RCP_FULL - RCP_START)
#define SDM_TOP        (RCP_RANGE + (RCP_RANGE * PCT_PWR_MIN) / 100)
#define SDM_LEFT       (US_TO_TICKS(RCP_START) - (RCP_RANGE * PCT_PWR_MIN) / 100)
#define RCP_TO_SDM(x)  (x - SDM_LEFT)

static int16_t sdm_err;

void sdm_reset() {
  sdm_err = 0;
  sdm_ref = 0;
  pwr_stage.sdm_state = 0;
}

void sdm() {
  int16_t err = sdm_ref;
  if (pwr_stage.sdm_state) err -= SDM_TOP;
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
