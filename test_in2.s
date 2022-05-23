@ prueba_in1.s
@ 
@ based on D. Thiebaut C program:
@ 
@ ---------------------------------------
@ Modified: 
@ K. Barrera
@ 2022-05-13
@ Ver. 1.2@ Description: 
@ blinking 1 time pin wPi 4, when 
@ pressing button on wPi 5
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
i:	 	 .int	0
delayMs: .int	250
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
	ldr	r0, =pin1				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode					// llama funcion wiringpi para configurar
	
	
	ldr	r0, =pin2				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar
	
@------- if gpio == 1			// si se activa switch entrada gpio4
try:
	@------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#0
	beq	try
	

	
@------- for ( i=0; i<10; i++ ) { 
	ldr	r4, =i					// carga valor de contador en 10
	ldr	r4, [r4]
	mov	r5, #10
forLoop:						// inicio de ciclo 
	cmp	r4, r5
	bgt	done					// si el ciclo se ha completado 10 veces
								// entonces termina programa
@------- digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO
	
@------- delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

@------- digitalWrite(pin, 0) 	;
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 0 en pin para desactivar puerto GPIO

@------- delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

	add	r4, #1					// incrementa contador
	b	try					// repite ciclo
	
done:	
        pop 	{ip, pc}	@ pop return address into pc
