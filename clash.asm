;-------------------------start.asm---------------------------
EXTRN startScreen1:far 
EXTRN BUFFNAME1:BYTE, BufferData1:BYTE
EXTRN startScreen2:far 
EXTRN BUFFNAME2:BYTE, BufferData2:BYTE
;-------------------------RM.asm---------------------------
EXTRN RegMemo:far
PUBLIC m0_1,m1_1,m2_1,m3_1,m4_1,m5_1,m6_1 ,m7_1,m8_1,m9_1,mA_1,mB_1 ,mC_1,mD_1,mE_1,mF_1 
PUBLIC m0_2,m1_2,m2_2,m3_2,m4_2,m5_2,m6_2 ,m7_2,m8_2,m9_2,mA_2,mB_2 ,mC_2,mD_2,mE_2,mF_2 
PUBLIC AxVar1,BxVar1,CxVar1,DxVar1,SiVar1,DiVar1,SpVar1 ,BpVar1
PUBLIC AxVar2,BxVar2,CxVar2,DxVar2,SiVar2,DiVar2,SpVar2 ,BpVar2
;-------------------------chat.asm---------------------------
EXTRN Chat:far 
;-------------------------command.asm---------------------------
EXTRN execute:far 
PUBLIC commandStr,commandCode,isExternal,Instruction,Destination,Source,External
PUBLIC commandS
;-------------------------Gun.asm---------------------------
EXTRN DrawGun:far
EXTRN FireGun_initial:far
EXTRN FireGun_Continue:far
EXTRN gunPrevX:WORD,gunPrevY:WORD,gunNewX:WORD,gunNewY:WORD
;-------------------------UI.inc------------------------------
include UI.inc
;-------------------powerups.asm----------------------------
EXTRN changeForbidden1:FAR
EXTRN forbidden1:BYTE
EXTRN changeForbidden2:FAR
EXTRN forbidden2:BYTE



.286
.MODEL SMALL
.STACK 64
.DATA
;-------------------------Main Screen-----------------------------------
main_str1 DB 'To start chatting press F1','$'
main_str2 DB 'To start the game press F2','$'
main_str3 DB 'To end the program press ESC','$'
;----------------------------MEMORY-------------------------------------
;These variables are not in an array just to simplifie to vision
;---------Registers for player 1
AxVar1 dw 1
BxVar1 dw 3
CxVar1 dw 4
DxVar1 dw 0

SiVar1 dw 0
DiVar1 dw 0
SpVar1 dw 0
BpVar1 dw 0
;---------Memory for player 1
m0_1 db 0
m1_1 DB 0
m2_1 DB 0
m3_1 DB 0
m4_1 DB 0
m5_1 DB 0
m6_1 DB 0
m7_1 DB 0
m8_1 DB 0
m9_1 DB 0
mA_1 DB 0
mB_1 DB 0
mC_1 DB 0
mD_1 DB 0
mE_1 DB 0
mF_1 DB 0
;---------------------------------------
;---------Registers for player 2
AxVar2 dw 0
BxVar2 dw 0
CxVar2 dw 0
DxVar2 dw 0

SiVar2 dw 0
DiVar2 dw 0
SpVar2 dw 0 
BpVar2 dw 0
;---------Memory for player 2
m0_2 db 0
m1_2 DB 0
m2_2 DB 0
m3_2 DB 0
m4_2 DB 0
m5_2 DB 0
m6_2 DB 0
m7_2 DB 0
m8_2 DB 0
m9_2 DB 0
mA_2 DB 0
mB_2 DB 0
mC_2 DB 0
mD_2 DB 0
mE_2 DB 0
mF_2 DB 0
;----------------------------------------------------------------------
;-------------------------Command String-------------------------------
commandStr LABEL BYTE
cmdMaxSize db 15 ;maximum size of command
cmdCurrSize db 0 ; current size of command
commandS db 22 dup('$') ;22 3shan bytb3 3lehom m3rfsh leh :)
cursor dw ?          ;holds the address of the upcomming letter

commandCode LABEL BYTE
isExternal db 0
Instruction db 00
Destination db 00
Source db 00
External dw 0000
;------------------------Empty string------------------------------
EmptyString db 22 dup('$')
;----------------------------Error----------------------------------
isError db 0
;---------------------------------Turns------------------------------
Turn db 1
;--------------------------From start screen-------------------------




