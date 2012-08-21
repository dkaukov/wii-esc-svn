/**
 * Wii ESC NG 2.0 - 2012
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
// RC Input               *
//*************************
#define    RCP_MIN             900
#define    RCP_MAX             2200
#define    RCP_START           1060
#define    RCP_FULL            1860
#define    RCP_DEADBAND        5
#define    RCP_TIMEOUT_MS      2500
#define    RCP_CAL             1000

/* Extended range
#define    RCP_MIN             14
#define    RCP_MAX             2200
#define    RCP_START           18
#define    RCP_FULL            2016
#define    RCP_DEADBAND        2
#define    RCP_TIMEOUT_MS      2500
#define    RCP_CAL             16
*/

#endif

