/**
 * Wii ESC NG 2.0 - 2012
 * Powerstage Interface
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

#ifndef POWER_STAGE_H_INCLUDED
#define POWER_STAGE_H_INCLUDED

inline void free_spin() {
  PORTB = PORTB_INIT; PORTC = PORTC_INIT; PORTD = PORTD_INIT;
}

inline void precharge_bootstrap_caps() {
  AnFETOn(); BnFETOn(); CnFETOn();
  __delay_ms(5);
  AnFETOff(); BnFETOff(); CnFETOff();
}

void set_pwm_on(uint8_t state) {
  switch (state) {
    case 5:
    case 0:
      CnFETOn();
      break;
    case 1:
    case 2:
      BnFETOn();
      break;
    case 3:
    case 4:
      AnFETOn();
      break;
  }
}

inline void set_pwm_off(uint8_t state) {
  AnFETOff();
  BnFETOff();
  CnFETOff();
}

void change_comm_state(uint8_t state) {
  switch (state) {
    case 0:
      CpFETOff();
      ApFETOn();
      ACPhaseB();
      BpFETOff();
      break;
    case 1:
      CpFETOff();
      if (pwr_stage.sdm_state) BnFETOn();
      ACPhaseC();
      CnFETOff();
      break;
    case 2:
      BpFETOff();
      CpFETOn();
      ACPhaseA();
      ApFETOff();
      break;
    case 3:
      BpFETOff();
      if (pwr_stage.sdm_state) AnFETOn();
      ACPhaseB();
      BnFETOff();
      break;
    case 4:
      ApFETOff();
      BpFETOn();
      ACPhaseC();
      CpFETOff();
      break;
    case 5:
      ApFETOff();
      if (pwr_stage.sdm_state) CnFETOn();
      ACPhaseA();
      AnFETOff();
      break;
  }
}

void set_ac_state(uint8_t state) {
  switch (state) {
    case 0:
    case 3:
      ACPhaseB();
      break;
    case 1:
    case 4:
      ACPhaseC();
      break;
    case 2:
    case 5:
      ACPhaseA();
      break;
  }
}


inline void next_comm_state() {
  uint8_t r = pwr_stage.com_state;
  if (++r >= 6) r -= 6;
  pwr_stage.com_state = r;
}

inline void next_comm_state(uint8_t n) {
  uint8_t r = pwr_stage.com_state + n;
  if (r >= 6) r -= 6;
  pwr_stage.com_state = r;
}

void set_comm_state() {
  uint8_t prev_state = pwr_stage.com_state ;
  if (prev_state-- == 0xFF) prev_state = 5;
  change_comm_state(prev_state);
  change_comm_state(pwr_stage.com_state);
}

inline void aco_sample() {
 if bit_is_set(ACSR, ACO)
   pwr_stage.aco = 0x00;
 else
   pwr_stage.aco = 0x01;
}

inline void PowerStage_Init() {
  free_spin();
  precharge_bootstrap_caps();
}

#endif // POWER_STAGE_H_INCLUDED
