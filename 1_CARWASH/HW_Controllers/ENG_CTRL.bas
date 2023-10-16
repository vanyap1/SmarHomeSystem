$regfile = "m64def.dat"
$crystal = 16000000
$hwstack = 40
$swstack = 16
$framesize = 32
$baud = 115200
$version 1 , 2 , 45

test_led alias portd.5   : config test_led = output
stat_led alias portd.6   : config stat_led = output
fail_led alias portd.7   : config fail_led = output'  : set fail_led



btn_lat alias portd.0   : config btn_lat = output  : set btn_lat
btn_dat alias portd.4   : config btn_dat = output  : set btn_dat
btn_clk alias portd.1   : config btn_clk = output  : set btn_clk


config portb = output
Config Portc = input


Config Lcd = 16x2
Config Lcdpin = Pin , Port = PortA , E = Porte.4 , Rs = Portg.0

Config Adc = SINGLE , Prescaler = 128 , Reference = Avcc
Dim adc_data As Word  , vbat as single , callibration_factor as single


'0.0275862
callibration_factor = 0.0275862



Initlcd
Cursor Off
cls
Locate 1 , 1 : Lcd "ver:" ; Version(2)
Locate 2 , 1 : Lcd "f:" ; Version(3)
wait 2
cls




dim s as string*20 , tmp_str as string*3
dim count as byte

dim data_transfer as byte

Start Adc

dim start_time as word

do

adc_data = Getadc(2)
vbat = adc_data * callibration_factor
tmp_str = str(count)
s = "HB " + format(tmp_str , "000")






if  pinc.0 = 0 then
set portb.7                          'VCC Enable
wait 3
set portb.6                          'Starter EN
start_time = 0

do                                    'Check When start
waitms 100
incr start_time
if start_time > 50 then
goto err_lbl
end if

adc_data = Getadc(2)
vbat = adc_data * callibration_factor
Locate 1 , 1
Lcd fusing(vbat , "#.#" ) ; "  "
Locate  2 , 1 : LCD  start_time ; "0   "
loop until vbat > 13
reset portb.6


do
adc_data = Getadc(2)
vbat = adc_data * callibration_factor
Locate 1 , 1
Lcd fusing(vbat , "#.#" ) ; "  "
Locate  2 , 1 : LCD  "RUN     " ;  start_time ; "0   "

loop until pinc.0 = 1
reset portb.7

ELSE

adc_data = Getadc(2)
vbat = adc_data * callibration_factor
Locate 1 , 1
Lcd fusing(vbat , "#.#" ) ; "  "
Locate  2 , 1 : LCD  "IDLE     "

end if



'portb.7 = not pinc.0
'wait 1
'if pinc.0 = 0 and vbat < 13.5 then
'set portb.6
'wait 3
'reset portb.6
'wait 2
'end if





toggle stat_led
incr count
waitms 500
loop



err_lbl:
set fail_led
reset portb.6
reset portb.7
do
locate 1,1 : lcd "START ERROR"

loop