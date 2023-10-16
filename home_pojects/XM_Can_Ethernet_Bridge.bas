$regfile = "xm256A3BUdef.dat"
$crystal = 32000000                     '32MHz
$hwstack = 512
$swstack = 512
$framesize = 512

CONST debg=0

Config Osc = Enabled , 32mhzosc = Enabled  , 32khzosc = Enabled
Config Sysclock = 32mhz , Prescalea = 1 , Prescalebc = 1_1

$bigstrings
$forcesofti2c                                               ' with this the software I2C/TWI commands are used when inlcuding i2c.lbx
$lib "i2c.lbx"

heartbeat alias portf.6
config heartbeat = output

dbg_pin alias porta.0 : config dbg_pin = output


can_act alias porta.2 : config can_act = output : set can_act
can_err alias porta.1 : config can_err = output : set can_err
eth_act alias porta.3 : config eth_act = output : set eth_act
eth_err alias porta.4 : config eth_err = output : set eth_err
net_pin alias porta.5 : config net_pin = output : set net_pin
dim can_led_timer as byte




rel1 alias portb.2 : config rel1 = output
rel2 alias portb.3 : config rel2 = output

in1 alias pINb.0 : config in1 = input
in2 alias pINb.1 : config in2 = input

Config 1wire = Porta.6
dim t_request as byte , t_action as byte
Dim Byte0 As Byte
Dim Byte1 As Byte
Dim Sign As String * 1
Dim T1 As Single
Dim T2 As Byte
dim t as Single
dim t_w as word





spi_rst alias portc.0 : config spi_rst = output : set spi_rst
can_en alias portc.1 : config can_en = output : set can_en
can_int alias pinc.2 : config can_int = input

dim serialflg as bit
Config Com5 = 115200 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
Config Com7 = 115200 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
Config Serialin = Buffered , Size = 255
Config Serialin1 = Buffered , Size = 254   , Bytematch = all
Config Serialin2 = Buffered , Size = 254   , Bytematch = 13
Config Serialin3 = Buffered , Size = 254   , Bytematch = 13
Dim S2 As String * 255 , Ns2 As Byte , Rs2 As Byte , Str_com2 As String * 200

declare function init_can () as byte
declare function check_can () as byte
declare function start_can () as byte
declare function can_write (byval _ID as word) as byte
declare function can_filter (byval _mask as word) as byte
declare function can_write_ (byval _ID as word) as byte
declare function can_read (byref _ID as word ) as byte
declare function check_int() as byte
declare function check_err () as byte
'declare function readADC(byval adc_ch As Byte) as string*7

declare function read_parameter(byval arg1 as byte) as string*16

const bat_voltage_const = 0
const bat_current_const = 1
const bat_capacity_const = 2
const bat_available_const =3
const pump_status_const = 4
const pump_current_const = 5
const current_pow_source = 6


dim bat_energy_long as long
Dim bat_energy_long_0 As Byte At bat_energy_long Overlay
Dim bat_energy_long_1 As Byte At bat_energy_long + 1 Overlay
Dim bat_energy_long_2 As Byte At bat_energy_long + 2 Overlay
Dim bat_energy_long_3 As Byte At bat_energy_long + 3 Overlay

Dim can_bat_voltage as byte

dim can_bat_current as integer
Dim can_bat_current_0 As Byte At can_bat_current Overlay
Dim can_bat_current_1 As Byte At can_bat_current + 1 Overlay

dim sys_flags as byte
dim pump_current as byte



power_source alias sys_flags.0
pump_ok alias sys_flags.1
kotel_error alias sys_flags.2
gateway_error alias sys_flags.3
low_battery alias sys_flags.4
overload alias sys_flags.5




dim can_output_buffer(16) as byte
dim can_input_buffer(16) as byte
dim can_write_data(10) as byte
dim can_read_data(10) as byte
dim can_read_data2(10) as byte


dim status as byte
dim wr_req as byte , rd_req as byte
dim b_count as word
dim CAN_read_request as bit

dim RX_ID as word

const CFG1x1000kbps = &h00 : const CFG2x1000kbps = &h80 : const CFG3x1000kbps = &h80
'const CFG1x500kbps = &h00 : const CFG2x500kbps = &h90 : const CFG3x500kbps = &h82
const CFG1x500kbps = &h00 : const CFG2x500kbps = &hF0 : const CFG3x500kbps = &h86

