#include <stdint.h>
#include <avr/eeprom.h>
#include "nvram.h"

static uint16_t _address;

void nvram_open(uint8_t mode) {
  _address = 0;
}

void nvram_close() {
}

void nvram_read(void *buff, size_t len) {
  eeprom_read_block(buff, (void*)(_address), len);
  _address += len;
}

inline void eeprom_update_block(const void *__src, void *__dst, size_t __n) {
  char *_dst_ptr = (char *)__dst;
  char *_src_ptr = (char *)__src;
  while (__n--) {
    uint8_t b = eeprom_read_byte((const uint8_t *)_dst_ptr);
    if (b != *_src_ptr) eeprom_write_byte((uint8_t *)_dst_ptr, *_src_ptr);
    _dst_ptr++;
    _src_ptr++;
  }
}

void nvram_write(const void *buff, size_t len) {
  eeprom_update_block(buff, (void*)(_address), len);
  _address += len;
}
