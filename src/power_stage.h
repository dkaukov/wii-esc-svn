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


#define FWD(x) (x)
#define REV(x) (x + 0b1000)
#define EXT_STATE(x) ((x) | (pwr_stage.rev << 3))


void free_spin() {
  AnFETOff(); BnFETOff(); CnFETOff();
  ApFETOff(); BpFETOff(); CpFETOff();
}

inline void brake() {
  AnFETOn(); BnFETOn(); CnFETOn();
}

inline void precharge_bootstrap_caps() {
  AnFETOn(); BnFETOn(); CnFETOn();
  __delay_ms(5);
  AnFETOff(); BnFETOff(); CnFETOff();
}

__attribute__ ((noinline))
static void set_pwm_on_comp_on(uint8_t ext_state) {
  switch (ext_state) {
    case FWD(1):
    case FWD(2):
    case REV(3):
    case REV(4):
      BnFETOn();
      break;
    case FWD(3):
    case FWD(4):
    case REV(1):
    case REV(2):
      AnFETOn();
      break;
    case FWD(0):
    case FWD(5):
    case REV(0):
    case REV(5):
      CnFETOn();
      break;
  }
}

void set_pwm_on(uint8_t state) {
  uint8_t ext_state = EXT_STATE(state);
  #ifdef COMP_PWM
  switch (ext_state) {
    case FWD(1):
    case FWD(2):
    case REV(3):
    case REV(4):
      BpFETOff();
      set_pwm_on_comp_on(ext_state);
      break;
    case FWD(3):
    case FWD(4):
    case REV(1):
    case REV(2):
      ApFETOff();
      set_pwm_on_comp_on(ext_state);
      break;
    case FWD(5):
    case FWD(0):
    case REV(5):
    case REV(0):
      CpFETOff();
      set_pwm_on_comp_on(ext_state);
      break;
  }
  #else
  switch (ext_state) {
    case FWD(1):
    case FWD(2):
    case REV(3):
    case REV(4):
      BnFETOn();
      break;
    case FWD(3):
    case FWD(4):
    case REV(1):
    case REV(2):
      AnFETOn();
      break;
    default:
      CnFETOn();
      break;
  }
  #endif
}

__attribute__ ((noinline))
static void set_pwm_off_comp_on(uint8_t ext_state) {
  switch (ext_state) {
    case FWD(1):
    case FWD(2):
    case REV(3):
    case REV(4):
      BpFETOn();
      break;
    case FWD(3):
    case FWD(4):
    case REV(1):
    case REV(2):
      ApFETOn();
      break;
    case FWD(0):
    case FWD(5):
    case REV(0):
    case REV(5):
      CpFETOn();
      break;
  }
}

void set_pwm_off(uint8_t state) {
  uint8_t ext_state = EXT_STATE(state);
  AnFETOff();
  BnFETOff();
  CnFETOff();
  #ifdef COMP_PWM
    set_pwm_off_comp_on(ext_state);
  #endif
}

void change_comm_state(uint8_t state) {
  uint8_t ext_state = EXT_STATE(state);
  switch (ext_state) {
    // Forward
    case FWD(0):
      BpFETOff();
      CpFETOff();
      ApFETOn();
      ACPhaseB();
      break;
    case FWD(1):
      CpFETOff();
      CnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) BnFETOn();
      ACPhaseC();
      break;
    case FWD(2):
      BpFETOff();
      ApFETOff();
      CpFETOn();
      ACPhaseA();
      break;
    case FWD(3):
      BpFETOff();
      BnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) AnFETOn();
      ACPhaseB();
      break;
    case FWD(4):
      CpFETOff();
      ApFETOff();
      BpFETOn();
      ACPhaseC();
      break;
    case FWD(5):
      ApFETOff();
      AnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) CnFETOn();
      ACPhaseA();
      break;
    // Rererse
    case REV(0):
      ApFETOff();
      CpFETOff();
      BpFETOn();
      ACPhaseA();
      break;
    case REV(1):
      CpFETOff();
      CnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) AnFETOn();
      ACPhaseC();
      break;
    case REV(2):
      ApFETOff();
      BpFETOff();
      CpFETOn();
      ACPhaseB();
      break;
    case REV(3):
      ApFETOff();
      AnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) BnFETOn();
      ACPhaseA();
      break;
    case REV(4):
      CpFETOff();
      BpFETOff();
      ApFETOn();
      ACPhaseC();
      break;
    case REV(5):
      BpFETOff();
      BnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) CnFETOn();
      ACPhaseA();
      break;
  }
}

void set_ac_state(uint8_t state) {
  uint8_t ext_state = EXT_STATE(state);
  switch (ext_state) {
    case FWD(0):
    case FWD(3):
    case REV(2):
    case REV(5):
      ACPhaseB();
      break;
    case FWD(1):
    case FWD(4):
    case REV(1):
    case REV(4):
      ACPhaseC();
      break;
    case FWD(2):
    case FWD(5):
    case REV(0):
    case REV(3):
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
