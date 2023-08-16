$regfile = "xm256A3BUdef.dat"
$crystal = 32000000                     '32MHz
$hwstack = 512
$swstack = 512
$framesize = 512

CONST debg=0

Config Osc = Enabled , 32mhzosc = Enabled  , 32khzosc = DISABLED
Config Sysclock = 32mhz , Prescalea = 1 , Prescalebc = 1_1

$bigstrings
$forcesofti2c                                               ' with this the software I2C/TWI commands are used when inlcuding i2c.lbx
$lib "i2c.lbx"
'   Config Scl = Porte.1
'   Config Sda = Porte.0
'   Config I2cdelay = 1
'   I2cinit

Config Single = NORMAL  , Digits = 7


Config Scl = Portd.1
Config Sda = Portd.0
Config I2cdelay = 10
I2cinit

wait 1
ac_sel alias porta.6 : config ac_sel = output : set ac_sel
inv_en alias porta.7 : config inv_en = output : reset inv_en
fan alias portb.1 : config fan = output  : set fan

pump_off alias portd.1 : config pump_off = output : reset pump_off


rld alias porta.2 : config rld = output : set rld
gld alias porta.3 : config gld = output : set gld
bld alias porta.1 : config bld = output : set bld
pe5 alias porte.5 : config pe5 = output

ac_det alias pINb.0 : config ac_det = input
in1 alias pINb.0 : config in1 = input


spi_rst alias portc.0 : config spi_rst = output : set spi_rst
can_en alias portc.1 : config can_en = output : set can_en
can_int alias pinc.2 : config can_int = input
Config Spic = Hard , Master = Yes , Mode = 0 , Clockdiv = Clk2 , Data_order = Msb , Ss = auto

Config Adca = Single , Convmode = Unsigned , Resolution = 8bit , Dma = Off , Reference = INTVCC  , Event_mode = None , Prescaler = 32 , _
Ch0_gain = 1 , Ch0_inp = Single_ended , Mux0 = 0 'you can setup other channels as well







declare function init_can () as byte
declare function check_can () as byte
declare function start_can () as byte
declare function can_write (byval _ID as word) as byte
declare function can_filter (byval _mask as word) as byte
declare function can_write_ (byval _ID as word) as byte
declare function can_read (byref _ID as word ) as byte
declare function check_int() as byte
declare function check_err () as byte
declare function i2c_scan() as byte
declare function readADC(byval adc_ch As Byte) as string*6

declare sub read_voltage()
declare sub read_current()
declare sub read_shunt()
declare sub read_power()

declare sub adc_conversion_start(byval ch as byte)
declare sub adc_data_read(byval ch as byte)


declare sub set_pump(byval run as byte)




Const Ads1115_write = &H90
Const Ads1115_read = &H91

Dim adc_data As Word
Dim ADC_l_byte As Byte At adc_data Overlay
Dim ADC_h_byte As Byte At ADC_l_byte + 1 Overlay





dim load_ctrl as byte , power_good as byte , pg as byte



dim adc_ch(4)as integer  , adc_data_ready as byte
dim adc_automat as byte
adc_automat = 1
adc_data_ready = 0

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
dim data_wr_req as byte
dim adc_read_req as byte





'_____________________________________________________________________________________KOTEL
dim kotel_run_mode as byte , kotel_data_valid_timer as byte , highlite_alm as byte
dim kotel_temp as single  , kotel_temp_tmp as word
dim kotel_h_lim as byte , kotel_delta as byte , kotel_t_run as byte  , kotel_t_stop as byte  , reset_pump_flg as byte
dim kotel_status as byte

dim run_pump_lo as word , run_pump_hi as word
run_pump_lo = 6500
run_pump_hi = 5000
'_____________________________________________________________________________________RF
dim rf_wr_flg as byte
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
dim delta_t as byte , real_t_dot as single , real_t as byte
'_____________________________________________________________________________________




Config Com5 = 38400 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
Config Com7 = 38400 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8

Open "com7:" For Binary As #1
Open "com5:" For Binary As #2

Config Tcc0 = Normal , Prescale = 1024
'Tcc0_per = 7912       '32MHz/1024 = 31250
const timer_overload_value = 7960
Tcc0_per = timer_overload_value
On Tcc0_ovf Tc0_isr                               'Setup overflow interrupt of Timer/Counter C0 and name ISR
Enable Tcc0_ovf , Lo


'Config Date = YMD , Separator = DOT
'Config Clock = Soft , Rtc = 1khz_int32khz_ulp
'Rtc32_ctrl.0 = 1

