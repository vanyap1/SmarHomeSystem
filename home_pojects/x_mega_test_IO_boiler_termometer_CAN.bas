'(
02.01.2023

Додано соті значення температури для відображення.
Додано контроль помпи по КАН шині. Інформація з шлюза.
Додано установку параметрів розпалювання
Додано індикатор помпи на porta.4


CAN
249 -  rel1 = can_read_data(1).0
       relay_delay = can_read_data(2)

248 -  run_mode = can_read_data(1)
       if can_read_data(2) < &hff then : h_lim = can_read_data(2)
       if can_read_data(3) < &hff then : delta = can_read_data(3)
       if can_read_data(4) < &hff then : t_run = can_read_data(4)
       if can_read_data(5) < &hff then : t_stop = can_read_data(5)
       if can_read_data(6) < &hff then : prerun = can_read_data(6)
')



$regfile = "xm256A3BUdef.dat"
$crystal = 32000000                     '32MHz
$hwstack = 640
$swstack = 512
$framesize = 512




Config Osc = Enabled , 32mhzosc = Enabled  , 32khzosc = Enabled
Config Sysclock = 32mhz , Prescalea = 1 , Prescalebc = 1_1
$lib "glcdeadogm128x6.lbx"

heartbeat alias portf.6
config heartbeat = output
Config Eeprom = Mapped





door_sensor alias pinb.1 : config door_sensor = input : set portb.1
ign alias pinb.0 : config ign = input : set portb.0
sel alias pina.0 : config sel = input : set porta.0
up alias pina.1 : config up = input : set porta.1
dn alias pina.2 : config dn = input : set porta.2

rel1 alias portb.2 : config rel1 = output
rel2 alias portb.3 : config rel2 = output
st_led alias porta.5 : config st_led = output
pump_led alias porta.4 : config pump_led = output


lcd_blk alias portd.1 : config lcd_blk = output
Config 1wire = Porta.3

spi_rst alias portc.0 : config spi_rst = output : set spi_rst
can_en alias portc.1 : config can_en = output : set can_en
can_int alias pinc.2 : config can_int = input
dim relay_delay as byte


declare function init_can () as byte
declare function check_can () as byte
declare function start_can () as byte
declare function can_write (byval _ID as word) as byte
declare function can_filter (byval _mask as word) as byte
declare function can_write_ (byval _ID as word) as byte
declare function can_read (byref _ID as word ) as byte
declare function check_int() as byte
declare function check_err () as byte

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



'_____________________________________________________________________________________Kotel BRIDGE CAN

Dim sys_voltage As Word  , tmp_single as single
Dim v_sys_l_byte As Byte At sys_voltage Overlay
Dim v_sys_h_byte As Byte At sys_voltage + 1 Overlay

Dim bat_current As integer
Dim bat_curr_l_byte As Byte At bat_current Overlay
Dim bat_curr_h_byte As Byte At bat_current + 1 Overlay


Dim pump_current As Word
Dim pump_current_l_byte As Byte At pump_current Overlay
Dim pump_current_h_byte As Byte At pump_current + 1 Overlay
Dim dalas_temp as byte
dim gateway_data_valid_timer as byte




dim out_str as string*24
Config Com7 = 115200 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
set portf.2 : set portf.3

Open "com7:" For Binary As #1




Config Spic = Hard , Master = Yes , Mode = 0 , Clockdiv = Clk2 , Data_order = Msb , Ss = auto



dim sys_status as byte



















dim relay_stat as bit


dim tmp_flg as bit

Dim Byte0 As Byte
Dim Byte1 As Byte
Dim Sign As String * 1
Dim T1 As Single
Dim T2 As Byte
dim t as byte
dim t_w as word

Config Graphlcd = 128 * 64eadogm , Cs1 = Porte.4 , A0 = Portf.0 , Si = Portf.4 , Sclk = Portf.1 , Rst = Porte.5

Glcdcmd &ha1
Glcdcmd &ha6
Glcdcmd &hc0
Glcdcmd &ha2
Glcdcmd &h26
waitms 1
Glcdcmd &h87
Glcdcmd &h27
waitms 1
Glcdcmd &hf8
Glcdcmd &h00
Glcdcmd &h2f
waitms 1
Glcdcmd &h40
Glcdcmd &hb0
Glcdcmd &h00
Glcdcmd &h10

Glcdcmd &hc8
Glcdcmd &ha0
Glcdcmd &h81
Glcdcmd 33



'dim count as byte

Cls
Setfont Font6x8

