Imports System
Imports System.IO
Imports System.IO.Ports
Imports System.Management

Public Class Form1
    Dim serial As String = "none"
    Delegate Sub SetTextCallback(ByVal [text] As String) 'Added to prevent threading errors during receiveing of data
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        RTC_box.Text = "rtc:" + Now.ToString("yy.MM.dd:hh.mm.ss") + ":s"


        'Dim nameArray() As String
        'nameArray = SerialPort.GetPortNames
        'Array.Sort(nameArray)
        'PortNameBox.DataSource = nameArray
        'PortNameBox.DropDownStyle = ComboBoxStyle.DropDownList
        'If nameArray.Length > 1 Then
        ' PortNameBox.SelectedIndex = 1
        ' End If








        Dim moReturn As Management.ManagementObjectCollection
        Dim moSearch As Management.ManagementObjectSearcher
        Dim mo As Management.ManagementObject
        moSearch = New Management.ManagementObjectSearcher("Select * from Win32_PnPEntity")
        moReturn = moSearch.Get
        Dim my_str As String = "1"
        Dim i As Byte
        For Each mo In moReturn
            'If CStr(mo.Properties.Item("Name").Value).Contains("Prolific") Then
            'returns something like: "Prolific USB-to-Serial Comm Port (COM17)"
            If Not CStr(mo.Properties.Item("Name").Value) = vbNullString Then
                my_str = CStr(mo.Properties.Item("Name").Value)
                If my_str.Contains("COM") Then
                    PortNameBox.Items.Add(my_str)
                    i += 1
                End If
            End If
            'End If
        Next

        If i > 2 Then
            PortNameBox.SelectedIndex = 2
        Else
            PortNameBox.SelectedIndex = 0
        End If






        PortBaudBox.Items.Add("9600")
        PortBaudBox.Items.Add("19200")
        PortBaudBox.Items.Add("38400")
        PortBaudBox.Items.Add("115200")
        PortBaudBox.Items.Add("250000")
        PortBaudBox.Items.Add("500000")
        'PortNameBox.SelectedIndex = 2
        PortBaudBox.SelectedIndex = 5
        PortOpen.BackColor = Color.Lime
        TcpConnectBut.BackColor = Color.Lime
        RtsBox.Enabled = False
        DtrBox.Enabled = False
        TimerBox.Enabled = False
        RS485AdressBox.Enabled = False
        InPic_1.BackColor = Color.Gray
        InPic_2.BackColor = Color.Gray
        InPic_3.BackColor = Color.Gray
        InPic_4.BackColor = Color.Gray
        InPic_5.BackColor = Color.Gray
        InPic_6.BackColor = Color.Gray
        InPic_7.BackColor = Color.Gray
        InPic_8.BackColor = Color.Gray
        select_interface(TCP_SerialSelector.Checked)
        Label8.Text = "Night build 2022y By VanyaP1"
    End Sub

    Private Sub PortOpen_Click(sender As Object, e As EventArgs) Handles PortOpen.Click
        Dim stat As Byte = Port_open(serial, PortBaudBox.SelectedItem)

    End Sub


    Private Sub WdBut_Click(sender As Object, e As EventArgs) Handles WdBut.Click
        Dim stat As Byte = port_write(WdBox.Text)
        'If stat = 0 Then : WdBox.Text = "" : End If
    End Sub




    Function gen_data() As String
        gen_data = "$out"
        If CheckBox8.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox7.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox6.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox5.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox4.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox3.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox2.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        If CheckBox1.Checked = True Then : gen_data &= "1" : Else gen_data &= "0" : End If
        Dim stat As Byte = port_write(gen_data)
    End Function



    Function Port_open(ByVal port As String, ByVal baud As String) As Byte
        If Not SerialPort1.IsOpen Then
            Try
                SerialPort1.PortName = port
                SerialPort1.BaudRate = CInt(Val(baud))
                SerialPort1.NewLine = vbCr
                SerialPort1.Open()
                Port_open = 0
                PortOpen.BackColor = Color.Red
                PortOpen.Text = "Close"
                PortNameBox.Enabled = False
                PortBaudBox.Enabled = False
                RtsBox.Enabled = True
                DtrBox.Enabled = True
                TimerBox.Enabled = True
            Catch ex As Exception
                Port_open = 1
                PortOpen.BackColor = Color.Yellow
                PortOpen.Text = "Port not available"
            End Try
        Else
            SerialPort1.Close()
            PortOpen.BackColor = Color.Lime
            PortOpen.Text = "Open"
            PortNameBox.Enabled = True
            PortBaudBox.Enabled = True
            RtsBox.Enabled = False
            DtrBox.Enabled = False
            TimerBox.Enabled = False
            Port_open = 2
            InPic_1.BackColor = Color.Gray
            InPic_2.BackColor = Color.Gray
            InPic_3.BackColor = Color.Gray
            InPic_4.BackColor = Color.Gray
            InPic_5.BackColor = Color.Gray
            InPic_6.BackColor = Color.Gray
            InPic_7.BackColor = Color.Gray
            InPic_8.BackColor = Color.Gray
        End If
    End Function

    Function port_write(ByVal data As String) As Byte
        Try
            If SerialPort1.IsOpen Then
                SerialPort1.WriteLine(data)
                port_write = 0
            Else
                port_write = 2
            End If
        Catch ex As Exception
            port_write = 3
        End Try
    End Function

    Private Sub SerialPort1_DataReceived(sender As Object, e As IO.Ports.SerialDataReceivedEventArgs) Handles SerialPort1.DataReceived
        Try
            ReceivedText1(SerialPort1.ReadLine())
        Catch ex As Exception

        End Try
    End Sub

    Private Sub ReceivedText1(ByVal [text] As String) 'input from ReadExisting
        Dim response As String
        Dim red As Color = Color.Red
        Dim green As Color = Color.Lime
        Dim input_state As Byte
        If Me.RdBox.InvokeRequired Then
            Dim x As New SetTextCallback(AddressOf ReceivedText1)
            Me.Invoke(x, New Object() {(text)})
        Else
            Dim text1 As String = [text]

            response = text1
            response = response.Replace(vbCr, "")
            response = response.Replace(vbLf, "")

            If Mid(response, 1, 5) = "keys:" Then
                Dim elements() As String = Split(response, ":")
                Try

                    If Len(elements(2)) = 24 Then
                        KEY_1W.Text = Mid(elements(2), 1, 23)
                    End If
                    If Len(elements(3)) = 24 Then
                        KEY_1W.Text = Mid(elements(3), 1, 23)
                    End If

                Catch ex As Exception

                End Try


            End If


            If Mid(response, 1, 5) = "devs:" Then
                Dim elements() As String = Split(response, ":")
                Try

                    If Len(elements(2)) = 24 Then
                        T1_ID.Text = Mid(elements(2), 1, 23)
                    End If
                    If Len(elements(3)) = 24 Then
                        T2_ID.Text = Mid(elements(3), 1, 23)
                    End If

                Catch ex As Exception

                End Try

            End If
            If Mid(response, 1, 7) = "1W_key:" Then
                Dim elements() As String = Split(response, ":")

                Try
                    If Len(elements(1)) = 24 Then
                        KEY_1W.Text = Mid(elements(1), 1, 23)
                    End If
                Catch ex As Exception

                End Try
            End If

            If Mid(response, 1, 5) = "in:h:" Then

                input_state = Convert.ToByte(Mid(response, 6, 2), 16)
                'Dim binary_input_state = Convert.ToString(input_state, 2)
                Dim binary_input_state = Convert.ToString(input_state, 2).PadLeft(8, "0"c)


                If Mid(binary_input_state, 8, 1) = "1" Then : InPic_1.BackColor = green : Else : InPic_1.BackColor = red : End If
                If Mid(binary_input_state, 7, 1) = "1" Then : InPic_2.BackColor = green : Else : InPic_2.BackColor = red : End If
                If Mid(binary_input_state, 6, 1) = "1" Then : InPic_3.BackColor = green : Else : InPic_3.BackColor = red : End If
                If Mid(binary_input_state, 5, 1) = "1" Then : InPic_4.BackColor = green : Else : InPic_4.BackColor = red : End If
                If Mid(binary_input_state, 4, 1) = "1" Then : InPic_5.BackColor = green : Else : InPic_5.BackColor = red : End If
                If Mid(binary_input_state, 3, 1) = "1" Then : InPic_6.BackColor = green : Else : InPic_6.BackColor = red : End If
                If Mid(binary_input_state, 2, 1) = "1" Then : InPic_7.BackColor = green : Else : InPic_7.BackColor = red : End If
                If Mid(binary_input_state, 1, 1) = "1" Then : InPic_8.BackColor = green : Else : InPic_8.BackColor = red : End If
            Else
                RdBox.AppendText(response & vbCrLf)
            End If
            'Me.TextBox2.Text &= response & ">> HEX: (" & StringToHex(response) & "); len:(" & Len(response) & ");" & vbCrLf
        End If
    End Sub



    Private Sub RtsBox_CheckedChanged(sender As Object, e As EventArgs) Handles RtsBox.CheckedChanged
        If SerialPort1.IsOpen Then
            SerialPort1.RtsEnable = RtsBox.Checked
        End If
    End Sub

    Private Sub DtrBox_CheckedChanged(sender As Object, e As EventArgs) Handles DtrBox.CheckedChanged
        If SerialPort1.IsOpen Then
            SerialPort1.DtrEnable = DtrBox.Checked
        End If
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked Then
            port_write("bit:0:1:s")
        Else
            port_write("bit:0:0:s")
        End If
    End Sub

    Private Sub CheckBox2_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox2.CheckedChanged
        If CheckBox2.Checked Then
            port_write("bit:1:1:s")
        Else
            port_write("bit:1:0:s")
        End If
    End Sub

    Private Sub CheckBox3_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox3.CheckedChanged
        If CheckBox3.Checked Then
            port_write("bit:2:1:s")
        Else
            port_write("bit:2:0:s")
        End If
    End Sub

    Private Sub CheckBox4_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox4.CheckedChanged
        If CheckBox4.Checked Then
            port_write("bit:3:1:s")
        Else
            port_write("bit:3:0:s")
        End If
    End Sub

    Private Sub CheckBox5_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox5.CheckedChanged
        If CheckBox5.Checked Then
            port_write("bit:4:1:s")
        Else
            port_write("bit:4:0:s")
        End If
    End Sub

    Private Sub CheckBox6_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox6.CheckedChanged
        If CheckBox6.Checked Then
            port_write("bit:5:1:s")
        Else
            port_write("bit:5:0:s")
        End If
    End Sub

    Private Sub CheckBox7_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox7.CheckedChanged
        If CheckBox7.Checked Then
            port_write("bit:6:1:s")
        Else
            port_write("bit:6:0:s")
        End If
    End Sub

    Private Sub CheckBox8_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox8.CheckedChanged
        If CheckBox8.Checked Then
            port_write("bit:7:1:s")
        Else
            port_write("bit:7:0:s")
        End If
    End Sub

    Private Sub TimerBox_CheckedChanged(sender As Object, e As EventArgs) Handles TimerBox.CheckedChanged
        Timer1.Enabled = TimerBox.Checked
    End Sub

    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        port_write("in:ff:h:r")
    End Sub

    Private Sub CheckBox9_CheckedChanged(sender As Object, e As EventArgs) Handles TCP_SerialSelector.CheckedChanged
        If Not SerialPort1.IsOpen Then
            select_interface(TCP_SerialSelector.Checked)
        Else
            TCP_SerialSelector.Checked = False
        End If
    End Sub
    Function select_interface(ByVal num As Boolean) As Byte
        If TCP_SerialSelector.Checked Then
            GroupBox5.Visible = False
            GroupBox5.SendToBack()
            GroupBox4.Visible = True
            GroupBox4.BringToFront()
            select_interface = 1
        Else
            GroupBox4.Visible = False
            GroupBox4.SendToBack()
            GroupBox5.Visible = True
            GroupBox5.BringToFront()

            select_interface = 2
        End If

    End Function

    Private Sub ExitToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
    End Sub

    Private Sub ToolStripMenuItem2_Click(sender As Object, e As EventArgs) Handles ToolStripMenuItem2.Click
        About.Show()
    End Sub

    Private Sub RS485Box_CheckedChanged(sender As Object, e As EventArgs) Handles RS485Box.CheckedChanged

    End Sub

    Private Sub PortNameBox_SelectedIndexChanged(sender As Object, e As EventArgs) Handles PortNameBox.SelectedIndexChanged
        serial = PortNameBox.Text
        serial = serial.Replace(")", "")
        Dim strArr() As String
        strArr = serial.Split("(")
        serial = strArr(1).ToString
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim stat As Byte = port_write("tmp:1:1:r")
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Dim stat As Byte = port_write("tmp:2:1:r")
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Dim stat As Byte = port_write("1w_scan:::r")
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Dim stat As Byte = port_write("devID:1w:set:1:" + T1_ID.Text + ":r")
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Dim stat As Byte = port_write("devID:1w:set:2:" + T2_ID.Text + ":r")
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        Dim tmp As String = T2_ID.Text
        T2_ID.Text = T1_ID.Text
        T1_ID.Text = tmp
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Dim stat As Byte = port_write("devID:key:get:::r")

    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Dim stat As Byte = port_write("devID:key:set:" + KEY_1W.Text + ":r")
    End Sub

    Private Sub Form1_FormClosing(sender As Object, e As FormClosingEventArgs) Handles MyBase.FormClosing
        port_write("bit:rst:1:s")
        If SerialPort1.IsOpen Then
            SerialPort1.Close()
        End If
    End Sub

    Private Sub Button9_Click(sender As Object, e As EventArgs) Handles Button9.Click
        port_write("1w_key_scan:::r")
    End Sub

    Private Sub RTC_get_Click(sender As Object, e As EventArgs) Handles RTC_get.Click
        port_write("rtc:::r")
    End Sub

    Private Sub rtc_timer_Tick(sender As Object, e As EventArgs) Handles rtc_timer.Tick

        RTC_box.Text = "rtc:" + Now.ToString("yy.MM.dd:hh.mm.ss") + ":s"
    End Sub

    Private Sub Button10_Click(sender As Object, e As EventArgs) Handles Button10.Click
        port_write(RTC_box.Text)
    End Sub



    Private Sub CheckBox16_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox16.CheckedChanged
        If CheckBox16.Checked Then
            port_write("bit:8:1:s")
        Else
            port_write("bit:8:0:s")
        End If
    End Sub

    Private Sub CheckBox15_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox15.CheckedChanged
        If CheckBox15.Checked Then
            port_write("bit:9:1:s")
        Else
            port_write("bit:9:0:s")
        End If
    End Sub

    Private Sub CheckBox14_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox14.CheckedChanged
        If CheckBox14.Checked Then
            port_write("bit:10:1:s")
        Else
            port_write("bit:10:0:s")
        End If
    End Sub

    Private Sub CheckBox13_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox13.CheckedChanged
        If CheckBox13.Checked Then
            port_write("bit:11:1:s")
        Else
            port_write("bit:11:0:s")
        End If
    End Sub

    Private Sub CheckBox12_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox12.CheckedChanged
        If CheckBox12.Checked Then
            port_write("bit:12:1:s")
        Else
            port_write("bit:12:0:s")
        End If
    End Sub

    Private Sub CheckBox11_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox11.CheckedChanged
        If CheckBox11.Checked Then
            port_write("bit:13:1:s")
        Else
            port_write("bit:13:0:s")
        End If
    End Sub

    Private Sub CheckBox10_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox10.CheckedChanged
        If CheckBox10.Checked Then
            port_write("bit:14:1:s")
        Else
            port_write("bit:14:0:s")
        End If
    End Sub

    Private Sub CheckBox9_CheckedChanged_1(sender As Object, e As EventArgs) Handles CheckBox9.CheckedChanged
        If CheckBox9.Checked Then
            port_write("bit:15:1:s")
        Else
            port_write("bit:15:0:s")
        End If
    End Sub

    Private Sub CheckBox17_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox17.CheckedChanged
        CheckBox17.Checked = False
        CheckBox16.Checked = False
        CheckBox15.Checked = False
        CheckBox14.Checked = False
        CheckBox13.Checked = False
        CheckBox12.Checked = False
        CheckBox11.Checked = False
        CheckBox10.Checked = False
        CheckBox9.Checked = False
        CheckBox8.Checked = False
        CheckBox7.Checked = False
        CheckBox6.Checked = False
        CheckBox5.Checked = False
        CheckBox4.Checked = False
        CheckBox3.Checked = False
        CheckBox2.Checked = False
        CheckBox1.Checked = False
        port_write("bit:rst:1:s")
    End Sub

    Private Sub MenuStrip1_ItemClicked(sender As Object, e As ToolStripItemClickedEventArgs) Handles MenuStrip1.ItemClicked

    End Sub
End Class