'Date$ = "01.09.09"
'Time$ = "14:40:00"





dim config_reg as integer, power_conversion_req  as byte , power_conversion_divider as byte
Dim config_l As Byte At config_reg Overlay
Dim config_h As Byte At config_reg + 1 Overlay

dim ShuntReg as integer
Dim ShuntReg_l As Byte At ShuntReg Overlay
Dim ShuntReg_h As Byte At ShuntReg + 1 Overlay

dim VoltageReg as integer
Dim VoltageReg_l As Byte At VoltageReg Overlay
Dim VoltageReg_h As Byte At VoltageReg + 1 Overlay

dim CallibrationReg as word
Dim CallibrationReg_l As Byte At CallibrationReg Overlay
Dim CallibrationReg_h As Byte At CallibrationReg + 1 Overlay


dim CurrentReg as integer
Dim CurrentReg_l As Byte At CurrentReg Overlay
Dim CurrentReg_h As Byte At CurrentReg + 1 Overlay

dim PowerReg as integer
Dim PowerReg_l As Byte At PowerReg Overlay
Dim PowerReg_h As Byte At PowerReg + 1 Overlay
dim power_calculator as single
dim calc_power as long

dim BatEnergy as Single , calc_bat_energy as single , momental_current as single
Dim BatEnergy_0 As Byte At BatEnergy Overlay
Dim BatEnergy_1 As Byte At BatEnergy + 1 Overlay
Dim BatEnergy_2 As Byte At BatEnergy + 2 Overlay
Dim BatEnergy_3 As Byte At BatEnergy + 3 Overlay
dim PowerMeasDelay as byte


dim bat_energy_long as long
Dim bat_energy_long_0 As Byte At bat_energy_long Overlay
Dim bat_energy_long_1 As Byte At bat_energy_long + 1 Overlay
Dim bat_energy_long_2 As Byte At bat_energy_long + 2 Overlay
Dim bat_energy_long_3 As Byte At bat_energy_long + 3 Overlay
dim BatEnergyLcd as single




Dim can_bat_voltage as byte

dim can_bat_current as integer
Dim can_bat_current_0 As Byte At can_bat_current Overlay
Dim can_bat_current_1 As Byte At can_bat_current + 1 Overlay






dim ld_green as byte , ld_yellow as byte, ld_red as byte
dim alarms as byte
dim lcd_line1 as string *32 , lcd_line2 as string *32 , tmp_str as string *16
dim tmp_sin as single
dim pump_error_counter as byte , pump_current_state as byte
dim sys_flags as byte , msg_flg as bit

power_source alias sys_flags.0
pump_ok alias sys_flags.1
kotel_error alias sys_flags.2
gateway_error alias sys_flags.3
low_battery alias sys_flags.4
overload alias sys_flags.5


if BatEnergy < 10 then : BatEnergy = 100000 : end if
PowerMeasDelay = 10


CallibrationReg = 2490 '1755

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
power_conversion_req = 0














status =  init_can()
waitms 20
status =  start_can()

Config Watchdog = 4000
Config Priority = Static , Vector = Application , Lo = Enabled       ' the RTC uses LO priority interrupts so these must be enabled !!!
Enable Interrupts
Start Watchdog


'reset can_act
'reset can_err



      'can_write_data(1) = 0
      'can_write_data(2) = &hff
      'can_write_data(3) = &hff
      'can_write_data(4) = &hff
      'can_write_data(5) = &hff
      'can_write_data(6) = &hff
      'can_write_data(7) = &hff
      'can_write_data(8) = &hff
      'status = can_write(&h248)

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

print #1 , "                     /                     /2/0/0/"
do


   reset watchdog

   status = check_err()
   if status.0 = 1 or status.1 = 1 or gateway_data_valid_timer > 250 then
      status =  init_can()
      waitms 20
      status =  start_can()
      waitms 20
   end if


   if data_wr_req > 0 then

      data_wr_req = 0
      can_write_data(1) = 1
      can_write_data(2) = 3
      status = can_write(&h249)
      bld = 1
   end if

   if adc_read_req > 0 then
      adc_read_req = 0  ''>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      bld = 0   'blue led
   'print #1 , readADC(0) ; "; " ; readADC(1) ; "; " ;readADC(2) ; "; " ;readADC(3)  ; "; "






'      load_ctrl = Getadc(adca , 0 , &B0_0000_111)

'      'print #1 , " AC_det:" ; ac_det ; " PG:" ; pg  ; " kotel_t=" ; kotel_temp_tmp   ; "  dat_val=" ; kotel_data_valid_timer  ; " mode:" ; bin(kotel_run_mode)

