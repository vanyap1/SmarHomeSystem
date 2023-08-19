$regfile = "m328pbdef.dat"
$crystal = 16000000
$hwstack = 128
$swstack = 128
$framesize = 160
$baud = 9600

$version 1 , 1 , 152

Config Watchdog = 2048
Start Watchdog

$PROGRAMMER = 3
const debg = 0


Config Spi = Hard , Interrupt = Off , Data Order = Msb , Master = Yes , Polarity = Low , Phase = 0 , Clockrate = 4 , Noss = 1
Spiinit


dim nodeID as byte, e_nodeID as eram byte , def_state as byte , e_def_state as eram byte
nodeID = e_nodeID
def_state = e_def_state

uSonic alias pine.1 : config uSonic = input
dim w_level as word

Dim count As byte
dim tmp as byte


dim conversion_ready as byte , conversion_start as byte
conversion_start = def_state

Const Kfi1 = 10

Dim Temp_value As Sram Integer                                       'temporere Variable
Dim W As Sram Integer                                       'temporere Variable
Dim S As Sram String * 10                                   'ser.Ausgabepuffer
Dim filtered_value As Sram word                             'Temperatur in 1/10tel °C
Dim Df1 As Sram Integer

dim outputs as byte
orange_led alias outputs.6
red_led alias outputs.7
green_led alias outputs.4
pump_out alias outputs.5


dim inputs as byte
level1 alias inputs.0
level2 alias inputs.1
level3 alias inputs.2

out_en alias portd.7 : config out_en = output : reset out_en

'spi_rst alias portc.0 : config spi_rst = output : set spi_rst
can_en alias portd.4 : config can_en = output : set can_en
can_int alias pind.3 : config can_int = input

Config Scl = Portc.5
Config Sda = Portc.4
I2cinit

Config I2cdelay = 1


Const RTC_W = &HD0                                         'I2C Adresse MPU-6050
Const RTC_R = &HD1
Const EXP_W = &H4f                                         'I2C Adresse MPU-6050
Const EXP_R = &H4e



dim can_output_buffer(16) as byte
dim can_input_buffer(16) as byte
dim can_write_data(10) as byte
dim can_read_data(10) as byte
dim can_read_data2(10) as byte


dim status as byte
dim wr_req as byte , rd_req as byte
dim b_count as word
dim CAN_read_request as bit


dim water_press_lim as word , water_press_delta as byte,water_press_h as byte, water_tmp as byte
dim can_write_request as byte

dim e_lim as eram word , e_delta as eram byte

water_press_lim = e_lim
water_press_delta = e_delta
dim manual_run as byte

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




declare function io_update (byval _dat as byte) as byte
declare function set_out(byval _dat as byte) as byte
declare function get_in() as byte
declare function i2c_scan() as byte
declare function init_can () as byte
declare function check_can () as byte
declare function start_can () as byte
declare function can_write (byval _ID as word) as byte
declare function can_filter (byval _mask as word) as byte
declare function can_write_ (byval _ID as word) as byte
declare function can_read (byref _ID as word ) as byte
declare function check_int() as byte
declare function check_err () as byte

Config Timer1 = Timer , Prescale = 64
Dim Wtime As Byte
On Timer1 convercion_request:


Dim serial_buf(255) As Byte
Dim Serial_str As String * 255 At serial_buf Overlay , Ns As Byte , Rs As Byte
Config Serialin = Buffered , Size = 254
Declare Sub Getline(s_dan As String)
Declare Sub Flushbuf()




Config Adc = Single , Prescaler = 8 , Reference = avcc
Start Adc
Start ADC
tmp = io_update(0)
tmp = i2c_scan()
status =  init_can()
waitms 20
status =  start_can()

