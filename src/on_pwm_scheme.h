void set_pwm_on(uint8_t state) {
  #ifdef COMP_PWM
  switch (state) {
    case 0: CpFETOff(); break;
    case 1: AnFETOff(); break;
    case 2: BpFETOff(); break;
    case 3: CnFETOff(); break;
    case 4: ApFETOff(); break;
    case 5: BnFETOff(); break;
  }
  #endif
  switch (state) {
    case 0: CnFETOn(); break;
    case 1: ApFETOn(); break;
    case 2: BnFETOn(); break;
    case 3: CpFETOn(); break;
    case 4: AnFETOn(); break;
    case 5: BpFETOn(); break;
  }
}

inline void set_pwm_off(uint8_t state) {
  switch (state) {
    case 0: CnFETOff(); break;
    case 1: ApFETOff(); break;
    case 2: BnFETOff(); break;
    case 3: CpFETOff(); break;
    case 4: AnFETOff(); break;
    case 5: BpFETOff(); break;
  }
  #ifdef COMP_PWM
  switch (state) {
    case 0: CpFETOn(); break;
    case 1: AnFETOn(); break;
    case 2: BpFETOn(); break;
    case 3: CnFETOn(); break;
    case 4: ApFETOn(); break;
    case 5: BnFETOn(); break;
  }
  #endif
}

void change_comm_state(uint8_t state) {
  switch (state) {
    case 0:
      BpFETOff(); BnFETOff();
      CpFETOff(); AnFETOff();
      ApFETOn();
      if (pwr_stage.sdm_state) CnFETOn();
      ACPhaseB();
      break;
    case 1:
      CnFETOff(); CpFETOff();
      BpFETOff(); AnFETOff();
      BnFETOn();
      if (pwr_stage.sdm_state) ApFETOn();
      ACPhaseC();
      break;
    case 2:
      ApFETOff(); AnFETOff();
      BpFETOff(); CnFETOff();
      CpFETOn();
      if (pwr_stage.sdm_state) BnFETOn();
      ACPhaseA();
      break;
    case 3:
      BpFETOff(); BnFETOff();
      ApFETOff(); CnFETOff();
      AnFETOn();
      if (pwr_stage.sdm_state) CpFETOn();
      ACPhaseB();
      break;
    case 4:
      CpFETOff(); CnFETOff();
      ApFETOff(); BnFETOff();
      BpFETOn();
      if (pwr_stage.sdm_state) AnFETOn();
      ACPhaseC();
      break;
    case 5:
      ApFETOff(); AnFETOff();
      CpFETOff(); BnFETOff();
      CnFETOn();
      if (pwr_stage.sdm_state) BpFETOn();
      ACPhaseA();
      break;
  }
}