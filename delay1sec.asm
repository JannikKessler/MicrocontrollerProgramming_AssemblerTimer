/*
 * delay1sec.asm
 *
 *  Created: 10.06.2020 11:33:43
 *   Author: arnof
 */ 

delay1sec_start :
	rcall delay1sec_resetcount ; Zurücksetzen
	rcall delay1sec_waitforcount ; Abzählen
ret

; Zuruecksetzen clk= 3+7
delay1sec_resetcount :
	ldi cnt_low , byte1 (counter)
	ldi cnt_mid , byte2 (counter)
	ldi cnt_high , byte3 (counter)
ret

; Warten clk=11+7
delay1sec_waitforcount : 
	clc ; Clear Carry
	; Hier Counter runterzählen mithilfe von Carry
	sbci cnt_low ,1
	sbci cnt_mid ,0 
	sbci cnt_high ,0

	clr accu ; Test leeren
	or accu , cnt_high
	or accu , cnt_mid
	or accu , cnt_low

	tst accu ; Testregister auf 0 überprüfen
	brne delay1sec_waitforcount
ret
