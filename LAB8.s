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
pin3:    .int   14				    @ pin in pin19 en placa
i:	 	 .int	0
delayMs: .int	250
INPUT1	 =	0
INPUT2   =  0
OUTPUT	 =	1
main: 

 push 	{ip, lr}	@ push return address + dummy register
				@ for alignment

	bl	wiringPiSetup			// Inicializar librería wiringpi
	mov	r1,#-1					// -1 representa un código de error
	cmp	r0, r1					// verifica si se retornó cod error en r0
	bne	init					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y
	b	done					// salir del programa
done:	
        pop 	{ip, pc}	@ pop return address into pc
