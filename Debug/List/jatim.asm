
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 12,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _sen=R4
	.DEF _sen_msb=R5
	.DEF _pot=R6
	.DEF _pot_msb=R7
	.DEF _pb=R8
	.DEF _pb_msb=R9
	.DEF _vrx=R10
	.DEF _vrx_msb=R11
	.DEF _vry=R12
	.DEF _vry_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0xC7,0xBB,0xB3,0xAB,0x9B,0xBB,0xC7,0xFF
	.DB  0xEF,0xCF,0xEF,0xEF,0xEF,0xEF,0xC7,0xFF
	.DB  0xC7,0xBB,0xFB,0xF7,0xEF,0xDF,0x83,0xFF
	.DB  0xC7,0xBB,0xFB,0xE7,0xFB,0xBB,0xC7,0xFF
	.DB  0xF7,0xEF,0xDB,0xBB,0x83,0xFB,0xFB,0xFF
	.DB  0x83,0xBF,0x87,0xFB,0xFB,0xFB,0x87,0xFF
	.DB  0xC7,0xBB,0xBF,0x87,0xBB,0xBB,0xC7,0xFF
	.DB  0x83,0xFB,0xF7,0xEF,0xDF,0xBF,0xBF,0xFF
	.DB  0xC7,0xBB,0xBB,0x83,0xBB,0xBB,0xC7,0xFF
	.DB  0xC7,0xBB,0xBB,0xC3,0xFB,0xBB,0xC7,0xFF
_0x4:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x7,0x7F,0x7F,0xF,0x7F,0x7F,0x7F,0xFF
	.DB  0x8F,0x77,0x77,0x7,0x77,0x77,0x77,0xFF
	.DB  0x8F,0x77,0x7F,0x8F,0xF7,0x77,0x8F,0xFF
	.DB  0x7,0x7F,0x7F,0xF,0x7F,0x7F,0x7,0xFF
	.DB  0x8F,0x77,0xF7,0xEF,0xDF,0xBF,0x7,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x5:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x8F,0x77,0x7F,0x8F,0xF7,0x77,0x8F,0xFF
	.DB  0x77,0x27,0x57,0x77,0x77,0x77,0x77,0xFF
	.DB  0x77,0x6F,0x5F,0x3F,0x5F,0x6F,0x77,0xFF
	.DB  0xF,0x77,0x77,0xF,0x77,0x77,0xF,0xFF
	.DB  0x1F,0xBF,0xBF,0xBF,0xBF,0xBF,0x1F,0xFF
	.DB  0x8F,0x77,0x7F,0x8F,0xF7,0x77,0x8F,0xFF
	.DB  0x8F,0x77,0x77,0x7,0x77,0x77,0x77,0xFF
	.DB  0xFF,0xFF,0xFF,0x7,0xFF,0xFF,0xFF,0xFF
	.DB  0xC7,0xBB,0xB3,0xAB,0x9B,0xBB,0xC7,0xFF
	.DB  0xC7,0xBB,0xBB,0x83,0xBB,0xBB,0xC7,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x6:
	.DB  0x1F,0x5F,0x5F,0x5F,0x1F,0xFF,0xFF,0xFF
	.DB  0xBF,0x3F,0xBF,0xBF,0x1F,0xFF,0xFF,0xFF
	.DB  0x1F,0xDF,0x1F,0x7F,0x1F,0xFF,0xFF,0xFF
	.DB  0x1F,0xDF,0x1F,0xDF,0x1F,0xFF,0xFF,0xFF
	.DB  0x5F,0x5F,0x1F,0xDF,0xDF,0xFF,0xFF,0xFF
	.DB  0x1F,0x7F,0x1F,0xDF,0x1F,0xFF,0xFF,0xFF
	.DB  0x1F,0x7F,0x1F,0x5F,0x1F,0xFF,0xFF,0xFF
	.DB  0x1F,0xDF,0xDF,0xDF,0xDF,0xFF,0xFF,0xFF
	.DB  0x1F,0x5F,0x1F,0x5F,0x1F,0xFF,0xFF,0xFF
	.DB  0x1F,0x5F,0x1F,0xDF,0x1F,0xFF,0xFF,0xFF
_0x7:
	.DB  0xF1,0xF5,0xF5,0xF5,0xF1,0xFF,0xFF,0xFF
	.DB  0xFB,0xF3,0xFB,0xFB,0xF1,0xFF,0xFF,0xFF
	.DB  0xF1,0xFD,0xF1,0xF7,0xF1,0xFF,0xFF,0xFF
	.DB  0xF1,0xFD,0xF1,0xFD,0xF1,0xFF,0xFF,0xFF
	.DB  0xF5,0xF5,0xF1,0xFD,0xFD,0xFF,0xFF,0xFF
	.DB  0xF1,0xF7,0xF1,0xFD,0xF1,0xFF,0xFF,0xFF
	.DB  0xF1,0xF7,0xF1,0xF5,0xF1,0xFF,0xFF,0xFF
	.DB  0xF1,0xFD,0xFD,0xFD,0xFD,0xFF,0xFF,0xFF
	.DB  0xF1,0xF5,0xF1,0xF5,0xF1,0xFF,0xFF,0xFF
	.DB  0xF1,0xF5,0xF1,0xFD,0xF1,0xFF,0xFF,0xFF
_0x8:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xE7,0xC3,0x81,0x0,0xC3,0xC3,0xC3,0xC3
	.DB  0xEF,0xCF,0x80,0x0,0x0,0x80,0xCF,0xEF
	.DB  0xF7,0xF3,0x1,0x0,0x0,0x1,0xF3,0xF7
	.DB  0xC3,0xC3,0xC3,0xC3,0x0,0x81,0xC3,0xE7
_0x0:
	.DB  0x45,0x53,0x50,0x20,0x46,0x41,0x53,0x45
	.DB  0x20,0x33,0x0,0x4C,0x4B,0x53,0x20,0x4B
	.DB  0x45,0x2D,0x32,0x38,0x2F,0x32,0x30,0x32
	.DB  0x30,0x0,0x42,0x41,0x54,0x41,0x53,0x20
	.DB  0x42,0x41,0x57,0x41,0x48,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x25,0x32,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x42,0x41,0x54
	.DB  0x41,0x53,0x20,0x54,0x45,0x4E,0x47,0x41
	.DB  0x48,0x20,0x20,0x20,0x0,0x25,0x32,0x64
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x42,0x41
	.DB  0x54,0x41,0x53,0x20,0x41,0x54,0x41,0x53
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x4B
	.DB  0x4F,0x4D,0x50,0x41,0x52,0x41,0x54,0x4F
	.DB  0x52,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x54,0x45,0x4D,0x50,0x3A,0x25,0x2E,0x32
	.DB  0x66,0x27,0x43,0x20,0x20,0x0,0x54,0x45
	.DB  0x4B,0x41,0x4E,0x20,0x53,0x31,0x20,0x73
	.DB  0x2F,0x64,0x20,0x53,0x34,0x20,0x0,0x4E
	.DB  0x49,0x4C,0x41,0x49,0x20,0x54,0x45,0x4E
	.DB  0x47,0x41,0x48,0x20,0x20,0x20,0x20,0x0
	.DB  0x50,0x55,0x54,0x41,0x52,0x20,0x50,0x4F
	.DB  0x54,0x45,0x4E,0x53,0x49,0x4F,0x20,0x20
	.DB  0x0,0x4E,0x49,0x4C,0x41,0x49,0x20,0x41
	.DB  0x54,0x41,0x53,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x25,0x32,0x64,0x20,0x25,0x32
	.DB  0x64,0x20,0x25,0x32,0x64,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x54,0x45,0x4D,0x50
	.DB  0x3A,0x25,0x2E,0x32,0x66,0x27,0x43,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x50
	.DW  _angka
	.DW  _0x3*2

	.DW  0x60
	.DW  _smk
	.DW  _0x5*2

	.DW  0x50
	.DW  _puluhan
	.DW  _0x6*2

	.DW  0x50
	.DW  _satuan
	.DW  _0x7*2

	.DW  0x28
	.DW  _arah
	.DW  _0x8*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 29/01/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 12,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <stdlib.h>
