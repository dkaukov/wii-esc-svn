
bin/avr/wii_esc_ng.elf:     file format elf32-avr


Disassembly of section .text:

00000000 <__vectors>:
   0:	12 c0       	rjmp	.+36     	; 0x26 <__ctors_end>
   2:	5f c0       	rjmp	.+190    	; 0xc2 <__vector_1>
   4:	2b c0       	rjmp	.+86     	; 0x5c <__bad_interrupt>
   6:	2a c0       	rjmp	.+84     	; 0x5c <__bad_interrupt>
   8:	29 c0       	rjmp	.+82     	; 0x5c <__bad_interrupt>
   a:	28 c0       	rjmp	.+80     	; 0x5c <__bad_interrupt>
   c:	27 c0       	rjmp	.+78     	; 0x5c <__bad_interrupt>
   e:	26 c0       	rjmp	.+76     	; 0x5c <__bad_interrupt>
  10:	25 c0       	rjmp	.+74     	; 0x5c <__bad_interrupt>
  12:	54 c5       	rjmp	.+2728   	; 0xabc <__vector_9>
  14:	23 c0       	rjmp	.+70     	; 0x5c <__bad_interrupt>
  16:	22 c0       	rjmp	.+68     	; 0x5c <__bad_interrupt>
  18:	21 c0       	rjmp	.+66     	; 0x5c <__bad_interrupt>
  1a:	20 c0       	rjmp	.+64     	; 0x5c <__bad_interrupt>
  1c:	1f c0       	rjmp	.+62     	; 0x5c <__bad_interrupt>
  1e:	1e c0       	rjmp	.+60     	; 0x5c <__bad_interrupt>
  20:	1d c0       	rjmp	.+58     	; 0x5c <__bad_interrupt>
  22:	1c c0       	rjmp	.+56     	; 0x5c <__bad_interrupt>
  24:	1b c0       	rjmp	.+54     	; 0x5c <__bad_interrupt>

00000026 <__ctors_end>:
  26:	11 24       	eor	r1, r1
  28:	1f be       	out	0x3f, r1	; 63
  2a:	cf e5       	ldi	r28, 0x5F	; 95
  2c:	d4 e0       	ldi	r29, 0x04	; 4
  2e:	de bf       	out	0x3e, r29	; 62
  30:	cd bf       	out	0x3d, r28	; 61

00000032 <__do_copy_data>:
  32:	10 e0       	ldi	r17, 0x00	; 0
  34:	a0 e6       	ldi	r26, 0x60	; 96
  36:	b0 e0       	ldi	r27, 0x00	; 0
  38:	ec e4       	ldi	r30, 0x4C	; 76
  3a:	fc e0       	ldi	r31, 0x0C	; 12
  3c:	02 c0       	rjmp	.+4      	; 0x42 <.do_copy_data_start>

0000003e <.do_copy_data_loop>:
  3e:	05 90       	lpm	r0, Z+
  40:	0d 92       	st	X+, r0

00000042 <.do_copy_data_start>:
  42:	a0 3a       	cpi	r26, 0xA0	; 160
  44:	b1 07       	cpc	r27, r17
  46:	d9 f7       	brne	.-10     	; 0x3e <.do_copy_data_loop>

00000048 <__do_clear_bss>:
  48:	10 e0       	ldi	r17, 0x00	; 0
  4a:	a0 ea       	ldi	r26, 0xA0	; 160
  4c:	b0 e0       	ldi	r27, 0x00	; 0
  4e:	01 c0       	rjmp	.+2      	; 0x52 <.do_clear_bss_start>

00000050 <.do_clear_bss_loop>:
  50:	1d 92       	st	X+, r1

00000052 <.do_clear_bss_start>:
  52:	a2 3d       	cpi	r26, 0xD2	; 210
  54:	b1 07       	cpc	r27, r17
  56:	e1 f7       	brne	.-8      	; 0x50 <.do_clear_bss_loop>
  58:	2c d5       	rcall	.+2648   	; 0xab2 <main>
  5a:	f6 c5       	rjmp	.+3052   	; 0xc48 <_exit>

0000005c <__bad_interrupt>:
  5c:	d1 cf       	rjmp	.-94     	; 0x0 <__vectors>

0000005e <__delay_us(unsigned int)>:
  5e:	ac 01       	movw	r20, r24
  60:	44 0f       	add	r20, r20
  62:	55 1f       	adc	r21, r21
  64:	44 50       	subi	r20, 0x04	; 4
  66:	50 40       	sbci	r21, 0x00	; 0
  68:	8f b7       	in	r24, 0x3f	; 63
  6a:	f8 94       	cli
  6c:	6c b5       	in	r22, 0x2c	; 44
  6e:	7d b5       	in	r23, 0x2d	; 45
  70:	8f bf       	out	0x3f, r24	; 63
  72:	2f b7       	in	r18, 0x3f	; 63
  74:	f8 94       	cli
  76:	8c b5       	in	r24, 0x2c	; 44
  78:	9d b5       	in	r25, 0x2d	; 45
  7a:	2f bf       	out	0x3f, r18	; 63
  7c:	86 1b       	sub	r24, r22
  7e:	97 0b       	sbc	r25, r23
  80:	84 17       	cp	r24, r20
  82:	95 07       	cpc	r25, r21
  84:	b0 f3       	brcs	.-20     	; 0x72 <__delay_us(unsigned int)+0x14>
  86:	08 95       	ret

00000088 <__delay_ms(unsigned long)>:
  88:	ef 92       	push	r14
  8a:	ff 92       	push	r15
  8c:	0f 93       	push	r16
  8e:	1f 93       	push	r17
  90:	7b 01       	movw	r14, r22
  92:	8c 01       	movw	r16, r24
  94:	61 15       	cp	r22, r1
  96:	71 05       	cpc	r23, r1
  98:	81 05       	cpc	r24, r1
  9a:	91 05       	cpc	r25, r1
  9c:	69 f0       	breq	.+26     	; 0xb8 <__delay_ms(unsigned long)+0x30>
  9e:	88 ee       	ldi	r24, 0xE8	; 232
  a0:	93 e0       	ldi	r25, 0x03	; 3
  a2:	dd df       	rcall	.-70     	; 0x5e <__delay_us(unsigned int)>
  a4:	08 94       	sec
  a6:	e1 08       	sbc	r14, r1
  a8:	f1 08       	sbc	r15, r1
  aa:	01 09       	sbc	r16, r1
  ac:	11 09       	sbc	r17, r1
  ae:	e1 14       	cp	r14, r1
  b0:	f1 04       	cpc	r15, r1
  b2:	01 05       	cpc	r16, r1
  b4:	11 05       	cpc	r17, r1
  b6:	99 f7       	brne	.-26     	; 0x9e <__delay_ms(unsigned long)+0x16>
  b8:	1f 91       	pop	r17
  ba:	0f 91       	pop	r16
  bc:	ff 90       	pop	r15
  be:	ef 90       	pop	r14
  c0:	08 95       	ret

000000c2 <__vector_1>:
  c2:	1f 92       	push	r1
  c4:	0f 92       	push	r0
  c6:	0f b6       	in	r0, 0x3f	; 63
  c8:	0f 92       	push	r0
  ca:	11 24       	eor	r1, r1
  cc:	2f 93       	push	r18
  ce:	3f 93       	push	r19
  d0:	8f 93       	push	r24
  d2:	9f 93       	push	r25
  d4:	2c b5       	in	r18, 0x2c	; 44
  d6:	3d b5       	in	r19, 0x2d	; 45
  d8:	82 99       	sbic	0x10, 2	; 16
  da:	13 c0       	rjmp	.+38     	; 0x102 <__vector_1+0x40>
  dc:	80 91 a4 00 	lds	r24, 0x00A4
  e0:	90 91 a5 00 	lds	r25, 0x00A5
  e4:	28 1b       	sub	r18, r24
  e6:	39 0b       	sbc	r19, r25
  e8:	30 93 a3 00 	sts	0x00A3, r19
  ec:	20 93 a2 00 	sts	0x00A2, r18
  f0:	9f 91       	pop	r25
  f2:	8f 91       	pop	r24
  f4:	3f 91       	pop	r19
  f6:	2f 91       	pop	r18
  f8:	0f 90       	pop	r0
  fa:	0f be       	out	0x3f, r0	; 63
  fc:	0f 90       	pop	r0
  fe:	1f 90       	pop	r1
 100:	18 95       	reti
 102:	30 93 a5 00 	sts	0x00A5, r19
 106:	20 93 a4 00 	sts	0x00A4, r18
 10a:	f2 cf       	rjmp	.-28     	; 0xf0 <__vector_1+0x2e>

0000010c <filter_ppm_data()>:
 10c:	20 91 a2 00 	lds	r18, 0x00A2
 110:	30 91 a3 00 	lds	r19, 0x00A3
 114:	c9 01       	movw	r24, r18
 116:	89 50       	subi	r24, 0x09	; 9
 118:	97 40       	sbci	r25, 0x07	; 7
 11a:	87 52       	subi	r24, 0x27	; 39
 11c:	9a 40       	sbci	r25, 0x0A	; 10
 11e:	d8 f4       	brcc	.+54     	; 0x156 <filter_ppm_data()+0x4a>
 120:	40 91 a0 00 	lds	r20, 0x00A0
 124:	50 91 a1 00 	lds	r21, 0x00A1
 128:	ca 01       	movw	r24, r20
 12a:	02 96       	adiw	r24, 0x02	; 2
 12c:	82 17       	cp	r24, r18
 12e:	93 07       	cpc	r25, r19
 130:	38 f4       	brcc	.+14     	; 0x140 <filter_ppm_data()+0x34>
 132:	a9 01       	movw	r20, r18
 134:	41 50       	subi	r20, 0x01	; 1
 136:	50 40       	sbci	r21, 0x00	; 0
 138:	50 93 a1 00 	sts	0x00A1, r21
 13c:	40 93 a0 00 	sts	0x00A0, r20
 140:	42 50       	subi	r20, 0x02	; 2
 142:	50 40       	sbci	r21, 0x00	; 0
 144:	24 17       	cp	r18, r20
 146:	35 07       	cpc	r19, r21
 148:	30 f4       	brcc	.+12     	; 0x156 <filter_ppm_data()+0x4a>
 14a:	2f 5f       	subi	r18, 0xFF	; 255
 14c:	3f 4f       	sbci	r19, 0xFF	; 255
 14e:	30 93 a1 00 	sts	0x00A1, r19
 152:	20 93 a0 00 	sts	0x00A0, r18
 156:	08 95       	ret

00000158 <set_pwm_on(unsigned char)>:
 158:	83 30       	cpi	r24, 0x03	; 3
 15a:	20 f4       	brcc	.+8      	; 0x164 <set_pwm_on(unsigned char)+0xc>
 15c:	81 30       	cpi	r24, 0x01	; 1
 15e:	40 f0       	brcs	.+16     	; 0x170 <set_pwm_on(unsigned char)+0x18>
 160:	c1 9a       	sbi	0x18, 1	; 24
 162:	08 95       	ret
 164:	85 30       	cpi	r24, 0x05	; 5
 166:	10 f4       	brcc	.+4      	; 0x16c <set_pwm_on(unsigned char)+0x14>
 168:	c2 9a       	sbi	0x18, 2	; 24
 16a:	08 95       	ret
 16c:	85 30       	cpi	r24, 0x05	; 5
 16e:	e9 f7       	brne	.-6      	; 0x16a <set_pwm_on(unsigned char)+0x12>
 170:	c0 9a       	sbi	0x18, 0	; 24
 172:	08 95       	ret

