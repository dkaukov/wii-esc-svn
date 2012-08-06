#include <util\twi.h>

// TWI actions
#define TWI_ACT_START           _BV(TWSTA) | _BV(TWEN)  | _BV(TWINT)
#define TWI_ACT_RESTART         _BV(TWSTA) | _BV(TWEN)  | _BV(TWINT)
#define TWI_ACT_STOP            _BV(TWSTO) | _BV(TWEN)  | _BV(TWINT)
#define TWI_ACT_W_ADDR          _BV(TWEN)  | _BV(TWINT)
#define TWI_ACT_W_DATA          _BV(TWEN)  | _BV(TWINT)
#define TWI_ACT_R_ACK           _BV(TWEN)  | _BV(TWINT) | _BV(TWEA)
#define TWI_ACT_R_NACK          _BV(TWEN)  | _BV(TWINT)
#define TWI_ACT_RELEASE_BUS     _BV(TWEN)  | _BV(TWINT) | _BV(TWEA);

// TWI stauses
#define TWI_RES_START_OK        0x08
#define TWI_RES_RESTART_OK      0x10
#define TWI_RES_W_ADDR_OK       0x18 
#define TWI_RES_R_ADDR_OK       0x40
#define TWI_RES_W_DATA_ACK      0x28 
#define TWI_RES_W_DATA_NACK     0x30
#define TWI_RES_R_ACK_OK        0x50 
#define TWI_RES_R_NACK_OK       0x58 
#define TWI_RES_TIMEOUT         0xFF

#define I2C_SET_CLOCK(x)        TWBR = ((16000000L / x) - 16) / 2;

uint16_t twi_err_cnt   = 0; 
uint8_t  i2c_io_result = 0; 

uint8_t twi_act(uint8_t action);

void twi_failure(){
  twi_act(TWI_ACT_STOP);               
  twi_err_cnt++;
  i2c_io_result = 1;
}  
 
uint8_t twi_act(uint8_t action){
  // action
  TWCR = action;
  // wait for finish
  if(action != (TWI_ACT_STOP)) {
    uint8_t count = 0;
    while (!(TWCR & _BV(TWINT))) {
      //count--;
      if (!(++count)) {
        TWCR = 0;
        //twi_failure();
        return TWI_RES_TIMEOUT;
      }
    }
  }  
  // return status
  return (TWSR & 0xF8);
}



// i2c transactions
uint8_t i2c_trn_begin_write(uint8_t dev_addr, uint8_t reg_addr);

uint8_t i2c_trn_begin_read(uint8_t dev_addr, uint8_t reg_addr) {
  i2c_io_result = 0;
  if (!i2c_trn_begin_write(dev_addr, reg_addr))       goto fail;
  if (twi_act(TWI_ACT_RESTART) != TWI_RES_RESTART_OK) goto fail;
  TWDR = dev_addr + 1;
  if (twi_act(TWI_ACT_W_ADDR)  != TWI_RES_R_ADDR_OK)  goto fail;
  return 1;
fail: {
  twi_failure();
  return 0;  
  }
}  

uint8_t i2c_trn_begin_write(uint8_t dev_addr, uint8_t reg_addr) {
  i2c_io_result = 0;
  if (twi_act(TWI_ACT_START)  != TWI_RES_START_OK)   goto fail;
  TWDR = dev_addr + 0;
  if (twi_act(TWI_ACT_W_ADDR) != TWI_RES_W_ADDR_OK)  goto fail;
  TWDR = reg_addr;
  if (twi_act(TWI_ACT_W_DATA) != TWI_RES_W_DATA_ACK) goto fail;
  return 1;
fail: {
  twi_failure();
  return 0;  
  }
}  

uint8_t i2c_trn_read_next() {                                                                                   
  if (i2c_io_result == 0) {
    if (twi_act(TWI_ACT_R_ACK) == TWI_RES_R_ACK_OK) 
      return TWDR; 
    else {
      twi_failure();
      return 0;  
    }  
  } 
  return 0;  
}  

uint8_t i2c_trn_read_last() {
  if (i2c_io_result == 0) {
    if (twi_act(TWI_ACT_R_NACK) == TWI_RES_R_NACK_OK) 
      return TWDR; 
    else {
      twi_failure();
      return 0;  
    }  
  } 
  return 0;  
}  

uint8_t i2c_trn_write(uint8_t data) {
  if (i2c_io_result == 0) {
    TWDR = data;
    switch (twi_act(TWI_ACT_W_DATA)) {
      case TWI_RES_W_DATA_ACK:  return 1; break;
      case TWI_RES_W_DATA_NACK: return 0; break;
      default: twi_failure();   return 0; break;
    }
  }  
  return 0;
}  

void i2c_trn_end() {
  if (i2c_io_result == 0)
    twi_act(TWI_ACT_STOP);
}

uint8_t i2c_trn_error() {
  return (i2c_io_result != 0);
}  

// i2c high level read/write
void avr_i2c_write_byte(uint8_t add, uint8_t reg, uint8_t val) {
  if (i2c_trn_begin_write(add, reg)) {
    i2c_trn_write(val);
    i2c_trn_end();
  }
}

uint8_t avr_i2c_read_byte(uint8_t add, uint8_t reg) {
  if (i2c_trn_begin_read(add, reg)) {
    uint8_t res = i2c_trn_read_last();  
    i2c_trn_end();
    return res;
  } else return 0;
}