const CFG1x250kbps = &h00 : const CFG2x250kbps = &hb1 : const CFG3x250kbps = &h85
const CFG1x200kbps = &h00 : const CFG2x200kbps = &hb4 : const CFG3x200kbps = &h86
const CFG1x125kbps = &h01 : const CFG2x125kbps = &hb1 : const CFG3x125kbps = &h85
const CFG1x100kbps = &h01 : const CFG2x100kbps = &hb4 : const CFG3x100kbps = &h86
const CFG1x80kbps = &h01 : const CFG2x80kbps = &hbf : const CFG3x80kbps = &h87
const CFG1x50kbps = &h03 : const CFG2x50kbps = &hb4 : const CFG3x50kbps = &hb6

set portf.2 : set portf.3
Open "com7:" For Binary As #1
Open "com5:" For Binary As #2

Config Scl = Porte.1
Config Sda = Porte.0
Config I2cdelay = 10
I2cinit

Declare Sub Ethernet()
Declare function serial_read() as string
Dim Sport as string*128

Config Spic = Hard , Master = Yes , Mode = 0 , Clockdiv = Clk2 , Data_order = Msb , Ss = auto

Waitms 10
'                                                 Ip = 192.168.1.19

Config Tcpip = Noint , Mac = 12.128.12.14.20.50 , Ip = 192.168.1.19 , Submask = 255.255.255.0 , Gateway = 192.168.1.1 , Localport = 80 , Chip = W5500 , Spi = Spic , Cs = Portc.4

Waitms 10                                          ' long SNTP time
'dim used variables
Dim S As String * 1024                                      '700
Dim Buf(1024) As Byte At S Overlay
Dim Tempw As Word
Dim I As Byte , Bcmd As Byte

dim eth_str as string*2048
Dim eth_tx_buf(2048) As Byte At eth_str Overlay

dim key_poz as byte  , str_len as word  , tmp as byte , Args(10) As String * 32 , Bcount As Byte  , i2 as byte , can_byte_str as string*2 , can_id as word , byte_poz as byte
dim substr as string*256  , str_divider as word

'Kotel status
dim kotel_run_mode as byte , kotel_data_valid_timer as byte , highlite_alm as byte
dim kotel_temp as single  , kotel_temp_tmp as word
dim kotel_h_lim as byte , kotel_delta as byte , kotel_t_run as byte  , kotel_t_stop as byte

dim can_available_timer as byte , eth_available_timer as byte

dim ups_data_valid_timer as byte  , ups_highlite_alm as byte


dim tank_data_valid_timer as byte , tank_highlite_alm as byte
dim dig_in as byte , dig_out as byte , pressure as word , pressure_lim as word , pressure_delta as byte


Config Tcc0 = Normal , Prescale = 1024
Tcc0_per = 7812       '32MHz/1024 = 31250
On Tcc0_ovf Tc0_isr                               'Setup overflow interrupt of Timer/Counter C0 and name ISR


Config Date = YMD , Separator = DOT
Config Clock = Soft , Gosub = Sectic , Rtc32 = 1khz_32khz_crystosc
Rtc32_ctrl.0 = 1

'Date$ = "01.09.09"
Time$ = "14:40:00"

status =  init_can()
waitms 20
status =  start_can()

Config Watchdog = 4000
Config Priority = Static , Vector = Application , Lo = Enabled       ' the RTC uses LO priority interrupts so these must be enabled !!!
Enable Interrupts
Start Watchdog


reset can_act
reset can_err
reset eth_act
reset eth_err
reset net_pin

