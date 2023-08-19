$regfile = "m328pbdef.dat"
$crystal = 8000000
$hwstack = 128
$swstack = 128
$framesize = 160
$baud = 19200

$version 2 , 1 , 50

Config Watchdog = 2048
Start Watchdog

$PROGRAMMER = 3
const debg = 0



Config Scl = Portc.5
Config Sda = Portc.4
I2cinit

Config I2cdelay = 1

Const RTC = &HD0
Const EXP1 = &H4c
Const EXP2 = &H4e


R_ld alias portd.5 : config R_ld = output : reset R_ld
G_ld alias portd.6 : config G_ld = output : reset G_ld
out_en alias portd.7 : config out_en = output : reset out_en


Config Com1 = 19200 , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
Dim S1 As String * 100 , Str_com1 As String * 100
Dim s_buf1(100) As Byte At S1 Overlay

declare function io_update (byval _dat as byte, byval exp_addr as byte) as byte
declare function set_out(byval _dat as byte, byval exp_addr as byte) as byte
declare function get_in(byval exp_addr as byte) as byte
declare function i2c_scan() as byte
Declare sub Com1_read()
Declare function i2c_BITS(byval addres as byte) as string*16

dim tmp as byte , stat as byte , io_tmp(2) as byte
dim output_stat as word , input_stat as word  , keep_alive_timer as byte
Dim Arg(6) As String * 32 , el_count as byte
stat = i2c_scan()



Config Timer1 = Timer , Prescale = 64
Dim Wtime As Byte
Const Timer1pre = 40536 '0.2hz - 16784
On Timer1 convercion_request:
Timer1 = Timer1pre


dim conversion_ready as byte , conversion_start as byte , fail_code as byte


slave_sel alias pinc.1 : config portc.1 = input
slave_en alias pinc.0 : config portc.0 = input

if slave_sel = 0 then
   do
      out_en = slave_en
      if slave_en = 1 then
         set out_en
         g_ld = tmp.2
         r_ld = 0
      else
         reset out_en
         g_ld = 0
         r_ld = 1
      end if
      waitms 10
      Reset Watchdog
      incr tmp
   loop

else
   slave_ctrl alias portc.0 : config portc.0 = output : reset slave_ctrl

   'print "BIST start"
   'print i2c_BITS(EXP1)
   'print i2c_BITS(EXP2)
   'print i2c_BITS(RTC)
end if

'pickit4  (programmer name, only for notice)


Enable Interrupts
'Enable Int0
'Enable Int1
Enable Timer1

do
   reset watchdog
   If Ischarwaiting() = 1 Then
      set G_ld
      Com1_read
      s1 = Lcase(s1)
      el_count = split(s1 , Arg() , ":")
      if el_count = 3 and Arg(1) = "out" then
         print hex(input_stat) ; ";" ; Arg(2)  ; ";" ; keep_alive_timer
         output_stat = hexval(Arg(2))
         keep_alive_timer = 10
      end if
      if el_count = 2 and Arg(1) = "bits" then
         print i2c_BITS(EXP1) ; ";" ; i2c_BITS(EXP2) ; ";" ; i2c_BITS(RTC)
      end if
      reset G_ld
   end if


   if conversion_ready > 0 then
      conversion_ready = 0

      io_tmp(1) = io_update(LOW(output_stat) , EXP1)
      io_tmp(2) = io_update(High(output_stat) , EXP2)
      input_stat = io_tmp(2) * 256
      input_stat = input_stat + io_tmp(1)
      if keep_alive_timer > 0 then
         decr keep_alive_timer
         set out_en
         set slave_ctrl
         reset fail_code.0
      else
         set fail_code.0
         reset out_en
         reset slave_ctrl
      end if
   end if

   if fail_code > 0 then
      set R_ld
   else
      reset R_ld
   end if
loop



convercion_request:
   Timer1 = Timer1pre
   conversion_ready = 1
return

sub Com1_read()
   $timeout = 100000
   Input  S1 Noecho
end sub


function i2c_BITS(byval addres as byte) as string*16
   I2cstart                                                 'send start
   I2cwbyte addres                                               'send address
   If Err = 0 Then                                           'we got an ack
      i2c_BITS = "F:" + Hex(addres) + ":OK"
   else
      i2c_BITS = "F:" + Hex(addres) + ":ERR"
   End If
   I2cstop
end function






function i2c_scan() as byte
   local b as byte
   Print "Scan start"
   For B = 0 To 254 Step 2                                     'for all odd addresses
      I2cstart                                                 'send start
      I2cwbyte B                                               'send address
      If Err = 0 Then                                           'we got an ack
         Print "Slave at : " ; B ; " hex : " ; Hex(b) ; " bin : " ; Bin(b)
      End If
      I2cstop                                                   'free bus
   Next
   Print "End Scan"
   i2c_scan = 1
end function

function set_out(byval _dat as byte , byval exp_addr as byte) as byte
   local wd as byte
   local adrr as byte
   adrr = exp_addr
   print hex(adrr)
   wd = not _dat

   I2cstart
   I2cwbyte adrr
   I2cwbyte wd
   I2cwbyte &HFF
   I2cstop
end function

function get_in(byval exp_addr as byte) as byte
   local rd as byte
   local adrr as byte
   adrr = exp_addr
   incr adrr
   I2cstart
   I2cwbyte adrr
   I2crbyte Rd , Ack
   I2crbyte Rd , Nack
   I2cstop
   get_in = not rd
end function

function io_update (byval _dat as byte , exp_addr as byte) as byte
   local wd as byte
   local rd as byte
   local adrr as byte
   adrr = exp_addr
   wd = not _dat
   I2cstart
   I2cwbyte adrr
   I2cwbyte wd
   I2cwbyte &HFF
   I2cstop
   incr adrr
   I2cstart
   I2cwbyte adrr
   I2crbyte Rd , Ack
   I2crbyte Rd , Nack
   I2cstop
   io_update = not rd
end function