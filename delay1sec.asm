; 1sek Delay
/*.equ clk_in_Mhz = 16000000
.equ freq_per_Sek = 1 ; Die Loop soll 1mal pro Sekunde enden
.equ offset = 15 ; Clks die außerhalb der Loop auftreten
.equ clk_per_Loop = 11 ; Clks die innerhalb der Loop immer wieder auftreten 
.equ counter = ((clk_in_Mhz/freq_per_Sek)-offset)/clk_per_Loop*/

;.def test = r16
/*.def count_low = r17 
.def count_mid = r18 
.def count_high = r19
*/
; Hauptprogramm
delay1sec_start :
	rcall delay1sec_resetcount ; Zurücksetzen
	rcall delay1sec_waitforcount ; Abzählen
ret
;rjmp delay1sec_start

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