00000174 <change_comm_state(unsigned char)>:
 174:	82 30       	cpi	r24, 0x02	; 2
 176:	b9 f1       	breq	.+110    	; 0x1e6 <change_comm_state(unsigned char)+0x72>
 178:	83 30       	cpi	r24, 0x03	; 3
 17a:	80 f0       	brcs	.+32     	; 0x19c <change_comm_state(unsigned char)+0x28>
 17c:	84 30       	cpi	r24, 0x04	; 4
 17e:	09 f4       	brne	.+2      	; 0x182 <change_comm_state(unsigned char)+0xe>
 180:	3c c0       	rjmp	.+120    	; 0x1fa <change_comm_state(unsigned char)+0x86>
 182:	84 30       	cpi	r24, 0x04	; 4
 184:	d0 f4       	brcc	.+52     	; 0x1ba <change_comm_state(unsigned char)+0x46>
 186:	94 98       	cbi	0x12, 4	; 18
 188:	33 fc       	sbrc	r3, 3
 18a:	c2 9a       	sbi	0x18, 2	; 24
 18c:	84 e0       	ldi	r24, 0x04	; 4
 18e:	87 b9       	out	0x07, r24	; 7
 190:	37 98       	cbi	0x06, 7	; 6
 192:	80 b7       	in	r24, 0x30	; 48
 194:	88 60       	ori	r24, 0x08	; 8
 196:	80 bf       	out	0x30, r24	; 48
 198:	c1 98       	cbi	0x18, 1	; 24
 19a:	08 95       	ret
 19c:	88 23       	and	r24, r24
 19e:	51 f4       	brne	.+20     	; 0x1b4 <change_comm_state(unsigned char)+0x40>
 1a0:	93 98       	cbi	0x12, 3	; 18
 1a2:	95 9a       	sbi	0x12, 5	; 18
 1a4:	84 e0       	ldi	r24, 0x04	; 4
 1a6:	87 b9       	out	0x07, r24	; 7
 1a8:	37 98       	cbi	0x06, 7	; 6
 1aa:	80 b7       	in	r24, 0x30	; 48
 1ac:	88 60       	ori	r24, 0x08	; 8
 1ae:	80 bf       	out	0x30, r24	; 48
 1b0:	94 98       	cbi	0x12, 4	; 18
 1b2:	08 95       	ret
 1b4:	81 30       	cpi	r24, 0x01	; 1
 1b6:	71 f0       	breq	.+28     	; 0x1d4 <change_comm_state(unsigned char)+0x60>
 1b8:	08 95       	ret
 1ba:	85 30       	cpi	r24, 0x05	; 5
 1bc:	e9 f7       	brne	.-6      	; 0x1b8 <change_comm_state(unsigned char)+0x44>
 1be:	95 98       	cbi	0x12, 5	; 18
 1c0:	33 fc       	sbrc	r3, 3
 1c2:	c0 9a       	sbi	0x18, 0	; 24
 1c4:	85 e0       	ldi	r24, 0x05	; 5
 1c6:	87 b9       	out	0x07, r24	; 7
 1c8:	37 98       	cbi	0x06, 7	; 6
 1ca:	80 b7       	in	r24, 0x30	; 48
 1cc:	88 60       	ori	r24, 0x08	; 8
 1ce:	80 bf       	out	0x30, r24	; 48
 1d0:	c2 98       	cbi	0x18, 2	; 24
 1d2:	08 95       	ret
 1d4:	93 98       	cbi	0x12, 3	; 18
 1d6:	33 fc       	sbrc	r3, 3
 1d8:	c1 9a       	sbi	0x18, 1	; 24
 1da:	80 b7       	in	r24, 0x30	; 48
 1dc:	87 7f       	andi	r24, 0xF7	; 247
 1de:	80 bf       	out	0x30, r24	; 48
 1e0:	37 9a       	sbi	0x06, 7	; 6
 1e2:	c0 98       	cbi	0x18, 0	; 24
 1e4:	08 95       	ret
 1e6:	94 98       	cbi	0x12, 4	; 18
 1e8:	93 9a       	sbi	0x12, 3	; 18
 1ea:	85 e0       	ldi	r24, 0x05	; 5
 1ec:	87 b9       	out	0x07, r24	; 7
 1ee:	37 98       	cbi	0x06, 7	; 6
 1f0:	80 b7       	in	r24, 0x30	; 48
 1f2:	88 60       	ori	r24, 0x08	; 8
 1f4:	80 bf       	out	0x30, r24	; 48
 1f6:	95 98       	cbi	0x12, 5	; 18
 1f8:	08 95       	ret
 1fa:	95 98       	cbi	0x12, 5	; 18
 1fc:	94 9a       	sbi	0x12, 4	; 18
 1fe:	80 b7       	in	r24, 0x30	; 48
 200:	87 7f       	andi	r24, 0xF7	; 247
 202:	80 bf       	out	0x30, r24	; 48
 204:	37 9a       	sbi	0x06, 7	; 6
 206:	93 98       	cbi	0x12, 3	; 18
 208:	08 95       	ret

0000020a <set_comm_state()>:
 20a:	83 2d       	mov	r24, r3
 20c:	87 70       	andi	r24, 0x07	; 7
 20e:	81 50       	subi	r24, 0x01	; 1
 210:	b1 df       	rcall	.-158    	; 0x174 <change_comm_state(unsigned char)>
 212:	83 2d       	mov	r24, r3
 214:	87 70       	andi	r24, 0x07	; 7
 216:	ae cf       	rjmp	.-164    	; 0x174 <change_comm_state(unsigned char)>

00000218 <sdm()>:
 218:	92 01       	movw	r18, r4
 21a:	43 2d       	mov	r20, r3
 21c:	46 95       	lsr	r20
 21e:	46 95       	lsr	r20
 220:	46 95       	lsr	r20
 222:	41 70       	andi	r20, 0x01	; 1
 224:	11 f0       	breq	.+4      	; 0x22a <sdm()+0x12>
 226:	20 5d       	subi	r18, 0xD0	; 208
 228:	37 40       	sbci	r19, 0x07	; 7
 22a:	80 91 c7 00 	lds	r24, 0x00C7
 22e:	90 91 c8 00 	lds	r25, 0x00C8
 232:	82 1b       	sub	r24, r18
 234:	93 0b       	sbc	r25, r19
 236:	90 93 c8 00 	sts	0x00C8, r25
 23a:	80 93 c7 00 	sts	0x00C7, r24
 23e:	97 fd       	sbrc	r25, 7
 240:	08 c0       	rjmp	.+16     	; 0x252 <sdm()+0x3a>
 242:	44 23       	and	r20, r20
 244:	29 f0       	breq	.+10     	; 0x250 <sdm()+0x38>
 246:	87 ef       	ldi	r24, 0xF7	; 247
 248:	38 22       	and	r3, r24
 24a:	c2 98       	cbi	0x18, 2	; 24
 24c:	c1 98       	cbi	0x18, 1	; 24
 24e:	c0 98       	cbi	0x18, 0	; 24
 250:	08 95       	ret
 252:	44 23       	and	r20, r20
 254:	e9 f7       	brne	.-6      	; 0x250 <sdm()+0x38>
 256:	83 2d       	mov	r24, r3
 258:	88 60       	ori	r24, 0x08	; 8
 25a:	38 2e       	mov	r3, r24
 25c:	87 70       	andi	r24, 0x07	; 7
 25e:	7c cf       	rjmp	.-264    	; 0x158 <set_pwm_on(unsigned char)>

00000260 <start_power_control()>:
 260:	55 df       	rcall	.-342    	; 0x10c <filter_ppm_data()>
 262:	80 91 a0 00 	lds	r24, 0x00A0
 266:	90 91 a1 00 	lds	r25, 0x00A1
 26a:	80 5d       	subi	r24, 0xD0	; 208
 26c:	97 40       	sbci	r25, 0x07	; 7
 26e:	84 36       	cpi	r24, 0x64	; 100
 270:	91 05       	cpc	r25, r1
 272:	e4 f0       	brlt	.+56     	; 0x2ac <start_power_control()+0x4c>
 274:	8c 38       	cpi	r24, 0x8C	; 140
 276:	91 05       	cpc	r25, r1
 278:	8c f4       	brge	.+34     	; 0x29c <start_power_control()+0x3c>
 27a:	2c e8       	ldi	r18, 0x8C	; 140
 27c:	30 e0       	ldi	r19, 0x00	; 0
 27e:	c2 01       	movw	r24, r4
 280:	24 19       	sub	r18, r4
 282:	35 09       	sbc	r19, r5
 284:	35 95       	asr	r19
 286:	27 95       	ror	r18
 288:	35 95       	asr	r19
 28a:	27 95       	ror	r18
 28c:	35 95       	asr	r19
 28e:	27 95       	ror	r18
 290:	35 95       	asr	r19
 292:	27 95       	ror	r18
 294:	29 01       	movw	r4, r18
 296:	48 0e       	add	r4, r24
 298:	59 1e       	adc	r5, r25
 29a:	08 95       	ret
 29c:	9c 01       	movw	r18, r24
 29e:	82 e0       	ldi	r24, 0x02	; 2
 2a0:	29 35       	cpi	r18, 0x59	; 89
 2a2:	38 07       	cpc	r19, r24
 2a4:	64 f3       	brlt	.-40     	; 0x27e <start_power_control()+0x1e>
 2a6:	28 e5       	ldi	r18, 0x58	; 88
 2a8:	32 e0       	ldi	r19, 0x02	; 2
 2aa:	e9 cf       	rjmp	.-46     	; 0x27e <start_power_control()+0x1e>
 2ac:	44 24       	eor	r4, r4
 2ae:	55 24       	eor	r5, r5
 2b0:	08 95       	ret

