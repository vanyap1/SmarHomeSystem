$regfile = "xm256A3BUdef.dat"
$crystal = 32000000                     '32MHz
$hwstack = 128
$swstack = 128
$framesize = 128

Config Osc = Enabled , 32mhzosc = Enabled  , 32khzosc = Enabled
Config Sysclock = 32mhz , Prescalea = 1 , Prescalebc = 1_1


$forcesofti2c                                               ' with this the software I2C/TWI commands are used when inlcuding i2c.lbx
$lib "i2c.lbx"

heartbeat alias portf.6
config heartbeat = output



rel1 alias portb.2 : config rel1 = output
rel2 alias portb.3 : config rel2 = output

in1 alias pINb.0 : config in1 = input
in2 alias pINb.1 : config in2 = input


spi_rst alias portc.0 : config spi_rst = output : set spi_rst
can_en alias portc.1 : config can_en = output : set can_en
can_int alias pinc.2 : config can_int = input

Config 1wire = Porta.1


dim serialflg as bit
Config Com5 = 9600 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
Config Com7 = 115200 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
Config Serialin = Buffered , Size = 255
Config Serialin1 = Buffered , Size = 254   , Bytematch = all
Config Serialin2 = Buffered , Size = 254   , Bytematch = 13
Config Serialin3 = Buffered , Size = 254   , Bytematch = 13
Dim S2 As String * 255 , Ns2 As Byte , Rs2 As Byte , Str_com2 As String * 200


Config Tcc0 = Normal , Prescale = 1024
Tcc0_per = 7812       '32MHz/1024 = 31250
On Tcc0_ovf Tc0_isr                               'Setup overflow interrupt of Timer/Counter C0 and name ISR





set portf.2 : set portf.3
Open "com7:" For Binary As #1
Open "com5:" For Binary As #2

Config Scl = Porte.1
Config Sda = Porte.0
Config I2cdelay = 10
I2cinit


declare sub read_voltage()
declare sub read_current()
declare sub read_shunt()
declare sub read_power()
Declare Sub Ethernet()
Declare function serial_read() as string
Declare Sub Read_pressure(pressure_mpl As Word , Temp_mpl As Single)
declare sub sht_temp(byval command as byte)
dim sht_read_request as byte
dim room_humidity as word
dim room_temp as word
Dim Ctr As Byte , Dataword As Word , Command As Byte , Dis As String * 20 , Calc As Single
Dim Calc2 As Single , Rhlinear As Single , Rhlintemp As Single , Tempc As Single , Tempf As Single
Dim Tin As Single , Tout As Single , Rin As Single , Rout As Single





Const C1 = -4
Const C2 = 0.0405
Const C3 = -0.0000028
Const T1c = .01
Const T2_sht = .00008
Const T1f = .018
const humidity_command = &B00000101
const temperature_command = &B00000011

Sck Alias Porta.6
Dataout Alias Porta.7
Datain Alias Pina.7
Config Sck = Output 'sck
Config Dataout = Output
Set Dataout







Dim Sport as string*128 , Str_com As String * 128


Config Spic = Hard , Master = Yes , Mode = 0 , Clockdiv = Clk2 , Data_order = Msb , Ss = auto

Waitms 100




Config Tcpip = Noint , Mac = 12.128.12.34.56.78 , Ip = 192.168.1.8 , Submask = 255.255.255.0 , Gateway = 192.168.1.1 , Localport = 80 , Chip = W5500 , Spi = Spic , Cs = Portc.4
Waitms 100                                          ' long SNTP time
'dim used variables
Dim S As String * 512                                      '700
Dim Buf(512) As Byte At S Overlay
Dim Tempw As Word
Dim I As Byte , Bcmd As Byte
dim eth_str as string*128
dim teststr as string*1000
dim key_poz as byte


dim lcd_str1 as string*22
dim lcd_str2 as string*22
dim lcd_str3 as string*22
dim lcd_str4 as string*22



Dim S05 As bit
Dim Byte0 As Byte
Dim Byte1 As Byte
Dim Sign As String * 1
Dim T As Word
Dim T1 As Single
Dim T2 As Byte
Dim Temp_str_ds As String * 10
Dim T_tmp As String * 4
Dim Press_pm As Word , Temp_pm As Single
Dim P_tmp As String * 6
dim masure_atomat as byte

Rs485dir Alias Porta.0
Config Rs485dir = Output
Rs485dir = 0
dim pm as byte , pm_s as string*2
pm=1

dim boiler_stat as string*5
boiler_stat = "false"
Config Priority = Static , Vector = Application , Lo = Enabled ' the RTC uses LO priority interrupts so these must be enabled !!!
Enable Interrupts ' as usual interrupts must be enabled
Enable Tcc0_ovf , Lo








