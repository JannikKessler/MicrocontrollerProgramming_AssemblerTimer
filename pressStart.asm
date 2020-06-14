/*
 * pressStart.asm
 *
 *  Created: 13/06/2020 17:13:21
 *   Author: arnof
 */ 

 pressStart_start : 
	rcall refresh_display ; Aktualisiert die Anzeige
	rcall delay1sec_start ; 1 Sekunde vor n�chstem runterz�hlen warten
	rcall decrease_sec_e ; Routine um Sekunde f�r Sekunde abzuz�hlen

	clr accu ; Test ob Register leer sind
	or accu , num_0
	or accu , num_1
	or accu , num_2
	or accu , num_3

	tst accu ; Falls leer beenden ansonsten wieder 1 runterz�hlen
	brne pressStart_start
	rcall refresh_display
 ret

 ; Unterroutinen zum Abz�hlen
 decrease_sec_e :
	; Test
	tst num_3 ; Falls num_3 leer ist auf sec_z wechseln
	breq decrease_sec_z
	
	; Decrease
	dec num_3 ; num_3 runterz�hlen
 ret

 decrease_sec_z :
	; Test
	tst num_2 ; Falls num_2 leer ist auf min_e wechseln
	breq decrease_min_e
	
	; Decrease
	dec num_2 ; num_2 runterz�hlen +
	ldi num_3, 9 ; num_3 auff�llen
 ret

 decrease_min_e :
	; Test
	tst num_1 ; Falls num_1 leer ist auf min_z wechseln
	breq test_min_z
	
	; Decrease
	dec num_1 ; num_1 runterz�hlen +
	ldi num_2, 5 ; num_2 auff�llen +
	ldi num_3, 9 ; num_3 auff�llen
 ret

 test_min_z :
	tst num_0
	brne decrease_min_z
 ret

 decrease_min_z :
	dec num_0 ; num_0 runterz�hlen +
	ldi num_1, 9 ; num_1 auff�llen +
	ldi num_2, 5 ; num_2 auff�llen +
	ldi num_3, 9 ; num_3 auff�llen
 ret

 ; Aktualisiert die Displayanzeige
 refresh_display :
	mov arg1, num_0 ; �bernimmt aktuellen Wert als Ausgabewert
	ldi arg0, 0 ; An Stelle 0
	rcall send_number

	mov arg1, num_1 ; �bernimmt aktuellen Wert als Ausgabewert
	ldi arg0, 1 ; An Stelle 1
	rcall send_number

	mov arg1, num_2 ; �bernimmt aktuellen Wert als Ausgabewert
	ldi arg0, 2 ; An Stelle 2
	rcall send_number

	mov arg1, num_3 ; �bernimmt aktuellen Wert als Ausgabewert
	ldi arg0, 3 ; An Stelle 3
	rcall send_number
 ret