Config Date = YMD , Separator = DOT
Config Clock = Soft , Gosub = Sectic , Rtc32 = 1khz_32khz_crystosc
Rtc32_ctrl.0 = 1


'Date$ = "01.09.09"
Time$ = "14:40:00"
'SERIAL PORT config


dim er_1 as eram byte
dim er_2 as eram byte
dim er_3 as eram byte
dim er_4 as eram byte
dim er_5 as eram byte
dim er_6 as eram byte

dim prerun as byte
dim t_run as byte
dim t_stop as byte
dim delta as byte
Dim h_lim as byte
dim l_lim as byte
dim menu_time as byte
dim run_timeout as word
Dim Dsid1(8) As Byte
Dsid1(1) = 1wsearchfirst()



Dim T_tmp As String * 4     'Debug



t_run = er_1
t_stop = er_2
delta = er_3
h_lim = er_4
menu_time = er_5
prerun = er_6

if h_lim > 90 or menu_time < 10  then
   er_1 = 0 : er_2 = 0 : er_3 = 0 : er_4 = 0 : er_5 = 20 : er_5 = 180
   t_run = er_1
   t_stop = er_2
   delta = er_3
   h_lim = er_4
   menu_time = er_5
   prerun = er_6
end if



dim tmp_str as string*8
dim fan_chr as string*1



dim menu_pointer as byte , menu_delay as byte
dim lcd_upd_req as byte  , i as byte , sel_index(10) as string*1
dim run_mode as byte
dim ld_blk as word




menu_delay = menu_time
Config Watchdog = 4000
Config Priority = Static , Vector = Application , Lo = Enabled       ' the RTC uses LO priority interrupts so these must be enabled !!!
Enable Interrupts
Start Watchdog

fan_chr = " "
set lcd_blk
Setfont Font6x8
Lcdat 2 , 5 , hex(Dsid1(1)) ; hex(Dsid1(2)) ;hex(Dsid1(3)) ;hex(Dsid1(4)) ;hex(Dsid1(5)) ;hex(Dsid1(6)) ;hex(Dsid1(7)) ;hex(Dsid1(8)) ;

status =  init_can()
waitms 20
status =  start_can()

wait 2
cls







do
   incr ld_blk
   reset watchdog
   l_lim = h_lim - delta

   if door_sensor = 1 then
      rel2 = relay_stat
      st_led = 0
   else
      rel2 = 0
      st_led = ld_blk.14
   end if
   if gateway_data_valid_timer > 10 then
        pump_led = ld_blk.13
   end if



   'toggle rel2

   'fan_chr = "|"