000002b2 <start()>:
 2b2:	a8 e0       	ldi	r26, 0x08	; 8
 2b4:	b0 e0       	ldi	r27, 0x00	; 0
 2b6:	ee e5       	ldi	r30, 0x5E	; 94
 2b8:	f1 e0       	ldi	r31, 0x01	; 1
 2ba:	7e c4       	rjmp	.+2300   	; 0xbb8 <__prologue_saves__+0x6>
 2bc:	10 92 c3 00 	sts	0x00C3, r1
 2c0:	2c e8       	ldi	r18, 0x8C	; 140
 2c2:	42 2e       	mov	r4, r18
 2c4:	51 2c       	mov	r5, r1
 2c6:	88 e0       	ldi	r24, 0x08	; 8
 2c8:	98 ef       	ldi	r25, 0xF8	; 248
 2ca:	a1 e0       	ldi	r26, 0x01	; 1
 2cc:	b0 e0       	ldi	r27, 0x00	; 0
 2ce:	80 93 bd 00 	sts	0x00BD, r24
 2d2:	90 93 be 00 	sts	0x00BE, r25
 2d6:	a0 93 bf 00 	sts	0x00BF, r26
 2da:	b0 93 c0 00 	sts	0x00C0, r27
 2de:	8f ef       	ldi	r24, 0xFF	; 255
 2e0:	80 93 b8 00 	sts	0x00B8, r24
 2e4:	40 91 c5 00 	lds	r20, 0x00C5
 2e8:	50 91 c6 00 	lds	r21, 0x00C6
 2ec:	5e 83       	std	Y+6, r21	; 0x06
 2ee:	4d 83       	std	Y+5, r20	; 0x05
 2f0:	60 91 b3 00 	lds	r22, 0x00B3
 2f4:	70 91 b4 00 	lds	r23, 0x00B4
 2f8:	7c 83       	std	Y+4, r23	; 0x04
 2fa:	6b 83       	std	Y+3, r22	; 0x03
 2fc:	80 91 b6 00 	lds	r24, 0x00B6
 300:	90 91 b7 00 	lds	r25, 0x00B7
 304:	9a 83       	std	Y+2, r25	; 0x02
 306:	89 83       	std	Y+1, r24	; 0x01
 308:	e0 91 c1 00 	lds	r30, 0x00C1
 30c:	f0 91 c2 00 	lds	r31, 0x00C2
 310:	f8 87       	std	Y+8, r31	; 0x08
 312:	ef 83       	std	Y+7, r30	; 0x07
 314:	e0 90 b9 00 	lds	r14, 0x00B9
 318:	f0 90 ba 00 	lds	r15, 0x00BA
 31c:	00 91 bb 00 	lds	r16, 0x00BB
 320:	10 91 bc 00 	lds	r17, 0x00BC
 324:	c0 90 c4 00 	lds	r12, 0x00C4
 328:	dd 24       	eor	r13, r13
 32a:	22 24       	eor	r2, r2
 32c:	98 e0       	ldi	r25, 0x08	; 8
 32e:	89 2e       	mov	r8, r25
 330:	98 ef       	ldi	r25, 0xF8	; 248
 332:	99 2e       	mov	r9, r25
 334:	91 e0       	ldi	r25, 0x01	; 1
 336:	a9 2e       	mov	r10, r25
 338:	b1 2c       	mov	r11, r1
 33a:	8f b7       	in	r24, 0x3f	; 63
 33c:	f8 94       	cli
 33e:	6c b4       	in	r6, 0x2c	; 44
 340:	7d b4       	in	r7, 0x2d	; 45
 342:	8f bf       	out	0x3f, r24	; 63
 344:	45 9b       	sbis	0x08, 5	; 8
 346:	a1 c0       	rjmp	.+322    	; 0x48a <__stack+0x2b>
 348:	ff ee       	ldi	r31, 0xEF	; 239
 34a:	3f 22       	and	r3, r31
 34c:	65 df       	rcall	.-310    	; 0x218 <sdm()>
 34e:	34 fe       	sbrs	r3, 4
 350:	94 c0       	rjmp	.+296    	; 0x47a <__stack+0x1b>
 352:	c5 9a       	sbi	0x18, 5	; 24
 354:	5a e2       	ldi	r21, 0x2A	; 42
 356:	d5 16       	cp	r13, r21
 358:	09 f4       	brne	.+2      	; 0x35c <start()+0xaa>
 35a:	94 c0       	rjmp	.+296    	; 0x484 <__stack+0x25>
 35c:	6d e2       	ldi	r22, 0x2D	; 45
 35e:	d6 16       	cp	r13, r22
 360:	09 f4       	brne	.+2      	; 0x364 <start()+0xb2>
 362:	b4 c0       	rjmp	.+360    	; 0x4cc <__stack+0x6d>
 364:	dd 20       	and	r13, r13
 366:	09 f0       	breq	.+2      	; 0x36a <start()+0xb8>
 368:	c3 c0       	rjmp	.+390    	; 0x4f0 <__stack+0x91>
 36a:	a5 01       	movw	r20, r10
 36c:	94 01       	movw	r18, r8
 36e:	49 01       	movw	r8, r18
 370:	5a 01       	movw	r10, r20
 372:	78 86       	std	Y+8, r7	; 0x08
 374:	6f 82       	std	Y+7, r6	; 0x07
 376:	c3 01       	movw	r24, r6
 378:	ef 81       	ldd	r30, Y+7	; 0x07
 37a:	f8 85       	ldd	r31, Y+8	; 0x08
 37c:	8e 1b       	sub	r24, r30
 37e:	9f 0b       	sbc	r25, r31
 380:	a0 e0       	ldi	r26, 0x00	; 0
 382:	b0 e0       	ldi	r27, 0x00	; 0
 384:	82 17       	cp	r24, r18
 386:	93 07       	cpc	r25, r19
 388:	a4 07       	cpc	r26, r20
 38a:	b5 07       	cpc	r27, r21
 38c:	08 f4       	brcc	.+2      	; 0x390 <start()+0xde>
 38e:	a1 c0       	rjmp	.+322    	; 0x4d2 <__stack+0x73>
 390:	23 2d       	mov	r18, r3
 392:	27 70       	andi	r18, 0x07	; 7
 394:	85 01       	movw	r16, r10
 396:	74 01       	movw	r14, r8
 398:	78 86       	std	Y+8, r7	; 0x08
 39a:	6f 82       	std	Y+7, r6	; 0x07
 39c:	72 e1       	ldi	r23, 0x12	; 18
 39e:	c7 2e       	mov	r12, r23
 3a0:	c3 01       	movw	r24, r6
 3a2:	4f 81       	ldd	r20, Y+7	; 0x07
 3a4:	58 85       	ldd	r21, Y+8	; 0x08
 3a6:	84 1b       	sub	r24, r20
 3a8:	95 0b       	sbc	r25, r21
 3aa:	a0 e0       	ldi	r26, 0x00	; 0
 3ac:	b0 e0       	ldi	r27, 0x00	; 0
 3ae:	8e 15       	cp	r24, r14
 3b0:	9f 05       	cpc	r25, r15
 3b2:	a0 07       	cpc	r26, r16
 3b4:	b1 07       	cpc	r27, r17
 3b6:	08 f4       	brcc	.+2      	; 0x3ba <start()+0x108>
 3b8:	6b c0       	rjmp	.+214    	; 0x490 <__stack+0x31>
 3ba:	93 2d       	mov	r25, r3
 3bc:	97 70       	andi	r25, 0x07	; 7
 3be:	85 01       	movw	r16, r10
 3c0:	74 01       	movw	r14, r8
 3c2:	dd 24       	eor	r13, r13
 3c4:	d3 94       	inc	r13
 3c6:	89 2f       	mov	r24, r25
 3c8:	8f 5f       	subi	r24, 0xFF	; 255
 3ca:	86 30       	cpi	r24, 0x06	; 6
 3cc:	10 f0       	brcs	.+4      	; 0x3d2 <start()+0x120>
 3ce:	89 2f       	mov	r24, r25
 3d0:	85 50       	subi	r24, 0x05	; 5
 3d2:	87 70       	andi	r24, 0x07	; 7
 3d4:	93 2d       	mov	r25, r3
 3d6:	98 7f       	andi	r25, 0xF8	; 248
 3d8:	39 2e       	mov	r3, r25
 3da:	38 2a       	or	r3, r24
 3dc:	cb de       	rcall	.-618    	; 0x174 <change_comm_state(unsigned char)>
 3de:	40 df       	rcall	.-384    	; 0x260 <start_power_control()>
 3e0:	a5 01       	movw	r20, r10
 3e2:	94 01       	movw	r18, r8
 3e4:	28 52       	subi	r18, 0x28	; 40
 3e6:	30 40       	sbci	r19, 0x00	; 0
 3e8:	40 40       	sbci	r20, 0x00	; 0
 3ea:	50 40       	sbci	r21, 0x00	; 0
 3ec:	20 3a       	cpi	r18, 0xA0	; 160
 3ee:	66 e8       	ldi	r22, 0x86	; 134
 3f0:	36 07       	cpc	r19, r22
 3f2:	61 e0       	ldi	r22, 0x01	; 1
 3f4:	46 07       	cpc	r20, r22
 3f6:	60 e0       	ldi	r22, 0x00	; 0
 3f8:	56 07       	cpc	r21, r22
 3fa:	20 f4       	brcc	.+8      	; 0x404 <start()+0x152>
 3fc:	20 ea       	ldi	r18, 0xA0	; 160
 3fe:	36 e8       	ldi	r19, 0x86	; 134
 400:	41 e0       	ldi	r20, 0x01	; 1
 402:	50 e0       	ldi	r21, 0x00	; 0
 404:	dd 20       	and	r13, r13
 406:	09 f4       	brne	.+2      	; 0x40a <start()+0x158>
 408:	a5 c0       	rjmp	.+330    	; 0x554 <__stack+0xf5>
 40a:	22 24       	eor	r2, r2
 40c:	41 14       	cp	r4, r1
 40e:	51 04       	cpc	r5, r1
 410:	09 f0       	breq	.+2      	; 0x414 <start()+0x162>
 412:	c1 c0       	rjmp	.+386    	; 0x596 <__stack+0x137>
 414:	20 92 c3 00 	sts	0x00C3, r2
 418:	ed 81       	ldd	r30, Y+5	; 0x05
 41a:	fe 81       	ldd	r31, Y+6	; 0x06
 41c:	f0 93 c6 00 	sts	0x00C6, r31
 420:	e0 93 c5 00 	sts	0x00C5, r30
 424:	6b 81       	ldd	r22, Y+3	; 0x03
 426:	7c 81       	ldd	r23, Y+4	; 0x04
 428:	70 93 b4 00 	sts	0x00B4, r23
 42c:	60 93 b3 00 	sts	0x00B3, r22
 430:	89 81       	ldd	r24, Y+1	; 0x01
 432:	9a 81       	ldd	r25, Y+2	; 0x02
 434:	90 93 b7 00 	sts	0x00B7, r25
 438:	80 93 b6 00 	sts	0x00B6, r24
 43c:	20 93 bd 00 	sts	0x00BD, r18
 440:	30 93 be 00 	sts	0x00BE, r19
 444:	40 93 bf 00 	sts	0x00BF, r20
 448:	50 93 c0 00 	sts	0x00C0, r21
 44c:	70 92 c2 00 	sts	0x00C2, r7
 450:	60 92 c1 00 	sts	0x00C1, r6
 454:	e0 92 b9 00 	sts	0x00B9, r14
 458:	f0 92 ba 00 	sts	0x00BA, r15
 45c:	00 93 bb 00 	sts	0x00BB, r16
 460:	10 93 bc 00 	sts	0x00BC, r17
 464:	c0 92 c4 00 	sts	0x00C4, r12
 468:	82 e0       	ldi	r24, 0x02	; 2
 46a:	80 93 b8 00 	sts	0x00B8, r24
 46e:	80 91 b8 00 	lds	r24, 0x00B8
 472:	28 96       	adiw	r28, 0x08	; 8
 474:	ef e0       	ldi	r30, 0x0F	; 15
 476:	bc c3       	rjmp	.+1912   	; 0xbf0 <__epilogue_restores__+0x6>
 478:	c9 c0       	rjmp	.+402    	; 0x60c <run_init()>
 47a:	c5 98       	cbi	0x18, 5	; 24
 47c:	5a e2       	ldi	r21, 0x2A	; 42
 47e:	d5 16       	cp	r13, r21
 480:	09 f0       	breq	.+2      	; 0x484 <__stack+0x25>
 482:	6c cf       	rjmp	.-296    	; 0x35c <start()+0xaa>
 484:	a8 01       	movw	r20, r16
 486:	97 01       	movw	r18, r14
 488:	76 cf       	rjmp	.-276    	; 0x376 <start()+0xc4>
 48a:	40 e1       	ldi	r20, 0x10	; 16
 48c:	34 2a       	or	r3, r20
 48e:	5e cf       	rjmp	.-324    	; 0x34c <start()+0x9a>
 490:	e8 1a       	sub	r14, r24
 492:	f9 0a       	sbc	r15, r25
 494:	0a 0b       	sbc	r16, r26
 496:	1b 0b       	sbc	r17, r27
 498:	92 2f       	mov	r25, r18
 49a:	20 fd       	sbrc	r18, 0
 49c:	0d c0       	rjmp	.+26     	; 0x4b8 <__stack+0x59>
 49e:	34 fe       	sbrs	r3, 4
 4a0:	0d c0       	rjmp	.+26     	; 0x4bc <__stack+0x5d>
 4a2:	c3 94       	inc	r12
 4a4:	52 e1       	ldi	r21, 0x12	; 18
 4a6:	5c 15       	cp	r21, r12
 4a8:	68 f4       	brcc	.+26     	; 0x4c4 <__stack+0x65>
 4aa:	82 e1       	ldi	r24, 0x12	; 18
 4ac:	c8 2e       	mov	r12, r24
 4ae:	bd e2       	ldi	r27, 0x2D	; 45
 4b0:	db 2e       	mov	r13, r27
 4b2:	78 86       	std	Y+8, r7	; 0x08
 4b4:	6f 82       	std	Y+7, r6	; 0x07
 4b6:	41 cf       	rjmp	.-382    	; 0x33a <start()+0x88>
 4b8:	34 fe       	sbrs	r3, 4
 4ba:	f3 cf       	rjmp	.-26     	; 0x4a2 <__stack+0x43>
 4bc:	ca 94       	dec	r12
 4be:	52 e1       	ldi	r21, 0x12	; 18
 4c0:	5c 15       	cp	r21, r12
 4c2:	98 f3       	brcs	.-26     	; 0x4aa <__stack+0x4b>
 4c4:	cc 20       	and	r12, r12
 4c6:	99 f7       	brne	.-26     	; 0x4ae <__stack+0x4f>
 4c8:	dd 24       	eor	r13, r13
 4ca:	7d cf       	rjmp	.-262    	; 0x3c6 <start()+0x114>
 4cc:	23 2d       	mov	r18, r3
 4ce:	27 70       	andi	r18, 0x07	; 7
 4d0:	67 cf       	rjmp	.-306    	; 0x3a0 <start()+0xee>
 4d2:	79 01       	movw	r14, r18
 4d4:	8a 01       	movw	r16, r20
 4d6:	e8 1a       	sub	r14, r24
 4d8:	f9 0a       	sbc	r15, r25
 4da:	0a 0b       	sbc	r16, r26
 4dc:	1b 0b       	sbc	r17, r27
 4de:	23 2d       	mov	r18, r3
 4e0:	27 70       	andi	r18, 0x07	; 7
 4e2:	20 fd       	sbrc	r18, 0
 4e4:	61 c0       	rjmp	.+194    	; 0x5a8 <__stack+0x149>
 4e6:	34 fc       	sbrc	r3, 4
 4e8:	57 cf       	rjmp	.-338    	; 0x398 <start()+0xe6>
 4ea:	ea e2       	ldi	r30, 0x2A	; 42
 4ec:	de 2e       	mov	r13, r30
 4ee:	e1 cf       	rjmp	.-62     	; 0x4b2 <__stack+0x53>
 4f0:	20 92 c3 00 	sts	0x00C3, r2
 4f4:	ed 81       	ldd	r30, Y+5	; 0x05
 4f6:	fe 81       	ldd	r31, Y+6	; 0x06
 4f8:	f0 93 c6 00 	sts	0x00C6, r31
 4fc:	e0 93 c5 00 	sts	0x00C5, r30
 500:	4b 81       	ldd	r20, Y+3	; 0x03
 502:	5c 81       	ldd	r21, Y+4	; 0x04
 504:	50 93 b4 00 	sts	0x00B4, r21
 508:	40 93 b3 00 	sts	0x00B3, r20
 50c:	69 81       	ldd	r22, Y+1	; 0x01
 50e:	7a 81       	ldd	r23, Y+2	; 0x02
 510:	70 93 b7 00 	sts	0x00B7, r23
 514:	60 93 b6 00 	sts	0x00B6, r22
 518:	80 92 bd 00 	sts	0x00BD, r8
 51c:	90 92 be 00 	sts	0x00BE, r9
 520:	a0 92 bf 00 	sts	0x00BF, r10
 524:	b0 92 c0 00 	sts	0x00C0, r11
 528:	8f 81       	ldd	r24, Y+7	; 0x07
 52a:	98 85       	ldd	r25, Y+8	; 0x08
 52c:	90 93 c2 00 	sts	0x00C2, r25
 530:	80 93 c1 00 	sts	0x00C1, r24
 534:	e0 92 b9 00 	sts	0x00B9, r14
 538:	f0 92 ba 00 	sts	0x00BA, r15
 53c:	00 93 bb 00 	sts	0x00BB, r16
 540:	10 93 bc 00 	sts	0x00BC, r17
 544:	c0 92 c4 00 	sts	0x00C4, r12
 548:	80 91 b8 00 	lds	r24, 0x00B8
 54c:	28 96       	adiw	r28, 0x08	; 8
 54e:	ef e0       	ldi	r30, 0x0F	; 15
 550:	4f c3       	rjmp	.+1694   	; 0xbf0 <__epilogue_restores__+0x6>
 552:	5c c0       	rjmp	.+184    	; 0x60c <run_init()>
 554:	83 2d       	mov	r24, r3
 556:	87 70       	andi	r24, 0x07	; 7
 558:	80 ff       	sbrs	r24, 0
 55a:	58 cf       	rjmp	.-336    	; 0x40c <start()+0x15a>
 55c:	c3 01       	movw	r24, r6
 55e:	e9 81       	ldd	r30, Y+1	; 0x01
 560:	fa 81       	ldd	r31, Y+2	; 0x02
 562:	8e 1b       	sub	r24, r30
 564:	9f 0b       	sbc	r25, r31
 566:	9e 83       	std	Y+6, r25	; 0x06
 568:	8d 83       	std	Y+5, r24	; 0x05
 56a:	6b 81       	ldd	r22, Y+3	; 0x03
 56c:	7c 81       	ldd	r23, Y+4	; 0x04
 56e:	68 0f       	add	r22, r24
 570:	79 1f       	adc	r23, r25
 572:	76 95       	lsr	r23
 574:	67 95       	ror	r22
 576:	7c 83       	std	Y+4, r23	; 0x04
 578:	6b 83       	std	Y+3, r22	; 0x03
 57a:	23 94       	inc	r2
 57c:	77 e7       	ldi	r23, 0x77	; 119
 57e:	72 15       	cp	r23, r2
 580:	b0 f4       	brcc	.+44     	; 0x5ae <__stack+0x14f>
 582:	8b 81       	ldd	r24, Y+3	; 0x03
 584:	9c 81       	ldd	r25, Y+4	; 0x04
 586:	8d 55       	subi	r24, 0x5D	; 93
 588:	91 41       	sbci	r25, 0x11	; 17
 58a:	a0 f0       	brcs	.+40     	; 0x5b4 <__stack+0x155>
 58c:	7a 82       	std	Y+2, r7	; 0x02
 58e:	69 82       	std	Y+1, r6	; 0x01
 590:	f8 e7       	ldi	r31, 0x78	; 120
 592:	2f 2e       	mov	r2, r31
 594:	3b cf       	rjmp	.-394    	; 0x40c <start()+0x15a>
 596:	83 2d       	mov	r24, r3
 598:	87 70       	andi	r24, 0x07	; 7
 59a:	09 f0       	breq	.+2      	; 0x59e <__stack+0x13f>
 59c:	e8 ce       	rjmp	.-560    	; 0x36e <start()+0xbc>
 59e:	88 b3       	in	r24, 0x18	; 24
 5a0:	90 e1       	ldi	r25, 0x10	; 16
 5a2:	89 27       	eor	r24, r25
 5a4:	88 bb       	out	0x18, r24	; 24
 5a6:	e3 ce       	rjmp	.-570    	; 0x36e <start()+0xbc>
 5a8:	34 fc       	sbrc	r3, 4
 5aa:	9f cf       	rjmp	.-194    	; 0x4ea <__stack+0x8b>
 5ac:	f5 ce       	rjmp	.-534    	; 0x398 <start()+0xe6>
 5ae:	7a 82       	std	Y+2, r7	; 0x02
 5b0:	69 82       	std	Y+1, r6	; 0x01
 5b2:	2c cf       	rjmp	.-424    	; 0x40c <start()+0x15a>
 5b4:	88 e7       	ldi	r24, 0x78	; 120
 5b6:	80 93 c3 00 	sts	0x00C3, r24
 5ba:	6d 81       	ldd	r22, Y+5	; 0x05
 5bc:	7e 81       	ldd	r23, Y+6	; 0x06
 5be:	70 93 c6 00 	sts	0x00C6, r23
 5c2:	60 93 c5 00 	sts	0x00C5, r22
 5c6:	8b 81       	ldd	r24, Y+3	; 0x03
 5c8:	9c 81       	ldd	r25, Y+4	; 0x04
 5ca:	90 93 b4 00 	sts	0x00B4, r25
 5ce:	80 93 b3 00 	sts	0x00B3, r24
 5d2:	70 92 b7 00 	sts	0x00B7, r7
 5d6:	60 92 b6 00 	sts	0x00B6, r6
 5da:	20 93 bd 00 	sts	0x00BD, r18
 5de:	30 93 be 00 	sts	0x00BE, r19
 5e2:	40 93 bf 00 	sts	0x00BF, r20
 5e6:	50 93 c0 00 	sts	0x00C0, r21
 5ea:	70 92 c2 00 	sts	0x00C2, r7
 5ee:	60 92 c1 00 	sts	0x00C1, r6
 5f2:	e0 92 b9 00 	sts	0x00B9, r14
 5f6:	f0 92 ba 00 	sts	0x00BA, r15
 5fa:	00 93 bb 00 	sts	0x00BB, r16
 5fe:	10 93 bc 00 	sts	0x00BC, r17
 602:	c0 92 c4 00 	sts	0x00C4, r12
 606:	10 92 b8 00 	sts	0x00B8, r1
 60a:	31 cf       	rjmp	.-414    	; 0x46e <__stack+0xf>

