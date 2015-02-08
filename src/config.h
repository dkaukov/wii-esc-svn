/**
 * Wii ESC NG 2.0 - 2013
 * Global configuration
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

#ifndef config_h
#define config_h

//*************************
// System settings        *
//*************************
//#define    OSC_DEBUG
#define    READ_EXTERNAL_CONFIG
#define    ZC_FILTER_NUMBER    2

//*************************
// Power settings         *
//*************************
#define    PCT_PWR_MIN         8

//*************************
// Startup settings       *
//*************************
#define    RPM_STEP_INITIAL    155
#define    RPM_STEP_MAX        200
#define    PCT_PWR_STARTUP     8
#define    PCT_PWR_MAX_STARTUP 25
#define    RPM_START_MIN_RPM   5600
#define    ENOUGH_GOODIES      120

//*************************
// Run settings           *
//*************************
#define    RPM_RUN_MIN_RPM     4000

//*************************
// Config settings        *
//*************************
#define    RCP_MIN             900
#define    RCP_MAX             2200
#define    RCP_START           1000
#define    RCP_FULL            2000
#define    RCP_CAL             1000
#define    RCP_DEADBAND        5
#define    BRAKING             0
#define    TIMING_ADV          0
#define    STICK_CAL_DIS       0
#define    REVERSE             0
#define    ONESHOT125          1

#define    RCP_OS125_MIN       110
#define    RCP_OS125_MAX       255
#define    RCP_TIMEOUT_MS      2500


inline void Config_Init() {
  cfg.rcp_min_us = RCP_MIN;
  cfg.rcp_max_us = RCP_MAX;
  cfg.rcp_start_us = RCP_START;
  cfg.rcp_full_us = RCP_FULL;
  cfg.rcp_cal_us = RCP_CAL;
  cfg.rcp_deadband_us = RCP_DEADBAND;
  cfg.braking = BRAKING;
  cfg.timing_adv = TIMING_ADV;
  cfg.stick_cal_dis = STICK_CAL_DIS;
  cfg.rev = REVERSE;
  cfg.oneshot125 = ONESHOT125;
}

#endif