Print #1 , "START"
do
   reset watchdog
   Call Ethernet()
   status = check_err()
   if status.0 = 1 or status.1 = 1 then
      status =  init_can()
      waitms 20
      status =  start_can()
      waitms 20
      Print #1 , "init"
   end if

   status = can_read(RX_ID)








   if eth_available_timer > 180 then : set eth_err : else : reset eth_err : end if
   if can_available_timer > 10 then : set can_err : else : reset can_err : end if
   if t_request > 0 then
      t_request = 0
      if t_action = 0 then

         1wreset
         1wwrite &HCC
         1wwrite &H44
      else
         1wreset
         if err = 0 then

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

            If Sign = "-" Then : T1 = T1 + 1 : End If
            t_w = t1 * 100
            t = t1
         else
            t = 255
         end if

         can_write_data(1) = t
         can_write_data(2) = 0
         can_write_data(3) = 0
         can_write_data(4) = 0
         can_write_data(5) = 0
         can_write_data(6) = 0
         can_write_data(7) = 0
         can_write_data(8) = &haa
         status = can_write(&h069)

      end if


   end if



   if status > 0 then

      can_available_timer = 0
      can_led_timer = 250
      '#IF debg
      Print #1 , hex(RX_ID) ; "-"  ; hex(can_read_data(1)) ; ";" ; hex(can_read_data(2)) ; ";" ; hex(can_read_data(3)) ; ";" ; hex(can_read_data(4)) ; ";" ; hex(can_read_data(5)) ; ";" ; hex(can_read_data(6)) ; ";" ; hex(can_read_data(7)) ; ";" ;  hex(can_read_data(8))
      '#ENDIF
    'dim kotel_run_mode as byte
    'dim kotel_temp as single  , kotel_temp_tmp as word
    'dim kotel_h_lim as byte , kotel_delta as byte , kotel_t_run as byte  , kotel_t_stop as byte


      if RX_ID = &h033 then
         ups_data_valid_timer = 0
         can_bat_voltage = can_read_data(1)
         can_bat_current_1 = can_read_data(2)
         can_bat_current_0 = can_read_data(3)
         bat_energy_long_3 = can_read_data(4)
         bat_energy_long_2 = can_read_data(5)
         bat_energy_long_1 = can_read_data(6)
         bat_energy_long_0 = can_read_data(7)
         sys_flags = can_read_data(8)
      end if

      if RX_ID = &h043 then

         pump_current= can_read_data(1)
         sys_flags = can_read_data(8)
      end if



      if RX_ID = &h247 then

         kotel_data_valid_timer = 0

         kotel_temp_tmp = can_read_data(2)
         Shift kotel_temp_tmp , left , 8
         kotel_temp_tmp = kotel_temp_tmp +  can_read_data(3)

         kotel_run_mode = can_read_data(1)
         kotel_h_lim =  can_read_data(4)
         kotel_delta =  can_read_data(8)
         kotel_t_run =  can_read_data(6)
         kotel_t_stop = can_read_data(7)

         #IF debg

            print #1 , kotel_temp_tmp
            print #1 , bin(kotel_run_mode)
            print #1 , kotel_h_lim
            print #1 , kotel_delta
            print #1 , kotel_t_run
            print #1 , kotel_t_stop
            print #1 , kotel_data_valid_timer

         #ENDIF
      end if

      if RX_ID = &h301 then
         tank_data_valid_timer  = 0
         dig_in = can_read_data(2)
         dig_out = can_read_data(1)
         pressure = can_read_data(3) * 256
         pressure = pressure + can_read_data(4)
         pressure_lim = can_read_data(5) * 256
         pressure_lim = pressure_lim + can_read_data(6)
         pressure_delta = can_read_data(7)
      end if
   end if

   if can_led_timer > 0 then : decr can_led_timer : set can_act : else : reset can_act : end if
   if kotel_data_valid_timer > 10 then : highlite_alm = 1  : else : highlite_alm = 0  : end if
   if tank_data_valid_timer > 10 then : tank_highlite_alm = 1  : else : tank_highlite_alm = 0  : end if
   if ups_data_valid_timer > 10 then : ups_highlite_alm = 1  : else : ups_highlite_alm = 0  : end if

   toggle dbg_pin
   toggle heartbeat
loop



