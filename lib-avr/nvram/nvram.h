#ifndef nvram_h
#define nvram_h

#ifdef __cplusplus
extern "C"{
#endif

enum enum_nvram_modes {
    NVRAM_MODE_CLOSED,
    NVRAM_MODE_READ,
    NVRAM_MODE_WRITE,
};

void nvram_open(uint8_t mode);
void nvram_close();
void nvram_read(void *buff, size_t len);
void nvram_write(const void *buff, size_t len);

#ifdef __cplusplus
} // extern "C"
#endif

#endif
