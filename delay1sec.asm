; 1sek Delay
.equ clk_in_Mhz = 16000000
.equ freq_per_Sek = 1 ; Die Loop soll 1mal pro Sekunde enden
.equ offset = 15 ; Clks die außerhalb der Loop auftreten
.equ clk_per_Loop = 11 ; Clks die innerhalb der Loop immer wieder auftreten 
.equ counter = ((clk_in_Mhz/freq_per_Sek)-offset)/clk_per_Loop

.def test = r16
.def count_low = r17 
.def count_mid = r18 
.def count_high = r19

; Hauptprogramm
start :
	rcall resetcount ; Zurücksetzen
	rcall waitforcount ; Abzählen
rjmp start

; Zuruecksetzen clk= 3+7
resetcount :
	ldi count_low , byte1 (counter)
	ldi count_mid , byte2 (counter)
	ldi count_high , byte3 (counter)
ret

; Warten clk=11+7
waitforcount : 
	clc ; Clear Carry
	; Hier Counter runterzählen mithilfe von Carry
	sbci count_low ,1
	sbci count_mid ,0 
	sbci count_high ,0

	clr test ; Test leeren
	or test , count_high
	or test , count_mid
	or test , count_low

	tst test ; Testregister auf 0 überprüfen
	brne waitforcount
ret