'*******************************************************************************
'Check all sockets status
'*******************************************************************************
dim deb_str as string*10
Sub Ethernet()

   For I = 0 To 7                                              ' for all sockets
      Tempw = Socketstat(i , 0)                               ' get status

      Select Case Tempw

         Case Sock_established

            Tempw = Socketstat(i , Sel_recv)                ' get received bytes
            If Tempw > 0 Then                               ' if there is something received
               Do
                  set eth_act
                  eth_available_timer = 0

                  Tempw = Tcpread(i , S)                     ' read a line
                  if len(s)>1 then
                     #IF debg
                        print #1 , s
                     #ENDIF

                     if mid(s, 1, 10) = "GET / HTTP"  then
                        #IF debg
                           print #1 , s
                        #ENDIF
                        Tempw = Tcpwrite(i , "HTTP/1.0 200 OK{013}{010}")
                        Tempw = Tcpwrite(i , "Content-Type: text/html{013}{010}")
                        eth_str = "<!DOCTYPE html><html><head>"
                        eth_str = eth_str + "<style>table, th, td {border: 1px solid black;border-collapse: collapse;} </style></head><body>"
                        eth_str = eth_str + "inputs="  + str(in1) + str(in2) + "<br>need to use direct socket connection"
                        eth_str = eth_str + "<table>"
                        eth_str = eth_str + "<tr><th>parameter</th><th>value</th></tr>"
                        eth_str = eth_str + "<tr><td>Kotel_t</td><td style='text-align:center'>" + str(kotel_temp_tmp) + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Kotel_stat</td><td style='text-align:center'>" + bin(kotel_run_mode)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>kotel_h_lim</td><td style='text-align:center'>" + str(kotel_h_lim)   + "</td></tr>"
                        eth_str = eth_str + "<tr><td>kotel_delta</td><td style='text-align:center'>" + str(kotel_delta) + "</td></tr>"
                        eth_str = eth_str + "<tr><td>kotel_t_run</td><td style='text-align:center'>" + str(kotel_t_run)    + "</td></tr>"
                        eth_str = eth_str + "<tr><td>kotel_t_stop</td><td style='text-align:center'>" + str(kotel_t_stop)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>kotel_data_valid_timer</td><td style='text-align:center' bgcolor='" + Lookupstr(highlite_alm , highlite_color_list) + "'>" + str(kotel_data_valid_timer)  + "</td></tr>"

                        eth_str = eth_str + "<tr><td>Dig outputs</td><td style='text-align:center'>" + str(dig_in)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Dig inputs</td><td style='text-align:center'>" + str(dig_out)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Pressure</td><td style='text-align:center'>" + str(pressure)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Pressure lim</td><td style='text-align:center'>" + str(pressure_lim)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>delta</td><td style='text-align:center'>" + str(pressure_delta)  + "</td></tr>"

                        eth_str = eth_str + "<tr><td>Tank_data_valid_timer</td><td style='text-align:center' bgcolor='" + Lookupstr(tank_highlite_alm , highlite_color_list) + "'>" + str(tank_data_valid_timer)  + "</td></tr>"
                        'const bat_voltage_const = 0
                        'const bat_current_const = 1
                        'const bat_capacity_const = 2
                        'const bat_available_const =3
                        'const pump_status_const = 4
                        'const pump_current_const = 5
                        'const current_pow_source = 6
                        eth_str = eth_str + "<tr><td>BAT_voltage</td><td style='text-align:center'>" + read_parameter(bat_voltage_const)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Bat_current</td><td style='text-align:center'>" + read_parameter(bat_current_const)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Bat_capacity</td><td style='text-align:center'>" + read_parameter(bat_capacity_const)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Bat_available</td><td style='text-align:center'>" + read_parameter(bat_available_const)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Pump_status</td><td style='text-align:center'>" + read_parameter(pump_status_const)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Pump_current</td><td style='text-align:center'>" + read_parameter(pump_current_const)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>Powered from</td><td style='text-align:center'>" + read_parameter(current_pow_source)  + "</td></tr>"
                        eth_str = eth_str + "<tr><td>dalas</td><td style='text-align:center'>" + str(t_w)  + "</td></tr>"
                        eth_str = eth_str + "</table></body></html>{013}{010}"
                        str_len = len(eth_str)
                        S = "Content-Length: " + Str(str_len) + "{013}{010}"
                        print #1 , str_len
                        Tempw = Tcpwritestr(i , s , 255)
                        #IF debg
                           print #1 , S
                           print #1 , eth_str
                        #ENDIF
                        Tempw = Tcpwrite(i , eth_tx_buf(1) , str_len)
                        'Socketdisconnect I
                     end if

                     if Left(s , 4) = "cmd:" then
                        print #1 , s

                        Bcount = Split(s , Args(1) , ":")
                        print #1 , "1 - " ; Args(1)
                        print #1 , "2 - " ; Args(2)
                        print #1 , "3 - " ; Args(3)
                        print #1 , "4 - " ; Args(4)
                        print #1 , "5 - " ; Args(5)
                        print #1 , "6 - " ; Args(6)
                     end if

                     if Left(s , 4) = "CAN:" then
                        Bcount = Split(s , Args(1) , ":")
                        can_id = hexval(Args(2))
                        #IF debg
                           print #1 , s
                           print #1 , "1 - " ; Args(1)
                           print #1 , "2 - " ; Args(2)
                           print #1 , "3 - " ; Args(3)
                           print #1 , hex(can_id)
                        #ENDIF

                        for i2 = 1 to 8
                           can_write_data(i2) = 0
                        next
                        byte_poz = 1
                        for i2 = 1 to len(Args(3)) step 2
                           can_byte_str = mid(Args(3) , i2 , 2)
                           can_write_data(byte_poz) = hexval(can_byte_str)
                           incr byte_poz
                           #IF debg
                              print #1 , can_byte_str
                           #ENDIF

                        next
                        status = can_write(can_id)

                        #IF debg
                        #ENDIF
                     end if
                     if Left(s , 7) = "Boiler:" then
                        print #1 , s
                        Bcount = Split(s , Args(1) , ":")
                        print #1 , "1 - " ; Args(1)
                        print #1 , "2 - " ; Args(2)
                        print #1 , "3 - " ; Args(3)
                        print #1 , "4 - " ; Args(4)
                        print #1 , "5 - " ; Args(5)
                        print #1 , "6 - " ; Args(6)
                        print #1 , "7 - " ; Args(7)
                        Select Case Args(2)
                           case "stop" : can_write_data(1) = 0
                           case "run" : can_write_data(1) = 2
                           case "prerun" : can_write_data(1) = 1
                           case "ignore" : can_write_data(1) = 5

                        end select
                        can_write_data(2) = val(Args(3))
                        can_write_data(3) = val(Args(4))
                        can_write_data(4) = val(Args(5))
                        can_write_data(5) = val(Args(6))
                        can_write_data(6) = val(Args(7))
                        status = can_write(&h248)
                        #IF debg
                           print #1 , hex(can_write_data(1))
                           print #1 , hex(can_write_data(2))
                           print #1 , hex(can_write_data(3))
                           print #1 , hex(can_write_data(4))
                           print #1 , hex(can_write_data(5))
                           print #1 , hex(can_write_data(6))
                        #ENDIF
                        eth_str = str(kotel_temp_tmp) + ";" + bin(kotel_run_mode) + ";" + str(kotel_h_lim) + ";" + str(kotel_delta) + ";" + str(kotel_t_run) + ";" + str(kotel_t_stop) + ";" + str(kotel_data_valid_timer) + ";" +"{013}{010}"
                        Tempw = Tcpwritestr(i , eth_str , 0)

                     end if
                     if Left(s , 5) = "Tank?" then
                        eth_str = "Tank_status;" + str(tank_data_valid_timer) + ";" + str(dig_in) + ";" + str(dig_out) + ";" + str(pressure) + ";" + str(pressure_lim) + ";" + str(pressure_delta) + ";"
                        Tempw = Tcpwritestr(i , eth_str , 0)
                     end if
                     if Left(s , 7) = "Boiler?" then
                        #IF debg
                           print #1 , kotel_temp_tmp
                           print #1 , bin(kotel_run_mode)
                           print #1 , kotel_h_lim
                           print #1 , kotel_delta
                           print #1 , kotel_t_run
                           print #1 , kotel_t_stop
                           print #1 , kotel_data_valid_timer
                        #ENDIF
                        'const bat_voltage_const = 0
                        'const bat_current_const = 1
                        'const bat_capacity_const = 2
                        'const bat_available_const =3
                        'const pump_status_const = 4
                        'const pump_current_const = 5
                        eth_str = str(kotel_temp_tmp) + ";" + bin(kotel_run_mode) + ";" + str(kotel_h_lim) + ";" + str(kotel_delta) + ";" + str(kotel_t_run) + ";" + str(kotel_t_stop) + ";" + str(kotel_data_valid_timer) + ";"

                        eth_str = eth_str  + read_parameter(bat_voltage_const) + ";"
                        eth_str = eth_str  + read_parameter(bat_current_const) + ";"
                        eth_str = eth_str  + read_parameter(bat_capacity_const) + ";"
                        eth_str = eth_str  + read_parameter(bat_available_const) + ";" '
                        eth_str = eth_str  + read_parameter(pump_status_const) + ";"
                        eth_str = eth_str  + read_parameter(pump_current_const) + ";"
                        eth_str = eth_str  + read_parameter(current_pow_source) + ";"
                        eth_str = eth_str  + str(t_w) + ";"
                        eth_str = eth_str  +"{013}{010}"
                        Tempw = Tcpwritestr(i , eth_str , 0)
                     end if


                     if Left(s , 4) = "Rel:" then
                        Bcount = Split(s , Args(1) , ":")
                        if Args(2) = "r" then
                           can_write_data(1) = 1
                           can_write_data(2) = 3
                           status = can_write(&h249)
                        end if

                        if Args(2) = "l" then
                           tmp = binval(Args(3))
                           rel1 = tmp.0
                           rel2 = tmp.1
                        end if
                        eth_str = "done{013}{010}"
                        Tempw = Tcpwritestr(i , eth_str , 0)
                     end if


                     if Left(s , 3) = "T?:" then
                        eth_str = "CAN status:" + str(status) + "{013}{010}"
                        Tempw = Tcpwritestr(i , eth_str , 0)
                     end if
                     Tempw = Tcpwrite(i , "end{013}{010}")
                  end if
               Loop Until S = ""
               reset eth_act
            End If
         Case Sock_close_wait

            #IF debg
               print #1 , "Socketdisconnect: " ; i
            #ENDIF

            Socketdisconnect I                              ' we need to close
         Case Sock_closed
            if I > 3 then
               I = Getsocket(i , Sock_stream , 1024 , 0)         ' get a new socket on Port 80
            else
               I = Getsocket(i , Sock_stream , 80 , 0)         ' get a new socket on Port 80                                  ' listen
            end if
            #IF debg
               print #1 , "listen on port: " ; i
            #ENDIF

            Socketlisten I

      End Select
   Next