0000060c <run_init()>:
 60c:	8f ef       	ldi	r24, 0xFF	; 255
 60e:	80 93 a6 00 	sts	0x00A6, r24
 612:	81 e0       	ldi	r24, 0x01	; 1
 614:	80 93 b5 00 	sts	0x00B5, r24
 618:	40 91 b6 00 	lds	r20, 0x00B6
 61c:	50 91 b7 00 	lds	r21, 0x00B7
 620:	50 93 ac 00 	sts	0x00AC, r21
 624:	40 93 ab 00 	sts	0x00AB, r20
 628:	80 91 b3 00 	lds	r24, 0x00B3
 62c:	90 91 b4 00 	lds	r25, 0x00B4
 630:	9c 01       	movw	r18, r24
 632:	36 95       	lsr	r19
 634:	27 95       	ror	r18
 636:	30 93 a8 00 	sts	0x00A8, r19
 63a:	20 93 a7 00 	sts	0x00A7, r18
 63e:	84 0f       	add	r24, r20
 640:	95 1f       	adc	r25, r21
 642:	82 0f       	add	r24, r18
 644:	93 1f       	adc	r25, r19
 646:	2f b7       	in	r18, 0x3f	; 63
 648:	f8 94       	cli
 64a:	9b bd       	out	0x2b, r25	; 43
 64c:	8a bd       	out	0x2a, r24	; 42
 64e:	2f bf       	out	0x3f, r18	; 63
 650:	90 e1       	ldi	r25, 0x10	; 16
 652:	98 bf       	out	0x38, r25	; 56
 654:	88 b3       	in	r24, 0x18	; 24
 656:	89 27       	eor	r24, r25
 658:	88 bb       	out	0x18, r24	; 24
 65a:	08 95       	ret

