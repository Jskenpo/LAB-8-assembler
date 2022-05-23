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
pin3:    .int   22				    @ pin in pin19 en placa
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
    @------- set pinMode

init:

	ldr	r0, =pin1				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode					// llama funcion wiringpi para configurar

    ldr	r0, =pin3				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode					// llama funcion wiringpi para configurar
	
	ldr	r0, =pin2				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar
	
@------- if gpio == 1			// si se activa switch entrada gpio4

ejecutar1:
    @------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#0
	beq	ejecutar1 
    ldr r6,[r0]               // si es 0, entonces seguir ejecutando

@------- digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO
	
@------- delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay


    cmp r6,#1
    beq ejecutar2


ejecutar2:
    @------- delay(250)	
    
    ldr	r0, =delayMs
    ldr	r0, [r0]
    bl	delay
    
    ldr	r0, =pin3				// carga dirección de pin
    ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
    bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
    cmp	r0,#0
    beq	ejecutar2

    cmpeq r6,r0
@------- digitalWrite(pin, 0) 	;
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite

    


done:	
        pop 	{ip, pc}	@ pop return address into pc