End Sub




Tc0_isr:


Return

Settime:
Return

Getdatetime:
Return

Setdate:
Return

Sectic:

   'print #1, "test - " ; str(in1) ; str(in2)
   if kotel_data_valid_timer < 255 then : incr kotel_data_valid_timer : end if
   if tank_data_valid_timer < 255 then : incr tank_data_valid_timer : end if
   if eth_available_timer < 255 then : incr eth_available_timer : end if
   if can_available_timer < 255 then : incr can_available_timer : end if
   if ups_data_valid_timer < 255 then : incr ups_data_valid_timer : end if


   t_request = 1
   toggle t_action.0

   toggle net_pin
Return



function serial_read() as string
   $timeout = 1600000
   Input #2 , Sport Noecho
   serial_read = Sport '+ "<" + str(len(s))
end function



Serial1bytereceived:

   Print #1 , "we got a char"

Return



Serial0bytereceived:

   print #1 , "int4"
   set serialflg
Return


SERIAL0CHARMATCH:
   set serialflg : print #1 , "int0"
return
SERIAL1CHARMATCH:
   set serialflg : print #1 , "int1"
return
SERIAL2CHARMATCH:
   set serialflg : print #1 , "int2"
return
SERIAL3CHARMATCH:
   set serialflg : print #1 , "int3"
