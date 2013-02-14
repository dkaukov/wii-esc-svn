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

static uint8_t state_table_nxt[6] = {1, 2, 3, 4, 5, 0};
static uint8_t state_table_prv[6] = {5, 0, 1, 2, 3, 4};
static uint8_t state_table_zcs[6] = {0, 1, 0, 1, 0, 1};

void set_reverse() {
  static uint8_t state_table_tmp[6];
  memcpy(state_table_tmp, state_table_nxt, 6);
  memcpy(state_table_nxt, state_table_prv, 6);
  memcpy(state_table_prv, state_table_tmp, 6);
  for (uint8_t i = 0; i < 6; i++)
    state_table_zcs[i] ^= 0x01;
}


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
static void set_pwm_on_comp_on(uint8_t state) {
  switch (state) {
    case 1:
    case 2:
    case 6:
    case 7:
      BnFETOn();
      break;
    case 3:
    case 4:
      AnFETOn();
      break;
    case 0:
    case 5:
      CnFETOn();
  }
}

void set_pwm_on(uint8_t state) {
  #ifdef COMP_PWM
  switch (state) {
    case 1:
    case 2:
      BpFETOff();
      set_pwm_on_comp_on(state);
      break;
    case 3:
    case 4:
      ApFETOff();
      set_pwm_on_comp_on(state);
      break;
    default:
      CpFETOff();
      set_pwm_on_comp_on(state);
  }
  #else
  switch (state) {
    case 1:
    case 2:
      BnFETOn();
      break;
    case 3:
    case 4:
      AnFETOn();
      break;
    default:
      CnFETOn();
  }
  #endif
}

__attribute__ ((noinline))
static void set_pwm_off_comp_on(uint8_t state) {
  switch (state) {
    case 1:
    case 2:
    case 6:
    case 7:
      BpFETOn();
      break;
    case 3:
    case 4:
      ApFETOn();
      break;
    case 0:
    case 5:
      CpFETOn();
  }
}

void set_pwm_off(uint8_t state) {
  AnFETOff();
  BnFETOff();
  CnFETOff();
  #ifdef COMP_PWM
    set_pwm_off_comp_on(state);
  #endif
}

void change_comm_state(uint8_t state) {
  switch (state) {
    case 0:
      BpFETOff();
      CpFETOff();
      ApFETOn();
      ACPhaseB();
      break;
    case 1:
      CpFETOff();
      CnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) BnFETOn();
      ACPhaseC();
      break;
    case 2:
      BpFETOff();
      ApFETOff();
      CpFETOn();
      ACPhaseA();
      break;
    case 3:
      BpFETOff();
      BnFETOff();
      AnFETOff();
      if (pwr_stage.sdm_state) AnFETOn();
      ACPhaseB();
      break;
    case 4:
      CpFETOff();
      ApFETOff();
      BpFETOn();
      ACPhaseC();
      break;
    case 5:
      ApFETOff();
      AnFETOff();
      BnFETOff();
      if (pwr_stage.sdm_state) CnFETOn();
      ACPhaseA();
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
  pwr_stage.com_state = state_table_nxt[pwr_stage.com_state];
  pwr_stage.zc_sign = state_table_zcs[pwr_stage.com_state];
}

inline void next_comm_state(uint8_t n) {
  uint8_t tmp = pwr_stage.com_state;
  for (uint8_t i = 0; i < n; i++)
    tmp = state_table_nxt[tmp];
  pwr_stage.com_state  = tmp;
  pwr_stage.zc_sign = state_table_zcs[tmp];
}

void set_comm_state() {
  change_comm_state(state_table_prv[pwr_stage.com_state]);
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
