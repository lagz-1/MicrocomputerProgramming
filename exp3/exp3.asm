
P8255A EQU 0640H
P8255B EQU 0642H
P8255C EQU 0646H
P8255MODE EQU 0646H
SSTACK  SEGMENT STACK
        DW 32 DUP(0)
SSTACK  ENDS
 
CODE    SEGMENT
        ASSUME CS:CODE
 
START:  MOV DX,P8255MODE    ; Load the control mode register address into DX
        MOV AL,10010000B    ; Set the control mode for Port A (input) and Port B (output)
        OUT DX,AL           ; Send the control mode word
NEXT:
        MOV AL,0FFH             ; Turn on all data LEDs (D0~D7)
        
        MOV DX,P8255B
        OUT DX,AL               
        
        PUSH DS
        MOV AX, 0000H
        MOV DS, AX
        MOV AX, OFFSET MIR7  ; Load the address of the MIR7 interrupt service routine into AX
        MOV SI, 003CH        ; Load the address of the interrupt vector for interrupt 7
                             ; and store the service routine address in the 3CH and 3DH bytes       
        MOV [SI], AX             
        MOV AX, CS               
        MOV SI, 003EH           ; Load the address of the interrupt vector for interrupt 7
                             ; and store the code segment address in the 3EH and 3FH bytes
        MOV [SI], AX                  
        
        MOV AX, OFFSET MIR6         
        MOV SI, 0038H
        MOV [SI], AX             ; Write the service routine address to the interrupt vector (first two bytes)
        MOV AX, CS
        MOV SI, 003AH
        MOV [SI], AX
        CLI                      
        POP DS

        ;
        ; Note: The initialization order of the master and slave 8259 PICs is fixed, with the master being initialized first,
        ; and the port initialization order is also fixed. ICW1 must use 20H as the immediate value, and the other three
        ; ports must use 21H as the immediate value.

        ; Initialize the master 8259 PIC
        MOV AL, 11H             
        OUT 20H, AL             ;ICW1
        MOV AL, 08H             
        OUT 21H, AL             ;ICW2
        MOV AL, 04H             
        OUT 21H, AL             ;ICW3
        MOV AL, 01H             ;Enable 8086/8088 mode, non-buffered mode
        OUT 21H, AL             ;ICW4
 
        ; Initialize the slave 8259 PIC
        ; In fact, it's not being used
        MOV AL, 11H             
        OUT 0A0H, AL            
        MOV AL, 30H             
        OUT 0A1H, AL            
        MOV AL, 02H             
        OUT 0A1H, AL            
        MOV AL, 01H             
        OUT 0A1H, AL 
        MOV AL, 0FDH          ; OCW1 for slave PIC: Enable IR1 interrupt request
        OUT 0A1H, AL
        MOV AL, 2BH           ; OCW1 for master PIC: Unmask IR2, IR4, IR6, IR7 interrupts
        OUT 21H, AL
        STI
 
MAIN:   NOP
        MOV AL,0FFH             ;数据灯全亮
        MOV DX,P8255B
        OUT DX,AL               ;送b口
        JMP MAIN
 
MIR7:
        MOV AL,0F0H             ;Turn on the red LED and turn off the green LED
        MOV DX,P8255B
        OUT DX,AL               ;Output
        MOV AL, 20H
        OUT 20H, AL             ;Send End of Interrupt (EOI) command to PIC
        CALL DELAY
        IRET
MIR6:
        MOV AL,00FH             ; Turn on the green LED and turn off the red LED
        MOV DX,P8255B
        OUT DX,AL               ;Output
        MOV AL, 20H
        OUT 20H, AL             ;Send End of Interrupt (EOI) command to PIC
        CALL DELAY
        IRET
        

DELAY:  PUSH CX                 ; Delay subroutine
        MOV CX, 0FFFFH
DELAY_LOOP:  
        NOP  
        NOP    
        NOP         
        LOOP DELAY_LOOP        

    POP CX                  ; Restore CX register
    RET   
CODE    ENDS
        END  START
