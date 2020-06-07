/*
 * press_up.asm
 *
 *  Created: 07/06/2020 03:16:36
 *   Author: Jannik
 */ 

 pressUp_start:
	sbic PIND, pressUp_bit
		rjmp pressUp_incr
	rjmp pressUp_start

pressUp_delay:
	ldi cnt_init_low , byte1(pressUp_delayClk)
	ldi cnt_init_mid , byte2(pressUp_delayClk)
	ldi cnt_init_high , byte3(pressUp_delayClk)
	rcall delay_long
	rjmp pressUp_start

pressUp_incr:
	sbr accu , 5
	add num_right , accu
	; Bei hinterster 0 muss die vorletzte inkrementiert werden
	cpi num_right , 10
	breq pressUp_set10
	cpi num_right , 20
	breq pressUp_set20
	cpi num_right , 30
	breq pressUp_set30
	cpi num_right , 40
	breq pressUp_set40
	cpi num_right , 50
	breq pressUp_set50
	ldi arg1,5
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_set10:
	ldi arg1,1
	ldi arg0,2
	rcall send_number
	ldi arg1,0
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_set20:
	ldi arg1,2
	ldi arg0,2
	rcall send_number
	ldi arg1,0
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_set30:
	ldi arg1,3
	ldi arg0,2
	rcall send_number
	ldi arg1,0
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_set40:
	ldi arg1,4
	ldi arg0,2
	rcall send_number
	ldi arg1,0
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_set50:
	ldi arg1,5
	ldi arg0,2
	rcall send_number
	ldi arg1,0
	ldi arg0,3
	rcall send_number
	rjmp pressUp_delay

pressUp_set0:
	ldi arg1,0
	ldi arg0,3
	rcall send_number
	rjmp pressUp_start

pressUp_set5:
	ldi arg1,5
	ldi arg0,3
	rcall send_number
	rjmp pressUp_start
	/*
	; Hier kann man festlegen was angezeigt werden muss

	; sets one digits from left to right to 1234:
	ldi arg1,1				; set digit value ; Zahl selbst
	ldi arg0,0              ; set digit no ; Position an der die Zahl hinkommt, hier 1234
	rcall send_number       ; display digit
	ldi arg1,2				; set digit value ; Die Zwei an Position 1
	ldi arg0,1              ; set digit no
	rcall send_number       ; display digit
	ldi arg1,3				; set digit value
	ldi arg0,2              ; set digit no
	rcall send_number       ; display digit
	ldi arg1,4				; set digit value
	ldi arg0,3              ; set digit no
	rcall send_number       ; display digit
	ret
	*/