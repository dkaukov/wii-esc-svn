/**
 * Wii ESC NG 2.0 - 2013
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

// Added to use complementary mode
#define COMP_PWM

#define __FWD__(x) (x)
#define __REV__(x) (x | 0b1000)


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
    case __FWD__(1):
    case __FWD__(2):
    case __REV__(3):
    case __REV__(4):
      BnFETOn();
      break;
    case __FWD__(3):
    case __FWD__(4):
    case __REV__(1):
    case __REV__(2):
      AnFETOn();
      break;
    case __FWD__(0):
    case __FWD__(5):
    case __REV__(0):
    case __REV__(5):
      CnFETOn();
      break;
  }
}

void set_pwm_on(uint8_t state) {
  uint8_t ext_state = state;
  if (pwr_stage.rev) ext_state = __REV__(ext_state);
  #ifdef COMP_PWM
  switch (ext_state) {
    case __FWD__(1):
    case __FWD__(2):
    case __REV__(3):
    case __REV__(4):
      BpFETOff();
      set_pwm_on_comp_on(ext_state);
      break;
    case __FWD__(3):
    case __FWD__(4):
    case __REV__(1):
    case __REV__(2):
      ApFETOff();
      set_pwm_on_comp_on(ext_state);
      break;
    case __FWD__(5):
    case __FWD__(0):
    case __REV__(5):
    case __REV__(0):
      CpFETOff();
      set_pwm_on_comp_on(ext_state);
      break;
  }
  #else
  switch (ext_state) {
    case __FWD__(1):
    case __FWD__(2):
    case __REV__(3):
    case __REV__(4):
      BnFETOn();
      break;
    case __FWD__(3):
    case __FWD__(4):
    case __REV__(1):
    case __REV__(2):
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
    case __FWD__(1):
    case __FWD__(2):
    case __REV__(3):
    case __REV__(4):
      BpFETOn();
      break;
    case __FWD__(3):
    case __FWD__(4):
    case __REV__(1):
    case __REV__(2):
      ApFETOn();
      break;
    case __FWD__(0):
    case __FWD__(5):
    case __REV__(0):
    case __REV__(5):
      CpFETOn();
      break;
  }
}

void set_pwm_off(uint8_t state) {
  AnFETOff();
  BnFETOff();
  CnFETOff();
  #ifdef COMP_PWM
    uint8_t ext_state = state;
    if (pwr_stage.rev) ext_state = __REV__(ext_state);
    set_pwm_off_comp_on(ext_state);
  #endif
}

void change_comm_state(uint8_t state) {
  uint8_t ext_state = state;
  if (pwr_stage.rev) ext_state = __REV__(ext_state);
  switch (ext_state) {
    // Forward
    case __FWD__(0):
      BpFETOff();
      CpFETOff();
      ApFETOn();
      ACPhaseB();
      break;
    case __FWD__(1):
      CpFETOff();
      CnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) BnFETOn();
      #ifdef COMP_PWM
        else BpFETOn();
      #endif
      ACPhaseC();
      break;
    case __FWD__(2):
      BpFETOff();
      ApFETOff();
      CpFETOn();
      ACPhaseA();
      break;
    case __FWD__(3):
      BpFETOff();
      BnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) AnFETOn();
      #ifdef COMP_PWM
        else ApFETOn();
      #endif
      ACPhaseB();
      break;
    case __FWD__(4):
      CpFETOff();
      ApFETOff();
      BpFETOn();
      ACPhaseC();
      break;
    case __FWD__(5):
      ApFETOff();
      AnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) CnFETOn();
      #ifdef COMP_PWM
        else CpFETOn();
      #endif
      ACPhaseA();
      break;
    // Rererse
    case __REV__(0):
      ApFETOff();
      CpFETOff();
      BpFETOn();
      ACPhaseA();
      break;
    case __REV__(1):
      CpFETOff();
      CnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) AnFETOn();
      #ifdef COMP_PWM
        else ApFETOn();
      #endif
      ACPhaseC();
      break;
    case __REV__(2):
      ApFETOff();
      BpFETOff();
      CpFETOn();
      ACPhaseB();
      break;
    case __REV__(3):
      ApFETOff();
      AnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) BnFETOn();
      #ifdef COMP_PWM
        else BpFETOn();
      #endif
      ACPhaseA();
      break;
    case __REV__(4):
      CpFETOff();
      BpFETOff();
      ApFETOn();
      ACPhaseC();
      break;
    case __REV__(5):
      BpFETOff();
      BnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) CnFETOn();
      #ifdef COMP_PWM
        else CpFETOn();
      #endif
      ACPhaseB();
      break;
  }
}

void set_ac_state(uint8_t state) {
  uint8_t ext_state = state;
  if (pwr_stage.rev) ext_state = __REV__(ext_state);
  switch (ext_state) {
    case __FWD__(0):
    case __FWD__(3):
    case __REV__(2):
    case __REV__(5):
      ACPhaseB();
      break;
    case __FWD__(1):
    case __FWD__(4):
    case __REV__(1):
    case __REV__(4):
      ACPhaseC();
      break;
    case __FWD__(2):
    case __FWD__(5):
    case __REV__(0):
    case __REV__(3):
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
