/**
 * Wii ESC NG 2.0 - 2012
 * Pre-defined configurations
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

#ifndef CONFIG_DATA_H_INCLUDED
#define CONFIG_DATA_H_INCLUDED

__attribute__((section("default_eep")))
struct eeprom_layout __default_eep__  = {
  __ver_magic:       ver_magic,
  cfg: {
    rcp_min_us:      RCP_MIN,
    rcp_max_us:      RCP_MAX,
    rcp_start_us:    RCP_START,
    rcp_full_us:     RCP_FULL,
    rcp_cal_us:      0,
    rcp_deadband_us: RCP_DEADBAND,
    braking:         0,
    timing_adv:      0,
    stick_cal_dis:   0,
  }
};

__attribute__((section("extended_eep")))
struct eeprom_layout __extended_eep__  = {
  __ver_magic:       ver_magic,
  cfg: {
    rcp_min_us:      14,
    rcp_max_us:      2200,
    rcp_start_us:    18,
    rcp_full_us:     2016,
    rcp_cal_us:      16,
    rcp_deadband_us: 2,
    braking:         0,
    timing_adv:      0,
    stick_cal_dis:   1,
  }
};

__attribute__((section("free_flight_eep")))
struct eeprom_layout __free_flight_eep__  = {
  __ver_magic:       ver_magic,
  cfg: {
    rcp_min_us:      800,
    rcp_max_us:      2200,
    rcp_start_us:    1188,
    rcp_full_us:     1650,
    rcp_cal_us:      900,
    rcp_deadband_us: 5,
    braking:         0,
    timing_adv:      0,
    stick_cal_dis:   1,
  }
};

__attribute__((section("ultra_pwm_eep")))
struct eeprom_layout __ultra_pwm_eep__  = {
  __ver_magic:       ver_magic,
  cfg: {
    rcp_min_us:      14,
    rcp_max_us:      1400,
    rcp_start_us:    200,
    rcp_full_us:     1200,
    rcp_cal_us:      0,
    rcp_deadband_us: 0,
    braking:         0,
    timing_adv:      0,
    stick_cal_dis:   1,
  }
};

__attribute__((section("multiwii_eep")))
struct eeprom_layout __multiwii_eep__  = {
  __ver_magic:       ver_magic,
  cfg: {
    rcp_min_us:      900,
    rcp_max_us:      2200,
    rcp_start_us:    1140,
    rcp_full_us:     1850,
    rcp_cal_us:      1000,
    rcp_deadband_us: 5,
    braking:         0,
    timing_adv:      0,
    stick_cal_dis:   1,
  }
};


#endif // CONFIG_DATA_H_INCLUDED
