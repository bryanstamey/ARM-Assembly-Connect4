	area uartdemo, code, readonly
pinsel0  equ  0xe002c000	; controls function of pins
u0start  equ  0xe000c000	; start of UART0 registers
lcr0  equ  0xc		; line control register for UART0
lsr0  equ  0x14		; line status register for UART0
ramstart  equ  0x40000000	; start of onboard RAM for 2104
stackstart  equ  0x40000200  ; start of stack

	entry

start
	ldr sp, = stackstart	; set up stack pointer
	bl UARTConfig	; initialize/configure UART0
	bl Print		; initial board print
next	bl play1row		; request row input from player1 NEXT GOES HERE
		bl play1rowR	; recieve player 1 row
		bl PrintNL		; print new line
		bl play1col		; request col input from player 1
		bl play1colR	; recieve player 1 col
		bl PrintNL		; new line
		bl placePiece1	; place game piece in table
		bl Print		; print board
		bl Win1
		bl play2row		; request row input from player1
		bl play2rowR	; recieve player 1 row
		bl PrintNL		; new line
		bl play2col		; request col input from player 1
		bl play2colR	; recieve player 1 col
		bl PrintNL		; new line
		bl placePiece2	; place game piece in table
		bl Print		; print board
		bl Win2
		b next			; loop until win

;;;;;;;;;;;;;;;;;;;;;;
;   Player 1 Subs    ;
;;;;;;;;;;;;;;;;;;;;;;
	
play1row
	push {r5, r6, lr}
	ldr r1, =play1rowtxt
loop
	ldrb r0, [r1], #1	; load character, increment address
	cmp r0, #0		; null terminated?
	blne Transmit		; send character to UART
	bne loop		; continue if not a '0'
	pop {r5, r6, pc}
	
play1rowR
	push {r5, r6, lr}			; recieve & store
	ldr r5, = u0start			; recieve
