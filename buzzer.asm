;
; Project "Eieruhr"
;
; Created: 11.06.2020
; Author : Nidzad 
;


;.equ output_buzz = 2            ; buzzer is connected to D2
;.equ clk_frq = 16 * 1000000     ; frequency of the board
;.equ buzz_pause = clk_frq / 22  ; buzzing in defined time e.g. 1s cyklus

; assigned registers for buzz_pause
;.def accu = R16
;.def buzz_low = R17
;.def buzz_mid = R18
;.def buzz_hig = R19
;.def test_zero = R20


    sbi DDRD, output_buzz       ; setting I/O Register as output

buzzer_start:
    
    sbi PORTD, output_buzz      ; set bit to turn off buzzer

    rcall setTimerBits
    rcall delayBuzz;delay1sec_start

    cbi PORTD, output_buzz      ; clear bit to turn on buzzer

    ret;rjmp buzzer_start

; assigning the registers for buzz_pause
setTimerBits:
	clr cnt_low
	clr cnt_mid
	clr cnt_high
    ldi cnt_low, byte1(counter)
    ldi cnt_mid, byte2(counter)
    ldi cnt_high, byte3(counter)
    ret

; pause between buzzing - e.g. 1s
delayBuzz:
    clc                 ; clear carry
    sbci cnt_low, 1
    sbci cnt_mid, 0
    sbci cnt_high, 0
    
    ; check if counter == 0
    clr accu
    or accu, cnt_high
    or accu, cnt_mid
    or accu, cnt_low

    tst accu            ; test accu for zero or minus
    brne delayBuzz
    ret
