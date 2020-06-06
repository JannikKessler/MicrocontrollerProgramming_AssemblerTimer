; delay_long implements a 24 bit counter and returns after cnt_init iterations
; The 24 bit cnt_init is defined using cnt_init_low, cnt_init_mid, cnt_init_high
; Each iteration takes 21 clock cycles + a constant 8 cycles offset
delay_long:
	push r17  ; save zero_test register
	push accu ; save accu register
delay_long_loop:
	clc ; clear carry

	; decrement counter:
	sbci cnt_init_low,1
	sbci cnt_init_mid,0
	sbci cnt_init_high,0

	; check if counter == 0 with constant time
	clr r17               ; reset zero test register
	tst cnt_init_high     ; test if zero
	in accu,SREG          ; copy SREG to accu
	bst accu,1            ; T <- Z
	bld r17,0             ; zero_test(0) <- Z

	tst cnt_init_mid      ; test if zero
	in accu,SREG          ; copy SREG to accu
	bst accu,1            ; T <- Z
	bld r17,1             ; zero_test(1) <- Z

	tst cnt_init_low
	in accu,SREG          ; copy SREG to accu
	bst accu,1            ; T <- Z
	bld r17,2             ; zero_test(2) <- Z

	ldi accu,0x07         ; load 7 into accu
	eor r17,accu          ; 
	brne delay_long_loop  ; continue only when all cnt registers are zero

	pop accu       ; restore accu register
	pop r17  ; restore zero_test register

	ret

