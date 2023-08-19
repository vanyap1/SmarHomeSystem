$regfile = "m64def.dat"
$crystal = 16000000
$hwstack = 40
$swstack = 16
$framesize = 32
$version 1 , 0 , 60

$PROGRAMMER = 3 'external

Config Timer1 = Timer , Prescale = 64
Dim Wtime As Byte
On Timer1 Pulse:
dim f_alive as byte



test_led alias portd.5   : config test_led = output : set test_led
stat_led alias portd.6   : config stat_led = output
fail_led alias portd.7   : config fail_led = output : set fail_led



btn_lat alias portd.0   : config btn_lat = output  : set btn_lat
btn_dat alias portd.4   : config btn_dat = output  : set btn_dat
btn_clk alias portd.1   : config btn_clk = output  : set btn_clk

io_stat alias pine.6 : config porte.6 = input
dim io_tmp as byte  , out_tmp as byte

config portb = output
Config Portc = input


Config Com1 = 115200 , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
Config Com2 = 9600 , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
Open "COM1:115200,8,n,1" For Binary As #1
Open "COM2:9600,8,n,1" For Binary As #2

Config Serialin = Buffered , Size = 200
Config Serialin1 = Buffered , Size = 200 , Bytematch = All



Dim S1 As String * 255 , Ns1 As Byte , Rs1 As Byte , Str_com1 As String * 200
Dim S2 As String * 255 , Ns2 As Byte , Rs2 As Byte , Str_com2 As String * 254  , b2 as byte  , serial_ready as bit
Dim Buf(250) As Byte At S2 Overlay
dim v_stat as byte , validator_enable as byte
dim port_stat as string*8
dim sequenter as byte
dim error_timer as byte , io_overload_timer as byte

error_timer = 10

Declare Sub Getline1(s1 As String)
Declare Sub Flushbuf1()
declare sub cash_add(byval value_tmp as byte)
declare sub init_validator()
declare sub keepalive_validator(byval arg as byte)



Enable Interrupts



init_validator
waitms 100
set test_led
wait 2
validator_enable = 1
reset test_led

Enable Timer1
do

if error_timer > 0 then
set fail_led
else
reset fail_led
end if



if io_stat = 0 then
error_timer = 10
io_overload_timer = 10
portb = 0
else
if io_overload_timer = 0 then : portb = out_tmp : end if
end if


   If Ischarwaiting(#1) = 1 Then
      Waitms 10
      Getline1 S1
      Flushbuf1
      if left(s1 , 2) = "en" then : init_validator : validator_enable = 1 : end if
      if left(s1 , 2) = "of" then : validator_enable = 0 : end if
      if left(s1 , 2) = "io" then
      port_stat = mid(s1 , 3 , 8)
      if len(port_stat) = 8 then
      out_tmp = binval(port_stat)
      else
      error_timer = 10
      print #1 , "len_err"
      end if
      end if

      if left(s1 , 3) = "ver" then
      print  #1 , VERSION(1) ; " / " ; VERSION(2) ; " / " ; VERSION(3)
      error_timer = 20
      end if

      if left(s1 , 3) = "run" then : print #1 , "ok" : end if
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
      'print #1 , hex(buf(5)) ; hex(buf(6)) ;  hex(buf(7))
      reset serial_ready
   End If
loop


sub cash_add(byval value_tmp as byte)
   print #1 , "inserted - " ; value_tmp
end sub


Sub Getline1(s1 As String)

   S1 = ""
   Ns1 = Inkey(#1)
   If Ns1 <> 10 Then
      $timeout = 1000
      Input #1 , S1 Noecho
      If Ns1 <> 10 Then S1 = Chr(ns1) + S1
   End If
End Sub

Sub Flushbuf1()

   Do
      Ns1 = Inkey(#1)
   Loop Until Ns1 = 0
End Sub




Serial1bytereceived:
   B2 = Inkey(#2)
   if b2 = &h7f then : s2 = "" : set serial_ready : end if
   s2 = s2 + chr(b2)
Return


pulse:
   if error_timer > 0 then : decr error_timer : end if
   if io_overload_timer > 0 then : decr io_overload_timer : end if
   toggle stat_led
   incr sequenter
   io_tmp = not pinc
   select case sequenter
      Case 0 : Print #1 , "0"

      Case 1 : keepalive_validator 0
      Case 2 : Print #1 , "IO:" ; bin(io_tmp)
      Case 3 : 'Print #1 , "3"
      Case 4 : Print #1 , "IO:" ; bin(io_tmp)
      Case 5 : keepalive_validator 1
      Case 6 : Print #1 , "IO:" ; bin(io_tmp)
      Case 7 : 'Print #1 , "7"
      Case 8 : Print #1 , "IO:" ; bin(io_tmp)
      Case 9 : if io_overload_timer > 0 then : Print #1 , "overload_io" : end if
      Case 10 : Print #1 , "IO:" ; bin(io_tmp)
         sequenter = 0
   end select
return

sub keepalive_validator(byval arg as byte)
   if validator_enable = 1 then
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

end