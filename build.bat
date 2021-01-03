@echo off
cls
rem ------------------------------------------------------
rem 0 = Standard MPAG
rem 1 = Modificaciones para Pac-man
set /A mod = 1
rem ------------------------------------------------------

rem Compile AGD file
	copy AGDsource\%1.agd AGD
	cd AGD
	CompilerZX %1
	
rem Assemble game
	if %mod% == 0 (
		copy %1.asm ..\sjasmplus\
		copy ..\..\user.asm ..\sjasmplus\
		del %1.*
		cd ..\sjasmplus
		copy leader.txt+%1.asm+trailer.txt agdcode.asm
		sjasmplus.exe agdcode.asm --lst=list.txt
		copy test.tap ..\speccy

		rem limpieza en sjasmplus
			del %1.asm
			del user.asm
			del agdcode.asm
			del test.tap

		rem Start emulator
			cd ..\speccy
			speccy -128 test.tap
			del test.tap
			cd ..
		)
	if %mod% == 1 (
		copy %1.asm ..\assembly\
		copy ..\..\user.asm ..\assembly\
		del %1.*
		cd ..\assembly
		copy ..\Basic\loader48k.bas ..\assembly\
		copy ..\Tapes\SC.tap ..\assembly\
		..\Tools\bas2tap -e -a1 -sPacman48 loader48k.bas loader.tap
		..\Tools\fart %1.asm 24832 32000
		..\Tools\fart %1.asm "jp gamelp " "jp game"		
		..\Tools\Pasmo --tap --name AG %1.asm AG.tap
		copy /b loader.tap + SC.tap + AG.tap Pacman48.tap
		
		rem limpieza en assembly
			del %1.asm
			del user.asm
			del loader*.*
			del AG.tap
			del SC.tap

		rem Start emulator
			..\speccy\speccy -128 Pacman48.tap
			cd ..
		)
