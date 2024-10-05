$regfile = "xm256A3BUdef.dat"
$crystal = 32000000                     '32MHz
$hwstack = 512
$swstack = 512
$framesize = 512

CONST debg=0

Config Osc = Enabled , 32mhzosc = Enabled  , 32khzosc = DISABLED
Config Sysclock = 32mhz , Prescalea = 1 , Prescalebc = 1_1

$bigstrings
                                              ' with this the software I2C/TWI commands are used when inlcuding i2c.lbx


Config Single = NORMAL  , Digits = 7




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


dim gateway_data_valid_timer as byte



Config Com5 = 115200 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8
Config Com7 = 115200 , Mode = 0 , Parity = None , Stopbits = 1 , Databits = 8

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


















status =  init_can()
waitms 20
status =  start_can()

Config Watchdog = 4000
Config Priority = Static , Vector = Application , Lo = Enabled       ' the RTC uses LO priority interrupts so these must be enabled !!!
Enable Interrupts
Start Watchdog

dim socValue as word

'print #1 , "                     /                     /2/0/0/"
do


   reset watchdog



   'status = check_err()
   if gateway_data_valid_timer > 250 then
      gateway_data_valid_timer = 0
      status =  init_can()
      print #1 , "CAN reinit"
      waitms 20
      status =  start_can()
      'waitms 20
   end if









   status = can_read(RX_ID)
   if status > 0 then

      gateway_data_valid_timer = 0
      if RX_ID = &h355  or RX_ID = &h356 then
         print #1 , "CAN:";  hex(RX_ID);":8:"; hex(can_read_data(1)); hex(can_read_data(2)); hex(can_read_data(3)); hex(can_read_data(4)); hex(can_read_data(5)); hex(can_read_data(6)); hex(can_read_data(7)); hex(can_read_data(8))
         'if RX_ID = &h355 then
         '   socValue = can_read_data(2)
         '   Shift socValue , left , 8
         '   socValue = socValue + can_read_data(1)
         '   print #1 , socValue
         'end if
         'dalas_temp = can_read_data(1)
         'solarModuleTemp = can_read_data(4)
         'gateway_data_valid_timer = 0
      end if
   end if








loop



Tc0_isr:
   Tcc0_per = timer_overload_value
   if gateway_data_valid_timer < 255 then : incr gateway_data_valid_timer : end if
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

   'data_wr_req = 1





   toggle gld
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