/**
 * Wii ESC NG 2.0 - 2012
 * Oscilloscope debugging utilities
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

#ifndef DEBUG_H_INCLUDED
#define DEBUG_H_INCLUDED

#if defined(OSC_DEBUG)

inline void Debug_Init() {
  DebugStrOff();
  DebugLEDOff();
}

// OSC: External trigger
volatile void Debug_Trigger() {
  DebugStrToggle();
};

// OSC: Invert trace
volatile void Debug_TraceToggle() {
  DebugLEDToggle();
};

// OSC: Put short spike
volatile void Debug_TraceMark() {
  DebugLEDToggle();
  asm("nop");
  DebugLEDToggle();
};

#else

inline void Debug_Init() {};
inline void Debug_Trigger() {};
inline void Debug_TraceToggle() {};
inline void Debug_TraceMark() {};

#endif //OSC_DEBUG
#endif //DEBUG_H_INCLUDED
