*-----------------------------------------------------------
* Program    :	Assignment 10 Question 1
* Written by :	Christian Silivestru	050602990
* Date       :	March 24 2007
* Description:	Demonstration of 
*-----------------------------------------------------------
*D7 will be used to hold a flag used by the CHK exception routine
START	ORG	$1000
	
	MOVE.L	#CHK_Exception,$018	;Set up CHK Exception Vector
	JSR	Prompt_For_Pen

Check_Red
	TST	D1			;Check for red
	BEQ	Pen_Is_Red

Check_Blue
	SUBI.B	#1,D1			;Check for blue
	BEQ	Pen_Is_Blue

Check_Green
	SUBI.B	#1,D1			;Check for green
	BEQ	Pen_Is_Green

Coords_Retrieval
	

Check_X1
	MOVE.B	#Coord_Exception,D7	;Set the exception flag for later
	LEA	PromptX1,A1		;Prompt the user for the first coord
	MOVE.B	#14,D0
	TRAP	#15
	
	MOVE.B	#4,D0
	TRAP	#15
	CHK	#Max_CoordX,D1
	TST	D7			;If exception happened, this register will contain a zero
	BEQ	Check_X1
	MOVE.W	D1,D2			;Preserve coord

Check_Y1
	MOVE.B	#Coord_Exception,D7	;Set the exception flag for later
	LEA	PromptY1,A1		;Prompt for second coord
	MOVE.B	#14,D0
	TRAP	#15
	
	MOVE.B	#4,D0
	TRAP	#15
	CHK	#Max_CoordY,D1
	TST	D7			;If exception happened, D7 will be cleared
	BEQ	Check_Y1
	MOVE.W	D1,D3			;Preserve coord

Check_X2
	MOVE.B	#Coord_Exception,D7	;Set the exception flag for later
	LEA	PromptX2,A1		;Prompt for third coord
	MOVE.B	#14,D0
	TRAP	#15
	
	MOVE.B	#4,D0
	TRAP	#15
	CHK	#Max_CoordX,D1
	TST	D7			;If exception happened, D7 will be clear
	BEQ	Check_X2
	MOVE.W	D1,D4			;Preserve coord

Check_Y2
	MOVE.B	#Coord_Exception,D7	;Set the exception flag for later
	LEA	PromptY2,A1		;Final prompt for coords
	MOVE.B	#14,D0
	TRAP	#15
	
	MOVE.B	#4,D0
	TRAP	#15
	CHK	#Max_CoordY,D1
	TST	D7			;If exception happened, D7 will be clear
	BEQ	Check_Y2
	MOVE.W	D1,D5			;Preserve coord

	JSR	Clear_Screen

Draw_Line
	MOVE.W	D2,D1			;Put all the coords in their rightful spots
	MOVE.W	D3,D2
	MOVE.W	D4,D3
	MOVE.W	D5,D4

	MOVE.B	#84,D0			;Draw the line
	TRAP	#15

	JSR	Wait_For_Char
	JMP	START			;Infinite loop

Stop
	STOP	#$2700

*--------------------------------------Subroutines---------------------------------------*

Prompt_For_Pen
	LEA	PromptPen,A1
	MOVE.B	#14,D0
	TRAP	#15

Get_Pen_Colour
	LEA	Temp,A1			;Change the address of A1 to avoid overwriting prompt
	MOVE.B	#Pen_Exception,D7		;Used to let the CHK routine know which routine to execute
	MOVE.B	#4,D0
	TRAP	#15
	CHK	#Max_Colour,D1
	RTS

*------------------------------------Set pen colours-------------------------*
Pen_Is_Red
	MOVE.L	#Red,D1			
	MOVE.B	#80,D0
	TRAP	#15
	JMP	Check_Blue

Pen_Is_Blue
	MOVE.L	#Blue,D1
	MOVE.B	#80,D0
	TRAP	#15
	JMP	Check_Green

Pen_Is_Green
	MOVE.L	#Green,D1
	MOVE.B	#80,D0
	TRAP	#15
	JMP	Coords_Retrieval
*---------------------------------------------------------------------------*

*-------------------------------Screen Management---------------------------*
Clear_Screen
	MOVE.W	#$FF00,D1
	MOVE.B	#11,D0
	TRAP	#15
	RTS

Wait_For_Char
	MOVE.B	#5,D0
	TRAP	#15
	
	MOVE.W	#$FF00,D1
	MOVE.B	#11,D0
	TRAP	#15
	RTS
*--------------------------------------------------------------------------*

CHK_Exception
	TST	D7			;Based on what's in D7, the exception happened at a different time
	BNE	Coord_Exception_Routine

Pen_Exception_Routine
	LEA	Pen_error,A1		;Re-prompt the user
	MOVE.B	#13,D0
	TRAP	#15
	JSR	Prompt_For_Pen		;Recursive call to CHK happens here
	JMP	End_Of_Excecution

Coord_Exception_Routine
	LEA	Coord_Error,A1
	MOVE.B	#13,D0
	TRAP	#15
	MOVE.B	#0,D7		;Use D7	as a flag register. This means an error happened

End_Of_Excecution
	RTE
	
*-------------------------------------Data Structure-------------------------------------*

PromptPen
	DC.B	'Enter the pen colour (0 for Red, 1 for Blue or  2 for Green): ',0

PromptX1
	DC.B	'Enter the x-coordinate of the first point: ',0

PromptY1
	DC.B	'Enter the y-coordinate of the first point: ',0

PromptX2
	DC.B	'Enter the x-coordinate of the second point: ',0

PromptY2
	DC.B	'Enter the y-coordinate of the second point: ',0

Coord_Error
	DC.B	'Invalid Coordinate value!',0

Pen_Error
	DC.B	'Invalid Pen Value!',0

Temp	DS.B	1		;Temp storage to hold responses from user

Pen_Exception	EQU	0

Coord_Exception	EQU	1

Red	EQU	$000000FF	;The colours in hex format
Blue	EQU	$00FF0000
Green	EQU	$0000FF00
Max_CoordX	EQU	640

Max_CoordY	EQU	480

Max_Colour	Equ	2

	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~