0000065c <run_power_control()>:
 65c:	57 dd       	rcall	.-1362   	; 0x10c <filter_ppm_data()>
 65e:	80 91 a0 00 	lds	r24, 0x00A0
 662:	90 91 a1 00 	lds	r25, 0x00A1
 666:	80 5d       	subi	r24, 0xD0	; 208
 668:	97 40       	sbci	r25, 0x07	; 7
 66a:	84 36       	cpi	r24, 0x64	; 100
 66c:	91 05       	cpc	r25, r1
 66e:	24 f4       	brge	.+8      	; 0x678 <run_power_control()+0x1c>
 670:	80 e0       	ldi	r24, 0x00	; 0
 672:	90 e0       	ldi	r25, 0x00	; 0
 674:	2c 01       	movw	r4, r24
 676:	08 95       	ret
 678:	27 e0       	ldi	r18, 0x07	; 7
 67a:	81 3d       	cpi	r24, 0xD1	; 209
 67c:	92 07       	cpc	r25, r18
 67e:	d4 f3       	brlt	.-12     	; 0x674 <run_power_control()+0x18>
 680:	80 ed       	ldi	r24, 0xD0	; 208
 682:	97 e0       	ldi	r25, 0x07	; 7
 684:	2c 01       	movw	r4, r24
 686:	08 95       	ret