set out_en
Enable Interrupts
'Enable Int0
'Enable Int1
Enable Timer1
Flushbuf
do
   reset Watchdog
   status = check_err()
   if status.0 = 1 or status.1 = 1 then
      status =  init_can()
      waitms 20
      status =  start_can()
      waitms 20

   end if

  if can_int = 0 then
  status = can_read(RX_ID)
  if status > 0 then
  Print hex(RX_ID) ; "-"  ; hex(can_read_data(1)) ; ";" ; hex(can_read_data(2)) ; ";" ; hex(can_read_data(3)) ; ";" ; hex(can_read_data(4)) ; ";" ; hex(can_read_data(5)) ; ";" ; hex(can_read_data(6)) ; ";" ; hex(can_read_data(7)) ; ";" ;  hex(can_read_data(8))
   if RX_ID = &h303 and can_read_data(8) = &h55 then
       water_press_lim = can_read_data(1) * 256
       water_press_lim = water_press_lim + can_read_data(2)
       water_press_delta = can_read_data(3)
       e_lim = water_press_lim
       e_delta = water_press_delta
   end if
   if RX_ID = &h304 and can_read_data(8) = &h55 then
      manual_run = can_read_data(1)
   end if

end if
  end if
  water_press_h = water_press_lim + water_press_delta









   if conversion_ready > 0 and conversion_start > 0 then

      Temp_value = Getadc(3)
      W = Temp_value
      Temp_value = W - filtered_value
      Df1 = Df1 + Temp_value
      Temp_value = Df1 / Kfi1
      filtered_value = filtered_value + Temp_value
      Temp_value = Temp_value * Kfi1
      Df1 = Df1 - Temp_value
      conversion_ready = 0


      inputs = get_in()
      if filtered_value <= water_press_lim then
         manual_run = 0
         reset green_led
         set orange_led
         set pump_out
      end if

      if filtered_value >= water_press_h then
         reset orange_led
         reset pump_out
         if manual_run > 0 then
             set pump_out
             set green_led
          else
             reset pump_out
             reset green_led
         end if


      end if


      if level1 = 0 then
         set red_led
         reset pump_out
         manual_run = 0
      else
         reset red_led
         'set pump_out
      end if




      tmp = set_out(outputs)



   print filtered_value ; " lim: " ; water_press_lim ; " delta: " ; water_press_delta   ; " W: " ; w_level


   end if
   if can_write_request > 3 then
   can_write_request = 0
      can_write_data(1) = inputs
      can_write_data(2) = outputs
      can_write_data(3) = high(filtered_value)
      can_write_data(4) = low(filtered_value)
      can_write_data(5) = high(water_press_lim)
      can_write_data(6) = low(water_press_lim)
      can_write_data(7) = water_press_delta
      status = can_write(&h301)
   end if


   If Ischarwaiting() = 1 Then
      Getline Serial_str
      w_level = serial_buf(2) * 256
      w_level = w_level + serial_buf(3)
      if w_level <= 2048 then
      w_level = w_level / 8
      else
      w_level = 255
      end if
      w_level = 255 - w_level
      Flushbuf


   end if


   incr count
loop

convercion_request:
   conversion_ready = 1
   incr can_write_request
return


Sub Getline(s As String)
   Serial_str = ""
   'Ns = Inkey()
   'If Ns <> 10 Then
      $timeout = 10000
      Input Serial_str Noecho
      'If Ns <> 10 Then Serial_str = Chr(ns) + S
   'End If
End Sub

Sub Flushbuf()
   Waitms 10
   Do
      Ns = Inkey()
   Loop Until Ns = 0
End Sub



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

function set_out(byval _dat as byte) as byte
   local wd as byte
   wd = not _dat
   I2cstart
   I2cwbyte EXP_R
   I2cwbyte wd
   I2cwbyte &HFF
   I2cstop
end function

function get_in() as byte
   local rd as byte
   I2cstart
   I2cwbyte EXP_W
   I2crbyte Rd , Ack
   I2crbyte Rd , Nack
   I2cstop
   get_in = not rd
end function


function io_update (byval _dat as byte) as byte
   local wd as byte
   local rd as byte
   wd = not _dat
   I2cstart
   I2cwbyte EXP_R
   I2cwbyte wd
   I2cwbyte &HFF
   I2cstop

   I2cstart
   I2cwbyte EXP_W
   I2crbyte Rd , Ack
   I2crbyte Rd , Nack
   I2cstop
   io_update = not rd
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

end