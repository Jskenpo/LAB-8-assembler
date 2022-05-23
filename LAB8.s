/*
Organización de computadoras y assembler 
Laboratorio 8 
Manipulación de inputs y outputs
Jose Santisteban 
Brandon Sicay
*/

.data
.balign 4	
Intro: 	 .asciz  "Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
pin1:	 .int	4					@ pin in pin16 en placa
pin2:	 .int   5					@ pin out pin18 en placa	
i:	 	 .int	0
delayMs: .int	250
INPUT1	 =	0
INPUT2   =  0
OUTPUT	 =	1