00000688 <run()>:
 688:	ab e0       	ldi	r26, 0x0B	; 11
 68a:	b0 e0       	ldi	r27, 0x00	; 0
 68c:	e9 e4       	ldi	r30, 0x49	; 73
 68e:	f3 e0       	ldi	r31, 0x03	; 3
 690:	93 c2       	rjmp	.+1318   	; 0xbb8 <__prologue_saves__+0x6>
 692:	bc df       	rcall	.-136    	; 0x60c <run_init()>
 694:	20 91 af 00 	lds	r18, 0x00AF
 698:	30 91 b0 00 	lds	r19, 0x00B0
 69c:	3c 83       	std	Y+4, r19	; 0x04
 69e:	2b 83       	std	Y+3, r18	; 0x03
 6a0:	80 91 a9 00 	lds	r24, 0x00A9
 6a4:	90 91 aa 00 	lds	r25, 0x00AA
 6a8:	9e 83       	std	Y+6, r25	; 0x06
 6aa:	8d 83       	std	Y+5, r24	; 0x05
 6ac:	e0 91 c5 00 	lds	r30, 0x00C5
 6b0:	f0 91 c6 00 	lds	r31, 0x00C6
 6b4:	f8 87       	std	Y+8, r31	; 0x08
 6b6:	ef 83       	std	Y+7, r30	; 0x07
 6b8:	20 91 b6 00 	lds	r18, 0x00B6
 6bc:	30 91 b7 00 	lds	r19, 0x00B7
 6c0:	3a 83       	std	Y+2, r19	; 0x02
 6c2:	29 83       	std	Y+1, r18	; 0x01
 6c4:	e0 90 b1 00 	lds	r14, 0x00B1
 6c8:	f0 90 b2 00 	lds	r15, 0x00B2
 6cc:	c0 90 b3 00 	lds	r12, 0x00B3
 6d0:	d0 90 b4 00 	lds	r13, 0x00B4
 6d4:	a0 90 ab 00 	lds	r10, 0x00AB
 6d8:	b0 90 ac 00 	lds	r11, 0x00AC
 6dc:	60 90 a7 00 	lds	r6, 0x00A7
 6e0:	70 90 a8 00 	lds	r7, 0x00A8
 6e4:	80 90 ad 00 	lds	r8, 0x00AD
 6e8:	90 90 ae 00 	lds	r9, 0x00AE
 6ec:	00 91 b5 00 	lds	r16, 0x00B5
 6f0:	10 e0       	ldi	r17, 0x00	; 0
 6f2:	b0 e2       	ldi	r27, 0x20	; 32
 6f4:	2b 2e       	mov	r2, r27
 6f6:	8f b7       	in	r24, 0x3f	; 63
 6f8:	f8 94       	cli
 6fa:	ec b5       	in	r30, 0x2c	; 44
 6fc:	fd b5       	in	r31, 0x2d	; 45
 6fe:	fb 87       	std	Y+11, r31	; 0x0b
 700:	ea 87       	std	Y+10, r30	; 0x0a
 702:	8f bf       	out	0x3f, r24	; 63
 704:	45 9b       	sbis	0x08, 5	; 8
 706:	12 c0       	rjmp	.+36     	; 0x72c <run()+0xa4>
 708:	ff ee       	ldi	r31, 0xEF	; 239
 70a:	3f 22       	and	r3, r31
 70c:	39 85       	ldd	r19, Y+9	; 0x09
 70e:	30 fd       	sbrc	r19, 0
 710:	12 c0       	rjmp	.+36     	; 0x736 <run()+0xae>
 712:	14 34       	cpi	r17, 0x44	; 68
 714:	99 f0       	breq	.+38     	; 0x73c <run()+0xb4>
 716:	15 34       	cpi	r17, 0x45	; 69
 718:	d0 f5       	brcc	.+116    	; 0x78e <run()+0x106>
 71a:	18 32       	cpi	r17, 0x28	; 40
 71c:	09 f4       	brne	.+2      	; 0x720 <run()+0x98>
 71e:	71 c0       	rjmp	.+226    	; 0x802 <run()+0x17a>
 720:	19 32       	cpi	r17, 0x29	; 41
 722:	08 f4       	brcc	.+2      	; 0x726 <run()+0x9e>
 724:	69 c0       	rjmp	.+210    	; 0x7f8 <run()+0x170>
 726:	1a 32       	cpi	r17, 0x2A	; 42
 728:	a9 f5       	brne	.+106    	; 0x794 <run()+0x10c>
 72a:	77 c0       	rjmp	.+238    	; 0x81a <run()+0x192>
 72c:	20 e1       	ldi	r18, 0x10	; 16
 72e:	32 2a       	or	r3, r18
 730:	39 85       	ldd	r19, Y+9	; 0x09
 732:	30 ff       	sbrs	r19, 0
 734:	ee cf       	rjmp	.-36     	; 0x712 <run()+0x8a>
 736:	70 dd       	rcall	.-1312   	; 0x218 <sdm()>
 738:	14 34       	cpi	r17, 0x44	; 68
 73a:	69 f7       	brne	.-38     	; 0x716 <run()+0x8e>
 73c:	8a 85       	ldd	r24, Y+10	; 0x0a
 73e:	9b 85       	ldd	r25, Y+11	; 0x0b
 740:	8e 19       	sub	r24, r14
 742:	9f 09       	sbc	r25, r15
 744:	88 15       	cp	r24, r8
 746:	99 05       	cpc	r25, r9
 748:	08 f4       	brcc	.+2      	; 0x74c <run()+0xc4>
 74a:	77 c0       	rjmp	.+238    	; 0x83a <run()+0x1b2>
 74c:	ea 84       	ldd	r14, Y+10	; 0x0a
 74e:	fb 84       	ldd	r15, Y+11	; 0x0b
 750:	8b 80       	ldd	r8, Y+3	; 0x03
 752:	9c 80       	ldd	r9, Y+4	; 0x04
 754:	93 2d       	mov	r25, r3
 756:	97 70       	andi	r25, 0x07	; 7
 758:	89 2f       	mov	r24, r25
 75a:	8f 5f       	subi	r24, 0xFF	; 255
 75c:	86 30       	cpi	r24, 0x06	; 6
 75e:	08 f0       	brcs	.+2      	; 0x762 <run()+0xda>
 760:	86 50       	subi	r24, 0x06	; 6
 762:	87 70       	andi	r24, 0x07	; 7
 764:	93 2d       	mov	r25, r3
 766:	98 7f       	andi	r25, 0xF8	; 248
 768:	39 2e       	mov	r3, r25
 76a:	38 2a       	or	r3, r24
 76c:	03 dd       	rcall	.-1530   	; 0x174 <change_comm_state(unsigned char)>
 76e:	93 2d       	mov	r25, r3
 770:	97 70       	andi	r25, 0x07	; 7
 772:	21 f4       	brne	.+8      	; 0x77c <run()+0xf4>
 774:	88 b3       	in	r24, 0x18	; 24
 776:	30 e1       	ldi	r19, 0x10	; 16
 778:	83 27       	eor	r24, r19
 77a:	88 bb       	out	0x18, r24	; 24
 77c:	88 b3       	in	r24, 0x18	; 24
 77e:	82 25       	eor	r24, r2
 780:	88 bb       	out	0x18, r24	; 24
 782:	90 ff       	sbrs	r25, 0
 784:	70 c0       	rjmp	.+224    	; 0x866 <run()+0x1de>
 786:	bb 86       	std	Y+11, r11	; 0x0b
 788:	aa 86       	std	Y+10, r10	; 0x0a
 78a:	17 e2       	ldi	r17, 0x27	; 39
 78c:	5d c0       	rjmp	.+186    	; 0x848 <run()+0x1c0>
 78e:	1c 34       	cpi	r17, 0x4C	; 76
 790:	09 f4       	brne	.+2      	; 0x794 <run()+0x10c>
 792:	d4 c0       	rjmp	.+424    	; 0x93c <run()+0x2b4>
 794:	8f 81       	ldd	r24, Y+7	; 0x07
 796:	98 85       	ldd	r25, Y+8	; 0x08
 798:	90 93 c6 00 	sts	0x00C6, r25
 79c:	80 93 c5 00 	sts	0x00C5, r24
 7a0:	e9 81       	ldd	r30, Y+1	; 0x01
 7a2:	fa 81       	ldd	r31, Y+2	; 0x02
 7a4:	f0 93 b7 00 	sts	0x00B7, r31
 7a8:	e0 93 b6 00 	sts	0x00B6, r30
 7ac:	f0 92 b2 00 	sts	0x00B2, r15
 7b0:	e0 92 b1 00 	sts	0x00B1, r14
 7b4:	d0 92 b4 00 	sts	0x00B4, r13
 7b8:	c0 92 b3 00 	sts	0x00B3, r12
 7bc:	b0 92 ac 00 	sts	0x00AC, r11
 7c0:	a0 92 ab 00 	sts	0x00AB, r10
 7c4:	70 92 a8 00 	sts	0x00A8, r7
 7c8:	60 92 a7 00 	sts	0x00A7, r6
 7cc:	90 92 ae 00 	sts	0x00AE, r9
 7d0:	80 92 ad 00 	sts	0x00AD, r8
 7d4:	00 93 b5 00 	sts	0x00B5, r16
 7d8:	18 ba       	out	0x18, r1	; 24
 7da:	15 ba       	out	0x15, r1	; 21
 7dc:	12 ba       	out	0x12, r1	; 18
 7de:	10 92 c8 00 	sts	0x00C8, r1
 7e2:	10 92 c7 00 	sts	0x00C7, r1
 7e6:	44 24       	eor	r4, r4
 7e8:	55 24       	eor	r5, r5
 7ea:	f7 ef       	ldi	r31, 0xF7	; 247
 7ec:	3f 22       	and	r3, r31
 7ee:	80 91 a6 00 	lds	r24, 0x00A6
 7f2:	2b 96       	adiw	r28, 0x0b	; 11
 7f4:	ef e0       	ldi	r30, 0x0F	; 15
 7f6:	fc c1       	rjmp	.+1016   	; 0xbf0 <__epilogue_restores__+0x6>
 7f8:	11 23       	and	r17, r17
 7fa:	89 f1       	breq	.+98     	; 0x85e <run()+0x1d6>
 7fc:	17 32       	cpi	r17, 0x27	; 39
 7fe:	51 f6       	brne	.-108    	; 0x794 <run()+0x10c>
 800:	18 e2       	ldi	r17, 0x28	; 40
 802:	83 2d       	mov	r24, r3
 804:	87 70       	andi	r24, 0x07	; 7
 806:	80 fd       	sbrc	r24, 0
 808:	25 c0       	rjmp	.+74     	; 0x854 <run()+0x1cc>
 80a:	34 fe       	sbrs	r3, 4
 80c:	25 c0       	rjmp	.+74     	; 0x858 <run()+0x1d0>
 80e:	88 b3       	in	r24, 0x18	; 24
 810:	82 25       	eor	r24, r2
 812:	88 bb       	out	0x18, r24	; 24
 814:	88 b3       	in	r24, 0x18	; 24
 816:	82 25       	eor	r24, r2
 818:	88 bb       	out	0x18, r24	; 24
 81a:	08 b6       	in	r0, 0x38	; 56
 81c:	04 fc       	sbrc	r0, 4
 81e:	4f c0       	rjmp	.+158    	; 0x8be <run()+0x236>
 820:	34 fe       	sbrs	r3, 4
 822:	01 60       	ori	r16, 0x01	; 1
 824:	e0 2f       	mov	r30, r16
 826:	f0 e0       	ldi	r31, 0x00	; 0
 828:	e0 5a       	subi	r30, 0xA0	; 160
 82a:	ff 4f       	sbci	r31, 0xFF	; 255
 82c:	00 81       	ld	r16, Z
 82e:	00 fd       	sbrc	r16, 0
 830:	46 c0       	rjmp	.+140    	; 0x8be <run()+0x236>
 832:	bb 86       	std	Y+11, r11	; 0x0b
 834:	aa 86       	std	Y+10, r10	; 0x0a
 836:	1a e2       	ldi	r17, 0x2A	; 42
 838:	07 c0       	rjmp	.+14     	; 0x848 <run()+0x1c0>
 83a:	88 1a       	sub	r8, r24
 83c:	99 0a       	sbc	r9, r25
 83e:	ea 84       	ldd	r14, Y+10	; 0x0a
 840:	fb 84       	ldd	r15, Y+11	; 0x0b
 842:	bb 86       	std	Y+11, r11	; 0x0b
 844:	aa 86       	std	Y+10, r10	; 0x0a
 846:	14 e4       	ldi	r17, 0x44	; 68
 848:	29 85       	ldd	r18, Y+9	; 0x09
 84a:	2f 5f       	subi	r18, 0xFF	; 255
 84c:	29 87       	std	Y+9, r18	; 0x09
 84e:	aa 84       	ldd	r10, Y+10	; 0x0a
 850:	bb 84       	ldd	r11, Y+11	; 0x0b
 852:	51 cf       	rjmp	.-350    	; 0x6f6 <run()+0x6e>
 854:	34 fe       	sbrs	r3, 4
 856:	db cf       	rjmp	.-74     	; 0x80e <run()+0x186>
 858:	bb 86       	std	Y+11, r11	; 0x0b
 85a:	aa 86       	std	Y+10, r10	; 0x0a
 85c:	f5 cf       	rjmp	.-22     	; 0x848 <run()+0x1c0>
 85e:	93 2d       	mov	r25, r3
 860:	97 70       	andi	r25, 0x07	; 7
 862:	90 fd       	sbrc	r25, 0
 864:	90 cf       	rjmp	.-224    	; 0x786 <run()+0xfe>
 866:	fa de       	rcall	.-524    	; 0x65c <run_power_control()>
 868:	85 ed       	ldi	r24, 0xD5	; 213
 86a:	c8 16       	cp	r12, r24
 86c:	80 e3       	ldi	r24, 0x30	; 48
 86e:	d8 06       	cpc	r13, r24
 870:	08 f4       	brcc	.+2      	; 0x874 <run()+0x1ec>
 872:	64 c0       	rjmp	.+200    	; 0x93c <run()+0x2b4>
 874:	ef 81       	ldd	r30, Y+7	; 0x07
 876:	f8 85       	ldd	r31, Y+8	; 0x08
 878:	f0 93 c6 00 	sts	0x00C6, r31
 87c:	e0 93 c5 00 	sts	0x00C5, r30
 880:	29 81       	ldd	r18, Y+1	; 0x01
 882:	3a 81       	ldd	r19, Y+2	; 0x02
 884:	30 93 b7 00 	sts	0x00B7, r19
 888:	20 93 b6 00 	sts	0x00B6, r18
 88c:	f0 92 b2 00 	sts	0x00B2, r15
 890:	e0 92 b1 00 	sts	0x00B1, r14
 894:	d0 92 b4 00 	sts	0x00B4, r13
 898:	c0 92 b3 00 	sts	0x00B3, r12
 89c:	b0 92 ac 00 	sts	0x00AC, r11
 8a0:	a0 92 ab 00 	sts	0x00AB, r10
 8a4:	70 92 a8 00 	sts	0x00A8, r7
 8a8:	60 92 a7 00 	sts	0x00A7, r6
 8ac:	90 92 ae 00 	sts	0x00AE, r9
 8b0:	80 92 ad 00 	sts	0x00AD, r8
 8b4:	00 93 b5 00 	sts	0x00B5, r16
 8b8:	10 92 a6 00 	sts	0x00A6, r1
 8bc:	8d cf       	rjmp	.-230    	; 0x7d8 <run()+0x150>
 8be:	88 b7       	in	r24, 0x38	; 56
 8c0:	88 b3       	in	r24, 0x18	; 24
 8c2:	82 25       	eor	r24, r2
 8c4:	88 bb       	out	0x18, r24	; 24
 8c6:	88 b3       	in	r24, 0x18	; 24
 8c8:	82 25       	eor	r24, r2
 8ca:	88 bb       	out	0x18, r24	; 24
 8cc:	a8 ec       	ldi	r26, 0xC8	; 200
 8ce:	ea 2e       	mov	r14, r26
 8d0:	af ef       	ldi	r26, 0xFF	; 255
 8d2:	fa 2e       	mov	r15, r26
 8d4:	8a 85       	ldd	r24, Y+10	; 0x0a
 8d6:	9b 85       	ldd	r25, Y+11	; 0x0b
 8d8:	e8 0e       	add	r14, r24
 8da:	f9 1e       	adc	r15, r25
 8dc:	f7 01       	movw	r30, r14
 8de:	29 81       	ldd	r18, Y+1	; 0x01
 8e0:	3a 81       	ldd	r19, Y+2	; 0x02
 8e2:	e2 1b       	sub	r30, r18
 8e4:	f3 0b       	sbc	r31, r19
 8e6:	f8 87       	std	Y+8, r31	; 0x08
 8e8:	ef 83       	std	Y+7, r30	; 0x07
 8ea:	ce 0e       	add	r12, r30
 8ec:	df 1e       	adc	r13, r31
 8ee:	d6 94       	lsr	r13
 8f0:	c7 94       	ror	r12
 8f2:	46 01       	movw	r8, r12
 8f4:	96 94       	lsr	r9
 8f6:	87 94       	ror	r8
 8f8:	96 94       	lsr	r9
 8fa:	87 94       	ror	r8
 8fc:	96 94       	lsr	r9
 8fe:	87 94       	ror	r8
 900:	96 01       	movw	r18, r12
 902:	36 95       	lsr	r19
 904:	27 95       	ror	r18
 906:	39 01       	movw	r6, r18
 908:	68 0c       	add	r6, r8
 90a:	79 1c       	adc	r7, r9
 90c:	c6 01       	movw	r24, r12
 90e:	8e 0d       	add	r24, r14
 910:	9f 1d       	adc	r25, r15
 912:	82 0f       	add	r24, r18
 914:	93 1f       	adc	r25, r19
 916:	2f b7       	in	r18, 0x3f	; 63
 918:	f8 94       	cli
 91a:	9b bd       	out	0x2b, r25	; 43
 91c:	8a bd       	out	0x2a, r24	; 42
 91e:	2f bf       	out	0x3f, r18	; 63
 920:	30 e1       	ldi	r19, 0x10	; 16
 922:	38 bf       	out	0x38, r19	; 56
 924:	fa 82       	std	Y+2, r15	; 0x02
 926:	e9 82       	std	Y+1, r14	; 0x01
 928:	57 01       	movw	r10, r14
 92a:	8a 85       	ldd	r24, Y+10	; 0x0a
 92c:	9b 85       	ldd	r25, Y+11	; 0x0b
 92e:	8e 19       	sub	r24, r14
 930:	9f 09       	sbc	r25, r15
 932:	88 15       	cp	r24, r8
 934:	99 05       	cpc	r25, r9
 936:	08 f0       	brcs	.+2      	; 0x93a <run()+0x2b2>
 938:	09 cf       	rjmp	.-494    	; 0x74c <run()+0xc4>
 93a:	7f cf       	rjmp	.-258    	; 0x83a <run()+0x1b2>
 93c:	8a 85       	ldd	r24, Y+10	; 0x0a
 93e:	9b 85       	ldd	r25, Y+11	; 0x0b
 940:	8a 19       	sub	r24, r10
 942:	9b 09       	sbc	r25, r11
 944:	86 15       	cp	r24, r6
 946:	97 05       	cpc	r25, r7
 948:	28 f0       	brcs	.+10     	; 0x954 <run()+0x2cc>
 94a:	aa 84       	ldd	r10, Y+10	; 0x0a
 94c:	bb 84       	ldd	r11, Y+11	; 0x0b
 94e:	6d 80       	ldd	r6, Y+5	; 0x05
 950:	7e 80       	ldd	r7, Y+6	; 0x06
 952:	00 cf       	rjmp	.-512    	; 0x754 <run()+0xcc>
 954:	68 1a       	sub	r6, r24
 956:	79 0a       	sbc	r7, r25
 958:	1c e4       	ldi	r17, 0x4C	; 76
 95a:	76 cf       	rjmp	.-276    	; 0x848 <run()+0x1c0>

