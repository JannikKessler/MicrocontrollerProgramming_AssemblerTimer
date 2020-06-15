; Neue Datei anlegen -> Rechtsklick auf Eieruhr im Solution Explorer und Add.
; "Die Register sollte man in einer zentralen Main Datei erschaffen." -Prof. Kumm 2020
.cseg
	rjmp main;

.include "display.asm"
.include "pressUp.asm"
.include "delay1sec.asm"
.include "delay_long.asm"
.include "pressStart.asm"
.include "buzzer.asm"

; Frequenz fuer Display
.equ clk_freq_in_Hz = 16000000
.equ io_freq_in_Hz = 400000
.equ cnt_io_init = clk_freq_in_Hz/io_freq_in_Hz
.equ offset = 15 ; Clks die außerhalb der Loop auftreten
.equ clk_per_Loop = 11 ; Clks die innerhalb der Loop immer wieder auftreten 
.equ counter = (clk_freq_in_Hz - offset)/(clk_per_Loop)
.equ pressUp_counter = (clk_freq_in_Hz - offset)/(clk_per_Loop * 2 * 2) //Viertelsekunden hochzaehlen
.equ buzz_pause = clk_freq_in_Hz / 22  ; buzzing in defined time e.g. 1s cyklus

; accu ist temp Register
.def accu = r16  ; accu register, used for temporary computations and return of function values
.def arg0 = r17  ; argument 0 for subroutines
.def arg1  = r18 ; argument 1 for subroutines

; Von links nach rechts
.def num_0 = r19		; Speichert aktuelle Minuten im Zehner Bereich(0-9)
.def num_1 = r20		; Speichert aktuelle Minuten im Einer Bereich(0-9)
.def num_2 = r21		; Speichert aktuelle Sekunden im Zehner Bereich(0-5)
.def num_3 = r22		; Speichert aktuelle Sekunden im Einer Bereich(0-9)

; Kombiniertes Register für Sekundendelay
.def cnt_low  = r23
.def cnt_mid  = r24
.def cnt_high = r25

; Display an D5 weil dort die richtigen Pins sitzen
.equ clk_bit = 5
.equ dio_bit = 6 

; Zeiteinstellbutton an D2
.equ pressUp_bit = 2

; Timer-Start-Button an D4
.equ timeStart_bit = 4

; buzzer is connected to D7
.equ output_buzz = 7

; Hauptprogramm
main:
	rcall init_display      ; init the display
	rjmp loop

; Loop
loop :
	rcall refresh_display
	clr num_0
	clr num_1
	clr num_2
	clr num_3
	rcall pressUp_start
	rcall pressStart_start
	rcall buzzer_start
rjmp loop