datas segment
    buffer db 2, ?, 2 dup(?)   ;缓冲区
    array db 100 dup(?)  ;10x10的二维数组平展为100维的一维数组
    note1 db 'please input N:$'
datas ends

stack segment stack
  db 100 dup(?)        ;堆栈
stack ends

codes segment
  assume cs:codes,ds:datas,ss:stack

start:  
  mov ax, stack
  mov ss, ax

  mov ax, datas
  mov ds, ax

  lea dx, note1
  mov ah, 09h
  int 21h

  lea dx, buffer
  mov ah, 0ah
  int 21h

  mov ah, 02h     ;回车加换行
  mov dl, 0dh
  int 21h
  mov ah, 02h
  mov dl, 0ah
  int 21h

  mov bl, [buffer+2]
  sub bl, 30h   ;转为数值
  mov al, bl
  mul bl         ;note that: mov ax, al*al
  mov bx, ax
  mov cx, ax

l1: 
  mov array[bx-1], cl
  dec bx
  loop l1

  mov cx, 0   ;坐标初始化为0

l2:
  mov al, [buffer+2]
  sub al, 30h   ;转为数值
  mul ch   ;ax=N*ch ch为行标，cl为列标
  add al, cl  ;al=al+cl 为要打印的数的下标
  mov bx, ax
  mov al, array[bx]  ;al为要打印的数 
  mov dl, 10
  div dl        ;al = al/10, 商在al, 余数在ah
  mov dl, al    ;十位
  cmp dl, 0    ;不输出十位上的0
  je temp
  add dl, 30h   ;转为字符
  push ax
  mov ah, 02h   ;显示输出ascii码
  int 21h
  pop ax

temp: 
  mov dl, ah   ;个位
  add dl, 30h
  mov ah, 02h   ;显示输出ascii码
  int 21h   
  cmp ch, cl
  jz nextline ;行结束，进行判断
  mov dl, 32    ;否则打印空格
  mov ah, 02h   
  int 21h
  inc cl
  jmp l2

nextline:
  mov ah, 02h     ;回车加换行
  mov dl, 0dh
  int 21h
  mov ah, 02h
  mov dl, 0ah
  int 21h

  mov cl, 0
  inc ch  ;行++
  mov bl, [buffer+2]
  sub bl, 30h   ;转为数值
  cmp ch, bl  ;ch<N则继续下一行 
  jnz l2

exit:
  mov ax, 4C00H   ;程序结束，返回dos
  int 21h

codes ends
end start