0000095c <setup>:
 95c:	f8 94       	cli
 95e:	8f ef       	ldi	r24, 0xFF	; 255
 960:	81 bf       	out	0x31, r24	; 49
 962:	19 be       	out	0x39, r1	; 57
 964:	1f bc       	out	0x2f, r1	; 47
 966:	82 e0       	ldi	r24, 0x02	; 2
 968:	8e bd       	out	0x2e, r24	; 46
 96a:	18 ba       	out	0x18, r1	; 24
 96c:	87 e3       	ldi	r24, 0x37	; 55
 96e:	87 bb       	out	0x17, r24	; 23
 970:	15 ba       	out	0x15, r1	; 21
 972:	14 ba       	out	0x14, r1	; 20
 974:	12 ba       	out	0x12, r1	; 18
 976:	88 e3       	ldi	r24, 0x38	; 56
 978:	81 bb       	out	0x11, r24	; 17
 97a:	42 9a       	sbi	0x08, 2	; 8
 97c:	18 ba       	out	0x18, r1	; 24
 97e:	15 ba       	out	0x15, r1	; 21
 980:	12 ba       	out	0x12, r1	; 18
 982:	c2 9a       	sbi	0x18, 2	; 24
 984:	c1 9a       	sbi	0x18, 1	; 24
 986:	c0 9a       	sbi	0x18, 0	; 24
 988:	65 e0       	ldi	r22, 0x05	; 5
 98a:	70 e0       	ldi	r23, 0x00	; 0
 98c:	80 e0       	ldi	r24, 0x00	; 0
 98e:	90 e0       	ldi	r25, 0x00	; 0
 990:	7b db       	rcall	.-2314   	; 0x88 <__delay_ms(unsigned long)>
 992:	c2 98       	cbi	0x18, 2	; 24
 994:	c1 98       	cbi	0x18, 1	; 24
 996:	c0 98       	cbi	0x18, 0	; 24
 998:	92 9a       	sbi	0x12, 2	; 18
 99a:	85 b7       	in	r24, 0x35	; 53
 99c:	8c 7f       	andi	r24, 0xFC	; 252
 99e:	81 60       	ori	r24, 0x01	; 1
 9a0:	85 bf       	out	0x35, r24	; 53
 9a2:	8b b7       	in	r24, 0x3b	; 59
 9a4:	80 64       	ori	r24, 0x40	; 64
 9a6:	8b bf       	out	0x3b, r24	; 59
 9a8:	88 eb       	ldi	r24, 0xB8	; 184
 9aa:	9b e0       	ldi	r25, 0x0B	; 11
 9ac:	90 93 a3 00 	sts	0x00A3, r25
 9b0:	80 93 a2 00 	sts	0x00A2, r24
 9b4:	78 94       	sei
 9b6:	6a ef       	ldi	r22, 0xFA	; 250
 9b8:	70 e0       	ldi	r23, 0x00	; 0
 9ba:	80 e0       	ldi	r24, 0x00	; 0
 9bc:	90 e0       	ldi	r25, 0x00	; 0
 9be:	64 cb       	rjmp	.-2360   	; 0x88 <__delay_ms(unsigned long)>

000009c0 <beep(unsigned char, unsigned char)>:
 9c0:	ef 92       	push	r14
 9c2:	ff 92       	push	r15
 9c4:	0f 93       	push	r16
 9c6:	1f 93       	push	r17
 9c8:	cf 93       	push	r28
 9ca:	df 93       	push	r29
 9cc:	26 2f       	mov	r18, r22
 9ce:	e8 2f       	mov	r30, r24
 9d0:	f0 e0       	ldi	r31, 0x00	; 0
 9d2:	80 e1       	ldi	r24, 0x10	; 16
 9d4:	97 e2       	ldi	r25, 0x27	; 39
 9d6:	bf 01       	movw	r22, r30
 9d8:	d9 d0       	rcall	.+434    	; 0xb8c <__divmodhi4>
 9da:	7b 01       	movw	r14, r22
 9dc:	30 e0       	ldi	r19, 0x00	; 0
 9de:	2e 9f       	mul	r18, r30
 9e0:	80 01       	movw	r16, r0
 9e2:	2f 9f       	mul	r18, r31
 9e4:	10 0d       	add	r17, r0
 9e6:	3e 9f       	mul	r19, r30
 9e8:	10 0d       	add	r17, r0
 9ea:	11 24       	eor	r1, r1
 9ec:	01 15       	cp	r16, r1
 9ee:	11 05       	cpc	r17, r1
 9f0:	89 f0       	breq	.+34     	; 0xa14 <beep(unsigned char, unsigned char)+0x54>
 9f2:	c0 e0       	ldi	r28, 0x00	; 0
 9f4:	d0 e0       	ldi	r29, 0x00	; 0
 9f6:	83 2d       	mov	r24, r3
 9f8:	87 70       	andi	r24, 0x07	; 7
 9fa:	ae db       	rcall	.-2212   	; 0x158 <set_pwm_on(unsigned char)>
 9fc:	86 e0       	ldi	r24, 0x06	; 6
 9fe:	90 e0       	ldi	r25, 0x00	; 0
 a00:	2e db       	rcall	.-2468   	; 0x5e <__delay_us(unsigned int)>
 a02:	c2 98       	cbi	0x18, 2	; 24
 a04:	c1 98       	cbi	0x18, 1	; 24
 a06:	c0 98       	cbi	0x18, 0	; 24
 a08:	c7 01       	movw	r24, r14
 a0a:	29 db       	rcall	.-2478   	; 0x5e <__delay_us(unsigned int)>
 a0c:	21 96       	adiw	r28, 0x01	; 1
 a0e:	c0 17       	cp	r28, r16
 a10:	d1 07       	cpc	r29, r17
 a12:	88 f3       	brcs	.-30     	; 0x9f6 <beep(unsigned char, unsigned char)+0x36>
 a14:	cd b7       	in	r28, 0x3d	; 61
 a16:	de b7       	in	r29, 0x3e	; 62
 a18:	e6 e0       	ldi	r30, 0x06	; 6
 a1a:	f3 c0       	rjmp	.+486    	; 0xc02 <__epilogue_restores__+0x18>

00000a1c <startup_sound()>:
 a1c:	1f 93       	push	r17
 a1e:	88 ef       	ldi	r24, 0xF8	; 248
 a20:	38 22       	and	r3, r24
 a22:	f3 db       	rcall	.-2074   	; 0x20a <set_comm_state()>
 a24:	10 e0       	ldi	r17, 0x00	; 0
 a26:	91 2f       	mov	r25, r17
 a28:	97 70       	andi	r25, 0x07	; 7
 a2a:	83 2d       	mov	r24, r3
 a2c:	88 7f       	andi	r24, 0xF8	; 248
 a2e:	38 2e       	mov	r3, r24
 a30:	39 2a       	or	r3, r25
 a32:	81 2f       	mov	r24, r17
 a34:	9f db       	rcall	.-2242   	; 0x174 <change_comm_state(unsigned char)>
 a36:	81 2f       	mov	r24, r17
 a38:	8a 5f       	subi	r24, 0xFA	; 250
 a3a:	6a e0       	ldi	r22, 0x0A	; 10
 a3c:	c1 df       	rcall	.-126    	; 0x9c0 <beep(unsigned char, unsigned char)>
 a3e:	65 e0       	ldi	r22, 0x05	; 5
 a40:	70 e0       	ldi	r23, 0x00	; 0
 a42:	80 e0       	ldi	r24, 0x00	; 0
 a44:	90 e0       	ldi	r25, 0x00	; 0
 a46:	20 db       	rcall	.-2496   	; 0x88 <__delay_ms(unsigned long)>
 a48:	1f 5f       	subi	r17, 0xFF	; 255
 a4a:	15 30       	cpi	r17, 0x05	; 5
 a4c:	61 f7       	brne	.-40     	; 0xa26 <startup_sound()+0xa>
 a4e:	6a ef       	ldi	r22, 0xFA	; 250
 a50:	70 e0       	ldi	r23, 0x00	; 0
 a52:	80 e0       	ldi	r24, 0x00	; 0
 a54:	90 e0       	ldi	r25, 0x00	; 0
 a56:	18 db       	rcall	.-2512   	; 0x88 <__delay_ms(unsigned long)>
 a58:	1f 91       	pop	r17
 a5a:	08 95       	ret

00000a5c <wait_for_arm()>:
 a5c:	57 db       	rcall	.-2386   	; 0x10c <filter_ppm_data()>
 a5e:	80 91 a0 00 	lds	r24, 0x00A0
 a62:	90 91 a1 00 	lds	r25, 0x00A1
 a66:	81 5d       	subi	r24, 0xD1	; 209
 a68:	97 40       	sbci	r25, 0x07	; 7
 a6a:	c0 f7       	brcc	.-16     	; 0xa5c <wait_for_arm()>
 a6c:	08 95       	ret

00000a6e <wait_for_power_on()>:
 a6e:	01 c0       	rjmp	.+2      	; 0xa72 <wait_for_power_on()+0x4>
 a70:	4d db       	rcall	.-2406   	; 0x10c <filter_ppm_data()>
 a72:	80 91 a0 00 	lds	r24, 0x00A0
 a76:	90 91 a1 00 	lds	r25, 0x00A1
 a7a:	84 53       	subi	r24, 0x34	; 52
 a7c:	98 40       	sbci	r25, 0x08	; 8
 a7e:	c0 f3       	brcs	.-16     	; 0xa70 <wait_for_power_on()+0x2>
 a80:	08 95       	ret

00000a82 <loop>:
 a82:	cc df       	rcall	.-104    	; 0xa1c <startup_sound()>
 a84:	eb df       	rcall	.-42     	; 0xa5c <wait_for_arm()>
 a86:	8c e0       	ldi	r24, 0x0C	; 12
 a88:	62 e3       	ldi	r22, 0x32	; 50
 a8a:	9a df       	rcall	.-204    	; 0x9c0 <beep(unsigned char, unsigned char)>
 a8c:	18 ba       	out	0x18, r1	; 24
 a8e:	15 ba       	out	0x15, r1	; 21
 a90:	12 ba       	out	0x12, r1	; 18
 a92:	10 92 c8 00 	sts	0x00C8, r1
 a96:	10 92 c7 00 	sts	0x00C7, r1
 a9a:	44 24       	eor	r4, r4
 a9c:	55 24       	eor	r5, r5
 a9e:	87 ef       	ldi	r24, 0xF7	; 247
 aa0:	38 22       	and	r3, r24
 aa2:	e5 df       	rcall	.-54     	; 0xa6e <wait_for_power_on()>
 aa4:	06 dc       	rcall	.-2036   	; 0x2b2 <start()>
 aa6:	88 23       	and	r24, r24
 aa8:	89 f7       	brne	.-30     	; 0xa8c <loop+0xa>
 aaa:	ee dd       	rcall	.-1060   	; 0x688 <run()>
 aac:	88 23       	and	r24, r24
 aae:	71 f3       	breq	.-36     	; 0xa8c <loop+0xa>
 ab0:	08 95       	ret

00000ab2 <main>:
 ab2:	4c d0       	rcall	.+152    	; 0xb4c <init>
 ab4:	53 df       	rcall	.-346    	; 0x95c <setup>
 ab6:	e5 df       	rcall	.-54     	; 0xa82 <loop>
 ab8:	e4 df       	rcall	.-56     	; 0xa82 <loop>
 aba:	fd cf       	rjmp	.-6      	; 0xab6 <main+0x4>