;#include <stdio.h>
;#include <string.h>
;
;#define latch0 PORTB.1=0;
;#define latch1 PORTB.1=1;
;#define data0 PORTB.2=1;
;#define data1 PORTB.2=0;
;#define clk0 PORTB.0=0;
;#define clk1 PORTB.0=1;
;
;unsigned char angka[10][8]={
;                       {0b11000111,
;                        0b10111011,
;                        0b10110011,
;                        0b10101011,
;                        0b10011011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b11101111,
;                        0b11001111,
;                        0b11101111,
;                        0b11101111,
;                        0b11101111,
;                        0b11101111,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b11111011,
;                        0b11110111,
;                        0b11101111,
;                        0b11011111,
;                        0b10000011,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b11111011,
;                        0b11100111,
;                        0b11111011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b11110111,
;                        0b11101111,
;                        0b11011011,
;                        0b10111011,
;                        0b10000011,
;                        0b11111011,
;                        0b11111011,
;                        0b11111111},
;
;                       {0b10000011,
;                        0b10111111,
;                        0b10000111,
;                        0b11111011,
;                        0b11111011,
;                        0b11111011,
;                        0b10000111,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b10111111,
;                        0b10000111,
;                        0b10111011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b10000011,
;                        0b11111011,
;                        0b11110111,
;                        0b11101111,
;                        0b11011111,
;                        0b10111111,
;                        0b10111111,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b10111011,
;                        0b10000011,
;                        0b10111011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b10111011,
;                        0b11000011,
;                        0b11111011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111}};

	.DSEG