'      if rf_wr_flg > 5 then
'         '''''print #1 ,  "s;" ; pg ; ";" ;  kotel_temp_tmp ; ";" ; hex(kotel_run_mode) ; ";" ; sys_voltage ;";"; bat_current;";"; pump_current;";" ;gateway_data_valid_timer; ";" ;dalas_temp ; ";" ; real_t; ";" ; delta_t; ";e"
'         rf_wr_flg = 0
'         kotel_status = kotel_run_mode
'         kotel_status.5 = 0
'         kotel_status.6 = 0
'         kotel_status.7 = 0

'      else
'         incr rf_wr_flg
'      end if






      if ac_det = 0 then
         if pg > 0 then : decr pg : end if
      else
         if pg < 10 then : incr pg : end if
      end if
      bld = 1    'blue led
      if pg = 10 then : power_source = 1 : end if
      if pg = 0 then : power_source = 0 : end if


'      if kotel_data_valid_timer < 10 then  '
'         if dalas_temp > real_t then
'            delta_t = dalas_temp - real_t
'         else
'            delta_t = 0 :
'         end if

'         if pg > 5 then             'If powered from line
'               'обробка сценарія коли нема 220В


'            if reset_pump_flg = 1 then   'один сигнал що пропало живлення
'               reset_pump_flg = 3
'               reset ac_sel              'скинути попередній стан помпи
'            end if


'            if delta_t > 5 then  'якщо газовий котел включено, виключити регулювання
'               set ac_sel
'               reset pump_off    'якщо газовий котел ВИКЛ - економимо електрику
'            else


'               if kotel_status = 1 then  'якщо розпалюєся котел - зменшити ліміти температури для ВКЛ
'                  run_pump_hi = 3300
'                  run_pump_lo = 1000
'               else
'                  run_pump_hi = 6500
'                  run_pump_lo = 5000
'               end if

'               if kotel_temp_tmp > run_pump_hi then : set ac_sel : reset pump_off : end if
'               if kotel_temp_tmp < run_pump_lo then : reset ac_sel : set pump_off : end if

'            end if





'         else
'               'якщо є живлення - управляю по температурі
'            set ac_sel
'            if kotel_status = 1 then  ' Чи розпалюєся котел
'               reset pump_off
'            else
'               if kotel_temp_tmp > 3300 or dalas_temp > 33 then : reset pump_off : end if
'                  'якщо температура одного з котлів виросла
'               if kotel_temp_tmp < 3000 and dalas_temp < 30 then : set pump_off : end if
'                  'якщо температура обох котлів впала
'            end if
'            'print #1 ,"AC OK"

'         end if


'      else
'         'print #1 ,"CAN ERROR"
'         set ac_sel
'         reset pump_off
'      end if

          ''<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


   end if




   status = can_read(RX_ID)
   if status > 0 then
      if RX_ID = &h247 then

         kotel_data_valid_timer = 0

         kotel_temp_tmp = can_read_data(2)
         Shift kotel_temp_tmp , left , 8
         kotel_temp_tmp = kotel_temp_tmp +  can_read_data(3)
         kotel_run_mode = can_read_data(1) and 0b00001111
         real_t_dot = kotel_temp_tmp / 100
         real_t = round(real_t_dot)

         'run_mode | 5=1W error; 4= ; 3= ; 2=RUN; 1=PRERUN; 0=STOP
         'run_mode.5 = rel1
         'run_mode.7 = relay_stat
         'run_mode.6 = door_sensor
      end if

      if RX_ID = &h69 then
         dalas_temp = can_read_data(1)
         gateway_data_valid_timer = 0
      end if


      'Print #1 , hex(RX_ID) ; "-"  ; hex(can_read_data(1)) ; ";" ; hex(can_read_data(2)) ; ";" ; hex(can_read_data(3)) ; ";" ; hex(can_read_data(4)) ; ";" ; hex(can_read_data(5)) ; ";" ; hex(can_read_data(6)) ; ";" ; hex(can_read_data(7)) ; ";" ;  hex(can_read_data(8))
       'reset bld
   else
       'set bld
   end if





    'if pg = 5 then
    '    set inv_en
    'else
    '    reset inv_en
    'end if
    '
    'if pg = 10 then
    '    set ac_sel
    'else
    '    reset ac_sel
    'end if


   'if  power_good = 0 then :
   '   reset ac_sel
   '   reset inv_en
   'else
   '   set ac_sel
   '   set inv_en
   'end if



   'rld = ac_det
   if power_conversion_req = 1 then
      load_ctrl = Getadc(adca , 0 , &B0_0000_111)
      read_voltage
      'read_shunt
      read_current
      read_power
      calc_power = int_voltage  * int_current
      calc_power = calc_power / 1000
      'power_calculator = PowerReg / 40

      'calc_bat_energy = calc_bat_energy + int_current
      momental_current = int_current / 3600
      batenergy = batenergy +  momental_current
      if batenergy > 100000 then :  batenergy = 100000 : end if


      'print #1 , "V "; int_voltage ; "; C " ; int_current ; "; E: " ; batenergy ; ";";
      'print #1 , " AC_det:" ; ac_det ; "; ";
      'print #1 , " Load:" ; load_ctrl ; "; ";
      'print #1 , " PG:" ; pg ; "; ";

      'power_source alias sys_flags.0
'      pump_ok alias sys_flags.1
'      kotel_error alias sys_flags.2
'      gateway_error alias sys_flags.3
'      low_battery alias sys_flags.4
'      overload alias sys_flags.5


       'real_t     < from kotel thermometer
       'dalas_temp < from pump thermometer
       'kotel_data_valid_timer
       'gateway_data_valid_timer



      if kotel_data_valid_timer > 20 or gateway_data_valid_timer > 20 then
         alarms.0 = 1
      else
         alarms.0 = 0
      end if




      if alarms > 0 then
         ld_red = 1
         set_pump(1)
      else
         ld_red = 0
         if kotel_run_mode > 0 or real_t > 35 or dalas_temp > 35 then
            set_pump(1)
         else
            set_pump(0)
         end if
      end if




      ld_green = 1

      tmp_sin = int_voltage/1000
      tmp_str = fusing(tmp_sin , "0.0") + "V "
      lcd_line1 = tmp_str

      tmp_sin = int_current/1000
      tmp_str = fusing(tmp_sin , "0.0") + "A "
      lcd_line1 = lcd_line1 + tmp_str

      BatEnergyLcd = BatEnergy / 1000
      tmp_str = fusing(BatEnergyLcd , "0.0") + "Ah    "
      lcd_line1 = lcd_line1 + tmp_str


      bat_energy_long = int(batenergy)
      'fusing(batenergy , "0.0")



      tmp_sin = int_voltage/100
      can_bat_voltage = int(tmp_sin)
      can_bat_current = int_current

      if load_ctrl < 40 and pump_current_state = 1 then
         if pump_error_counter < 10 then
            incr pump_error_counter
         end if

      else : pump_error_counter = 0 : end if


      if pump_error_counter > 5 then : pump_ok = 1 : alarms.1 = 1: else : pump_ok = 0 :alarms.1 = 0 : end if

      if pump_current_state = 1 then : ld_yellow = 1 : else : ld_yellow = 0 : end if


      lcd_line2 = "Tk:" + str(real_t) + " Tp:" + str(dalas_temp) + "  "

      print #1 , lcd_line1 ;"/"; lcd_line2 ; "/"; ld_red ; "/" ; ld_green ; "/"; ld_yellow ; "/"





      'print #1 , " AC_det:" ; ac_det ;
      'print #1 , str(calc_bat_energy)
      power_conversion_req = 0
      PowerMeasDelay = 3













      if msg_flg = 0 then

         can_write_data(1) = can_bat_voltage
         can_write_data(2) = can_bat_current_1
         can_write_data(3) = can_bat_current_0
         can_write_data(4) = bat_energy_long_3
         can_write_data(5) = bat_energy_long_2
         can_write_data(6) = bat_energy_long_1
         can_write_data(7) = bat_energy_long_0
         can_write_data(8) = sys_flags
         status = can_write(&h033)
      else

         can_write_data(1) = load_ctrl
         can_write_data(2) = 0       'reserved
         can_write_data(3) = 0       'reserved
         can_write_data(4) = 0       'reserved
         can_write_data(5) = 0       'reserved
         can_write_data(6) = 0       'reserved
         can_write_data(7) = 0       'reserved
         can_write_data(8) = sys_flags
         status = can_write(&h043)
      end if


      toggle msg_flg










   end if

loop



Tc0_isr:
   Tcc0_per = timer_overload_value
   adc_read_req = 1
   if kotel_data_valid_timer < 255 then : incr kotel_data_valid_timer : end if
   if gateway_data_valid_timer < 255 then : incr gateway_data_valid_timer : end if



   incr power_conversion_divider

   if power_conversion_divider > PowerMeasDelay then : power_conversion_req = 1 : power_conversion_divider = 0 : end if

   toggle pe5
   toggle gld
Return

Settime:
Return

Getdatetime:
Return

Setdate:
Return

Sectic:

   data_wr_req = 1
   'print #1, "test - " ; str(in1) ; str(in2)
   'if kotel_data_valid_timer < 255 then : incr kotel_data_valid_timer : end if
   'if tank_data_valid_timer < 255 then : incr tank_data_valid_timer : end if
   'if eth_available_timer < 255 then : incr eth_available_timer : end if
   'if can_available_timer < 255 then : incr can_available_timer : end if
   't_request = 1
   'toggle t_action.0

   toggle gld
Return



sub set_pump(byval run as byte)
   if run = 1 then

      if pg > 8 then        'when poweret from AC line
         reset ac_sel
         reset inv_en
         if int_current > 3000 then
            reset fan
         else
            set fan
         end if
      end if

      if pg < 2 then        'when powered from invertor
         set ac_sel
         set inv_en
         reset fan

      end if
      pump_current_state = 1
   else                      'when pump is disable
      set ac_sel
      reset inv_en
      if int_current > 3000 then
         reset fan
      else
         set fan
      end if
      pump_current_state = 0
   end if




end sub




sub read_voltage()
   I2cstart
   I2cwbyte &h80
   I2cwbyte &h02
   I2cstart
   I2cwbyte &h81
   I2crbyte VoltageReg_h , Ack
   I2crbyte VoltageReg_l , Nack
   I2cstop
   real_voltage = VoltageReg * 1.24883677647497
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
   real_current = CurrentReg' / 1.887
   ''real_current = abs(real_current)
   int_current  = int(real_current)
   'waitms 10
end sub
sub read_power()
   I2cstart
   I2cwbyte &h80
   I2cwbyte &h03
   I2cstart
   I2cwbyte &h81
   I2crbyte PowerReg_h , Ack
   I2crbyte PowerReg_l , Nack
   power_calculator = PowerReg / 40
   PowerReg = power_calculator * 1000
   I2cstop
   'waitms 10
end sub



















function i2c_scan() as byte
   local b as byte
   Print #1 , "Scan start"
   For B = 0 To 254 Step 2                                     'for all odd addresses
      I2cstart                                                 'send start
      I2cwbyte B                                               'send address
      If Err = 0 Then                                           'we got an ack
         Print #1 , "Slave at : " ; B ; " hex : " ; Hex(b) ; " bin : " ; Bin(b)
      End If
      I2cstop                                                   'free bus
   Next
   Print #1 , "End Scan"
   i2c_scan = 1
end function


sub adc_conversion_start(byval ch as byte)
   local ch_tmp as byte
   select case ch
      case 0 : ch_tmp = &B11000010
      case 1 : ch_tmp = &B11010010
      case 2 : ch_tmp = &B11101000
      case 3 : ch_tmp = &B11110010    '0010
   end select
   I2cstart
   I2cwbyte Ads1115_write
   I2cwbyte 1
   I2cwbyte ch_tmp
   I2cwbyte &B10000011
   I2cstop
end sub

sub adc_data_read(byval ch as byte)
   I2cstart
   I2cwbyte Ads1115_write
   I2cwbyte 0
   I2cstart
   I2cwbyte Ads1115_read
   I2crbyte ADC_h_byte , Ack
   I2crbyte ADC_l_byte , Nack
   I2cstop
   if adc_data.15 = 1 Then
      adc_ch(ch) = 0
   else
      adc_ch(ch) = adc_data
   end if

end sub

function readADC(byval adc_ch As Byte) as string*6
   local ch as byte
   select case adc_ch
      case 0 : ch = &B11000010
      case 1 : ch = &B11010010
      case 2 : ch = &B11100010
      case 3 : ch = &B11110010    '0010
   end select
   I2cstart
   I2cwbyte Ads1115_write
   I2cwbyte 1
   I2cwbyte ch
   I2cwbyte &B10000011
   I2cstop
   Waitms 40
   I2cstart
   I2cwbyte Ads1115_write
   I2cwbyte 0
   I2cstart
   I2cwbyte Ads1115_read
   I2crbyte ADC_h_byte , Ack
   I2crbyte ADC_l_byte , Nack
   I2cstop

'print bin(adc_data)
   if adc_data.15 = 1 Then

      adc_data = 65535 - adc_data
      readADC = "-" + str(adc_data)
   else
      readADC = "+" + str(adc_data)

   end if
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