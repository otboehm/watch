*-----------------------------------------------------------
* Program    : 	Assignment 4 Question 1
* Written by :	Christian Silivestru	050602990
* Date       :	Feb 1st 2007
* Description:	Find the smallest input entered by the user and output it
*-----------------------------------------------------------
*	D3 will be used to store the Count
*	D4 will hold the biggest 16-bit number when the compare is done
*	D5 will hold the smallest number entered by the user


START	ORG	$1000

	JSR	Count_Prompt		Prompt the user for the count
	JSR	Retrieve_Number		Store the count
	TST	D1			Check to see if they entered a negative # (invalid)
	BMI	Invalid_Count
	CMP.W	#255,D1			Check to see if the number they entered is too big
	BCC	Invalid_Count
	MOVE.L	D1,D3			If everything is ok, store count D3
	MOVE.L	Biggest_Num,D5		Sets up for storing the smallest number entered by entering the biggest number possible

Loop
	JSR	Number_Prompt		Prompt the user for the next number they want to enter
	JSR	Retrieve_Number		and retrieve it
	MOVE.L	Biggest_Num,D4		Set up for the comparison
	CMP.L	D1,D4			Subtract the number we just retrieved from the biggest possible
	BLT	Invalid_Number		If the number entered is too big, take in a new number
	MOVE.L	Smallest_Num,D4
	CMP.L	D1,D4
	BGT	Invalid_Number		If the number is too small, take in a new number
	CMP.L	D5,D1
	BLT	Replace_Smallest	If the number entered is the new smallest number, replace it

After_Replace
	SUBI.B	#1,D3			If that's the last number, exit the loop
	BEQ	Done
	BRA	Loop			Otherwise ask the user for the next number to be inputted

Invalid_Number
	JMP	Error

Done
	JSR	Output_Number		Displays the smallest number entered

Stop
	STOP	#$2700
	


*---------------------------------------Subroutines--------------------------------------------*
Invalid_Count				*Get another number from the user
	LEA	Invalid_Count_Message,A1	Output error message
	MOVE.B	#13,D0
	TRAP	#15
	JMP	START			Repeat getting the number from the user

Count_Prompt				*Prompt the user for the length of their datalist
	LEA	Count_Prompt_Message,A1
	MOVE.B	#14,D0
	TRAP	#15
	RTS

Retrieve_Number				*Read a number inputted by the user
	MOVE.B	#4,D0
	TRAP	#15
	RTS

Number_Prompt				*Prompt for the next number in the datalist
	LEA	Number_Prompt_Message,A1
	MOVE.B	#14,D0
	TRAP	#15
	RTS

Error					*Prints error message and prompts user for another number
	LEA	Error_Message,A1
	MOVE.B	#13,D0
	TRAP	#15
	JMP	Loop

Replace_Smallest			*Replace the smallest number entered with the most recent number
	MOVE.L	D1,D5
	JMP	After_Replace
	

Output_Number				*Outputs the smallest number entered
	MOVE.L	D5,D1
	MOVE.B	#10,D2			Set up so it prints the number in decimal
	LEA	Output_Message,A1
	MOVE.B	#14,D0
	TRAP	#15

Display_Num
	MOVE.B	#3,D0			Prints the number
	TRAP	#15
	RTS
	


*-------------------------------------Data Structure-------------------------------------------*
Count_Prompt_Message
	DC.B	'How many numbers will you enter? (0-255): ',0

Number_Prompt_Message
	DC.B	'Enter a number between -32768 and 32767: ',0

Invalid_Count_Message
	DC.B	'Invalid Number!',0

Output_Message
	DC.B	'The smallest number is: ',0

Error_Message
	DC.B	'Number out of range',0

Biggest_Num		*The biggest signed 16-bit number
	DC.L	$00007FFF

Smallest_Num		*The smallest signed 16-bit number
	DC.L	$FFFF8000

Smallest_Data_Num	*Stores the smallest number that the user entered
	DS.W	1

	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~