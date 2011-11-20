@Echo Off
call _make.cmd Plush30A_16Mhz pwm_rc_100
pause
avrdude.exe -C "c:\Program Files\arduino-0022\hardware\tools\avr\etc\avrdude.conf" -v -p m8 -P com5  -c avrisp -b 19200 -U flash:w:bin\Plush30A_16Mhz.hex 



