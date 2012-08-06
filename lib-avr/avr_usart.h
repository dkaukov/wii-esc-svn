#if AVR_USART_PORT == 0
  #define __NAME__(NAME) avr_ ## NAME ## _0
  #if defined(SIG_UART_RECV)
    #define __ISR__(NAME)  ISR(SIG_UART_RECV)
  #elif defined(USART_RX_vect)
    #define __ISR__(NAME)  ISR(USART_ ## NAME )
  #else
    #define __ISR__(NAME)  ISR(USART0_ ## NAME )
  #endif

  #if !defined(UCSR0A)
    #define UCSR0A UCSRA
    #define UBRR0H UBRRH
    #define UBRR0L UBRRL
    #define UCSR0B UCSRB
    #define UDR0   UDR
    #define RXEN0  RXEN
    #define TXEN0  TXEN
    #define RXCIE0 RXCIE
    #define UDRIE0 UDRIE
    #define U2X0   U2X
    #define UDRE0  UDRE
  #endif

  #define __UCSRA UCSR0A
  #define __UBRRH UBRR0H
  #define __UBRRL UBRR0L
  #define __UCSRB UCSR0B
  #define __UDR   UDR0

  #define __RXEN  RXEN0
  #define __TXEN  TXEN0
  #define __RXCIE RXCIE0
  #define __UDRIE UDRIE0
  #define __U2X   U2X0
  #define __UDRE  UDRE0
#elif AVR_USART_PORT == 1
  #define __NAME__(NAME)  NAME ## _1
#endif

static uint8_t __NAME__(usartBufferRX)[USART_RX_BUFFER_SIZE];
static uint8_t __NAME__(usartBufferTX)[USART_TX_BUFFER_SIZE];
static volatile uint8_t __NAME__(usartHeadRX), __NAME__(usartHeadTX);
static volatile uint8_t __NAME__(usartTailRX), __NAME__(usartTailTX);

void __NAME__(UsartOpen)(uint32_t baud) {
  uint8_t h = ((F_CPU  / 4 / baud -1) / 2) >> 8;
  uint8_t l = ((F_CPU  / 4 / baud -1) / 2);
  __UCSRA  = _BV(__U2X); __UBRRH = h; __UBRRL = l; __UCSRB |= _BV(__RXEN) | _BV(__TXEN) | _BV(__RXCIE);
}

void __NAME__(UsartClose)() {
  __UCSRB &= ~(_BV(__RXEN) | _BV(__TXEN) | _BV(__RXCIE) | _BV(__UDRIE));
}

__ISR__(RX_vect){
  uint8_t d = UDR0;
  uint8_t i = (__NAME__(usartHeadRX) + 1) % USART_RX_BUFFER_SIZE;
  if (i != __NAME__(usartTailRX)) {
    __NAME__(usartBufferRX)[__NAME__(usartHeadRX)] = d;
    __NAME__(usartHeadRX) = i;
  }
}

uint8_t __NAME__(UsartRead)() {
  uint8_t c = __NAME__(usartBufferRX)[__NAME__(usartTailRX)];
  if ((__NAME__(usartHeadRX) != __NAME__(usartTailRX))) __NAME__(usartTailRX) = (__NAME__(usartTailRX) + 1) % USART_RX_BUFFER_SIZE;
  return c;
}

uint8_t __NAME__(UsartAvailable)() {
  return (uint8_t)(USART_RX_BUFFER_SIZE + __NAME__(usartHeadRX) - __NAME__(usartTailRX)) % USART_RX_BUFFER_SIZE;
}

void __NAME__(UsartPollWrite)(){
  if ((__NAME__(usartHeadTX) != __NAME__(usartTailTX)) && (__UCSRA & _BV(__UDRE))) {
    __UDR  = __NAME__(usartBufferTX)[__NAME__(usartTailTX)];
    __NAME__(usartTailTX) = (__NAME__(usartTailTX) + 1) % USART_TX_BUFFER_SIZE;
  }
}

void __NAME__(UsartWrite)(uint8_t c){
  uint8_t i = (__NAME__(usartHeadTX) + 1) % USART_TX_BUFFER_SIZE;
  while (i == __NAME__(usartTailTX)) __NAME__(UsartPollWrite)();
  __NAME__(usartBufferTX)[__NAME__(usartHeadTX)] = c;
  __NAME__(usartHeadTX) = i;
}

uint8_t __NAME__(UsartTXFull)() {
  uint8_t i = (__NAME__(usartHeadTX) + 1) % USART_TX_BUFFER_SIZE;
  return (i == __NAME__(usartTailTX));
}