return









function read_parameter(byval arg1 as byte) as string*16
   local current_source as string*4
   if power_source = 1 then : current_source = "AC" : else : current_source = "BAT" : end if

'   const bat_voltage_const = 0
'   const bat_current_const = 1
'   const bat_capacity_const = 2
'   const bat_available_const = 3
'   const pump_status_const = 4
'   const pump_current_const = 5
'   const current_pow_source = 6
   select case arg1
      Case bat_voltage_const: read_parameter = str(can_bat_voltage)
      Case bat_current_const: read_parameter = str(can_bat_current)
      Case bat_capacity_const: read_parameter = str(bat_energy_long)
      Case bat_available_const: read_parameter = str(ups_data_valid_timer)
      Case pump_status_const: read_parameter = str(pump_ok)
      Case pump_current_const: read_parameter = str(pump_current)
      Case current_pow_source: read_parameter = current_source
      Case Else : read_parameter = "NA"

   end select
end function



function can_filter (byval _mask as word) as byte
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h60
   can_output_buffer(3) = &b00000000
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en

   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h70
   can_output_buffer(3) = &b00000000
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en


end function

function check_err () as byte
   can_output_buffer(1) = &h03
   can_output_buffer(2) = &h2d
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 1 : set can_en
   check_err = can_input_buffer(1)
end function


function check_int() as byte
   can_output_buffer(1) = &h03
   can_output_buffer(2) = &h2c
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 1 : set can_en
   check_int = can_input_buffer(1)
end function