P2_score db 0
P1_score db 0

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    UserNames:
        call startScreen1  ;start.asm 
        ; call startScreen2 
    EndUserNames:
    ;Clear Screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    MainScreen:
        draw_mainscreen main_str1, main_str2, main_str3 ;UI.inc
        MainInput:
            mov ah,1
            int 16h
            jz MainInput
            mov ah, 0
            int 16h
            keyF1:
                cmp ah, 3Bh ;compare key code with f1 code
                jnz keyF2    ;if the key is not F1, jump to next check
                ; jmp chat
            keyF2:
                cmp ah, 3Ch ;compare key code with f1 code
                jnz keyESC    ;if the key is not F1, jump to next check
                jmp EndMainScreen
            keyESC:
                cmp ah, 1h ;compare key code with f1 code
                jnz MainInput    ;if the key is not F1, jump to next check
                jmp EndGame
            EndMainInput:

    EndMainScreen:
    mov ah,0   ;enter graphics mode
    mov al,13h
    int 10h

    

    ;Main Game Loop
    Background                          ;background color
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  120,0,0dh,10,120
    drawrectangle   5,2,0ah,5,5 ;draw shape
    verticalline 0,160,170              ;vertical line
    horizontalline 145,162,319          ;horizontal line
    drawrectangle  120,161,0Eh,10,120
    drawrectangle   5,162,0ah,5,5 ;draw shape

    ;display name
        push dx
        ; mov si,offset BufferData1

        ; MOV AL,[si]
        ; sub al,30H
        ; MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
        ; MOV BL,10 ;THE DIVISION THIS TIME IS OVER 10
        ; MUL BL
                        
        ; MOV DL,AL ;TO save the frist digit      
        ; mov al,[si+1] ;second digit   
        ; sub al,30H   
        ; add dl,al
        ; mov P1_score,dl ;first initial score
        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; mov si,offset BUFFNAME2
        ; MOV AL,[si]
        ; sub al,30H
        ; MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
        ; MOV BL,10 ;THE DIVISION THIS TIME IS OVER 10
        ; MUL BL           
        ; MOV DL,AL ;TO save the frist digit

        ; mov al,[si+1] ;second digit   
        ; sub al,30H   
        ; add dl,al
        ; ;;;;;;;;;;;;;;;;;;;;;;;
        ; cmp dl,P1_score
        ; jz eq
        ; jb bel
        ; eq:
        ;     mov P2_score,dl
        ; jmp
        ; bel:mov p
        ; ;I need to know the smallest of the 2 numbers the convet it to string and print it next to each name 
        ; ;;;;;;;;;;;;;;;;;;;;;;;
        ; mov dl,5
        ; mov dh,20
        ; mov ah,2
        ; int 10h
        ; mov ah,09
        ; mov dx,offset BUFFNAME1
        ; int 21h
        ; mov dx,offset BufferData1
        ; int 21h
        ; mov dl,70
        ; mov dh,20
        ; mov ah,2
        ; int 10h
        ; mov ah,09
        ; mov dx,offset BUFFNAME2
        ; int 21h
        ; mov dx,offset BufferData2
        ; int 21h

        pop dx
        mov di, offset commandS
        mov cursor, di
    
    Game:
        CALL PrintCommandString
        ;----------------------gun.asm-----------------------------
        CALL DrawGun       
        CALL FireGun_Continue
        ;----------------------rm.asm-----------------------------
        call RegMemo
        ;draw score squares UI.inc 
        setcursor 0000
        drawrectanglewithletter  140,7,0ah,10,10,63497d,'1',0ah
        setcursor 0000
        drawrectanglewithletter  140,30,9h,10,10,63500d,'2',09h
        setcursor 0000
        drawrectanglewithletter  140,53,0ch,10,10,63503d,'3',0ch
        setcursor 0000
        drawrectanglewithletter  140,77,0dh,10,10,63506d,'4',0dh
        setcursor 0000
        drawrectanglewithletter  140,101,0Eh,10,10, 63509d,'5',0eh
        setcursor 0000
        ;Read Keyboard input
        mov ah, 1
        int 16h
        jz Game   ;if no key is pressed, go to other functions like flying objects, etc. -----------to be changed--------------
        mov ah, 0
        int 16h
        ;AL contains ascii of key pressed
        ;-------------------------------------------------INPORTANT NOTE-------------------------------------------------------
        ;DON'T CALL ANY FUNCTION HERE THAT CHANGES THE VALUE OF AX,
        ;IF YOU WANT TO USE AX, PUSH IT IN REG THEN POP WHEN YOU FINISH TO RESTORE ITS VALUE 
        Gun:
            ;right arrow
            right:
                cmp ah, 4Dh ;compare key code with right key code
                jnz left    ;if the key is not right, jump to next check
                add gunNewX, 3  ;if the key is right, move the gun 3 pixels to the right
                jmp Game
            ;left arrow    
            left:
                cmp ah, 4Bh
                jnz up
                sub gunNewX, 3
                jmp Game
            ;up arrow
            up:
                cmp ah, 48h
                jnz down
                sub gunNewY, 3
                jmp Game
            ;down arrow
            down:
                cmp ah, 50h
                jnz space
                add gunNewY, 3
                jmp Game

            space:
                cmp ah, 39h
                jnz commandIn
                CALL FireGun_initial
                jmp Game
        EndGun:
        commandIn:
            backSpace:
                cmp ah, 0Eh
                jnz InsertChar
                cmp cmdCurrSize, 0 ;if the string is empty, do nothing and continue the main loop
                jz Game
                mov di, cursor ;get cursor
                dec di
                mov [di], '$$' ;to delete a character, put $. we add 2 $ because it's a word
                dec cmdCurrSize ;decrement cursor
                mov cursor, di
                horizontalline 170,0,320            ;horizontal line
                drawrectangle  120,0,0dh,10,120     ;draw the background of the command after deleting to override the old command

                horizontalline 145,162,319          ;horizontal line
                drawrectangle  120,161,0Eh,10,120
                jmp Game
            InsertChar:
                ;Validation
                ; ; there is no supported characters under 30h
                ; ; range of number 30h->39h
                ; cmp al, 30h
                ; jl Game
                ; cmp al, 39h
                ; jg isChar
                ; jmp concat
                ; ;range of small letters 61h->7Ah
                ; isChar:
                ;     cmp al, 61h
                ;     jl isObracket
                ;     cmp al, 7Ah
                ;     jg Game
                ;     jmp concat
                ; ;next 2 for addressing modes
                ; isObracket:
                ;     cmp al, 5Bh
                ;     jnz isCbracket
                ;     jmp concat
                ; isCbracket:
                ;     cmp al, 5Dh
                ;     jnz isComma
                ;     jmp concat
                ; isComma:
                ;     cmp al, 2Ch
                ;     jnz Game
                ;     jmp concat
                ; ; concatinate the character after validation
                IsEnter:
                    cmp al, 13d
                    jnz concat
                    CALL execute
                    ;------------------------Print, peter-----------------------------
                    MOV AL,Source ;PUT THE REAMINDER IN THE AL TO DIVIDE IT AGAIN
                    MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
                    MOV BL,10h ;THE DIVISION THIS TIME IS OVER 10
                    DIV BL
                    
                    MOV DL,AL ;TO DISPLAY THE TENS 
                    MOV CH,AH ;TO SAVE THE REMAINDER THE UNITS
                    
                    ADD DL,30H
                    MOV AH,02
                    INT 21H  
                    
                    MOV DL,CH ;NO DIVISION
                    ADD DL,30H
                    MOV AH,02H
                    INT 21H
                    ;------------------------Print, peter-----------------------------
                    CALL ClearCommandString
                    CALL SwitchTurn
                jmp game
            
                    
            



                concat:
                    mov dl, cmdCurrSize
                    cmp dl, cmdMaxSize
                    jz endInsertChar
                    mov di, cursor 
                    mov [di], al
                    inc cmdCurrSize
                    inc di
                    mov cursor, di
            endInsertChar:
        endcommandIn:



        ;Exit game if key if F3
        cmp al, 13h
        jz MainScreen
        jmp Game