'Setfont Font6x8

   if menu_delay = 0 then : reset lcd_blk : else : set lcd_blk : end if
   if  ign = 1 then : waitms 150 : run_mode = 1 : set relay_stat : lcd_upd_req = 1: run_timeout = prerun*10 : fan_chr = "|" :  end if
   if run_mode = 0 then : reset relay_stat : fan_chr = " " : end if

   'if run_mode = 1  then

   '   if t => t_run then  : run_mode = 2 : end if
   'end if

   if t => t_run then  : run_mode = 2 : end if
   if run_mode = 2 then
      if t => h_lim then : fan_chr = " " : reset relay_stat : end if
      if t =< l_lim then : fan_chr = "|" : set relay_stat : end if
      if t=<  t_stop then :  run_mode = 0 : end if
   end if
   if run_mode = 5 then : menu_pointer = 8 : reset relay_stat : end if
   if run_mode = 3 then : run_mode = 0 : end if

   if up = 1 or dn = 1 or sel = 1 or ign = 1 then : menu_delay = menu_time : lcd_upd_req = 1 : end if
   if up = 1 and menu_pointer = 1 and h_lim <= 80 then : waitms 150 : incr h_lim :  end if
   if dn = 1 and menu_pointer = 1 and h_lim >= 0 then : waitms 150 : decr h_lim :  end if
   if up = 1 and menu_pointer = 2 and delta <= 10 then : waitms 150 : incr delta :  end if
   if dn = 1 and menu_pointer = 2 and delta >= 0 then : waitms 150 : decr delta:  end if
   if up = 1 and menu_pointer = 3 and t_run <= 80 then : waitms 150 : incr t_run :  end if
   if dn = 1 and menu_pointer = 3 and t_run >= 0 then : waitms 150 : decr t_run:  end if
   if up = 1 and menu_pointer = 4 and t_stop <= 80 then : waitms 150 : incr t_stop :  end if
   if dn = 1 and menu_pointer = 4 and t_stop >= 0 then : waitms 150 : decr t_stop:  end if
   if up = 1 and menu_pointer = 5 and menu_time <= 60 then : waitms 150 : incr menu_time :  end if
   if dn = 1 and menu_pointer = 5 and menu_time >= 10 then : waitms 150 : decr menu_time:  end if

   if up = 1 and menu_pointer = 6 and prerun < 255 then : waitms 150 : incr prerun :  end if
   if dn = 1 and menu_pointer = 6 and prerun >= 10 then : waitms 150 : decr prerun:  end if

   if up = 1 or dn = 1 then
      waitms 150
      if menu_pointer = 7 then
         er_1 = t_run
         er_2 = t_stop
         er_3 = delta
         er_4 = h_lim
         er_5 = menu_time
         er_6 = prerun
         t_run = er_1
         t_stop = er_2
         delta = er_3
         h_lim = er_4
         menu_time = er_5
         menu_pointer = 0
         cls
      end if
      'if menu_pointer = 7 then
      '   t_run = er_1
      '   t_stop = er_2
      '   delta = er_3
      '   h_lim = er_4
      '   menu_time = er_5
      '   menu_pointer = 0
      '   cls
      'end if
   end if

   if sel= 1 then : waitms 150 : incr menu_pointer : menu_delay = menu_time :lcd_upd_req = 1 : cls: end if
   if menu_pointer = 8 then : menu_pointer = 1 : end if

   sys_status = run_mode
   sys_status.5 = rel1
   sys_status.7 = relay_stat
   sys_status.6 = door_sensor

   if lcd_upd_req = 1 then
      lcd_upd_req = 0
      Select Case menu_pointer

         Case 0 :

            Setfont Font25x32
            Lcdat 2 , 5 , fan_chr

            Lcdat 2 , 35 , t ; "~"

            Setfont Font6x8
            if run_mode = 0 then : Lcdat 1 , 5 , "     СТОП           " : end if
            if run_mode = 1 then : Lcdat 1 , 5 , "  РОЗПАЛЮВАННЯ   " ; run_timeout   ; " " : end if
            if run_mode = 2 then : Lcdat 1 , 5 , "Нормальна робота    " : end if
            'Lcdat 2 , 120 , run_mode ; "  "
            'Lcdat 3 , 120 , run_timeout   ; "  "

            Lcdat 6 , 5 , "t:" ; fusing(t1, "#.##") ; "^C"
            'Lcdat 6 , 5 , "%t:" ; delta ; "^C"
            Lcdat 7 , 5 , "t[:" ; h_lim ; "^C"
            Lcdat 8 , 5 , "t]:" ; l_lim ; "^C"
            Lcdat 7 , 55 , "старт:" ; t_run ; "^C"
            Lcdat 8 , 55 , "стоп :" ; t_stop ; "^C"


         Case 1 to 7 :
            Setfont Font6x8
            for i = 1 to 10
               if i = menu_pointer then
                  sel_index(i) = ">"
               else
                  sel_index(i) = " "
               end if
            next
            Lcdat 1 , 5 , "Настройка"
            Lcdat 2 , 5 , sel_index(1) ;  "Темп            -" ; h_lim ; " "
            Lcdat 3 , 5 , sel_index(2) ;  "Дельта t        -" ; delta ; " "
            Lcdat 4 , 5 , sel_index(3) ;  "Розпалювання до -" ; t_run ; " "
            Lcdat 5 , 5 , sel_index(4) ;  "t кiнець гор.   -" ; t_stop ; " "
            Lcdat 6 , 5 , sel_index(5) ;  "затримка меню   -" ; menu_time ; " "
            Lcdat 7 , 5 , sel_index(6) ;  "час розпалювання-" ; prerun ; "0 "
            Lcdat 8 , 5 , sel_index(7) ;  "зберегти, вийти  "

         Case 8 :
            Setfont Font8x12
            Lcdat 2 , 5 , "Збой термометра"
            Dsid1(1) = 1wsearchfirst()
            Setfont Font6x8
            Lcdat 4 , 5 , hex(Dsid1(1)) ; hex(Dsid1(2)) ;hex(Dsid1(3)) ;hex(Dsid1(4)) ;hex(Dsid1(5)) ;hex(Dsid1(6)) ;hex(Dsid1(7)) ;hex(Dsid1(8)) ;
      End Select

   end if

   if wr_req = 1 then
      can_write_data(1) = sys_status
      can_write_data(2) = high(t_w)
      can_write_data(3) = Low(t_w)
      can_write_data(4) = h_lim
      can_write_data(5) = l_lim
      can_write_data(6) = t_run
      can_write_data(7) = t_stop
      can_write_data(8) = delta
      status = can_write(&h247)
      wr_req = 0
   end if

   if can_int = 0 then
      rd_req = 1
      'Print #1 , "CAN read data request"
   end if


   status = check_err()
   if status.0 = 1 or status.1 = 1 then
      status =  init_can()
      waitms 20
      status =  start_can()
      waitms 20
      'Print #1 , "init"
   end if


   status = can_read(RX_ID)


   if status > 0 then


      if RX_ID = &h248 then
         Print #1 , hex(RX_ID) ; "> " ; status ; " < " ; hex(can_read_data(1)) ; ";" ; hex(can_read_data(2)) ; ";" ; hex(can_read_data(3)) ; ";" ; hex(can_read_data(4)) ; ";" ; hex(can_read_data(5)) ; ";" ; hex(can_read_data(6)) ; ";" ; hex(can_read_data(7)) ; ";" ;  hex(can_read_data(8))
         'out_str =  hex(RX_ID) + ";" + hex(can_read_data(1)) +  hex(can_read_data(2)) +  hex(can_read_data(3)) + hex(can_read_data(4)) + hex(can_read_data(5)) + hex(can_read_data(6)) + hex(can_read_data(7)) + hex(can_read_data(8))
         if can_read_data(1) < 4 then
            run_mode = can_read_data(1)
            menu_delay = menu_time
         end if

         if can_read_data(2) < &hff then : h_lim = can_read_data(2) : end if
         if can_read_data(3) < &hff then : delta = can_read_data(3) : end if
         if can_read_data(4) < &hff then : t_run = can_read_data(4) : end if
         if can_read_data(5) < &hff then : t_stop = can_read_data(5) : end if
         if can_read_data(6) < &hff then : lcd_upd_req = 1 :  prerun = can_read_data(6) : end if

         if run_mode = 1 then
            fan_chr = "|"
            lcd_upd_req = 1
            run_timeout = prerun*10
            set relay_stat
         end if



         er_1 = t_run
         er_2 = t_stop
         er_3 = delta
         er_4 = h_lim
         er_6 = prerun

         t_run = er_1
         t_stop = er_2
         delta = er_3
         h_lim = er_4
         prerun = er_6
         'Lcdat 8 , 5 , out_str
      end if
      if RX_ID = &h249 then
         rel1 = can_read_data(1).0
         relay_delay = can_read_data(2)
      end if

      if RX_ID = &h069 then
         'Print #1 , hex(RX_ID) ; "> " ; status ; " < " ; hex(can_read_data(1)) ; ";" ; hex(can_read_data(2)) ; ";" ; hex(can_read_data(3)) ; ";" ; hex(can_read_data(4)) ; ";" ; hex(can_read_data(5)) ; ";" ; hex(can_read_data(6)) ; ";" ; hex(can_read_data(7)) ; ";" ;  hex(can_read_data(8))
         dalas_temp = can_read_data(1)
         bat_curr_h_byte = can_read_data(2)
         bat_curr_l_byte = can_read_data(3)
         v_sys_h_byte =can_read_data(4)
         v_sys_l_byte = can_read_data(5)
         pump_current_h_byte = can_read_data(6)
         pump_current_l_byte =can_read_data(7)
         gateway_data_valid_timer = 0
         if pump_current > 1000 then : set pump_led : else : reset pump_led : end if

         print #1 , pump_current

      end if

   end if


loop






Settime:
Return

Getdatetime:
Return

Setdate:
Return

Sectic:
   wr_req = 1
   if menu_delay <> 0 then : decr menu_delay : else : menu_pointer = 0 :cls: end if
   if relay_delay > 0 then : decr relay_delay : else : rel1 = 0 : end if
   if gateway_data_valid_timer < 255 then : incr gateway_data_valid_timer : end if

   if run_mode = 1 then
      if run_timeout > 0 then :
         decr run_timeout
      else
         run_mode = 0
      end if
   end if

   Toggle heartbeat
   if tmp_flg = 0 then
      1wreset
      1wwrite &HCC
      1wwrite &H44
   else
      1wreset
      if err <> 0 then : run_mode = 5 : end if

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
      print #1 , t1
   end if
   toggle tmp_flg
   lcd_upd_req = 1

Return



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







$include "Font\st7565_6x8_m.font"
$include "Font\st7565_25x32.font"
$include "Font\st7565_8x12.font"