wait1	ldrb r6, [r5, #lsr0]	; logic
	tst	r6, #0x01				; sequence
	beq		wait1				;
	ldrb r0, [r5]				;
	sub r2, r0, #0x30			; row value to r2
	bl Transmit				; mirror to uart window
	pop {r5, r6, pc}
	
play1col
	push {r5, r6, lr}
	ldr r1, =play1coltxt
loop1
	ldrb r0, [r1], #1	; load character, increment address
	cmp r0, #0		; null terminated?
	blne Transmit		; send character to UART
	bne loop1		; continue if not a '0'
	pop {r5, r6, pc}
	
play1colR
	push {r5, r6, lr}			; recieve & store
	ldr r5, = u0start			; recieve
wait2	ldrb r6, [r5, #lsr0]	; logic
	tst	r6, #0x01				; sequence
	beq		wait2				;
	ldrb r0, [r5]				;
	sub r3, r0, #0x30				; col value to r2
	bl Transmit				; mirror to uart window
	pop {r5, r6, pc}

placePiece1
	push {r5, r6, lr}	; places value 1 in table for position of player 1
	sub r3, r3, #1 		; subtract 1 form col for (0-6 scale)
	mov	r4, #1			; store value (1 = player 1)
	cmp r2, #1
	beq row_1
	cmp r2, #2
	beq row_2
	cmp r2, #3
	beq row_3
	cmp r2, #4
	beq row_4
	cmp r2, #5
	beq row_5
	cmp r2, #6
	beq row_6
row_1 	ldr r5, =row1		; address row 1
		strb r4, [r5, r3]	; store in table
		b done1
row_2	ldr r5, =row2
		strb r4, [r5, r3]
		b done1
row_3	ldr r5, =row3
		strb r4, [r5, r3]
		b done1
row_4	ldr r5, =row4
		strb r4, [r5, r3]
		b done1
row_5	ldr r5, =row5
		strb r4, [r5, r3]
		b done1
row_6	ldr r5, =row6
		strb r4, [r5, r3]
		b done1
done1	pop {r5, r6, pc}

;;;;CHECK FOR WIN;;;;

Win1
		push {r5, r6, lr}
		; check to left
		ldr r1, =row1
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin
		b win
nowin	ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin1
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin1
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin1
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin1
		b win	
nowin1	ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin2
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin2
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin2
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin2
		b win	
nowin2	ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin3
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin3
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin3
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin3
		b win		
nowin3	ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin4
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin4
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin4
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin4
		b win
nowin4	ldr r1, =row6
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin5
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin5
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin5
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin5
		b win
		; check to right
nowin5	ldr r1, =row1
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin6
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin6
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin6
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin6
		b win
nowin6	ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin7
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin7
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin7
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin7
		b win	
nowin7	ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin8
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin8
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin8
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin8
		b win	
nowin8	ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin9
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin9
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin9
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin9
		b win		
nowin9	ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin10
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin10
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin10
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin10
		b win
nowin10	ldr r1, =row6
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne no
		b win
no	ldr r1, =row1
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no1
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no1
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no1
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no1
		b win
no1		ldr r1, =row2
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no2
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no2
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no2
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no2
		b win
no2		ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no3
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no3
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no3
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no3
		b win
no3		ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no4
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no4
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no4
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no4
		b win
no4		ldr r1, =row5
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no5
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no5
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no5
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no5
		b win
no5		ldr r1, =row6
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no6
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no6
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no6
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no6
		b win
no6		ldr r1, =row1
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no7
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no7
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no7
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no7
		b win
no7		ldr r1, =row2
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no8
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no8
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no8
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no8
		b win
no8		ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no9
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no9
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no9
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no9
		b win
no9		ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no10
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no10
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no10
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no10
		b win
no10	ldr r1, =row5
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no11
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no11
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no11
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no11
		b win
no11	ldr r1, =row6
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin11
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin11
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin11
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin11
		b win
		;;;CHECK DOWN;;;
nowin11	ldr r1, =row3
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin12
		ldr r1, =row4
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin12
		ldr r1, =row5
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin12
		ldr r1, =row6
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin12
		b win
nowin12 ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin13
		ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin13
		ldr r1, =row5
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin13
		ldr r1, =row6
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin13
		b win
nowin13	ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin14
		ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin14
		ldr r1, =row5
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin14
		ldr r1, =row6
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin14
		b win
nowin14	ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin15
		ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin15
		ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin15
		ldr r1, =row6
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin15
		b win
nowin15	ldr r1, =row3
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin16
		ldr r1, =row4
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin16
		ldr r1, =row5
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin16
		ldr r1, =row6
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin16
		b win
nowin16	ldr r1, =row3
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin17
		ldr r1, =row4
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin17
		ldr r1, =row5
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin17
		ldr r1, =row6
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin17
		b win
nowin17	ldr r1, =row3
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin18
		ldr r1, =row4
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin18
		ldr r1, =row5
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin18
		ldr r1, =row6
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin18
		b win
		;;;CHECK UP;;;
nowin18	ldr r1, =row4
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin19
		ldr r1, =row3
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin19
		ldr r1, =row2
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin19
		ldr r1, =row1
		ldrb r2, [r1]
		cmp r2, #1
		bne nowin19
		b win
nowin19	ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin20
		ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin20
		ldr r1, =row2
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne nowin20
		ldr r1, =row1
		ldrb r2, [r1, #1]
		cmp r1, #1
		bne nowin20
		b win
nowin20	ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin21
		ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin21
		ldr r1, =row2
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin21
		ldr r1, =row1
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne nowin21
		b win
nowin21	ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin22
		ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin22
		ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin2
		ldr r1, =row1
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne nowin22
		b win
nowin22	ldr r1, =row4
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin23
		ldr r1, =row3
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin23
		ldr r1, =row2
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin23
		ldr r1, =row1
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne nowin23
		b win
nowin23	ldr r1, =row4
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin24
		ldr r1, =row3
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin24
		ldr r1, =row2
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin24
		ldr r1, =row1
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne nowin24
		b win
nowin24	ldr r1, =row4
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne no12
		ldr r1, =row3
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne no12
		ldr r1, =row2
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne no12
		ldr r1, =row1
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne no12
		b win
no12	ldr r1, =row2
		ldrb r2, [r1]
		cmp r2, #1
		bne no13
		ldr r1, =row3
		ldrb r2, [r1]
		cmp r2, #1
		bne no13
		ldr r1, =row4
		ldrb r2, [r1]
		cmp r2, #1
		bne no13
		ldr r1, =row5
		ldrb r2, [r1]
		cmp r2, #1
		bne no13
		b win
no13	ldr r1, =row2
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no14
		ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no14
		ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no14
		ldr r1, =row5
		ldrb r2, [r1, #1]
		cmp r2, #1
		bne no14
		b win
no14	ldr r1, =row2
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no15
		ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no15
		ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no15
		ldr r1, =row5
		ldrb r2, [r1, #2]
		cmp r2, #1
		bne no15
		b win
no15	ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no16
		ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no16
		ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no16
		ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #1
		bne no16
		b win
no16	ldr r1, =row2
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no17
		ldr r1, =row3
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no17
		ldr r1, =row4
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no17
		ldr r1, =row5
		ldrb r2, [r1, #4]
		cmp r2, #1
		bne no17
		b win
no17	ldr r1, =row2
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no18
		ldr r1, =row3
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no18
		ldr r1, =row4
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no18
		ldr r1, =row5
		ldrb r2, [r1, #5]
		cmp r2, #1
		bne no18
		b win
no18	ldr r1, =row2
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin25
		ldr r1, =row3
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin25
		ldr r1, =row4
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin25
		ldr r1, =row5
		ldrb r2, [r1, #6]
		cmp r2, #1
		bne nowin25
		b win
		LTORG		; liteal pool
win		ldr r1, =win1text
loopp
		ldrb r0, [r1], #1	; load character, increment address
		cmp r0, #0		; null terminated?
		blne Transmit		; send character to UART
		bne loopp		; continue if not a '0'
		b exit
nowin25	pop {r5, r6, pc}	; there is no win
;;;;;;;;;;;;;;;;;;;;;;
;   Player 2 Subs    ;
;;;;;;;;;;;;;;;;;;;;;;	

play2row
	push {r5, r6, lr}
	ldr r1, =play2rowtxt
loop2
	ldrb r0, [r1], #1	; load character, increment address
	cmp r0, #0		; null terminated?
	blne Transmit		; send character to UART
	bne loop2		; continue if not a '0'
	pop {r5, r6, pc}
	
play2rowR
	push {r5, r6, lr}			; recieve & store
	ldr r5, = u0start			; recieve
wait3	ldrb r6, [r5, #lsr0]	; logic
	tst	r6, #0x01				; sequence
	beq		wait3				;
	ldrb r0, [r5]				;
	sub r2, r0, #0x30				; row value to r2
	bl Transmit				; mirror to uart window
	pop {r5, r6, pc}
	
play2col
	push {r5, r6, lr}
	ldr r1, =play2coltxt
loop3
	ldrb r0, [r1], #1	; load character, increment address
	cmp r0, #0		; null terminated?
	blne Transmit		; send character to UART
	bne loop3		; continue if not a '0'
	pop {r5, r6, pc}
	
play2colR
	push {r5, r6, lr}			; recieve & store
	ldr r5, = u0start			; recieve
wait4	ldrb r6, [r5, #lsr0]	; logic
	tst	r6, #0x01				; sequence
	beq		wait4				;
	ldrb r0, [r5]				;
	sub r3, r0, #0x30				; col value to r2
	bl Transmit				; mirror to uart window
	pop {r5, r6, pc}

placePiece2
	push {r5, r6, lr}	; places value 1 in table for position of player 1
	sub r3, r3, #1 		; subtract 1 form col for (0-6 scale)
	mov	r4, #2			; store value (2 = player 2)
	cmp r2, #1
	beq row_1
	cmp r2, #2
	beq row_2
	cmp r2, #3
	beq row_3
	cmp r2, #4
	beq row_4
	cmp r2, #5
	beq row_5
	cmp r2, #6
	beq row_6
row1_1 	ldr r5, =row1		; address row 1
		strb r4, [r5, r3]	; store in table
		b done
row1_2	ldr r5, =row2
		strb r4, [r5, r3]
		b done
row1_3	ldr r5, =row3
		strb r4, [r5, r3]
		b done
row1_4	ldr r5, =row4
		strb r4, [r5, r3]
		b done
row1_5	ldr r5, =row5
		strb r4, [r5, r3]
		b done
row1_6	ldr r5, =row6
		strb r4, [r5, r3]
		b done
done	pop {r5, r6, pc}


;;;;CHECK FOR WIN;;;;

Win2
		push {r5, r6, lr}
		; check to left
		ldr r1, =row1
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin
		b wwin
nnowin	ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin1
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin1
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin1
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin1
		b wwin	
nnowin1	ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin2
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin2
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin2
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin2
		b wwin	
nnowin2	ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin3
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin3
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin3
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin3
		b wwin		
nnowin3	ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin4
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin4
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin4
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin4
		b wwin
nnowin4	ldr r1, =row6
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin5
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin5
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin5
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin5
		b wwin
		; check to right
nnowin5	ldr r1, =row1
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin6
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin6
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin6
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin6
		b wwin
nnowin6	ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin7
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin7
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin7
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin7
		b wwin	
nnowin7	ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin8
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin8
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin8
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin8
		b wwin	
nnowin8	ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin9
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin9
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin9
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin9
		b wwin		
nnowin9	ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin10
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin10
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin10
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin10
		b wwin
nnowin10	ldr r1, =row6
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nno
		b wwin
nno	ldr r1, =row1
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno1
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno1
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno1
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno1
		b win
nno1	ldr r1, =row2
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno2
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno2
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno2
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno2
		b win
nno2		ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno3
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno3
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno3
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno3
		b win
nno3	ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno4
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno4
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno4
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno4
		b win
nno4	ldr r1, =row5
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno5
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno5
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno5
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno5
		b win
nno5	ldr r1, =row6
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno6
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno6
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno6
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno6
		b win
nno6	ldr r1, =row1
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno7
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno7
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno7
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno7
		b win
nno7	ldr r1, =row2
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno8
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno8
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno8
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno8
		b win
nno8	ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno9
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno9
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno9
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno9
		b win
nno9		ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno10
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno10
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno10
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno10
		b win
nno10	ldr r1, =row5
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno11
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno11
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno11
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno11
		b win
nno11	ldr r1, =row6
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin11
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin11
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin11
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin11
		b win
		;;;CHECK DOWN;;;
nnowin11	ldr r1, =row3
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin12
		ldr r1, =row4
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin12
		ldr r1, =row5
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin12
		ldr r1, =row6
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin12
		b wwin
nnowin12 ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin13
		ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin13
		ldr r1, =row5
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin13
		ldr r1, =row6
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin13
		b wwin
nnowin13	ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin14
		ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin14
		ldr r1, =row5
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin14
		ldr r1, =row6
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin14
		b wwin
nnowin14	ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin15
		ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin15
		ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin15
		ldr r1, =row6
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin15
		b wwin
nnowin15	ldr r1, =row3
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin16
		ldr r1, =row4
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin16
		ldr r1, =row5
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin16
		ldr r1, =row6
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin16
		b wwin
nnowin16	ldr r1, =row3
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin17
		ldr r1, =row4
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin17
		ldr r1, =row5
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin17
		ldr r1, =row6
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin17
		b wwin
nnowin17	ldr r1, =row3
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin18
		ldr r1, =row4
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin18
		ldr r1, =row5
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin18
		ldr r1, =row6
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin18
		b wwin
		;;;CHECK UP;;;
nnowin18	ldr r1, =row4
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin19
		ldr r1, =row3
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin19
		ldr r1, =row2
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin19
		ldr r1, =row1
		ldrb r2, [r1]
		cmp r2, #2
		bne nnowin19
		b wwin
nnowin19	ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin20
		ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin20
		ldr r1, =row2
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin20
		ldr r1, =row1
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nnowin20
		b wwin
nnowin20	ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin21
		ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin21
		ldr r1, =row2
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin21
		ldr r1, =row1
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nnowin21
		b wwin
nnowin21	ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin22
		ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin22
		ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin2
		ldr r1, =row1
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nnowin22
		b wwin
nnowin22	ldr r1, =row4
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin23
		ldr r1, =row3
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin23
		ldr r1, =row2
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin23
		ldr r1, =row1
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nnowin23
		b wwin
nnowin23	ldr r1, =row4
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin24
		ldr r1, =row3
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin24
		ldr r1, =row2
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin24
		ldr r1, =row1
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nnowin24
		b wwin
nnowin24	ldr r1, =row4
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nno12
		ldr r1, =row3
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nno12
		ldr r1, =row2
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nno12
		ldr r1, =row1
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nno12
		b wwin
nno12	ldr r1, =row2
		ldrb r2, [r1]
		cmp r2, #2
		bne nno13
		ldr r1, =row3
		ldrb r2, [r1]
		cmp r2, #2
		bne nno13
		ldr r1, =row4
		ldrb r2, [r1]
		cmp r2, #2
		bne nno13
		ldr r1, =row5
		ldrb r2, [r1]
		cmp r2, #2
		bne nno13
		b wwin
nno13	ldr r1, =row2
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno14
		ldr r1, =row3
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno14
		ldr r1, =row4
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno14
		ldr r1, =row5
		ldrb r2, [r1, #1]
		cmp r2, #2
		bne nno14
		b wwin
nno14	ldr r1, =row2
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno15
		ldr r1, =row3
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno15
		ldr r1, =row4
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno15
		ldr r1, =row5
		ldrb r2, [r1, #2]
		cmp r2, #2
		bne nno15
		b wwin
nno15	ldr r1, =row2
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno16
		ldr r1, =row3
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno16
		ldr r1, =row4
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno16
		ldr r1, =row5
		ldrb r2, [r1, #3]
		cmp r2, #2
		bne nno16
		b wwin
nno16	ldr r1, =row2
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno17
		ldr r1, =row3
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno17
		ldr r1, =row4
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno17
		ldr r1, =row5
		ldrb r2, [r1, #4]
		cmp r2, #2
		bne nno17
		b wwin
nno17	ldr r1, =row2
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno18
		ldr r1, =row3
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno18
		ldr r1, =row4
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno18
		ldr r1, =row5
		ldrb r2, [r1, #5]
		cmp r2, #2
		bne nno18
		b wwin
nno18	ldr r1, =row2
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin25
		ldr r1, =row3
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin25
		ldr r1, =row4
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin25
		ldr r1, =row5
		ldrb r2, [r1, #6]
		cmp r2, #2
		bne nnowin25
		b wwin
wwin	ldr r1, =win2text
looppp
		ldrb r0, [r1], #1	; load character, increment address
		cmp r0, #0		; null terminated?
		blne Transmit		; send character to UART
		bne looppp		; continue if not a '0'
		b exit
nnowin25	pop {r5, r6, pc}	; there is no win

;;;;;;;;;;;;;;;;;;;;;;
;  Gen Subroutines   ;
;;;;;;;;;;;;;;;;;;;;;;

UARTConfig
	push {r5, r6, lr}
	ldr r5, = pinsel0	; base address of register
	ldr r6, [r5]		; get contents
	bic r6, r6, #0xf		; clear out lower nibble
	orr r6, r6, #0x5	; sets P0.0 to Tx0 and P0.1 to Rx0
	str r6, [r5]		; r/modify/w back to register
	ldr r5, = u0start
	mov r6, #0x83		; set 8 bits, no parity, 1 stop bit
	strb r6, [r5, #lcr0]	; write control byte to LCR
	mov r6, #0x61		; 9600 baud @ 15MHz VPB clock
	strb r6, [r5]		; store control byte
	mov r6, #3		; set DLAB = 0
	strb r6, [r5, #lcr0]	; Tx and Rx buffers set up
	pop {r5, r6, pc}
	
Transmit
	push {r5, r6, lr}
	ldr r5, = u0start
wait	ldrb r6, [r5, #lsr0]	; get status of buffer
	tst r6, #0x20		; buffer empty?
				; in above instruction, text uses cmp, but should be tst
	beq wait		; spin until buffer is empty
	strb r0, [r5]
	pop {r5, r6, pc}

Recieve
	push {r5,r6,lr}
	ldr r5, = u0start
wait0	ldrb r6, [r5, #lsr0]	; status of buffer
	tst	r6, #0x01				; empty?
	beq		wait0
	ldrb r0, [r5]
	pop {r5, r6, pc}
	
Print
	push {r4, r6, lr}
	ldr r0, =0x20		; space (x2)
	bl Transmit
	bl Transmit
	ldr r0, =0x31		; 1
	bl Transmit
	ldr r0, =0x32		; 2
	bl Transmit
	ldr r0, =0x33		; 3
	bl Transmit
	ldr r0, =0x34		; 4
	bl Transmit
	ldr r0, =0x35		; 5
	bl Transmit
	ldr r0, =0x36		; 6
	bl Transmit
	ldr r0, =0x37		; 7
	bl Transmit
	ldr r0, =0xA		; print new line
	bl Transmit
	ldr r0, =0x20		; space x2
	bl Transmit
	bl Transmit
	ldr r0, =0x5F		; _
	bl Transmit
	bl Transmit
	bl Transmit
	bl Transmit
	bl Transmit
	bl Transmit
	bl Transmit
	ldr r0, =0xA		; print new line
	bl Transmit
	;;;;ROW1;;;;
	ldr r1, =row1
	mov r2, #0		; column counter
	ldr r0, =0x31	; row number
	bl Transmit
	ldr r0, =0x7C	; vertical bar
	bl Transmit
ploop
	ldrb r0, [r1], #1	; load character, increment address
	add r0, r0, #0x30	; convert to ASCII character
	add r2, r2, #1		; increment column counter
	bl Transmit		; send character to UART
	cmp r2, #7		
	bne ploop		; continue if not end of row
	ldr r0, =0xA	; new line
	bl Transmit
	;;;;ROW2;;;;
	ldr r1, =row2
	mov r2, #0
	ldr r0, =0x32	; row number
	bl Transmit
	ldr r0, =0x7C	; vertical bar
	bl Transmit
ploop1
	ldrb r0, [r1], #1	; load character, increment address
	add r0, r0, #0x30	; convert to ASCII character
	add r2, r2, #1		; counter of columns
	bl Transmit		; send character to UART
	cmp r2, #7		
	bne ploop1		; continue if not end of row	
	ldr r0, =0xA	; new line
	bl Transmit
	;;;;ROW3;;;;
	ldr r1, =row3
	mov r2, #0
	ldr r0, =0x33	; row number
	bl Transmit
	ldr r0, =0x7C	; vertical bar
	bl Transmit
ploop2
	ldrb r0, [r1], #1	; load character, increment address
	add r0, r0, #0x30	; convert to ASCII character
	add r2, r2, #1		; counter of columns
	bl Transmit		; send character to UART
	cmp r2, #7		
	bne ploop2		; continue if not end of row
	ldr r0, =0xA	; new line
	bl Transmit
	;;;;ROW4;;;;
	ldr r1, =row4
	mov r2, #0
	ldr r0, =0x34	; row number
	bl Transmit
	ldr r0, =0x7C	; vertical bar
	bl Transmit
ploop3
	ldrb r0, [r1], #1	; load character, increment address
	add r0, r0, #0x30	; convert to ASCII character
	add r2, r2, #1		; counter of columns
	bl Transmit		; send character to UART
	cmp r2, #7		
	bne ploop3		; continue if not end of row
	ldr r0, =0xA	; new line
	bl Transmit
	;;;;ROW5;;;;
	ldr r1, =row5
	mov r2, #0
	ldr r0, =0x35	; row number
	bl Transmit
	ldr r0, =0x7C	; vertical bar
	bl Transmit
ploop4
	ldrb r0, [r1], #1	; load character, increment address
	add r0, r0, #0x30	; convert to ASCII character
	add r2, r2, #1		; counter of columns
	bl Transmit		; send character to UART
	cmp r2, #7		
	bne ploop4		; continue if not end of row	
	ldr r0, =0xA	; new line
	bl Transmit	
	;;;;ROW6;;;;
	ldr r1, =row6
	mov r2, #0
	ldr r0, =0x36	; row number
	bl Transmit
	ldr r0, =0x7C	; vertical bar
	bl Transmit
ploop5
	ldrb r0, [r1], #1	; load character, increment address
	add r0, r0, #0x30	; convert to ASCII character
	add r2, r2, #1		; counter of columns
	bl Transmit		; send character to UART
	cmp r2, #7		
	bne ploop5		; continue if not end of row
	ldr r0, =0xA	; new line
	bl Transmit
	pop {r5, r6, pc}
	
PrintNL
	push {r5, r6, lr}
	ldr r0, =0xA
	bl Transmit
	pop {r5, r6, pc}

exit	b	exit

play1rowtxt	DCB  "Player 1- enter a row number:", 0
play1coltxt	DCB  "Player 1- enter a column number:", 0
play2rowtxt	DCB  "Player 2- enter a row number:", 0
play2coltxt	DCB  "Player 2- enter a column number:", 0
win1text	DCB	 "Player 1 wins!", 0
win2text	DCB	 "Player 2 wins!", 0



	area table_data, data, readwrite
row1	DCB	0,0,0,0,0,0,0
row2	DCB	0,0,0,0,0,0,0
row3	DCB 0,0,0,0,0,0,0
row4	DCB 0,0,0,0,0,0,0
row5	DCB 0,0,0,0,0,0,0
row6	DCB	0,0,0,0,0,0,0


	END