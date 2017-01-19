
*-----------------------------------------------------------
*D7 will be used strictly as a flag register. Bit 0 for negation. Bit 1 for carriage return
*D6 will be used to hold the high part BCD value of the number
*D5 will be used to hold the low part BCD value of the number
*D4 will be used to store the sum of the high part of the BCD
*D3 will be used as a calculation register and a counter
*D2 will hold the running sum

START	ORG	$1000


	JSR	Prompt			Prompt the user
	MOVE.B	#1,D3			Set up the counter

Loop
	JSR	Retrieve_Num_String	Gets the string, one character at a time and converts it to BCD
	MOVE.B	D6,D5			Transfer the low part of the BCD number
	ASR.L	#8,D6
	
	ABCD	D5,D2			Add the small part of the BCD together
	ABCD	D6,D4
	LSL.L	#8,D4
	ADD.L	D4,D2
	LSR.L	#8,D4
	
	DBRA	D3,Loop			Loop back
	
Stop
	STOP	#$2700
*------------------------------------------------------Subroutines-------------------------------------------------*

Prompt					*Prompts the user for the numbers.
	LEA	Marker,A1
	MOVE.B	#13,D0
	TRAP	#15
	LEA	User_Prompt, A1
	MOVE.B	#13,D0
	TRAP	#15
	RTS

*Input: D5 as a counter
Retrieve_Num_String			*Takes in the string of numbers the user entered
Check_Sub
	MOVE.L	D3,-(SP)	Preserve D3
	JSR	Read_Char

	MOVE.B	D1,D3		Used to preserve the data taken in
	SUBI.B	#$2D,D3
	BNE	Positive_Num	The number found is positive
	BSET	#0,D7		Sets the negation flag

Positive_Num
	SUBI.B	#$30,D1		Changes the character in to the number representation in ASCII
	MOVE.L	D1,D3
	LSL.L	#8,D3		Puts the number in the proper place fo packed BCD
	MOVE.L	D3,D6

	JSR	Read_Char	Reads the next character

	SUBI.B	#$30,D1		Changes the character in to the number representation in ASCII
	MOVE.L	D1,D3
	LSL.L	#4,D3		Puts the number in the proper place fo packed BCD
	ADD.L	D3,D6		Set up the second part of the BCD number

	JSR	Read_Char

	SUBI.B	#$30,D1		Changes the character in to the number representation in ASCII
	MOVE.L	D1,D3
	ADD.L	D3,D6		Completes the packed BCD number

	JSR	Read_Char
	
	SUBI.B	#$0D,D1
	BNE	Error
	MOVE.L	(SP)+,D3
	RTS	

Error					*Displays the error message to the user
	LEA	Error_Msg,A1
	MOVE.B	#13,D0
	TRAP	#15
	JMP	Retrieve_Num_String

Read_Char
	LEA	Temp,A1		Sets up temporary string holder so the prompt doesn't get overwritten
	MOVE.B	#5,D0
	TRAP	#15
	RTS

*-----------------------------------------------------Data Structure-----------------------------------------------*

Marker
	DC.B	'TO THE MARKER. This program does not work properly... ',0

User_Prompt
	DC.B	'Enter the numbers to add: ',0


	DS.B	1

Temp				*Used as a temporary string holder
	DC.B	0

BCD_High			*Holds the High part of the BCD number
	DC.B	0		Initialized to 0

Error_Msg
	DC.B	'Invalid Number! Please re-enter it:',0
	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~