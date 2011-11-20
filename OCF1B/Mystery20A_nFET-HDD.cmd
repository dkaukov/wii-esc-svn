@Echo Off
call _make.cmd Mystery20A_nFET-HDD pwm_fast_200
pause
avrdude.exe -C "h:\Program Files\arduino-0022\hardware\tools\avr\etc\avrdude.conf" -v -p m8 -P com3  -c avrisp -b 19200 -U flash:w:bin\Mystery20A_nFET-HDD.hex



