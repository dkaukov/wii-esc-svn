#ifndef MWC_Debug_h
#define MWC_Debug_h

#include <stdio.h>

#if defined(MWC_DEBUG)

#define __ASSERT_USE_STDERR
#include <assert.h>

#define dprintf(format, ...) printf_P(PSTR( format ), ##__VA_ARGS__)

#if defined(__AVR__)
static FILE debugout = {0};

static int debug_putchar (char c, FILE *stream) {
  CLI_serial_write(c);
  return 1;
}

inline void Debug_Init() {
  CLI_serial_open(115200);
  fdev_setup_stream (&debugout, debug_putchar, NULL, _FDEV_SETUP_WRITE);
  stdout = &debugout;
  stderr = &debugout;
}
#else

inline void Debug_Init() {
}

#endif

#else

  inline void Debug_Init() {};
  #define dprintf(format, ...)
  #define assert(expression)

#endif

#endif
