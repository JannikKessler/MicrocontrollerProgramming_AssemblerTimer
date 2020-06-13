; Neue Datei anlegen -> Rechtsklick auf Eieruhr im Solution Explorer und Add.
; "Die Register sollte man in einer zentralen Main Datei erschaffen." -Prof. Kumm 2020
.cseg
	rjmp main;

.include "delay_long.asm"
.include "display.asm"
.include "pressUp.asm"

; Frequenz fuer Display
.equ clk_freq_in_Hz = 16000000
.equ io_freq_in_Hz = 400000
.equ cnt_io_init = clk_freq_in_Hz/io_freq_in_Hz
.equ pressUp_delayClk = (clk_freq_in_Hz - 8) / (21 * 2)	; Eine Sekunde Delay beim Hochdruecken des Countdowns

; accu ist temp Register
.def accu = r16  ; accu register, used for temporary computations and return of function values
.def arg0 = r17  ; argument 0 for subroutines
.def arg1  = r18 ; argument 1 for subroutines
; Von links nach rechts
.def num_0 = r19		; Speichert aktuelle Minuten im Zehner Bereich(0-9)
.def num_1 = r20		; Speichert aktuelle Minuten im Einer Bereich(0-9)
.def num_2 = r21		; Speichert aktuelle Sekunden im Zehner Bereich(0-5)
.def num_3 = r22		; Speichert aktuelle Sekunden im Einer Bereich(0-9)

.def cnt_init_low  = r23
.def cnt_init_mid  = r24
.def cnt_init_high = r25

; Display an D5 weil dort die richtigen Pins sitzen
.equ clk_bit = 5
.equ dio_bit = 6 

; Zeiteinstellbutton an D2
.equ pressUp_bit = 2

main:
	rcall init_display      ; init the display
	clr num_0
	clr num_1
	clr num_2
	clr num_3
	rcall pressUp_start
	; Hier kann man festlegen was angezeigt werden muss
	/*
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
	*/
/*
	; set digit value to 'A':
	ldi arg1,0b01110111    ; set digit value
	;ldi arg1 , 0b11110111 ; fuer das Doppelpunkt noch
	ldi arg0,0             ; set digit no
	rcall send_digit       ; display digit

*/
loop:
	rjmp loop		; loop forever



