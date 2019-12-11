; lab6

.386

INCLUDE D:\irvine\Irvine32.inc
INCLUDE D:\irvine\Macros.inc

.stack 4096

ExitProcess proto,dwExitCode:dword

.code
main proc
	
	finit
	mWrite "Input x: "
	call Crlf
	call ReadFloat

	ftst
	fnstsw ax
	sahf
	jnb L1
	mWrite "Error: x<0!"
	call Crlf
	invoke ExitProcess,0

L1:
	
	mWrite "Input a1: "
	call Crlf
	call ReadFloat

	fld st(1)
	fsqrt
	fmul st(0), st(1)

	mWrite "Input a2: "
	call Crlf
	call ReadFloat

	fld st(3)
	fyl2x

	mWrite "Input a3: "
	call Crlf
	call ReadFloat
	
	fld st(4)
	fsin
	fmul st(0), st(1)

	fadd st(0), st(2)
	fadd st(0), st(3)
	call WriteFloat
	invoke ExitProcess,0
main endp
end main