dim config_reg as integer
Dim config_l As Byte At config_reg Overlay
Dim config_h As Byte At config_reg + 1 Overlay

dim ShuntReg as integer
Dim ShuntReg_l As Byte At ShuntReg Overlay
Dim ShuntReg_h As Byte At ShuntReg + 1 Overlay

dim VoltageReg as integer
Dim VoltageReg_l As Byte At VoltageReg Overlay
Dim VoltageReg_h As Byte At VoltageReg + 1 Overlay

dim CallibrationReg as integer
Dim CallibrationReg_l As Byte At CallibrationReg Overlay
Dim CallibrationReg_h As Byte At CallibrationReg + 1 Overlay


dim CurrentReg as integer
Dim CurrentReg_l As Byte At CurrentReg Overlay
Dim CurrentReg_h As Byte At CurrentReg + 1 Overlay

dim PowerReg as integer
Dim PowerReg_l As Byte At PowerReg Overlay
Dim PowerReg_h As Byte At PowerReg + 1 Overlay

CallibrationReg = 900'26931

const reset_bit = 0
const AVG = &b100
const VBUSCT = &b110
const VSHCT = &b110
const run_mode = &b111
dim real_voltage as single , int_voltage as integer
dim real_current as single , int_current as integer

config_reg = reset_bit
shift config_reg , left , 6
config_reg = config_reg + AVG
shift config_reg , left , 3
config_reg = config_reg + VBUSCT
shift config_reg , left , 3
config_reg = config_reg + VSHCT
shift config_reg , left , 3
config_reg = config_reg + run_mode


I2cstart
I2cwbyte &h80
I2cwbyte &h05
I2cwbyte CallibrationReg_h
I2cwbyte CallibrationReg_l
I2cstop


I2cstart
I2cwbyte &h80
I2cwbyte 0
I2cwbyte config_h
I2cwbyte config_l
I2cstop



RTC32_CNT = 100
RTC32_CTRL.0 = 1
print #1 , "START"

Enable Interrupts ' as usual interrupts must be enabled
Config Watchdog = 8000
Start Watchdog



do
   reset watchdog