function can_read (byref _ID as word) as byte
   can_output_buffer(1) = &h03  'read request
   can_output_buffer(2) = &h2c
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 2 : set can_en
   can_input_buffer(1) = can_input_buffer(1) and &b00000011
   'print bin(can_input_buffer(1))


   Select Case can_input_buffer(1)
      Case 1 :
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h61  'read SID
         reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 5 : set can_en
         Shift can_input_buffer(2) , right , 5
         _ID  = can_input_buffer(1)
         Shift _ID , left , 3
         _ID = _ID + can_input_buffer(2)
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h60  'RXB0CTRL
         can_output_buffer(2) = &h00
         reset can_en : SPIOUT can_output_buffer(1) , 3 : Spiin can_input_buffer(1) , 2 : set can_en
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h65  ' RECEIVE BUFFER
         reset can_en : SPIOUT can_output_buffer(1) , 3 : Spiin can_read_data(1) , 8 : set can_en
         can_output_buffer(1) = &h05
         can_output_buffer(2) = &h2c
         can_output_buffer(3) = &h01
         can_output_buffer(4) = &h00
         reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
         can_read = 1
      Case 2 :
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h71  'read SID
         reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 5 : set can_en
         Shift can_input_buffer(2) , right , 5
         _ID  = can_input_buffer(1)
         Shift _ID , left , 3
         _ID = _ID + can_input_buffer(2)
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h70  'RXB0CTRL
         can_output_buffer(2) = &h00
         reset can_en : SPIOUT can_output_buffer(1) , 3 : Spiin can_input_buffer(1) , 2 : set can_en
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h75  ' RECEIVE BUFFER
         reset can_en : SPIOUT can_output_buffer(1) , 3 : Spiin can_read_data(1) , 8 : set can_en

         can_output_buffer(1) = &h05
         can_output_buffer(2) = &h2c
         can_output_buffer(3) = &h02
         can_output_buffer(4) = &h00
         reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
         can_read = 2
      Case 3 :
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h71  'read SID
         reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 5 : set can_en
         Shift can_input_buffer(2) , right , 5
         _ID  = can_input_buffer(1)
         Shift _ID , left , 3
         _ID = _ID + can_input_buffer(2)
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h70  'RXB0CTRL
         can_output_buffer(2) = &h00
         reset can_en : SPIOUT can_output_buffer(1) , 3 : Spiin can_input_buffer(1) , 2 : set can_en
         can_output_buffer(1) = &h03  'read request
         can_output_buffer(2) = &h75  ' RECEIVE BUFFER
         reset can_en : SPIOUT can_output_buffer(1) , 3 : Spiin can_read_data(1) , 8 : set can_en

         can_output_buffer(1) = &h05
         can_output_buffer(2) = &h2c
         can_output_buffer(3) = &h02
         can_output_buffer(4) = &h00
         reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
         can_read = 1

      Case Else : can_read = 0
   end select



end function


function can_write (byval _ID as word) as byte
   can_output_buffer(1) = &h03
   can_output_buffer(2) = &h30
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_read_data(1) , 1 : set can_en
   local address as word
   address = HIGH(_ID)  * 256
   address =  address + LOW(_ID)
   Shift address , left , 5
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h31
   can_output_buffer(3) = High(address)
   can_output_buffer(4) = LOW(address)
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   can_output_buffer(7) = &h08
   can_output_buffer(8) = can_write_data(1)
   can_output_buffer(9) = can_write_data(2)
   can_output_buffer(10) = can_write_data(3)
   can_output_buffer(11) = can_write_data(4)
   can_output_buffer(12) = can_write_data(5)
   can_output_buffer(13) = can_write_data(6)
   can_output_buffer(14) = can_write_data(7)
   can_output_buffer(15) = can_write_data(8)
   reset can_en : SPIOUT can_output_buffer(1) , 15 : set can_en
   can_output_buffer(1) = &h05
   can_output_buffer(2) = &h30
   can_output_buffer(3) = &h08
   can_output_buffer(4) = &h08
   reset can_en : SPIOUT can_output_buffer(1) , 4 :  set can_en
   can_output_buffer(1) = &h03
   can_output_buffer(2) = &h30
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_read_data(1) , 1 : set can_en
end function

