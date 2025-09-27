;**********************************************************************
;    Filename:        sanitization_control.asm                        *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:    Adewale Opeloyeru                                     *
;    Company:                                                         *
;**********************************************************************
;                                                                     *
;    Files required: P16F72.INC                                       *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


    list        p=16f72        ; list directive to define processor
    #include    <p16f72.inc>    ; processor specific variable definitions
    
    __CONFIG   _CP_OFF & _WDTEN_OFF & _BODEN_OFF & _PWRTEN_ON & _XT_OSC


;***** VARIABLE DEFINITIONS *****

; Uninitialized Data Section
INT_VAR     UDATA     
w_temp      RES     	1       ; variable used for context saving 
status_temp RES     	1       ; variable used for context saving
a500usCOUNTER   res		1		; 500us delay counter
a10msCOUNTER    res		1 
a1sCOUNTER		RES		1		; 1s  COUNTER

; Uninitialized Data Section
TEMP_VAR    UDATA           ; explicit address specified is not required
temp_count  RES     1       ; temporary variable


; Overlayed Uninitialized Data Section
G_DATA      UDATA_OVR       ; explicit address can be specified
flag        RES     2       ; 

G_DATA      UDATA_OVR   
count       RES     2       ; temporary variable


;**********************************************************************
RESET_VECTOR      CODE    0x0000      
    goto    start                    

INT_VECTOR        CODE    0x0004      ; interrupt vector location

INTERRUPT

    movwf  w_temp          ; save off current W register contents
    bcf    STATUS,RP0      ; select bank0
    movf   STATUS,w        ; move status register into W register
    movwf  status_temp     ; save off contents of STATUS register


    movf   status_temp,w   ; retrieve copy of STATUS register
    movwf  STATUS          ; restore pre-isr STATUS register contents
    swapf  w_temp,f
    swapf  w_temp,w        ; restore pre-isr W register contents

    retfie                 ; return from interrupt



MAIN_PROG         CODE


a500usDELAY
	MOVLW	  .165				
	MOVWF	  a500usCOUNTER		
aDELAY500u						
	DECFSZ	  a500usCOUNTER,1
	GOTO	  aDELAY500u
	RETURN

a10msDELAY
	MOVLW	 .2
	MOVWF	 a10msCOUNTER
aDELAY10ms
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY 
	DECFSZ	 a10msCOUNTER,1
	GOTO	 aDELAY10ms
	RETURN

a1sDELAY
	MOVLW	 .200
	MOVWF	 a1sCOUNTER
aDELAY1s
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY
	CALL	 a500usDELAY 
	DECFSZ	 a1sCOUNTER,1
	GOTO	 aDELAY1s
	RETURN


start

		CLRF		PORTA

		BANKSEL		ADCON1
		MOVLW		0X07
		MOVWF		ADCON1

		
		BCF			STATUS,RP1
		BSF			STATUS,RP0	; SWITCH TO BANK 1

		MOVLW		0XFF
		MOVWF		TRISA

		MOVLW		0X01
		MOVWF		TRISB
                                                    ; SET THE TRIS AND OTHER BANK 1 REGISTERS.
		MOVLW		0XFF
		MOVWF		TRISC
		

		BCF			STATUS,RP1
		BCF			STATUS,RP0	; SWITCH BACK TO BANK 0

;*******************************************************		
		CLRF	PORTB
		
;*******************************************************
	CALL a1sDELAY
	CALL a1sDELAY

BEGIN
	BTFSC	PORTB,0
	GOTO	BEGIN
	
	BSF		PORTB,1
	CALL 	a1sDELAY
	CALL 	a1sDELAY
	CALL 	a1sDELAY
	CALL 	a1sDELAY
	CALL 	a1sDELAY
	BCF		PORTB,1
	
	GOTO	BEGIN
	

    END                       