'print #1 , "int2"
   'waitms 100



   Call Ethernet()
   if Ischarwaiting(#2) = 1 then

      Str_com = serial_read()
      delchars Str_com,&h0d
      delchars Str_com,&h0a
      delchars Str_com,&h22

      if mid(Str_com , 1 , 3) = "PM1" then
         lcd_str1 = "L1:" + mid(Str_com , 5 , 3) + ":" + mid(Str_com , 9 , 5)
      end if
      if mid(Str_com , 1 , 3) = "PM2" then
         lcd_str2 = "L2:" + mid(Str_com , 5 , 3) + ":" + mid(Str_com , 9 , 5)
      end if
      if mid(Str_com , 1 , 3) = "PM3" then
         lcd_str3 = "L3:" + mid(Str_com , 5 , 3) + ":" + mid(Str_com , 9 , 5)
      end if

      if mid(Str_com , 1 , 3) = "BM1" then
         lcd_str4 = "B1:" +  mid(Str_com , 4 , 10)
      end if


      eth_str = lcd_str1 +"/"+ lcd_str2 + "/"+lcd_str3 + "/"+lcd_str4 + "/"
      'print #1 , Temp_str_ds  ; eth_str ; " < " ;  Str_com


   end if

loop



'*******************************************************************************
'Check all sockets status
'*******************************************************************************
dim deb_str as string*10
Sub Ethernet()
   For I = 0 To 3                                              ' for all sockets
      Tempw = Socketstat(i , 0)                               ' get status

      Select Case Tempw
         Case Sock_established
            Tempw = Socketstat(i , Sel_recv)                ' get received bytes

            If Tempw > 0 Then                               ' if there is something received
               Bcmd = 0
               Do
                  Tempw = Tcpread(i , S)                     ' read a line
                  if len(s)>1 then
                     if mid(s, 1, 3) = "GET"  then



                        key_poz = Instr(s , "boiler")
                        if key_poz > 3 then

                           key_poz = key_poz + 7
                           if mid(s, key_poz , 4) = "true" then
                              boiler_stat = "true "
                           else
                              boiler_stat = "false"
                           end if
                           print #1 ,  boiler_stat
                        end if
                        'GET /?gpio=11&boiler=true HTTP/1.1
                        key_poz = Instr(s , "gpio")

                        if key_poz > 3 then
                           key_poz = key_poz + 5
                           if mid(s, key_poz , 1) = "0" then : reset rel1 : end if
                           if mid(s, key_poz , 1) = "1" then : set rel1 : end if
                           incr key_poz
                           if mid(s, key_poz , 1) = "0" then : reset rel2 : end if
                           if mid(s, key_poz , 1) = "1" then : set rel2 : end if
                        end if

                     end if
                  end if
               Loop Until S = ""
               teststr = "/"  + Temp_str_ds + eth_str + str(in1) + str(in2) + "/" + str(room_humidity) + "/"+ str(room_temp) + "/P/" + str(int_voltage) + "/" + str(int_current) + "/" + str(ShuntReg) + "/" + str(PowerReg)
               Tempw = Tcpwritestr(i , teststr , 0)
               Socketdisconnect I                           ' close the connection
            End If
         Case Sock_close_wait
            Socketdisconnect I                              ' we need to close
         Case Sock_closed
            I = Getsocket(i , Sock_stream , 80 , 0)         ' get a new socket on Port 80
            Socketlisten I                                  ' listen
      End Select
   Next
End Sub


sub read_voltage()
   I2cstart
   I2cwbyte &h80
   I2cwbyte &h02
   I2cstart
   I2cwbyte &h81
   I2crbyte VoltageReg_h , Ack
   I2crbyte VoltageReg_l , Nack
   I2cstop
   real_voltage = VoltageReg * 1.293216630
   int_voltage = int(real_voltage)

end sub
sub read_shunt()
   I2cstart
   I2cwbyte &h80
   I2cwbyte &h01
   I2cstart
   I2cwbyte &h81
   I2crbyte ShuntReg_h , Ack
   I2crbyte ShuntReg_l , Nack
   I2cstop
   'waitms 10
end sub
sub read_current()
   I2cstart
   I2cwbyte &h80
   I2cwbyte &h04
   I2cstart
   I2cwbyte &h81
   I2crbyte CurrentReg_h , Ack
   I2crbyte CurrentReg_l , Nack
   I2cstop
   real_current = CurrentReg '* 2.003081664
   int_current  = int(real_current)

end sub
sub read_power()
   I2cstart
   I2cwbyte &h80
   I2cwbyte &h03
   I2cstart
   I2cwbyte &h81
   I2crbyte PowerReg_h , Ack
   I2crbyte PowerReg_l , Nack
   I2cstop
   'waitms 10
end sub

sub sht_temp(command as byte)
   local Datavalue As Word
   local Databyte As Byte
   local iter as long
   Set Sck
   waitus 1
   Reset Dataout
   waitus 1
   Reset Sck
   waitus 1
   Set Sck
   waitus 1
   Set Dataout
   waitus 1
   Reset Sck

   Shiftout Dataout , Sck , Command , 1
   Config Dataout = Input
   Config Datain = Input 'datain
   Set Sck 'click one more off
   Reset Sck
   iter = 0
   do
      incr iter
   loop until Datain = 0 or iter > 200000
   Shiftin Datain , Sck , Databyte , 1 'get the MSB
   Datavalue = Databyte
   'print #1 , iter
   waitus 10
   Config dataout = Output

   Reset Dataout 'this is the tricky part- Lot's of hair pulling- have to tick the ack!
   Set Sck
   Reset Sck
   Config Dataout = Input
   waitus 10
   Shiftin Datain , Sck , Databyte , 1 'get the LSB
   Shift Datavalue , Left , 8
   waitus 10
   Datavalue = Datavalue Or Databyte
   Dataword = Datavalue
   Config dataout = Output

   Reset Dataout
   Set Sck
   Reset Sck
   Config dataout = Input
   waitus 10
   Shiftin Datain , Sck , Databyte , 1 'not using the CRC value for now- can't figure it out! Anybody know how to impliment?
   Config dataout = Output
   waitus 10
   Set Dataout
   Set Sck
   Reset Sck

   if Command = humidity_command then
      Calc = C2 * Dataword
      Calc2 = Dataword * Dataword 'that "2" in the datasheet sure looked like a footnote for a couple days, nope it means "squared"!
      Calc2 = C3 * Calc2
      Calc = Calc + C1
      Rhlinear = Calc + Calc2


      room_humidity = Rhlinear * 10

   end if

   if Command = temperature_command then
      Tempf = T1f * Dataword
      Tempf = Tempf - 40

      Tempc = T1c * Dataword 'get celcius for later calculations and for "the rest of the world"
      Tempc = Tempc - 40
      room_temp = Tempc * 10

   end if
end sub




Tc0_isr:
   toggle heartbeat
   incr pm
   if pm > 4 then : pm = 1 : end if
   if pm = 4 then
      if boiler_stat = "true " then
         pm_s = "41"
      else
         pm_s = "40"
      end if

   else
      pm_s = str(pm) + "1"
   end if

   if pm = 4 then
      incr masure_atomat
      Select Case masure_atomat

         Case 1 : sht_temp temperature_command
         Case 2 : sht_temp humidity_command
         Case 3 : Call Read_pressure(press_pm , Temp_pm)
         case 4 :  1wreset
            1wwrite &HCC
            1wwrite &H44
            read_voltage
      'waitms 1
      'read_shunt
            read_current
      'waitms 1
            read_power
         case 5 :
            1wreset
            1wwrite &HCC
            1wwrite &HBE
            Byte0 = 1wread()
            Byte1 = 1wread()
            If Byte1 > 248 Then
               Byte0 = &HFF - Byte0
               Byte1 = &HFF - Byte1
               Sign = "-"
            Else
               Sign = "+"
            End If
            T1 = Byte0 / 16
            T2 = Byte1 * 16
            T1 = T1 + T2
            If Sign = "-" Then
               T1 = T1 + 1
            End If

            If Sign = "+" And T1 = 0 Then
               Sign = " "
            End If
            T = T1 * 10
         Case 6 : masure_atomat = 0
      End Select



      T_tmp = Str(t)
      T_tmp = Format(t_tmp , "0000")

      P_tmp = Str(press_pm)
      P_tmp = Format(P_tmp , "000000")

      Temp_str_ds =  Sign + T_tmp + "/" + P_tmp + "/"

   end if

   if pm < 5 then
      set Rs485dir
      'waitms 1
      print #2 , pm_s
      waitus 3200
      reset Rs485dir
   end if

Return


Settime:
Return

Getdatetime:
Return

Setdate:
Return

Sectic:
   Toggle heartbeat
   'print #1, "test - " ; str(in1) ; str(in2)
Return

Sub Read_pressure(pressure_mpl As Word , Temp_mpl As Single)
   Local Alt_static As Single , Alt_temp As Single , Tmp_frac As Byte
   Local Mpl_dev_id As Byte , Mpl_status As Byte , Mpl_int As Integer
   Local Mpl_alt_msb As Byte , Mpl_alt_csb As Byte , Mpl_alt_lsb As Byte
   Local Mpl_temp_msb As Byte , Mpl_temp_lsb As Byte
   Local Timer_static As Single , Dt_static As Single
   Local Pressure As Word , Pressure_p As Long , Pressure_mm As Single , Sens_id As Byte
   I2cstart
   I2cwbyte &HC0                                           'write addr.
   I2cwbyte &H0C
   I2crepstart
   I2cwbyte &HC1
   I2crbyte Sens_id , Nack
   I2cstop
   I2cstart
   I2cwbyte &HC0
   I2cwbyte &H26
   I2cwbyte &B00111001
    'I2cwbyte &HB8
   I2cstop
   I2cstart
   I2cwbyte &HC0
   I2cwbyte &H13
   I2cwbyte &H07
   I2cstop
   I2cstart
   I2cwbyte &HC0
   I2cwbyte &H26
   I2cwbyte &B00111001
   I2cstop
   I2cstart
   I2cwbyte &HC0                                           'write addr.
   I2cwbyte &H01
   I2crepstart
   I2cwbyte &HC1
   I2crbyte Mpl_alt_msb , Ack
   I2crbyte Mpl_alt_csb , Ack
   I2crbyte Mpl_alt_lsb , Ack
   I2crbyte Mpl_temp_msb , Ack
   I2crbyte Mpl_temp_lsb , Nack
   I2cstop
   Tmp_frac = Mpl_alt_lsb
   Shift Tmp_frac , Right , 4                             'use bit7-4
   Pressure = Makeint(mpl_alt_csb , Mpl_alt_msb)
   Pressure_p = Pressure * 4
   Pressure_mm = Pressure_p / 133.322
   Mpl_int = Makeint(mpl_alt_csb , Mpl_alt_msb)
   Alt_static = Tmp_frac / 10
   Alt_static = Alt_static + Mpl_int
   Tmp_frac = Mpl_temp_lsb
   Shift Tmp_frac , Right , 4                             'use bit7-4
   Alt_temp = Tmp_frac / 10
   Alt_temp = Alt_temp + Mpl_temp_msb
   Pressure_mpl = Pressure_mm
   Temp_mpl = Alt_temp
End Sub

function serial_read() as string
'Waitms 50
   'S2 = ""
   'Ns2 = Inkey(#2)
   'If Ns2 <> 10 Then
   '   $timeout = 100
   '   Input #2 , S2 Noecho
   '   If Ns2 <> 10 Then S2 = Chr(ns2) + S2
   'End If

    'serial_read = S2
   $timeout = 1600000
   Input #2 , Sport Noecho
   serial_read = Sport '+ "<" + str(len(s))
end function

Serial1bytereceived:
Return



Serial0bytereceived:
   set serialflg
Return


SERIAL0CHARMATCH:
   set serialflg
return
SERIAL1CHARMATCH:
   set serialflg
return
SERIAL2CHARMATCH:
   set serialflg
return
SERIAL3CHARMATCH:
   set serialflg
return

