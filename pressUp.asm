/*
 * press_up.asm
 *
 *  Created: 07/06/2020 03:16:36
 *   Author: Jannik
 */ 

 pressUp_start:
	sbic PIND, pressUp_bit
		rjmp pressUp_incr
	sbic PIND, timeStart_bit
		ret
	rjmp pressUp_start

pressUp_delay:
	ldi cnt_low , byte1(counter)
	ldi cnt_mid , byte2(counter)
	ldi cnt_high , byte3(counter)
	rcall delay1sec_start
	rjmp pressUp_start

pressUp_incr:
	ldi accu , 5
	add num_3 , accu
	cpi num_3 , 10
	breq pressUp_secTenner
	ldi arg1,5
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_secTenner:
	ldi num_3 , 0
	mov arg1,num_3
	ldi arg0,3
	rcall send_number
	; Zehner Sekunde hochzaehlen
	inc num_2
	cpi num_2 , 6
	breq pressUp_min
	mov arg1,num_2
	ldi arg0,2
	rcall send_number
	rjmp pressUp_delay

pressUp_min:
	ldi num_2 , 0
	mov arg1,num_2
	ldi arg0,2
	rcall send_number
	; Minute hochzaehlen
	inc num_1
	cpi num_1 , 10
	breq pressUp_minTenner
	mov arg1,num_1
	ldi arg0,1
	rcall send_number
	rjmp pressUp_delay

pressUp_minTenner:
	ldi num_1 , 0
	mov arg1,num_1
	ldi arg0,1
	rcall send_number
	; Zehner Minute hochzaehlen
	inc num_0
	cpi num_0 , 10
	breq pressUp_full
	mov arg1,num_0
	ldi arg0,0
	rcall send_number
	rjmp pressUp_delay

; Wenn man 100:00 erreicht soll es abbrechen
pressUp_full:
	ldi num_0 , 9
	ldi num_1 , 9
	ldi num_2 , 5
	ldi num_3 , 5
	ret