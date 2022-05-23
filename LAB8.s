/*
Organización de computadoras y assembler 
Laboratorio 8 
Manipulación de inputs y outputs
-- Jose Santisteban 
-- Brandon Sicay

@ Description: 
@ turn on pin2 when pressing button on wPi 8
@ and turn of pin2 when pressing button on wPi 4
*/

@ ---------------------------------------
@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	 .data
	 .balign 4	
Intro: 	 .asciz  "Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
pin1:	 .int	4					@ pin in pin16 en placa
pin2:	 .int   5					@ pin out pin18 en placa
pin3:	 .int   8					@ pin out pin3 en placa	
i:	 	 .int	0
INPUT	 =	0
OUTPUT	 =	1
	
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
	.text
	.global main
	.extern printf
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern pinMode
	
main:   push 	{ip, lr}	@ push return address + dummy register
				@ for alignment

	bl	wiringPiSetup			// Inicializar librería wiringpi
	mov	r1,#-1					// -1 representa un código de error
	cmp	r0, r1					// verifica si se retornó cod error en r0
	bne	init					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y
	b	done					// salir del programa

@------- set pinMode
init:
	
	ldr	r0, =pin3				// coloca el #pin3 wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode 				// llama funcion wiringpi para configurar
	
	ldr	r0, =pin1				// coloca el #pin1 wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode					// llama funcion wiringpi para configurar
	
	ldr	r0, =pin2				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar
	
	ldr	r4, =i					// carga valor de contador en r4
	ldr	r4, [r4]
	mov	r5, #5					// cantidad de vueltas
	
@------- if gpio == 1			// si se activa switch entrada gpio4
try:
	
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#1					// switch NA, por lo que pasa corriente (1) hasta que se presione
	beq	try
	cmpne r0,#0					// si se presiona llama a subrutina ledOn
	beq ledOn


ledOn:	
	@------- digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#0
	beq	ledOn
	
ledOf:	
	@------- digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0					// apaga led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	add	r4, #1					// incrementa contador
	cmp	r4, r5
	bgt	done					// si el ciclo se ha completado 5 veces
								// entonces termina programa	
	b try
	
done:	
        pop 	{ip, pc}	@ pop return address into pc

