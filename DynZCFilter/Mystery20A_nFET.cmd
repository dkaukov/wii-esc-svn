@Echo Off
call _make.cmd Mystery20A_nFET pwm_fast_250
pause
avrdude.exe -C "c:\Program Files\arduino-0022\hardware\tools\avr\etc\avrdude.conf" -v -p m8 -P com5  -c avrisp -b 19200 -U flash:w:bin\Mystery20A_nFET.hex



