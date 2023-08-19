
$regfile = "m64def.dat"
Const Loaderchip = 64


'$regfile = "m328pbdef.dat"
'Const Loaderchip = 328
'$PROG &HFF, &HDE , &HC1 , &HF6



$crystal = 16000000
$hwstack = 128
$swstack = 128
$framesize = 128
$baud = 57600
$version 1 , 1 , 245




Config Watchdog = 2048
Start Watchdog



$PROGRAMMER = 3
const debg = 0






#if Loaderchip = 328
   Config Scl = Portc.5
   Config Sda = Portc.4
   I2cinit
   Config I2cdelay = 5
   test_led alias portd.5   : config test_led = output
   io_en alias portd.7   : config io_en = output
   fail_led alias portd.6   : config fail_led = output'  : set fail_led

   exp_int alias pine.7 : config exp_int = input  : set porte.7
   Config 1wire = Porte.1
#endif


#if Loaderchip = 64
   config portb = output
   Config Portc = input
   portc = 255
   Config Scl = PortG.4
   Config Sda = Portg.3
   Config I2cdelay = 1
   I2cinit

   test_led alias portd.5   : config test_led = output
   io_en alias portd.6   : config io_en = output
   fail_led alias portd.7   : config fail_led = output'  : set fail_led
   exp_int alias pind.2 : config exp_int = input  : set portd.2
   Config 1wire = Porte.2

   Config Timer1 = Timer , Prescale = 256
   Dim Wtime As Byte
   On Timer1 Pulse:
#endif




Const RTC_R = &HD1
Const RTC_W = &HD0
Const EXP_R = &H4D
Const EXP_W = &H4C
Const ADC_W = &H90
Const ADC_R = &H91

Dim adc_data As Word
Dim ADC_l_byte As Byte At adc_data Overlay
Dim ADC_h_byte As Byte At ADC_l_byte + 1 Overlay


Config Com1 = 57600 , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
Config Com2 = 9600 , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
Open "COM1:57600,8,n,1" For Binary As #1
Open "COM2:9600,8,n,1" For Binary As #2




Config Serialin = Buffered , Size = 32
Dim S As String * 32 , Str_com As String * 32
Dim s_buf(32) As Byte At S Overlay



Config Serialin1 = Buffered , Size = 200 , Bytematch = All
Dim S2 As String * 255 , Ns2 As Byte , Rs2 As Byte , Str_com2 As String * 254  , b2 as byte  , serial_ready as bit
Dim Buf(250) As Byte At S2 Overlay



Dim Arg(5) As String * 8 , el_count as byte , i as byte , port_mask as byte
dim adc_args(2) as byte  , tmp_str as string*8

dim time_long as long
dim _tm(4) as byte At time_long Overlay

dim temp as byte

Declare function serial_read() as string
declare function readADC(byval adc_ch As Byte , byval pga as byte) as string*6
declare sub io_data_write (byval arg1 as byte)
declare function io_data_read ()as byte
declare function i2c_devices_check(byval arg1 as byte)as byte

declare function 1W_RTC_reset()as byte
declare function 1W_RTC_write()as byte
declare function 1W_RTC_read()as byte
declare function 1W_KEY_check()as byte
declare function 1W_KEY_write_new()as byte



dim validator_enable as byte , operation as byte , operation_request as byte , init_reques as byte , err_detect as byte
init_reques = 0
declare sub cash_add(byval value_tmp as byte)
declare sub init_validator()
declare sub keepalive_validator(byval arg as byte)




Config Clock = User                                         'Use USER to write/use your own code
Config Date = Dmy , Separator = .



Dim 1w_key(8) As Byte

Dim Ar(8) As Byte ,  C As Byte

1w_key(8) = &h1d
1w_key(7) = &h00
1w_key(6) = &h00
1w_key(5) = &h00
1w_key(4) = &h57
1w_key(3) = &h32
1w_key(2) = &h36
1w_key(1) = &h24

'0 - 000 : FSR = ±6.144 V
'1 - 001 : FSR = ±4.096 V
'2 - 010 : FSR = ±2.048 V (default)
'3 - 011 : FSR = ±1.024 V
'4 - 100 : FSR = ±0.512 V
'5 - 101 : FSR = ±0.256 V
'6 - 110 : FSR = ±0.256 V
'7 - 111 : FSR = ±0.256 V
io_data_write 0

'if 1W_KEY_check() > 0 then
'   do
'      reset Watchdog
'      print "err:invalid 1W_key"
'      toggle fail_led
'      waitms 500
'   loop
'end if

Enable Interrupts
waitms 100

'adc:0:2:r{013}
'in:ff:h:r{013}
'out:b:00000001:s{013}
'




'Date$ = "09.01.22"
'Time$ = "20:47:00"
'1W_RTC_write


'do
'   if 1W_RTC_read() > 0 then
'   print "err:rtc:read"
'   end if
'   print "32bit - " ; time_long ; " d > " ; date$ ; " t> " ;time$
'   wait 1
'   reset Watchdog
'loop

