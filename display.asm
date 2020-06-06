
; 7 Segment Decoder ; das sind die Bitcodes fuer 0-9
table_7seg:
.db 0x3F,0x06,0x5b,0x4f,0x66,0x6d,0x7D,0x07,0x7f,0x6F


; init_display configures I/O and clears the display
init_display:
	sbi DDRD,dio_bit   ; DIO is output
	sbi DDRD,clk_bit   ; CLK is output
	sbi PORTD,dio_bit  ; DIO=1
	sbi PORTD,clk_bit  ; CLK=1
	rcall clear_disp

	ret

; clear_disp clears the display
clear_disp:
	ldi arg0,0				; set digit no
	ldi arg1,0              ; set digit value, 0 means all leds off
clear_disp_loop:
	rcall send_digit        ; display digit
	inc arg0                ; select next digit
	cpi arg0,4              ; last digit selected?
	brne clear_disp_loop    ; loop until all digits cleared

	ret

; seven_seg_decoder converts a binary number provided in register arg0 to a 7-segment representation returned in accu
seven_seg_decoder:
	ldi ZH, high(table_7seg << 1) ; init Z pointer (high byte)
	ldi ZL, low(table_7seg << 1)  ; init Z pointer (low byte)
	clr accu                      ; reset accu to zero (used for adc)
	add ZL,arg0                   ; Z <- Z + digit
	adc ZH,accu                   ; add carry to ZH    
	lpm accu,Z                    ; load 7seg from program memory
	ret

; send_number sends a number stored in register arg1 at the position stored in arg0 to the display
send_number:
	push accu
	push arg0
	mov arg0,arg1
	rcall seven_seg_decoder ; convert arg0 to 7seg, return is in accu
	pop arg0
	mov arg1,accu
	rcall send_digit        ; display digit
	pop accu
	ret

/* send_digit sends a 7-segment digit stored in register arg1 at the position stored in arg0 to the display

7-segment encoding is as follows (numbers represent the bits that have to be set):
|--0--|
|     |
5     1
|     |
|--6--|
|     |
4     2
|     |
|--3--|
*/

; Uebertraegt Bitfolge um eine Zahl darzustellen
send_digit:
	push accu
	push arg0         ; save arg0 (digit number)
	rcall send_frame_start
	mov accu,arg0     ; store arg0 to accu
	ldi arg0,0x44     ;set data command (fixed address)
	rcall send_byte
	rcall send_frame_end

	rcall send_frame_start
	ldi arg0,0xc0     ; set address command (channel 0)
;	pop accu          ; restore digit number from stack (formerly stored in arg0)
;	add arg0,digit_no ; add digit number
	add arg0,accu     ; add digit number
	rcall send_byte
	mov arg0,arg1     ; display data    
	rcall send_byte
	rcall send_frame_end

	rcall send_frame_start
;	ldi arg0,0x8b     ;display control (display on, pulse width 10/16)
;	ldi arg0,0x83     ;display control (display off, pulse width 10/16)
	ldi arg0,0x8f     ;display control (display on, pulse width 14/16)
	rcall send_byte
	rcall send_frame_end
	pop arg0          ; restore digit number from stack
	pop accu          ; restore accu register from stack
    ret

send_frame_start:
	cbi PORTD,dio_bit  ; DIO=0, start of transfer
	rcall delay_short  ; wait for transfer delay
	cbi PORTD,clk_bit  ; CLK=0, start of transfer / take over data bit
	rcall delay_short  ; wait for transfer delay
	ret

; send_byte sends one byte stored in register arg0
send_byte:
	push accu          ; used for bit_cnt
	ldi accu,8         ; init bit_cnt to 8 bits

send_bit:
	cbi PORTD,clk_bit  ; CLK=0, start of transfer / take over data bit
;	rcall delay_short ; wait for transfer delay

	sbrc arg0,0
	sbi PORTD,dio_bit  ; DIO=1, transfer 1
	sbrs arg0,0
	cbi PORTD,dio_bit  ; DIO=0, transfer 0
	rcall delay_short  ; wait for transfer delay

	sbi PORTD,clk_bit  ; CLK=1
	lsr arg0      ; right shift data

	rcall delay_short  ; wait for transfer delay

	dec accu           ; bit_cnt--
	brne send_bit      ; branch if bit_cnt != 0

	cbi PORTD,clk_bit  ; CLK=0, end of transfer
	sbi PORTD,dio_bit  ; DIO=1, enable pull-up
	cbi DDRD,dio_bit   ; DIO is input

	rcall delay_short  ; wait for transfer delay
	sbi PORTD,clk_bit  ; CLK=1, ack
	sbic PIND,dio_bit  ; check DIO, skip break if 0
	break              ; Error!
	rcall delay_short  ; wait for transfer delay
	cbi PORTD,clk_bit  ; CLK=0, ack end
	rcall delay_short  ; wait for transfer delay
	cbi PORTD,dio_bit  ; DIO=0
	sbi DDRD,dio_bit   ; DIO is output
	rcall delay_short  ; wait for transfer delay

	pop accu           ; restore accu

	ret

send_frame_end:
	sbi PORTD,clk_bit  ; CLK=1, stop
	rcall delay_short  ; wait for transfer delay
	sbi PORTD,dio_bit  ; DIO=1
	rcall delay_short  ; wait for transfer delay
	ret


delay_short:
	push accu        ; save accu, used for delay_cnt
	ldi accu,cnt_io_init
delay_loop:
	dec accu         ; delay_cnt--
	brne delay_loop  ; branch if delay_cnt != 0
	pop accu         ; restore accu
	ret