;
;unsigned char fase[7][8]={
;                       {0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00000111,
;                        0b01111111,
;                        0b01111111,
;                        0b00001111,
;                        0b01111111,
;                        0b01111111,
;                        0b01111111,
;                        0b11111111},
;
;                       {0b10001111,
;                        0b01110111,
;                        0b01110111,
;                        0b00000111,
;                        0b01110111,
;                        0b01110111,
;                        0b01110111,
;                        0b11111111},
;
;                       {0b10001111,
;                        0b01110111,
;                        0b01111111,
;                        0b10001111,
;                        0b11110111,
;                        0b01110111,
;                        0b10001111,
;                        0b11111111},
;
;                       {0b00000111,
;                        0b01111111,
;                        0b01111111,
;                        0b00001111,
;                        0b01111111,
;                        0b01111111,
;                        0b00000111,
;                        0b11111111},
;
;                       {0b10001111,
;                        0b01110111,
;                        0b11110111,
;                        0b11101111,
;                        0b11011111,
;                        0b10111111,
;                        0b00000111,
;                        0b11111111},
;
;                       {0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111}};
;
;unsigned char smk[12][8]={
;                       {0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b10001111,
;                        0b01110111,
;                        0b01111111,
;                        0b10001111,
;                        0b11110111,
;                        0b01110111,
;                        0b10001111,
;                        0b11111111},
;
;                       {0b01110111,
;                        0b00100111,
;                        0b01010111,
;                        0b01110111,
;                        0b01110111,
;                        0b01110111,
;                        0b01110111,
;                        0b11111111},
;
;                       {0b01110111,
;                        0b01101111,
;                        0b01011111,
;                        0b00111111,
;                        0b01011111,
;                        0b01101111,
;                        0b01110111,
;                        0b11111111},
;
;                       {0b00001111,
;                        0b01110111,
;                        0b01110111,
;                        0b00001111,
;                        0b01110111,
;                        0b01110111,
;                        0b00001111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b10111111,
;                        0b10111111,
;                        0b10111111,
;                        0b10111111,
;                        0b10111111,
;                        0b00011111,
;                        0b11111111},
;
;                       {0b10001111,
;                        0b01110111,
;                        0b01111111,
;                        0b10001111,
;                        0b11110111,
;                        0b01110111,
;                        0b10001111,
;                        0b11111111},
;
;                       {0b10001111,
;                        0b01110111,
;                        0b01110111,
;                        0b00000111,
;                        0b01110111,
;                        0b01110111,
;                        0b01110111,
;                        0b11111111},
;
;                       {0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b00000111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b10110011,
;                        0b10101011,
;                        0b10011011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b11000111,
;                        0b10111011,
;                        0b10111011,
;                        0b10000011,
;                        0b10111011,
;                        0b10111011,
;                        0b11000111,
;                        0b11111111},
;
;                       {0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111}};
;
;unsigned char puluhan[10][8]={
;                       {0b00011111,
;                        0b01011111,
;                        0b01011111,
;                        0b01011111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b10111111,
;                        0b00111111,
;                        0b10111111,
;                        0b10111111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b11011111,
;                        0b00011111,
;                        0b01111111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b11011111,
;                        0b00011111,
;                        0b11011111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b01011111,
;                        0b01011111,
;                        0b00011111,
;                        0b11011111,
;                        0b11011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b01111111,
;                        0b00011111,
;                        0b11011111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b01111111,
;                        0b00011111,
;                        0b01011111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b11011111,
;                        0b11011111,
;                        0b11011111,
;                        0b11011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b01011111,
;                        0b00011111,
;                        0b01011111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b00011111,
;                        0b01011111,
;                        0b00011111,
;                        0b11011111,
;                        0b00011111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111}};
;
;unsigned char satuan[10][8]={
;                       {0b11110001,
;                        0b11110101,
;                        0b11110101,
;                        0b11110101,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11111011,
;                        0b11110011,
;                        0b11111011,
;                        0b11111011,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11111101,
;                        0b11110001,
;                        0b11110111,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11111101,
;                        0b11110001,
;                        0b11111101,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110101,
;                        0b11110101,
;                        0b11110001,
;                        0b11111101,
;                        0b11111101,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11110111,
;                        0b11110001,
;                        0b11111101,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11110111,
;                        0b11110001,
;                        0b11110101,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11111101,
;                        0b11111101,
;                        0b11111101,
;                        0b11111101,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11110101,
;                        0b11110001,
;                        0b11110101,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11110001,
;                        0b11110101,
;                        0b11110001,
;                        0b11111101,
;                        0b11110001,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111}};
;
;unsigned char arah[5][8]={
;                       {0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111,
;                        0b11111111},
;
;                       {0b11100111,
;                        0b11000011,
;                        0b10000001,
;                        0b00000000,
;                        0b11000011,
;                        0b11000011,
;                        0b11000011,
;                        0b11000011},
;
;                       {0b11101111,
;                        0b11001111,
;                        0b10000000,
;                        0b00000000,
;                        0b00000000,
;                        0b10000000,
;                        0b11001111,
;                        0b11101111},
;
;                       {0b11110111,
;                        0b11110011,
;                        0b00000001,
;                        0b00000000,
;                        0b00000000,
;                        0b00000001,
;                        0b11110011,
;                        0b11110111},
;
;                       {0b11000011,
;                        0b11000011,
;                        0b11000011,
;                        0b11000011,
;                        0b00000000,
;                        0b10000001,
;                        0b11000011,
;                        0b11100111}};
;
;
;// Declare your global variables here
;
;unsigned int read_adc(unsigned char adc_input);
;int sen,pot,pb,vrx,vry;
;int suhu,jx,jy,joy,menu,level,push,lastc7,latchmenu,resbit,lvlpul,lvlsat,bawah,atas,tengah;
;int i;
;int j;
;int p;
;float vADC,temp;
;int menu=0;
;char datalcd[16];
;unsigned char bitresult[8];
;
;void bitwise(int x)
; 0000 0224 {

	.CSEG
_bitwise:
; .FSTART _bitwise
; 0000 0225   int pul,sat,k;
; 0000 0226   pul=x/10;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	x -> Y+6
;	pul -> R16,R17
;	sat -> R18,R19
;	k -> R20,R21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R16,R30
; 0000 0227   sat=x%10;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R18,R30
; 0000 0228   for(k=0;k<8;k++)
	__GETWRN 20,21,0
_0xA:
	__CPWRN 20,21,8
	BRGE _0xB
; 0000 0229   {
; 0000 022A     bitresult[k]=puluhan[pul][k]&satuan[sat][k];
	MOVW R30,R20
	SUBI R30,LOW(-_bitresult)
	SBCI R31,HIGH(-_bitresult)
	MOVW R0,R30
	MOVW R30,R16
	CALL __LSLW3
	SUBI R30,LOW(-_puluhan)
	SBCI R31,HIGH(-_puluhan)
	ADD  R30,R20
	ADC  R31,R21
	LD   R26,Z
	MOVW R30,R18
	CALL __LSLW3
	SUBI R30,LOW(-_satuan)
	SBCI R31,HIGH(-_satuan)
	ADD  R30,R20
	ADC  R31,R21
	LD   R30,Z
	AND  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0000 022B   }
	__ADDWRN 20,21,1
	RJMP _0xA
_0xB:
; 0000 022C }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;void matrix(unsigned char input_data[8])
; 0000 022F {
_matrix:
; .FSTART _matrix
; 0000 0230   unsigned int nilai_t16;
; 0000 0231   for(i=0;i<8;i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	input_data -> Y+2
;	nilai_t16 -> R16,R17
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0xD:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,8
	BRLT PC+2
	RJMP _0xE
; 0000 0232   {
; 0000 0233     nilai_t16=(0x01<<(15-i)) + input_data[i];
	LDS  R26,_i
	LDS  R27,_i+1
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOVW R0,R30
	LDS  R30,_i
	LDS  R31,_i+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
; 0000 0234     latch0;
	CBI  0x18,1
; 0000 0235     for(j=0;j<=15;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
	STS  _j+1,R30
_0x12:
	LDS  R26,_j
	LDS  R27,_j+1
	SBIW R26,16
	BRGE _0x13
; 0000 0236     {
; 0000 0237       if((nilai_t16) & (0x01 << j))
	LDS  R30,_j
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	AND  R30,R16
	AND  R31,R17
	SBIW R30,0
	BREQ _0x14
; 0000 0238       {data1;}
	CBI  0x18,2
; 0000 0239       else
	RJMP _0x17
_0x14:
; 0000 023A       {data0;}
	SBI  0x18,2
_0x17:
; 0000 023B       clk1;
	SBI  0x18,0
; 0000 023C       delay_us(10);
	__DELAY_USB 40
; 0000 023D       clk0;
	CBI  0x18,0
; 0000 023E       delay_us(10);
	__DELAY_USB 40
; 0000 023F     }
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	CALL SUBOPT_0x0
	RJMP _0x12
_0x13:
; 0000 0240     latch1;
	SBI  0x18,1
; 0000 0241   }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL SUBOPT_0x0
	RJMP _0xD
_0xE:
; 0000 0242 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void scrollmtx(unsigned int datalength, unsigned char data[datalength][8])
; 0000 0245 {
_scrollmtx:
; .FSTART _scrollmtx
; 0000 0246     int kl,lm,mn;
; 0000 0247     unsigned char buff_geser[8];
; 0000 0248 
; 0000 0249     for(kl=0;kl<(datalength-1)*8;kl++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,8
	CALL __SAVELOCR6
;	datalength -> Y+16
;	data -> Y+14
;	kl -> R16,R17
;	lm -> R18,R19
;	mn -> R20,R21
;	buff_geser -> Y+6
	__GETWRN 16,17,0
_0x21:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	CALL __LSLW3
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x22
; 0000 024A     {
; 0000 024B       for(lm=0;lm<8;lm++)
	__GETWRN 18,19,0
_0x24:
	__CPWRN 18,19,8
	BRGE _0x25
; 0000 024C       {
; 0000 024D         buff_geser[lm]=data[kl/8][lm]<<(kl%8) | (data[kl/8+1][lm] >>(8-(kl%8)));
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 23,24
	MOVW R26,R16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	CALL SUBOPT_0x1
	MOV  R26,R0
	CALL __LSLB12
	MOV  R22,R30
	MOVW R26,R16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	ADIW R30,1
	CALL SUBOPT_0x1
	LDI  R26,LOW(8)
	CALL __SWAPB12
	SUB  R30,R26
	MOV  R26,R0
	CALL __LSRB12
	OR   R30,R22
	__GETW2R 23,24
	ST   X,R30
; 0000 024E       }
	__ADDWRN 18,19,1
	RJMP _0x24
_0x25:
; 0000 024F 
; 0000 0250       for(mn=0;mn<5;mn++)
	__GETWRN 20,21,0
_0x27:
	__CPWRN 20,21,5
	BRGE _0x28
; 0000 0251       {
; 0000 0252         matrix(buff_geser);
	MOVW R26,R28
	ADIW R26,6
	RCALL _matrix
; 0000 0253       }
	__ADDWRN 20,21,1
	RJMP _0x27
_0x28:
; 0000 0254     }
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 0255 }
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0259 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x2
; 0000 025A // Reinitialize Timer 0 value
; 0000 025B TCNT0=0x44;
	LDI  R30,LOW(68)
	OUT  0x32,R30
; 0000 025C // Place your code here
; 0000 025D     delay_us(100);
	CALL SUBOPT_0x3
; 0000 025E     pot=read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	MOVW R6,R30
; 0000 025F     delay_us(100);
	CALL SUBOPT_0x3
; 0000 0260     pb=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	MOVW R8,R30
; 0000 0261     delay_us(100);
	CALL SUBOPT_0x3
; 0000 0262     vrx=read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	MOVW R10,R30
; 0000 0263     delay_us(100);
	CALL SUBOPT_0x3
; 0000 0264     vry=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOVW R12,R30
; 0000 0265 
; 0000 0266     if(vrx>300 && vrx<700){jx=0;}
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x2A
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	LDI  R30,LOW(0)
	STS  _jx,R30
	STS  _jx+1,R30
; 0000 0267     else if(vrx>700){jx=1;}
	RJMP _0x2C
_0x29:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x2D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB5
; 0000 0268     else if(vrx<300){jx=2;}
_0x2D:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x2F
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB5:
	STS  _jx,R30
	STS  _jx+1,R31
; 0000 0269 
; 0000 026A     if(vry>300 && vry<700){jy=0;}
_0x2F:
_0x2C:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x31
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x32
_0x31:
	RJMP _0x30
_0x32:
	LDI  R30,LOW(0)
	STS  _jy,R30
	STS  _jy+1,R30
; 0000 026B     else if(vry>700){jy=1;}
	RJMP _0x33
_0x30:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x34
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB6
; 0000 026C     else if(jy<300){jy=2;}
_0x34:
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRGE _0x36
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB6:
	STS  _jy,R30
	STS  _jy+1,R31
; 0000 026D 
; 0000 026E     if(jx==1 && jy==0){joy=1;}
_0x36:
_0x33:
	CALL SUBOPT_0x5
	SBIW R26,1
	BRNE _0x38
	CALL SUBOPT_0x4
	SBIW R26,0
	BREQ _0x39
_0x38:
	RJMP _0x37
_0x39:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x6
; 0000 026F     else if(jx==0 && jy==2){joy=2;}
	RJMP _0x3A
_0x37:
	CALL SUBOPT_0x5
	SBIW R26,0
	BRNE _0x3C
	CALL SUBOPT_0x4
	SBIW R26,2
	BREQ _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x6
; 0000 0270     else if(jx==0 && jy==1){joy=3;}
	RJMP _0x3E
_0x3B:
	CALL SUBOPT_0x5
	SBIW R26,0
	BRNE _0x40
	CALL SUBOPT_0x4
	SBIW R26,1
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x6
; 0000 0271     else if(jx==2 && jy==0){joy=4;}
	RJMP _0x42
_0x3F:
	CALL SUBOPT_0x5
	SBIW R26,2
	BRNE _0x44
	CALL SUBOPT_0x4
	SBIW R26,0
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x6
; 0000 0272     else if(jx==0 && jy==0){joy=0;}
	RJMP _0x46
_0x43:
	CALL SUBOPT_0x5
	SBIW R26,0
	BRNE _0x48
	CALL SUBOPT_0x4
	SBIW R26,0
	BREQ _0x49
_0x48:
	RJMP _0x47
_0x49:
	LDI  R30,LOW(0)
	STS  _joy,R30
	STS  _joy+1,R30
; 0000 0273 
; 0000 0274     if(joy==1){menu=1;}
_0x47:
_0x46:
_0x42:
_0x3E:
_0x3A:
	CALL SUBOPT_0x7
	SBIW R26,1
	BRNE _0x4A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB7
; 0000 0275     else if(joy==2){menu=2;}
_0x4A:
	CALL SUBOPT_0x7
	SBIW R26,2
	BRNE _0x4C
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0xB7
; 0000 0276     else if(joy==3){menu=3;}
_0x4C:
	CALL SUBOPT_0x7
	SBIW R26,3
	BRNE _0x4E
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0xB7
; 0000 0277     else if(joy==4){menu=4;}
_0x4E:
	CALL SUBOPT_0x7
	SBIW R26,4
	BRNE _0x50
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0xB7:
	STS  _menu,R30
	STS  _menu+1,R31
; 0000 0278 
; 0000 0279     if(pb<100){push=1;}
_0x50:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x51
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x8
; 0000 027A     else if(pb>100 && pb<400){push=2;}
	RJMP _0x52
_0x51:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x54
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x55
_0x54:
	RJMP _0x53
_0x55:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x8
; 0000 027B     else if(pb>400 && pb<700){push=3;}
	RJMP _0x56
_0x53:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x58
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x59
_0x58:
	RJMP _0x57
_0x59:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x8
; 0000 027C     else if(pb>700 && pb<1000){push=4;}
	RJMP _0x5A
_0x57:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x5C
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x8
; 0000 027D     else if(pb>1000){push=0;}
	RJMP _0x5E
_0x5B:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x5F
	LDI  R30,LOW(0)
	STS  _push,R30
	STS  _push+1,R30
; 0000 027E 
; 0000 027F     if(PINC.7==0 && lastc7==1)
_0x5F:
_0x5E:
_0x5A:
_0x56:
_0x52:
	SBIC 0x13,7
	RJMP _0x61
	LDS  R26,_lastc7
	LDS  R27,_lastc7+1
	SBIW R26,1
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0280         {
; 0000 0281           if(latchmenu==1){latchmenu=0;}
	CALL SUBOPT_0x9
	BRNE _0x63
	LDI  R30,LOW(0)
	STS  _latchmenu,R30
	STS  _latchmenu+1,R30
; 0000 0282           else{latchmenu=1;}
	RJMP _0x64
_0x63:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _latchmenu,R30
	STS  _latchmenu+1,R31
_0x64:
; 0000 0283         }
; 0000 0284         lastc7=PINC.7;
_0x60:
	LDI  R30,0
	SBIC 0x13,7
	LDI  R30,1
	LDI  R31,0
	STS  _lastc7,R30
	STS  _lastc7+1,R31
; 0000 0285 
; 0000 0286     if(latchmenu==0)
	LDS  R30,_latchmenu
	LDS  R31,_latchmenu+1
	SBIW R30,0
	BRNE _0x65
; 0000 0287         {
; 0000 0288 
; 0000 0289         }
; 0000 028A         else if(latchmenu==1)
	RJMP _0x66
_0x65:
	CALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x67
; 0000 028B         {
; 0000 028C           if(menu==1)
	CALL SUBOPT_0xA
	SBIW R26,1
	BREQ PC+2
	RJMP _0x68
; 0000 028D           {
; 0000 028E             if(push==1)
	CALL SUBOPT_0xB
	SBIW R26,1
	BRNE _0x69
; 0000 028F             {
; 0000 0290               p++;
	CALL SUBOPT_0xC
; 0000 0291               if(p==1){bawah+=10;if(bawah>99){bawah=0;}}
	CALL SUBOPT_0xD
	SBIW R26,1
	BRNE _0x6A
	CALL SUBOPT_0xE
	ADIW R30,10
	STS  _bawah,R30
	STS  _bawah+1,R31
	CALL SUBOPT_0xF
	BRLT _0x6B
	CALL SUBOPT_0x10
_0x6B:
; 0000 0292               else if(p==50){p=0;}
	RJMP _0x6C
_0x6A:
	CALL SUBOPT_0xD
	SBIW R26,50
	BRNE _0x6D
	CALL SUBOPT_0x11
; 0000 0293             }
_0x6D:
_0x6C:
; 0000 0294             else if(push==2)
	RJMP _0x6E
_0x69:
	CALL SUBOPT_0xB
	SBIW R26,2
	BRNE _0x6F
; 0000 0295             {
; 0000 0296               p++;
	CALL SUBOPT_0xC
; 0000 0297               if(p==1){bawah++;if(bawah>99){bawah=0;}}
	CALL SUBOPT_0xD
	SBIW R26,1
	BRNE _0x70
	LDI  R26,LOW(_bawah)
	LDI  R27,HIGH(_bawah)
	CALL SUBOPT_0x0
	CALL SUBOPT_0xF
	BRLT _0x71
	CALL SUBOPT_0x10
_0x71:
; 0000 0298               else if(p==50){p=0;}
	RJMP _0x72
_0x70:
	CALL SUBOPT_0xD
	SBIW R26,50
	BRNE _0x73
	CALL SUBOPT_0x11
; 0000 0299             }
_0x73:
_0x72:
; 0000 029A             else if(push==3){bawah=0;}
	RJMP _0x74
_0x6F:
	CALL SUBOPT_0xB
	SBIW R26,3
	BRNE _0x75
	CALL SUBOPT_0x10
; 0000 029B             else if(push==4){bawah=99;}
	RJMP _0x76
_0x75:
	CALL SUBOPT_0xB
	SBIW R26,4
	BRNE _0x77
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	STS  _bawah,R30
	STS  _bawah+1,R31
; 0000 029C           }
_0x77:
_0x76:
_0x74:
_0x6E:
; 0000 029D           else if(menu==2)
	RJMP _0x78
_0x68:
	CALL SUBOPT_0xA
	SBIW R26,2
	BRNE _0x79
; 0000 029E           {
; 0000 029F             tengah=(pot/10);
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _tengah,R30
	STS  _tengah+1,R31
; 0000 02A0           }
; 0000 02A1           else if(menu==3)
	RJMP _0x7A
_0x79:
	CALL SUBOPT_0xA
	SBIW R26,3
	BREQ PC+2
	RJMP _0x7B
; 0000 02A2           {
; 0000 02A3             if(push==1)
	CALL SUBOPT_0xB
	SBIW R26,1
	BRNE _0x7C
; 0000 02A4             {
; 0000 02A5               p++;
	CALL SUBOPT_0xC
; 0000 02A6               if(p==1){atas+=10;if(atas>99){atas=0;}}
	CALL SUBOPT_0xD
	SBIW R26,1
	BRNE _0x7D
	CALL SUBOPT_0x12
	ADIW R30,10
	STS  _atas,R30
	STS  _atas+1,R31
	CALL SUBOPT_0x13
	BRLT _0x7E
	CALL SUBOPT_0x14
_0x7E:
; 0000 02A7               else if(p==50){p=0;}
	RJMP _0x7F
_0x7D:
	CALL SUBOPT_0xD
	SBIW R26,50
	BRNE _0x80
	CALL SUBOPT_0x11
; 0000 02A8             }
_0x80:
_0x7F:
; 0000 02A9             else if(push==2)
	RJMP _0x81
_0x7C:
	CALL SUBOPT_0xB
	SBIW R26,2
	BRNE _0x82
; 0000 02AA             {
; 0000 02AB               p++;
	CALL SUBOPT_0xC
; 0000 02AC               if(p==1){atas++;if(atas>99){atas=0;}}
	CALL SUBOPT_0xD
	SBIW R26,1
	BRNE _0x83
	LDI  R26,LOW(_atas)
	LDI  R27,HIGH(_atas)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x13
	BRLT _0x84
	CALL SUBOPT_0x14
_0x84:
; 0000 02AD               else if(p==50){p=0;}
	RJMP _0x85
_0x83:
	CALL SUBOPT_0xD
	SBIW R26,50
	BRNE _0x86
	CALL SUBOPT_0x11
; 0000 02AE             }
_0x86:
_0x85:
; 0000 02AF             else if(push==3){atas=0;}
	RJMP _0x87
_0x82:
	CALL SUBOPT_0xB
	SBIW R26,3
	BRNE _0x88
	CALL SUBOPT_0x14
; 0000 02B0             else if(push==4){atas=99;}
	RJMP _0x89
_0x88:
	CALL SUBOPT_0xB
	SBIW R26,4
	BRNE _0x8A
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	STS  _atas,R30
	STS  _atas+1,R31
; 0000 02B1           }
_0x8A:
_0x89:
_0x87:
_0x81:
; 0000 02B2           else if(menu==4)
	RJMP _0x8B
_0x7B:
	CALL SUBOPT_0xA
	SBIW R26,4
; 0000 02B3           {
; 0000 02B4 
; 0000 02B5           }
; 0000 02B6         }
_0x8B:
_0x7A:
_0x78:
; 0000 02B7 }
_0x67:
_0x66:
	RJMP _0xB9
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 02BB {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	CALL SUBOPT_0x2
; 0000 02BC // Reinitialize Timer1 value
; 0000 02BD TCNT1H=0xCC70 >> 8;
	LDI  R30,LOW(204)
	OUT  0x2D,R30
; 0000 02BE TCNT1L=0xCC70 & 0xff;
	LDI  R30,LOW(112)
	OUT  0x2C,R30
; 0000 02BF // Place your code here
; 0000 02C0     delay_us(100);
	CALL SUBOPT_0x3
; 0000 02C1     sen=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	MOVW R4,R30
; 0000 02C2 
; 0000 02C3     vADC=(sen/1023.00)*5.00;
	CALL SUBOPT_0x15
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447FC000
	CALL __DIVF21
	__GETD2N 0x40A00000
	CALL __MULF12
	STS  _vADC,R30
	STS  _vADC+1,R31
	STS  _vADC+2,R22
	STS  _vADC+3,R23
; 0000 02C4     temp=vADC/0.01;
	LDS  R26,_vADC
	LDS  R27,_vADC+1
	LDS  R24,_vADC+2
	LDS  R25,_vADC+3
	__GETD1N 0x3C23D70A
	CALL __DIVF21
	STS  _temp,R30
	STS  _temp+1,R31
	STS  _temp+2,R22
	STS  _temp+3,R23
; 0000 02C5     suhu=((int)temp)*1;
	CALL SUBOPT_0x16
	CALL __CFD1
	STS  _suhu,R30
	STS  _suhu+1,R31
; 0000 02C6 }
_0xB9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 02CD {
_read_adc:
; .FSTART _read_adc
; 0000 02CE ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 02CF // Delay needed for the stabilization of the ADC input voltage
; 0000 02D0 delay_us(10);
	__DELAY_USB 40
; 0000 02D1 // Start the AD conversion
; 0000 02D2 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 02D3 // Wait for the AD conversion to complete
; 0000 02D4 while ((ADCSRA & (1<<ADIF))==0);
_0x8D:
	SBIS 0x6,4
	RJMP _0x8D
; 0000 02D5 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 02D6 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20C0006
; 0000 02D7 }
; .FEND
;
;void main(void)
; 0000 02DA {
_main:
; .FSTART _main
; 0000 02DB // Declare your local variables here
; 0000 02DC 
; 0000 02DD // Input/Output Ports initialization
; 0000 02DE // Port A initialization
; 0000 02DF // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02E0 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 02E1 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02E2 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 02E3 
; 0000 02E4 // Port B initialization
; 0000 02E5 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 02E6 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 02E7 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 02E8 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02E9 
; 0000 02EA // Port C initialization
; 0000 02EB // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02EC DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(128)
	OUT  0x14,R30
; 0000 02ED // State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02EE PORTC=(1<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 02EF 
; 0000 02F0 // Port D initialization
; 0000 02F1 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 02F2 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 02F3 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 02F4 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 02F5 
; 0000 02F6 // Timer/Counter 0 initialization
; 0000 02F7 // Clock source: System Clock
; 0000 02F8 // Clock value: 187,500 kHz
; 0000 02F9 // Mode: Normal top=0xFF
; 0000 02FA // OC0 output: Disconnected
; 0000 02FB // Timer Period: 1,0027 ms
; 0000 02FC TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 02FD TCNT0=0x44;
	LDI  R30,LOW(68)
	OUT  0x32,R30
; 0000 02FE OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 02FF 
; 0000 0300 // Timer/Counter 1 initialization
; 0000 0301 // Clock source: System Clock
; 0000 0302 // Clock value: 12000,000 kHz
; 0000 0303 // Mode: Normal top=0xFFFF
; 0000 0304 // OC1A output: Disconnected
; 0000 0305 // OC1B output: Disconnected
; 0000 0306 // Noise Canceler: Off
; 0000 0307 // Input Capture on Falling Edge
; 0000 0308 // Timer Period: 1,1 ms
; 0000 0309 // Timer1 Overflow Interrupt: On
; 0000 030A // Input Capture Interrupt: Off
; 0000 030B // Compare A Match Interrupt: Off
; 0000 030C // Compare B Match Interrupt: Off
; 0000 030D TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 030E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 030F TCNT1H=0xCC;
	LDI  R30,LOW(204)
	OUT  0x2D,R30
; 0000 0310 TCNT1L=0x70;
	LDI  R30,LOW(112)
	OUT  0x2C,R30
; 0000 0311 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0312 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0313 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0314 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0315 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0316 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0317 
; 0000 0318 // Timer/Counter 2 initialization
; 0000 0319 // Clock source: System Clock
; 0000 031A // Clock value: Timer2 Stopped
; 0000 031B // Mode: Normal top=0xFF
; 0000 031C // OC2 output: Disconnected
; 0000 031D ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 031E TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 031F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0320 OCR2=0x00;
	OUT  0x23,R30
; 0000 0321 
; 0000 0322 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0323 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0324 
; 0000 0325 // External Interrupt(s) initialization
; 0000 0326 // INT0: Off
; 0000 0327 // INT1: Off
; 0000 0328 // INT2: Off
; 0000 0329 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 032A MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 032B 
; 0000 032C // USART initialization
; 0000 032D // USART disabled
; 0000 032E UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 032F 
; 0000 0330 // Analog Comparator initialization
; 0000 0331 // Analog Comparator: Off
; 0000 0332 // The Analog Comparator's positive input is
; 0000 0333 // connected to the AIN0 pin
; 0000 0334 // The Analog Comparator's negative input is
; 0000 0335 // connected to the AIN1 pin
; 0000 0336 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0337 
; 0000 0338 // ADC initialization
; 0000 0339 // ADC Clock frequency: 750,000 kHz
; 0000 033A // ADC Voltage Reference: AVCC pin
; 0000 033B // ADC Auto Trigger Source: ADC Stopped
; 0000 033C ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 033D ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 033E SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 033F 
; 0000 0340 // SPI initialization
; 0000 0341 // SPI disabled
; 0000 0342 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0343 
; 0000 0344 // TWI initialization
; 0000 0345 // TWI disabled
; 0000 0346 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0347 
; 0000 0348 // Alphanumeric LCD initialization
; 0000 0349 // Connections are specified in the
; 0000 034A // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 034B // RS - PORTD Bit 1
; 0000 034C // RD - PORTD Bit 0
; 0000 034D // EN - PORTD Bit 2
; 0000 034E // D4 - PORTD Bit 3
; 0000 034F // D5 - PORTD Bit 4
; 0000 0350 // D6 - PORTD Bit 5
; 0000 0351 // D7 - PORTD Bit 6
; 0000 0352 // Characters/line: 16
; 0000 0353 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0354 
; 0000 0355 // Global enable interrupts
; 0000 0356 #asm("sei")
	sei
; 0000 0357 
; 0000 0358 lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 0359 sprintf(datalcd,"ESP FASE 3");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x18
; 0000 035A lcd_puts(datalcd);
; 0000 035B lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 035C sprintf(datalcd,"LKS KE-28/2020");
	__POINTW1FN _0x0,11
	CALL SUBOPT_0x18
; 0000 035D lcd_puts(datalcd);
; 0000 035E 
; 0000 035F PORTD.7=1;
	CALL SUBOPT_0x1A
; 0000 0360 delay_ms(50);
; 0000 0361 PORTD.7=0;
; 0000 0362 delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0363 PORTD.7=1;
	CALL SUBOPT_0x1A
; 0000 0364 delay_ms(50);
; 0000 0365 PORTD.7=0;
; 0000 0366 
; 0000 0367 scrollmtx(12,smk);
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_smk)
	LDI  R27,HIGH(_smk)
	RCALL _scrollmtx
; 0000 0368 
; 0000 0369 while (1)
_0x98:
; 0000 036A       {
; 0000 036B       // Place your code here
; 0000 036C         if(latchmenu==0)
	LDS  R30,_latchmenu
	LDS  R31,_latchmenu+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x9B
; 0000 036D         {
; 0000 036E           if(menu==1)
	CALL SUBOPT_0xA
	SBIW R26,1
	BRNE _0x9C
; 0000 036F           {
; 0000 0370             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 0371             sprintf(datalcd,"BATAS BAWAH     ");
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x18
; 0000 0372             lcd_puts(datalcd);
; 0000 0373             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 0374             sprintf(datalcd,"%2d              ",bawah);
	__POINTW1FN _0x0,43
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 0375             lcd_puts(datalcd);
; 0000 0376             matrix(angka[1]);
	__POINTW2MN _angka,8
	RCALL _matrix
; 0000 0377           }
; 0000 0378           if(menu==2)
_0x9C:
	CALL SUBOPT_0xA
	SBIW R26,2
	BRNE _0x9D
; 0000 0379           {
; 0000 037A             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 037B             sprintf(datalcd,"BATAS TENGAH   ");
	__POINTW1FN _0x0,61
	CALL SUBOPT_0x18
; 0000 037C             lcd_puts(datalcd);
; 0000 037D             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 037E             sprintf(datalcd,"%2d             ",tengah);
	__POINTW1FN _0x0,77
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
; 0000 037F             lcd_puts(datalcd);
; 0000 0380             matrix(angka[2]);
	__POINTW2MN _angka,16
	RCALL _matrix
; 0000 0381           }
; 0000 0382           if(menu==3)
_0x9D:
	CALL SUBOPT_0xA
	SBIW R26,3
	BRNE _0x9E
; 0000 0383           {
; 0000 0384             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 0385             sprintf(datalcd,"BATAS ATAS      ");
	__POINTW1FN _0x0,94
	CALL SUBOPT_0x18
; 0000 0386             lcd_puts(datalcd);
; 0000 0387             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 0388             sprintf(datalcd,"%2d              ",atas);
	__POINTW1FN _0x0,43
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1C
; 0000 0389             lcd_puts(datalcd);
; 0000 038A             matrix(angka[3]);
	__POINTW2MN _angka,24
	RCALL _matrix
; 0000 038B           }
; 0000 038C           if(menu==4)
_0x9E:
	CALL SUBOPT_0xA
	SBIW R26,4
	BRNE _0x9F
; 0000 038D           {
; 0000 038E             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 038F             sprintf(datalcd,"KOMPARATOR      ");
	__POINTW1FN _0x0,111
	CALL SUBOPT_0x18
; 0000 0390             lcd_puts(datalcd);
; 0000 0391             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 0392             sprintf(datalcd,"TEMP:%.2f'C  ",temp);
	__POINTW1FN _0x0,128
	CALL SUBOPT_0x1F
; 0000 0393             lcd_puts(datalcd);
; 0000 0394             matrix(angka[4]);
	__POINTW2MN _angka,32
	RCALL _matrix
; 0000 0395           }
; 0000 0396         }
_0x9F:
; 0000 0397         else if(latchmenu==1)
	RJMP _0xA0
_0x9B:
	CALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0xA1
; 0000 0398         {
; 0000 0399           if(menu==1)
	CALL SUBOPT_0xA
	SBIW R26,1
	BRNE _0xA2
; 0000 039A           {
; 0000 039B             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 039C             sprintf(datalcd,"BATAS BAWAH     ");
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x18
; 0000 039D             lcd_puts(datalcd);
; 0000 039E             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 039F             sprintf(datalcd,"TEKAN S1 s/d S4 ");
	__POINTW1FN _0x0,142
	CALL SUBOPT_0x18
; 0000 03A0             lcd_puts(datalcd);
; 0000 03A1             bitwise(bawah);
	LDS  R26,_bawah
	LDS  R27,_bawah+1
	CALL SUBOPT_0x20
; 0000 03A2             matrix(bitresult);
	RJMP _0xB8
; 0000 03A3           }
; 0000 03A4           else if(menu==2)
_0xA2:
	CALL SUBOPT_0xA
	SBIW R26,2
	BRNE _0xA4
; 0000 03A5           {
; 0000 03A6             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 03A7             sprintf(datalcd,"NILAI TENGAH    ");
	__POINTW1FN _0x0,159
	CALL SUBOPT_0x18
; 0000 03A8             lcd_puts(datalcd);
; 0000 03A9             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 03AA             sprintf(datalcd,"PUTAR POTENSIO  ");
	__POINTW1FN _0x0,176
	CALL SUBOPT_0x18
; 0000 03AB             lcd_puts(datalcd);
; 0000 03AC             bitwise(tengah);
	LDS  R26,_tengah
	LDS  R27,_tengah+1
	CALL SUBOPT_0x20
; 0000 03AD             matrix(bitresult);
	RJMP _0xB8
; 0000 03AE           }
; 0000 03AF           else if(menu==3)
_0xA4:
	CALL SUBOPT_0xA
	SBIW R26,3
	BRNE _0xA6
; 0000 03B0           {
; 0000 03B1             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 03B2             sprintf(datalcd,"NILAI ATAS      ");
	__POINTW1FN _0x0,193
	CALL SUBOPT_0x18
; 0000 03B3             lcd_puts(datalcd);
; 0000 03B4             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 03B5             sprintf(datalcd,"TEKAN S1 s/d S4 ");
	__POINTW1FN _0x0,142
	CALL SUBOPT_0x18
; 0000 03B6             lcd_puts(datalcd);
; 0000 03B7             bitwise(atas);
	LDS  R26,_atas
	LDS  R27,_atas+1
	CALL SUBOPT_0x20
; 0000 03B8             matrix(bitresult);
	RJMP _0xB8
; 0000 03B9           }
; 0000 03BA           else if(menu==4)
_0xA6:
	CALL SUBOPT_0xA
	SBIW R26,4
	BRNE _0xA8
; 0000 03BB           {
; 0000 03BC             lcd_gotoxy(0,0);
	CALL SUBOPT_0x17
; 0000 03BD             sprintf(datalcd,"%2d %2d %2d      ",bawah,tengah,atas);
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 03BE             lcd_puts(datalcd);
	LDI  R26,LOW(_datalcd)
	LDI  R27,HIGH(_datalcd)
	RCALL _lcd_puts
; 0000 03BF             lcd_gotoxy(0,1);
	CALL SUBOPT_0x19
; 0000 03C0             sprintf(datalcd,"TEMP:%.2f'C",temp);
	__POINTW1FN _0x0,228
	CALL SUBOPT_0x1F
; 0000 03C1             lcd_puts(datalcd);
; 0000 03C2             if(temp<bawah){matrix(arah[4]);}
	CALL SUBOPT_0x21
	BRSH _0xA9
	__POINTW2MN _arah,32
	RJMP _0xB8
; 0000 03C3             else if(temp>bawah && temp<tengah){matrix(arah[2]);}
_0xA9:
	CALL SUBOPT_0x21
	BREQ PC+2
	BRCC PC+2
	RJMP _0xAC
	CALL SUBOPT_0x22
	BRLO _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
	__POINTW2MN _arah,16
	RJMP _0xB8
; 0000 03C4             else if(temp>tengah && temp<atas){matrix(arah[3]);}
_0xAB:
	CALL SUBOPT_0x22
	BREQ PC+2
	BRCC PC+2
	RJMP _0xB0
	CALL SUBOPT_0x23
	BRLO _0xB1
_0xB0:
	RJMP _0xAF
_0xB1:
	__POINTW2MN _arah,24
	RJMP _0xB8
; 0000 03C5             else if(temp>atas){matrix(arah[1]);}
_0xAF:
	CALL SUBOPT_0x23
	BREQ PC+2
	BRCC PC+2
	RJMP _0xB3
	__POINTW2MN _arah,8
_0xB8:
	RCALL _matrix
; 0000 03C6           }
_0xB3:
; 0000 03C7         }
_0xA8:
; 0000 03C8 
; 0000 03C9 //        lcd_gotoxy(0,0);
; 0000 03CA //        sprintf(datalcd,"x=%4d y=%4d",vrx,vry);
; 0000 03CB //        lcd_puts(datalcd);
; 0000 03CC //
; 0000 03CD //        if(menu==0)
; 0000 03CE //        {
; 0000 03CF //          lcd_gotoxy(0,0);
; 0000 03D0 //          sprintf(datalcd,"MENU PROGRAM   ");
; 0000 03D1 //          lcd_puts(datalcd);
; 0000 03D2 //          lcd_gotoxy(0,1);
; 0000 03D3 //          sprintf(datalcd,"TEKAN S1 s/d S3");
; 0000 03D4 //          lcd_puts(datalcd);
; 0000 03D5 //        }
; 0000 03D6 //        else if(menu==1)
; 0000 03D7 //        {
; 0000 03D8 //          lcd_gotoxy(0,0);
; 0000 03D9 //          sprintf(datalcd,"SUHU= %.2f'C",temp);
; 0000 03DA //          lcd_puts(datalcd);
; 0000 03DB //          lcd_gotoxy(0,1);
; 0000 03DC //          sprintf(datalcd,"S4 KE MENU     ");
; 0000 03DD //          lcd_puts(datalcd);
; 0000 03DE //        }
; 0000 03DF //        else if(menu==2)
; 0000 03E0 //        {
; 0000 03E1 //          lcd_gotoxy(0,0);
; 0000 03E2 //          sprintf(datalcd,"ADC POT= %4d",pot);
; 0000 03E3 //          lcd_puts(datalcd);
; 0000 03E4 //          lcd_gotoxy(0,1);
; 0000 03E5 //          sprintf(datalcd,"S4 KE MENU     ");
; 0000 03E6 //          lcd_puts(datalcd);
; 0000 03E7 //        }
; 0000 03E8 //        else if(menu==3)
; 0000 03E9 //        {
; 0000 03EA //          lcd_gotoxy(0,0);
; 0000 03EB //          sprintf(datalcd,"X=%4d Y=%4d",vrx,vry);
; 0000 03EC //          lcd_puts(datalcd);
; 0000 03ED //          lcd_gotoxy(0,1);
; 0000 03EE //          sprintf(datalcd,"S4 KE MENU     ");
; 0000 03EF //          lcd_puts(datalcd);
; 0000 03F0 //        }
; 0000 03F1 //        matrix(angka[menu]);
; 0000 03F2       }
_0xA1:
_0xA0:
	RJMP _0x98
; 0000 03F3 }
_0xB4:
	RJMP _0xB4
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x12,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x12,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x12,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x12,4
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x12,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x12,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x12,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x12,6
_0x200000B:
	__DELAY_USB 20
	SBI  0x12,2
	__DELAY_USB 20
	CBI  0x12,2
	__DELAY_USB 20
	RJMP _0x20C0006
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 200
	RJMP _0x20C0006
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x24
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x24
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20C0006
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,1
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,1
	RJMP _0x20C0006
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x11,3
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x11,2
	SBI  0x11,1
	SBI  0x11,0
	CBI  0x12,2
	CBI  0x12,1
	CBI  0x12,0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	CALL SUBOPT_0x3
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0006:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x26
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	CALL SUBOPT_0x27
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20C0005
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0x27
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20C0005
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0x2D
	CALL __ADDF12
	CALL SUBOPT_0x28
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x2C
_0x2020014:
	CALL SUBOPT_0x2D
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2C
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0x27
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x20C0005
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0x29
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x29
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x15
	CALL __MULF12
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0004
	CALL SUBOPT_0x29
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x28
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x29
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x31
	RJMP _0x202001E
_0x2020020:
_0x20C0004:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x0
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x0
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G102:
; .FSTART __ftoe_G102
	CALL SUBOPT_0x26
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x20C0003
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x20C0003
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RJMP _0x204001C
_0x204001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x34
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
_0x2040022:
	CALL SUBOPT_0x34
	BRLO _0x2040024
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x36
	SUBI R19,-LOW(1)
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x34
	BRSH _0x2040028
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x36
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
_0x2040025:
	__GETD1S 12
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x36
	CALL SUBOPT_0x34
	BRLO _0x2040029
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x36
	SUBI R19,-LOW(1)
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	__GETD2S 4
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x33
	__GETD1S 4
	CALL SUBOPT_0x35
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x37
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x35
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x36
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x37
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x38
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2040113
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2040113:
	ST   X,R30
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x38
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x0
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x39
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x39
	RJMP _0x2040114
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3A
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3C
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3D
	CALL __GETD1P
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3F
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	CPI  R26,LOW(0x20)
	BREQ _0x204005F
	RJMP _0x2040060
_0x204005B:
	CALL SUBOPT_0x40
	CALL __ANEGF1
	CALL SUBOPT_0x3E
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x2040061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x3C
	RJMP _0x2040062
_0x2040061:
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040062:
_0x2040060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040064
	CALL SUBOPT_0x40
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2040065
_0x2040064:
	CALL SUBOPT_0x40
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G102
_0x2040065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x41
	RJMP _0x2040066
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040068
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x42
	CALL SUBOPT_0x41
	RJMP _0x2040069
_0x2040068:
	CPI  R30,LOW(0x70)
	BRNE _0x204006B
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x42
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006D
	CP   R20,R17
	BRLO _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	MOV  R17,R20
_0x204006C:
_0x2040066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006F
_0x204006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2040072
	CPI  R30,LOW(0x69)
	BRNE _0x2040073
_0x2040072:
	ORI  R16,LOW(4)
	RJMP _0x2040074
_0x2040073:
	CPI  R30,LOW(0x75)
	BRNE _0x2040075
_0x2040074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x43
	LDI  R17,LOW(10)
	RJMP _0x2040077
_0x2040076:
	__GETD1N 0x2710
	CALL SUBOPT_0x43
	LDI  R17,LOW(5)
	RJMP _0x2040077
_0x2040075:
	CPI  R30,LOW(0x58)
	BRNE _0x2040079
	ORI  R16,LOW(8)
	RJMP _0x204007A
_0x2040079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20400B8
_0x204007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x43
	LDI  R17,LOW(8)
	RJMP _0x2040077
_0x204007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x43
	LDI  R17,LOW(4)
_0x2040077:
	CPI  R20,0
	BREQ _0x204007D
	ANDI R16,LOW(127)
	RJMP _0x204007E
_0x204007D:
	LDI  R20,LOW(1)
_0x204007E:
	SBRS R16,1
	RJMP _0x204007F
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3D
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040115
_0x204007F:
	SBRS R16,2
	RJMP _0x2040081
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x42
	CALL __CWD1
	RJMP _0x2040115
_0x2040081:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x42
	CLR  R22
	CLR  R23
_0x2040115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040084
	CALL SUBOPT_0x40
	CALL __ANEGD1
	CALL SUBOPT_0x3E
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040086
_0x2040085:
	ANDI R16,LOW(251)
_0x2040086:
_0x2040083:
	MOV  R19,R20
_0x204006F:
	SBRC R16,0
	RJMP _0x2040087
_0x2040088:
	CP   R17,R21
	BRSH _0x204008B
	CP   R19,R21
	BRLO _0x204008C
_0x204008B:
	RJMP _0x204008A
_0x204008C:
	SBRS R16,7
	RJMP _0x204008D
	SBRS R16,2
	RJMP _0x204008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008F
_0x204008E:
	LDI  R18,LOW(48)
_0x204008F:
	RJMP _0x2040090
_0x204008D:
	LDI  R18,LOW(32)
_0x2040090:
	CALL SUBOPT_0x39
	SUBI R21,LOW(1)
	RJMP _0x2040088
_0x204008A:
_0x2040087:
_0x2040091:
	CP   R17,R20
	BRSH _0x2040093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040094
	CALL SUBOPT_0x44
	BREQ _0x2040095
	SUBI R21,LOW(1)
_0x2040095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x2040096
	SUBI R21,LOW(1)
_0x2040096:
	SUBI R20,LOW(1)
	RJMP _0x2040091
_0x2040093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040097
_0x2040098:
	CPI  R19,0
	BREQ _0x204009A
	SBRS R16,3
	RJMP _0x204009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009C
_0x204009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009C:
	CALL SUBOPT_0x39
	CPI  R21,0
	BREQ _0x204009D
	SUBI R21,LOW(1)
_0x204009D:
	SUBI R19,LOW(1)
	RJMP _0x2040098
_0x204009A:
	RJMP _0x204009E
_0x2040097:
_0x20400A0:
	CALL SUBOPT_0x45
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A2
	SBRS R16,3
	RJMP _0x20400A3
	SUBI R18,-LOW(55)
	RJMP _0x20400A4
_0x20400A3:
	SUBI R18,-LOW(87)
_0x20400A4:
	RJMP _0x20400A5
_0x20400A2:
	SUBI R18,-LOW(48)
_0x20400A5:
	SBRC R16,4
	RJMP _0x20400A7
	CPI  R18,49
	BRSH _0x20400A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20400A8
_0x20400A9:
	RJMP _0x20400AB
_0x20400A8:
	CP   R20,R19
	BRSH _0x2040116
	CP   R21,R19
	BRLO _0x20400AE
	SBRS R16,0
	RJMP _0x20400AF
_0x20400AE:
	RJMP _0x20400AD
_0x20400AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400B0
_0x2040116:
	LDI  R18,LOW(48)
_0x20400AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400B1
	CALL SUBOPT_0x44
	BREQ _0x20400B2
	SUBI R21,LOW(1)
_0x20400B2:
_0x20400B1:
_0x20400B0:
_0x20400A7:
	CALL SUBOPT_0x39
	CPI  R21,0
	BREQ _0x20400B3
	SUBI R21,LOW(1)
_0x20400B3:
_0x20400AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x45
	CALL __MODD21U
	CALL SUBOPT_0x3E
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x43
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20400A1
	RJMP _0x20400A0
_0x20400A1:
_0x204009E:
	SBRS R16,0
	RJMP _0x20400B4
_0x20400B5:
	CPI  R21,0
	BREQ _0x20400B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3C
	RJMP _0x20400B5
_0x20400B7:
_0x20400B4:
_0x20400B8:
_0x2040054:
_0x2040114:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x46
	SBIW R30,0
	BRNE _0x20400B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20400B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x46
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_angka:
	.BYTE 0x50
_smk:
	.BYTE 0x60
_puluhan:
	.BYTE 0x50
_satuan:
	.BYTE 0x50
_arah:
	.BYTE 0x28
_suhu:
	.BYTE 0x2
_jx:
	.BYTE 0x2
_jy:
	.BYTE 0x2
_joy:
	.BYTE 0x2
_menu:
	.BYTE 0x2
_push:
	.BYTE 0x2
_lastc7:
	.BYTE 0x2
_latchmenu:
	.BYTE 0x2
_bawah:
	.BYTE 0x2
_atas:
	.BYTE 0x2
_tengah:
	.BYTE 0x2
_i:
	.BYTE 0x2
_j:
	.BYTE 0x2
_p:
	.BYTE 0x2
_vADC:
	.BYTE 0x4
_temp:
	.BYTE 0x4
_datalcd:
	.BYTE 0x10
_bitresult:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R18
	ADC  R31,R19
	LD   R0,Z
	MOVW R30,R16
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	__DELAY_USW 300
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDS  R26,_jy
	LDS  R27,_jy+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDS  R26,_jx
	LDS  R27,_jx+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	STS  _joy,R30
	STS  _joy+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R26,_joy
	LDS  R27,_joy+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	STS  _push,R30
	STS  _push+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_latchmenu
	LDS  R27,_latchmenu+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xA:
	LDS  R26,_menu
	LDS  R27,_menu+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	LDS  R26,_push
	LDS  R27,_push+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_p)
	LDI  R27,HIGH(_p)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD:
	LDS  R26,_p
	LDS  R27,_p+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDS  R30,_bawah
	LDS  R31,_bawah+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDS  R26,_bawah
	LDS  R27,_bawah+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	STS  _bawah,R30
	STS  _bawah+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	STS  _p,R30
	STS  _p+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDS  R30,_atas
	LDS  R31,_atas+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDS  R26,_atas
	LDS  R27,_atas+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _atas,R30
	STS  _atas+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	LDS  R30,_temp
	LDS  R31,_temp+1
	LDS  R22,_temp+2
	LDS  R23,_temp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_datalcd)
	LDI  R31,HIGH(_datalcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R26,LOW(_datalcd)
	LDI  R27,HIGH(_datalcd)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_datalcd)
	LDI  R31,HIGH(_datalcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	SBI  0x12,7
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0xE
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_datalcd)
	LDI  R27,HIGH(_datalcd)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDS  R30,_tengah
	LDS  R31,_tengah+1
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x12
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x16
	CALL __PUTPARD1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL _bitwise
	LDI  R26,LOW(_bitresult)
	LDI  R27,HIGH(_bitresult)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0xE
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDS  R24,_temp+2
	LDS  R25,_temp+3
	RCALL SUBOPT_0x15
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x22:
	LDS  R30,_tengah
	LDS  R31,_tengah+1
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDS  R24,_temp+2
	LDS  R25,_temp+3
	RCALL SUBOPT_0x15
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x12
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDS  R24,_temp+2
	LDS  R25,_temp+3
	RCALL SUBOPT_0x15
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x29:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2B:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	__GETD2S 4
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x34:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x38:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x39:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3A:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3B:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3D:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x3A
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x3D
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x43:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x44:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