EndGame:
HLT
MAIN ENDP

PrintCommandString PROC
    ;-----set cursor---
    cmp Turn, 1
    jnz isTurn2
    MOV  DL, 0        ;column
    JMP isTurn1End
    isTurn2:
    MOV  DL, 20        ;column
    isTurn1End:
    MOV  DH, 15      ;row
    MOV  BH, 0        ;page
    MOV  AH, 02H      ;set cursor 
    INT  10H
    ;----print----
    mov ah, 9h
    mov dx, offset commandS
    int 21h        
    RET
PrintCommandString ENDP

ClearCommandString PROC
    MOV SI, OFFSET EmptyString
    MOV DI, OFFSET commandS
    MOV CX, 22
    REP MOVSB
    MOV DI, OFFSET commandS
    MOV Cursor, DI
    MOV cmdCurrSize, 0
    ;-----------------DRAW BACKGROUND RECTANGLE AGAIN TO OVERRIDE CURRENT DISPLAYED STRING----
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  120,0,0dh,10,120     ;draw the background of the command after deleting to override the old command

    horizontalline 145,162,319          ;horizontal line
    drawrectangle  120,161,0Eh,10,120
    RET
ClearCommandString ENDP

;description
SwitchTurn PROC
    cmp Turn, 1
    jnz SwitchTo1
    MOV  Turn, 2
    JMP SwitchTo2End
    SwitchTo1:
    MOV  Turn, 1        ;column
    SwitchTo2End:
    RET
SwitchTurn ENDP
END MAIN