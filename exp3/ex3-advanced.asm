P8255A EQU 0640H             ; Define the base address for PPI Port A
P8255B EQU 0642H             ; Define the base address for PPI Port B
P8255C EQU 0646H             ; Define the base address for PPI Port C
P8255MODE EQU 0646H          ; Define the base address for PPI Control Mode Register

CODE SEGMENT 
       ASSUME CS:CODE

START: MOV AX,0000H
       MOV DS,AX
       MOV BX,02H              ; 2 for stopping movement
       MOV DX,P8255MODE
       MOV AL,10010000B        ; Configure control mode for Port A (input) and Port B (output)
       OUT DX,AL               ; Send the control mode word

NEXT:  MOV AL,10000000B        ; Initialize with D7 on and all other LEDs off
       MOV DX,P8255B
       OUT DX,AL               ; Output

       ; Add MIR7 interrupt subroutine
       PUSH DS
       MOV AX,OFFSET MIR7
       MOV SI,003CH
       MOV [SI],AX
       MOV AX,CSPECTMAP
       MOV SI,003EH
       MOV [SI],AX

       ; Add MIR6 interrupt subroutine
       MOV AX,OFFSET MIR6
       MOV SI,0038H
       MOV [SI],AX
       MOV AX,CS
       MOV SI,003AH
       MOV [SI],AX
       CLI                       ; Disable interrupts
       POP DS

       ; Initialize master 8259 PIC
       MOV AL,11H
       OUT 20H,AL                ; ICW1
       MOV AL,08H                ; ICW2 (interrupt vector offset)
       OUT 21H,AL                ; ICW2
       MOV AL,04H                ; ICW3 (IR2 connected to slave PIC)
       OUT 21H,AL                ; ICW3
       MOV AL,03H                ; ICW4 (8086/8088 mode, non-buffered mode)
       OUT 21H,AL                ; ICW4
       
       ; Initialize slave 8259 PIC
       MOV AL,11H
       OUT 0A0H,AL               ; ICW1 (initialize)
       MOV AL,30H
       OUT 0A1H,AL               ; ICW2 (interrupt vector offset for slave)
       MOV AL,02H
       OUT 0A1H,AL               ; ICW3 (cascade configuration)
       MOV AL,01H
       OUT 0A1H,AL               ; ICW4 (8086/8088 mode, non-buffered mode)
       MOV AL,0FDH
       OUT 0A1H,AL               ; OCW1 (allow IR1 interrupt request)
       MOV AL,2BH
       OUT 21H,AL                ; OCW1 (unmask IR2, IR4, IR6, IR7 for master PIC)
       STI                        ; Enable interrupts

MAIN:    
       CMP BX,0
       JZ ToLeft                  ; If bx==0, jump to the ToLeft label to move left
       CMP BX,1
       JZ ToRight                 ; If bx==1, jump to the ToRight label to move right
       JMP MAIN
       ; This section of code loops continuously until an interrupt occurs

MIR7:         
       MOV BX,00H
       IRET                       ; Interrupt return

MIR6:  
       MOV BX,01H
       IRET                       ; Interrupt return

DELAY:  PUSH CX                    ; Delay subroutine
        MOV CX, 0FFFFH
DELAY_LOOP:  
        NOP  
        NOP    
        NOP    
        NOP
        NOP     
        LOOP DELAY_LOOP        

    POP CX                         ; Restore CX register
    RET                            ; Return

ToLeft:                           ; Move left
       ROL AL,1
       MOV DX,P8255B
       OUT DX,AL
       CALL DELAY
       JMP MAIN

ToRight:                          ; Move right
       ROR AL,1
       MOV DX,P8255B
       OUT DX,AL
       CALL DELAY
       JMP MAIN

CODE ENDS
END START
