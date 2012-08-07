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
