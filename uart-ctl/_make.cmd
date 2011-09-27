@ECHO OFF

SET AS="%ProgramFiles%\AvrAssembler2\avrasm2.exe"
SET AS_FLAGS= -I "%ProgramFiles%\AvrAssembler2\AppNotes"
SET OUT=bin

%AS% %AS_FLAGS% -i "..\input\%2.inc" -i "..\hw\%1.inc"  -S "%OUT%\labels.tmp" -fI -W+ie -o "%OUT%\%1.hex" -d "%OUT%\%1.obj" -m "%OUT%\%1.map" -l "%OUT%\%1.lst" "core\bldc.asm"