00000abc <__vector_9>:
 abc:	1f 92       	push	r1
 abe:	0f 92       	push	r0
 ac0:	0f b6       	in	r0, 0x3f	; 63
 ac2:	0f 92       	push	r0
 ac4:	11 24       	eor	r1, r1
 ac6:	2f 93       	push	r18
 ac8:	3f 93       	push	r19
 aca:	8f 93       	push	r24
 acc:	9f 93       	push	r25
 ace:	af 93       	push	r26
 ad0:	bf 93       	push	r27
 ad2:	80 91 cd 00 	lds	r24, 0x00CD
 ad6:	90 91 ce 00 	lds	r25, 0x00CE
 ada:	a0 91 cf 00 	lds	r26, 0x00CF
 ade:	b0 91 d0 00 	lds	r27, 0x00D0
 ae2:	30 91 d1 00 	lds	r19, 0x00D1
 ae6:	01 96       	adiw	r24, 0x01	; 1
 ae8:	a1 1d       	adc	r26, r1
 aea:	b1 1d       	adc	r27, r1
 aec:	23 2f       	mov	r18, r19
 aee:	2d 5f       	subi	r18, 0xFD	; 253
 af0:	2d 37       	cpi	r18, 0x7D	; 125
 af2:	20 f0       	brcs	.+8      	; 0xafc <__vector_9+0x40>
 af4:	2d 57       	subi	r18, 0x7D	; 125
 af6:	01 96       	adiw	r24, 0x01	; 1
 af8:	a1 1d       	adc	r26, r1
 afa:	b1 1d       	adc	r27, r1
 afc:	20 93 d1 00 	sts	0x00D1, r18
 b00:	80 93 cd 00 	sts	0x00CD, r24
 b04:	90 93 ce 00 	sts	0x00CE, r25
 b08:	a0 93 cf 00 	sts	0x00CF, r26
 b0c:	b0 93 d0 00 	sts	0x00D0, r27
 b10:	80 91 c9 00 	lds	r24, 0x00C9
 b14:	90 91 ca 00 	lds	r25, 0x00CA
 b18:	a0 91 cb 00 	lds	r26, 0x00CB
 b1c:	b0 91 cc 00 	lds	r27, 0x00CC
 b20:	01 96       	adiw	r24, 0x01	; 1
 b22:	a1 1d       	adc	r26, r1
 b24:	b1 1d       	adc	r27, r1
 b26:	80 93 c9 00 	sts	0x00C9, r24
 b2a:	90 93 ca 00 	sts	0x00CA, r25
 b2e:	a0 93 cb 00 	sts	0x00CB, r26
 b32:	b0 93 cc 00 	sts	0x00CC, r27
 b36:	bf 91       	pop	r27
 b38:	af 91       	pop	r26
 b3a:	9f 91       	pop	r25
 b3c:	8f 91       	pop	r24
 b3e:	3f 91       	pop	r19
 b40:	2f 91       	pop	r18
 b42:	0f 90       	pop	r0
 b44:	0f be       	out	0x3f, r0	; 63
 b46:	0f 90       	pop	r0
 b48:	1f 90       	pop	r1
 b4a:	18 95       	reti

00000b4c <init>:
 b4c:	78 94       	sei
 b4e:	83 b7       	in	r24, 0x33	; 51
 b50:	82 60       	ori	r24, 0x02	; 2
 b52:	83 bf       	out	0x33, r24	; 51
 b54:	83 b7       	in	r24, 0x33	; 51
 b56:	81 60       	ori	r24, 0x01	; 1
 b58:	83 bf       	out	0x33, r24	; 51
 b5a:	89 b7       	in	r24, 0x39	; 57
 b5c:	81 60       	ori	r24, 0x01	; 1
 b5e:	89 bf       	out	0x39, r24	; 57
 b60:	1e bc       	out	0x2e, r1	; 46
 b62:	8e b5       	in	r24, 0x2e	; 46
 b64:	82 60       	ori	r24, 0x02	; 2
 b66:	8e bd       	out	0x2e, r24	; 46
 b68:	8e b5       	in	r24, 0x2e	; 46
 b6a:	81 60       	ori	r24, 0x01	; 1
 b6c:	8e bd       	out	0x2e, r24	; 46
 b6e:	8f b5       	in	r24, 0x2f	; 47
 b70:	81 60       	ori	r24, 0x01	; 1
 b72:	8f bd       	out	0x2f, r24	; 47
 b74:	85 b5       	in	r24, 0x25	; 37
 b76:	84 60       	ori	r24, 0x04	; 4
 b78:	85 bd       	out	0x25, r24	; 37
 b7a:	85 b5       	in	r24, 0x25	; 37
 b7c:	80 64       	ori	r24, 0x40	; 64
 b7e:	85 bd       	out	0x25, r24	; 37
 b80:	32 9a       	sbi	0x06, 2	; 6
 b82:	31 9a       	sbi	0x06, 1	; 6
 b84:	30 9a       	sbi	0x06, 0	; 6
 b86:	37 9a       	sbi	0x06, 7	; 6
 b88:	1a b8       	out	0x0a, r1	; 10
 b8a:	08 95       	ret

00000b8c <__divmodhi4>:
 b8c:	97 fb       	bst	r25, 7
 b8e:	09 2e       	mov	r0, r25
 b90:	07 26       	eor	r0, r23
 b92:	0a d0       	rcall	.+20     	; 0xba8 <__divmodhi4_neg1>
 b94:	77 fd       	sbrc	r23, 7
 b96:	04 d0       	rcall	.+8      	; 0xba0 <__divmodhi4_neg2>
 b98:	43 d0       	rcall	.+134    	; 0xc20 <__udivmodhi4>
 b9a:	06 d0       	rcall	.+12     	; 0xba8 <__divmodhi4_neg1>
 b9c:	00 20       	and	r0, r0
 b9e:	1a f4       	brpl	.+6      	; 0xba6 <__divmodhi4_exit>

00000ba0 <__divmodhi4_neg2>:
 ba0:	70 95       	com	r23
 ba2:	61 95       	neg	r22
 ba4:	7f 4f       	sbci	r23, 0xFF	; 255

00000ba6 <__divmodhi4_exit>:
 ba6:	08 95       	ret

00000ba8 <__divmodhi4_neg1>:
 ba8:	f6 f7       	brtc	.-4      	; 0xba6 <__divmodhi4_exit>
 baa:	90 95       	com	r25
 bac:	81 95       	neg	r24
 bae:	9f 4f       	sbci	r25, 0xFF	; 255
 bb0:	08 95       	ret

00000bb2 <__prologue_saves__>:
 bb2:	2f 92       	push	r2
 bb4:	3f 92       	push	r3
 bb6:	4f 92       	push	r4
 bb8:	5f 92       	push	r5
 bba:	6f 92       	push	r6
 bbc:	7f 92       	push	r7
 bbe:	8f 92       	push	r8
 bc0:	9f 92       	push	r9
 bc2:	af 92       	push	r10
 bc4:	bf 92       	push	r11
 bc6:	cf 92       	push	r12
 bc8:	df 92       	push	r13
 bca:	ef 92       	push	r14
 bcc:	ff 92       	push	r15
 bce:	0f 93       	push	r16
 bd0:	1f 93       	push	r17
 bd2:	cf 93       	push	r28
 bd4:	df 93       	push	r29
 bd6:	cd b7       	in	r28, 0x3d	; 61
 bd8:	de b7       	in	r29, 0x3e	; 62
 bda:	ca 1b       	sub	r28, r26
 bdc:	db 0b       	sbc	r29, r27
 bde:	0f b6       	in	r0, 0x3f	; 63
 be0:	f8 94       	cli
 be2:	de bf       	out	0x3e, r29	; 62
 be4:	0f be       	out	0x3f, r0	; 63
 be6:	cd bf       	out	0x3d, r28	; 61
 be8:	09 94       	ijmp

00000bea <__epilogue_restores__>:
 bea:	2a 88       	ldd	r2, Y+18	; 0x12
 bec:	39 88       	ldd	r3, Y+17	; 0x11
 bee:	48 88       	ldd	r4, Y+16	; 0x10
 bf0:	5f 84       	ldd	r5, Y+15	; 0x0f
 bf2:	6e 84       	ldd	r6, Y+14	; 0x0e
 bf4:	7d 84       	ldd	r7, Y+13	; 0x0d
 bf6:	8c 84       	ldd	r8, Y+12	; 0x0c
 bf8:	9b 84       	ldd	r9, Y+11	; 0x0b
 bfa:	aa 84       	ldd	r10, Y+10	; 0x0a
 bfc:	b9 84       	ldd	r11, Y+9	; 0x09
 bfe:	c8 84       	ldd	r12, Y+8	; 0x08
 c00:	df 80       	ldd	r13, Y+7	; 0x07
 c02:	ee 80       	ldd	r14, Y+6	; 0x06
 c04:	fd 80       	ldd	r15, Y+5	; 0x05
 c06:	0c 81       	ldd	r16, Y+4	; 0x04
 c08:	1b 81       	ldd	r17, Y+3	; 0x03
 c0a:	aa 81       	ldd	r26, Y+2	; 0x02
 c0c:	b9 81       	ldd	r27, Y+1	; 0x01
 c0e:	ce 0f       	add	r28, r30
 c10:	d1 1d       	adc	r29, r1
 c12:	0f b6       	in	r0, 0x3f	; 63
 c14:	f8 94       	cli
 c16:	de bf       	out	0x3e, r29	; 62
 c18:	0f be       	out	0x3f, r0	; 63
 c1a:	cd bf       	out	0x3d, r28	; 61
 c1c:	ed 01       	movw	r28, r26
 c1e:	08 95       	ret

00000c20 <__udivmodhi4>:
 c20:	aa 1b       	sub	r26, r26
 c22:	bb 1b       	sub	r27, r27
 c24:	51 e1       	ldi	r21, 0x11	; 17
 c26:	07 c0       	rjmp	.+14     	; 0xc36 <__udivmodhi4_ep>

00000c28 <__udivmodhi4_loop>:
 c28:	aa 1f       	adc	r26, r26
 c2a:	bb 1f       	adc	r27, r27
 c2c:	a6 17       	cp	r26, r22
 c2e:	b7 07       	cpc	r27, r23
 c30:	10 f0       	brcs	.+4      	; 0xc36 <__udivmodhi4_ep>
 c32:	a6 1b       	sub	r26, r22
 c34:	b7 0b       	sbc	r27, r23

00000c36 <__udivmodhi4_ep>:
 c36:	88 1f       	adc	r24, r24
 c38:	99 1f       	adc	r25, r25
 c3a:	5a 95       	dec	r21
 c3c:	a9 f7       	brne	.-22     	; 0xc28 <__udivmodhi4_loop>
 c3e:	80 95       	com	r24
 c40:	90 95       	com	r25
 c42:	bc 01       	movw	r22, r24
 c44:	cd 01       	movw	r24, r26
 c46:	08 95       	ret

00000c48 <_exit>:
 c48:	f8 94       	cli

00000c4a <__stop_program>:
 c4a:	ff cf       	rjmp	.-2      	; 0xc4a <__stop_program>