Enable Timer1
do
   if init_reques = 1 then
      init_validator
      init_reques = 0
      validator_enable = 1
   end if


   reset Watchdog
   If Ischarwaiting() = 1 Then
      set test_led
      Str_com = serial_read()
      el_count = split(Str_com , Arg() , ":")
      #if debg = 1
         print el_count
         for i = 1 to el_count
            print "arg(" ; i ; ") " ; Arg(i)
         next
      #endif

      if Arg(1) = "out" and Arg(4) = "s" then
         select case Arg(2)
            case "b" : if len(arg(3)) = 8 then   : io_data_write binval(Arg(3)) : else : print "err:input:bin" : end if
            case "h" : if len(arg(3)) = 2 then   : io_data_write hexval(Arg(3)) : else : print "err:input:hex" : end if
            case "d" : if val(arg(3)) < 256 then : io_data_write val(Arg(3))     : else : print "err:input:dec" : end if
            case else : print "err:datatype:arg"
         end select
      end if
      if Arg(1) = "in" and Arg(4) = "r" then
         select case Arg(3)
            case "b" : port_mask = binval(Arg(2)) : temp = io_data_read() : temp = temp and port_mask : print "in:b:" ; bin(temp) ; ":s"
            case "h" : port_mask = hexval(Arg(2)) : temp = io_data_read() : temp = temp and port_mask : print "in:h:" ; hex(temp) ; ":s"
            case "d" : port_mask = val(Arg(2)) : temp = io_data_read() : temp = temp and port_mask : print "in:v:" ; temp ; ":s"
            case else : print "err:datatype:arg"
         end select
      end if
      if Arg(1) = "adc" and Arg(4) = "r" then
         adc_args(1) = val(Arg(2))
         adc_args(2) = val(Arg(3))
         tmp_str = readADC(adc_args(1) , adc_args(2))
         print "adc:"; Arg(2);":"; tmp_str ;":e"
      end if

      if Arg(1) = "val" and Arg(4) = "s" then
         if Arg(3) = "1" then
            init_reques = 1
            print "val:1:1:s"
         end if
         if Arg(3) = "0" then
            print "val:0:0:s"
            validator_enable = 0
         end if
      end if
      reset test_led
   end if


   if serial_ready = 1 then
      waitms 10
      if buf(5) = &hcc and buf(6) = &hee  then
         select case  buf(7)
            case  &h01 : cash_add 1
            case  &h02 : cash_add 2
            case  &h03 : cash_add 5
            case  &h04 : cash_add 10
            case  &h05 : cash_add 20
            case  &h06 : cash_add 50
            case  &h07 : cash_add 100
         end select
      end if
      if buf(4) = &hcc and buf(5) = &hee then
         select case  buf(6)
            case  &h01 : cash_add 1
            case  &h02 : cash_add 2
            case  &h03 : cash_add 5
            case  &h04 : cash_add 10
            case  &h05 : cash_add 20
            case  &h06 : cash_add 50
            case  &h07 : cash_add 100
         end select
      end if
      'print #1 , hex(buf(1)) ; hex(buf(2)) ;  hex(buf(3))
      err_detect = 0
      reset serial_ready
   end if


   if operation_request >= 1 then
      operation_request = 0
      keepalive_validator operation
      if err_detect > 2 then
         print "err:validator:1"
      end if
   end if

loop

'END program-------------------------------------------------------------------------------




