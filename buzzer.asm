;
; Project "Eieruhr"
;
; Created: 11.06.2020
; Author : Nidzad 
;


.equ output_buzz = 2            ; buzzer is connected to D2
.equ clk_frq = 16 * 1000000     ; frequency of the board
.equ buzz_pause = clk_frq / 22  ; buzzing in defined time e.g. 1s cyklus

; assigned registers for buzz_pause
.def accu = R16
.def buzz_low = R17
.def buzz_mid = R18
.def buzz_hig = R19
.def test_zero = R20


    sbi DDRD, output_buzz       ; setting I/O Register as output

start:
    
    cbi PORTD, output_buzz      ; set bit to turn on buzzer

    rcall setTimerBits
    rcall delayBuzz

    sbi PORTD, output_buzz      ; clear bit to turn off buzzer

    rjmp start

; assigning the registers for buzz_pause
setTimerBits:
    ldi buzz_low, byte1(buzz_pause)
    ldi buzz_mid, byte2(buzz_pause)
    ldi buzz_hig, byte3(buzz_pause)
    ret

; pause between buzzing - e.g. 1s
delayBuzz:
    clc                 ; clear carry
    sbci buzz_low, 1
    sbci buzz_mid, 0
    sbci buzz_hig, 0
    
    ; check if counter == 0
    clr accu
    or accu, buzz_hig
    or accu, buzz_mid
    or accu, buzz_low

    tst accu            ; test accu for zero or minus
    brne delayBuzz
    ret