function can_write_ (byval _ID as word) as byte

   local address as word
   local TXBUFF as byte
   TXBUFF = &h31
   can_output_buffer(1) = &h03  'read
   can_output_buffer(2) = &h30  'TXB1_check
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_read_data(1) , 1 : set can_en

   if can_read_data(1).3 = 1 then
      can_output_buffer(1) = &h03  'read
      can_output_buffer(2) = &h40  'TXB1_check
      reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_read_data(1) , 1 : set can_en
      TXBUFF = &h41
   end if

   if can_read_data(1).3 = 1 then
      can_output_buffer(1) = &h03  'read
      can_output_buffer(2) = &h50  'TXB1_check
      reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_read_data(1) , 1 : set can_en
      TXBUFF = &h51
   end if
   if can_read_data(1).3 = 0 then
      address = HIGH(_ID)  * 256
      address =  address + LOW(_ID)
      Shift address , left , 5
      can_output_buffer(1) = &h02                'wrire
      can_output_buffer(2) = TXBUFF                'TXB1_buffer
      can_output_buffer(3) = High(address)      'SID_10-3
      can_output_buffer(4) = LOW(address)       'SID_2-0._.EXIDE._.EID_17-16
      can_output_buffer(5) = &h00                'EID_15-8
      can_output_buffer(6) = &h00                'EID_7-0
      can_output_buffer(7) = &h02                'data_lenght
      can_output_buffer(8) = can_write_data(1)   'data0
      can_output_buffer(9) = can_write_data(2)   'data0
      can_output_buffer(10) = can_write_data(3)  'data0
      can_output_buffer(11) = can_write_data(4)  'data0
      can_output_buffer(12) = can_write_data(5)  'data0
      can_output_buffer(13) = can_write_data(6)  'data0
      can_output_buffer(14) = can_write_data(7)  'data0
      can_output_buffer(15) = can_write_data(8)  'data0
      reset can_en : SPIOUT can_output_buffer(1) , 15 : set can_en
      can_output_buffer(1) = &h05                'bit modify RXF1SIDL
      can_output_buffer(2) = &h30                'reg_for_modifier (TXREQ)
      can_output_buffer(3) = &h08                'mask_byte
      can_output_buffer(4) = &h08                'data_byte
      reset can_en : SPIOUT can_output_buffer(1) , 4 :  set can_en
      can_write_ = 0
   else
      can_write_ = 5
   end if
end function




function init_can () as byte
   can_output_buffer(1) = &hc0
   reset can_en
   SPIOUT can_output_buffer(1) , 1  : waitus 8
   set can_en
   waitms 10
   can_output_buffer(1) = &h02   'write instr
   can_output_buffer(2) = &h30   'address byte
   can_output_buffer(3) = &h00   'data
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h40
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h50
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h60
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en

   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h70
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en

   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h2b
   can_output_buffer(3) = &h03
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h60
   can_output_buffer(3) = &h67
   can_output_buffer(4) = &h04
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h70
   can_output_buffer(3) = &h67
   can_output_buffer(4) = &h01
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   init_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h00
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h00
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   init_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h04
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h08
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   init_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h08
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h00
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   can_output_buffer(1) = &h03  'read request
   can_output_buffer(2) = &h0e
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 2 : set can_en  : waitus 8
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h10
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h00
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   init_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h14
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h00
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   init_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h18
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h00
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   init_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h20
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h08
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   can_output_buffer(1) = &h03  'read request
   can_output_buffer(2) = &h0e
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 2 : set can_en
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h24
   can_output_buffer(3) = &h00
   can_output_buffer(4) = &h08
   can_output_buffer(5) = &h00
   can_output_buffer(6) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 6 : set can_en
   can_output_buffer(1) = &h05  'bit modify
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en

   can_output_buffer(1) = &h02   'write instr
   can_output_buffer(2) = &h0C   'address byte
   can_output_buffer(3) = &b00001111   'data
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en


   init_can = check_can ()
   init_can = can_input_buffer(1)
end function



function check_can () as byte
   can_output_buffer(1) = &h03
   can_output_buffer(2) = &h0e
   can_output_buffer(3) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 2 : Spiin can_input_buffer(1) , 1 : set can_en
   check_can = can_input_buffer(1)
end function

function start_can () as byte
   can_output_buffer(1) = &h05
   can_output_buffer(2) = &h0f    'set config mode
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h80
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   start_can = check_can ()
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h2a    'CFG1
   can_output_buffer(3) = CFG1x500kbps
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h29    'CFG2
   can_output_buffer(3) = CFG2x500kbps
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h02
   can_output_buffer(2) = &h28    'CFG3
   can_output_buffer(3) = CFG3x500kbps
   reset can_en : SPIOUT can_output_buffer(1) , 3 : set can_en
   can_output_buffer(1) = &h05
   can_output_buffer(2) = &h0f
   can_output_buffer(3) = &he0
   can_output_buffer(4) = &h00
   reset can_en : SPIOUT can_output_buffer(1) , 4 : set can_en
   start_can = check_can ()
end function


highlite_color_list:

   Data "yellowgreen" , "red" , "yellow"