Serial1bytereceived:
   B2 = Inkey(#2)
   if b2 = &h7f then : s2 = "" : set serial_ready : end if
   s2 = s2 + chr(b2)
Return



pulse:
   incr operation
   if operation => 2 then : operation = 0 : end if
   operation_request = 1
return



sub cash_add(byval value_tmp as byte)
   print #1 , "val:add:" ; value_tmp ; ":c"
end sub


sub keepalive_validator(byval arg as byte)
   if validator_enable = 1 then
      if err_detect < 254 then : incr err_detect : end if
      select case arg
         case 0 : print  #2 , chr(&h7f) ;  chr(&h80) ; chr(&h01) ;chr(&h07) ; chr(&h12) ; chr(&h02) ;
         case 1 : print  #2 , chr(&h7f) ;  chr(&h00) ; chr(&h01) ;chr(&h07) ; chr(&h11) ; chr(&h88) ;
      end select
   end if
end sub



sub init_validator()
   print  #2 , chr(&h7f) ;  chr(&h80) ; chr(&h01) ;chr(&h11) ; chr(&h65) ; chr(&h82) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h00) ; chr(&h01) ;chr(&h07) ; chr(&h11) ; chr(&h88) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h80) ; chr(&h01) ;chr(&h11) ; chr(&h65) ; chr(&h82) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h00) ; chr(&h03) ;chr(&h30) ; chr(&h05) ; chr(&h16) ;  chr(&hb7) ; chr(&hb5) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h80) ; chr(&h01) ;chr(&h11) ; chr(&h65) ; chr(&h82) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h00) ; chr(&h03) ;chr(&h30) ; chr(&h05) ; chr(&h44) ;  chr(&h58) ; chr(&h04) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h80) ; chr(&h01) ;chr(&h05) ; chr(&h1d) ; chr(&h82) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h00) ; chr(&h03) ;chr(&h02) ; chr(&hff) ; chr(&hff) ;  chr(&h26) ; chr(&h18) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h80) ; chr(&h01) ;chr(&h0a) ; chr(&h3f) ; chr(&h82) ;
   waitms 100
   print  #2 , chr(&h7f) ;  chr(&h00) ; chr(&h01) ;chr(&h23) ; chr(&hc9) ; chr(&h88) ;
   waitms 100
end sub







function 1W_KEY_check()as byte
   local tmp as byte
   Ar(1) = 1wsearchfirst()
   #if debg = 1
      print "FN"
      For tmp = 1 To 8                                             'print the number
         Print Hex(Ar(tmp));
      Next
      Print
      For tmp = 1 To 8                                             'print the number
         Print Hex(1w_key(tmp));
      Next
      Print
      print "end FN"
   #endif

   1W_KEY_check = Compare(Ar , 1w_key , 8)
end function


function 1W_KEY_write_new()as byte


end function

function 1W_RTC_read() as byte
   local tmp as byte
   1wreset                                                  'reset the device
   1wwrite &HCC
   1wwrite &H66
   tmp = 1wread()
   _tm(1) = 1wread()
   _tm(2) = 1wread()
   _tm(3) = 1wread()
   _tm(4) = 1wread()
   Time$ = Time(time_long)
   Date$ = Date(time_long)
   1W_RTC_read = 0
end function

function 1W_RTC_write() as byte
   time_long = Syssec()
   1wreset
   1wwrite &HCC
   1wwrite &H99
   1wwrite &b00001100
   1wwrite _tm(1)
   1wwrite _tm(2)
   1wwrite _tm(3)
   1wwrite _tm(4)
   1W_RTC_write = 0
end function

function 1W_RTC_reset()as byte
   1wreset
   1wwrite &HCC
   1wwrite &H99
   1wwrite &b00001100
   1wwrite &H00
   1wwrite &H00
   1wwrite &H00
   1wwrite &H00
   1W_RTC_reset = 0
end function

Settime:
   #if debg = 1
      print "Settime - event"
   #endif
Return

Getdatetime:
   #if debg = 1
      print "Getdatetime - event"
   #endif
Return

Setdate:
   #if debg = 1
      print "Setdate - event"
   #endif
Return

function i2c_devices_check(byval arg1 as byte)as byte
   local b as byte
   local tmp as byte
   tmp = 1
   For B = 0 To 254 Step 2                                     'for all odd addresses
      I2cstart                                                 'send start
      I2cwbyte B                                               'send address
      If Err = 0 Then
         if b = arg1 then : tmp = 0 : end if
         print hex(b)  ; " - " ; hex(arg1)
      End If
      I2cstop                                                   'free bus
   Next
   i2c_devices_check = tmp
end function

sub io_data_write (byval arg1 as byte)

   #if Loaderchip = 64
      portb = arg1
   #endif

   #if Loaderchip = 328
      local wd as byte
      wd = not arg1
      I2cstart
      I2cwbyte EXP_W
      I2cwbyte wd
      I2cwbyte &HFF
      I2cstop
   #endif
   if arg1 = 0 then : reset io_en : else : set io_en : end if
end sub

function io_data_read () as byte
   #if Loaderchip = 64
      io_data_read = not pinc
   #endif

   #if Loaderchip = 328
      local rd as byte
      I2cstart
      I2cwbyte EXP_R
      I2crbyte Rd , Ack
      I2crbyte Rd , Nack
      I2cstop
      io_data_read = not rd
   #endif
end function

function readADC(byval adc_ch As Byte, byval pga as byte) as string*6
   local ch as byte
   select case adc_ch
      case 0 : ch = &B11000000
      case 1 : ch = &B11010000
      case 2 : ch = &B11100000
      case 3 : ch = &B11110000    '0010
   end select
   Shift pga , Left , 1
   ch = ch + pga
   I2cstart
   I2cwbyte ADC_W
   I2cwbyte 1
   I2cwbyte ch
   I2cwbyte &B10000011
   I2cstop
   Waitms 10
   I2cstart
   I2cwbyte ADC_W
   I2cwbyte 0
   I2cstart
   I2cwbyte ADC_R
   I2crbyte ADC_h_byte , Ack
   I2crbyte ADC_l_byte , Nack
   I2cstop
   if adc_data.15 = 1 Then
      adc_data = 65535 - adc_data
      readADC = "-" + str(adc_data)
   else
      readADC = "+" + str(adc_data)
   end if
end function

function serial_read() as string
   $timeout = 100000
   Input S Noecho
   serial_read = s '+ "<" + str(len(s))
end function

end