/**
 * Wii ESC NG 2.0 - 2013
 * Permanent storage for parameters
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

#ifndef STORAGE_H_INCLUDED
#define STORAGE_H_INCLUDED

const uint8_t ver_magic = 30;

static uint8_t __ver_magic = ver_magic;

struct eeprom_layout {
  uint8_t __ver_magic;
  struct config_data cfg;
};

typedef struct nvr_entry nvr_entry_t;
struct nvr_entry{
  void *var;
  size_t size;
};

static const nvr_entry_t nvr_entry[] = {
  {&__ver_magic, sizeof(__ver_magic)},
  {&cfg, sizeof(cfg)},
};
const uint8_t nvr_entry_cnt = sizeof(nvr_entry) / sizeof(nvr_entry_t);

void read_storage() {
  nvram_open(NVRAM_MODE_READ);
  for(uint8_t i = 0; i < nvr_entry_cnt; i++)
    nvram_read(nvr_entry[i].var, nvr_entry[i].size);
  nvram_close();
}

void write_storage() {
#if defined(INT_OSC)
  uint8_t tmp = OSCCAL;
  OSCCAL = 127;
  __delay_ms(2);
#endif
  nvram_open(NVRAM_MODE_WRITE);
  for(uint8_t i = 0; i < nvr_entry_cnt; i++)
    nvram_write(nvr_entry[i].var, nvr_entry[i].size);
  nvram_close();
#if defined(INT_OSC)
  OSCCAL = tmp;
  __delay_ms(2);
#endif
}

inline void Storage_Init() {
#ifdef READ_EXTERNAL_CONFIG
  uint8_t test_val = ver_magic;
  nvram_open(NVRAM_MODE_READ); nvram_read(&test_val, 1); nvram_close();
  if (test_val == ver_magic)
    read_storage();
#endif
}

#endif // STORAGE_H_INCLUDED
