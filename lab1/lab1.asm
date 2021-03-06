.MODEL SMALL

DATAS SEGMENT
    FILENAME DB 'Input1.txt',00H
    INPUTLENGTH DW 0000H
    INPUTBUFFER DB 100 DUP(0)
    OUTFILENAME DB 'Output1.txt',00H
    
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS

START:
    MOV AX, DATAS
    MOV DS, AX

    ; NEW A FILE
    LEA DX, FILENAME
    MOV CX, 0000H
    MOV AH, 3CH
    INT 21H
    
    MOV BX, AX
    MOV AH, 3EH
    INT 21H
     ; READ KEYBOARD INPUT
    LEA DI, INPUTBUFFER
    MOV CX, 0
READ:
    MOV AH, 01H
    INT 21H
    CMP AL, 13
    JE WRITE
    MOV BYTE PTR [DI], AL
    ADD CX, 1
    INC DI
    JMP READ

    ; WRITE FILE
WRITE:
    ; OPEN INPUT.TXT FILE
    MOV AX, 3D01H
    LEA DX, FILENAME
    INT 21H

    ; WRITE FILE
    MOV BX, AX
    LEA DX, INPUTBUFFER
    MOV AH, 40H
    INT 21H
    ; CLOSE FILE INPUT1.TXT
    MOV INPUTLENGTH, CX
    MOV AH, 3EH
    INT 21H

READFILE:
    LEA DX, FILENAME
    MOV AX, 3D00H
    INT 21H
    MOV BX, AX
    LEA DX, INPUTBUFFER
    MOV CX, INPUTLENGTH
    MOV AH, 3FH
    INT 21H
    ; CLOSE INPUT1.TXT FILE
    MOV AH, 3EH
    INT 21H

    ; INITIAL LOOP
    LEA DI, INPUTBUFFER
    MOV BX, INPUTLENGTH
    MOV CX, 0
CHANGECHARA:
    CMP CX, BX
    JE WRITEFILE
    MOV AL, BYTE PTR [DI]
    CMP AL, 'a'
    JB CONTINUE
    CMP AL, 'z'
    JG CONTINUE
    SUB AL, 32
    MOV BYTE PTR [DI], AL
CONTINUE:
    INC DI
    ADD CX, 1
    JMP CHANGECHARA


WRITEFILE:

    LEA DX, OUTFILENAME
    MOV CX, 0000H
    MOV AH, 3CH
    INT 21H

    MOV BX, AX
    LEA DX, INPUTBUFFER
    MOV CX, INPUTLENGTH
    MOV AH, 40H
    INT 21H
    

    ; RETURN ZERO
    MOV AX, 4C00H
    INT 21H

CODES ENDS
END START
