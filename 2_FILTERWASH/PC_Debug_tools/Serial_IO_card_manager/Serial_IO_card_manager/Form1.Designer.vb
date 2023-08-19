<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Форма переопределяет dispose для очистки списка компонентов.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Является обязательной для конструктора форм Windows Forms
    Private components As System.ComponentModel.IContainer

    'Примечание: следующая процедура является обязательной для конструктора форм Windows Forms
    'Для ее изменения используйте конструктор форм Windows Form.  
    'Не изменяйте ее в редакторе исходного кода.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Form1))
        Me.SerialPort1 = New System.IO.Ports.SerialPort(Me.components)
        Me.RdBox = New System.Windows.Forms.TextBox()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.WdBut = New System.Windows.Forms.Button()
        Me.WdBox = New System.Windows.Forms.TextBox()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.CheckBox17 = New System.Windows.Forms.CheckBox()
        Me.CheckBox9 = New System.Windows.Forms.CheckBox()
        Me.TimerBox = New System.Windows.Forms.CheckBox()
        Me.CheckBox10 = New System.Windows.Forms.CheckBox()
        Me.InPic_8 = New System.Windows.Forms.PictureBox()
        Me.CheckBox11 = New System.Windows.Forms.CheckBox()
        Me.InPic_7 = New System.Windows.Forms.PictureBox()
        Me.CheckBox12 = New System.Windows.Forms.CheckBox()
        Me.InPic_6 = New System.Windows.Forms.PictureBox()
        Me.CheckBox13 = New System.Windows.Forms.CheckBox()
        Me.InPic_5 = New System.Windows.Forms.PictureBox()
        Me.CheckBox14 = New System.Windows.Forms.CheckBox()
        Me.InPic_4 = New System.Windows.Forms.PictureBox()
        Me.CheckBox15 = New System.Windows.Forms.CheckBox()
        Me.InPic_3 = New System.Windows.Forms.PictureBox()
        Me.CheckBox16 = New System.Windows.Forms.CheckBox()
        Me.InPic_2 = New System.Windows.Forms.PictureBox()
        Me.InPic_1 = New System.Windows.Forms.PictureBox()
        Me.CheckBox8 = New System.Windows.Forms.CheckBox()
        Me.CheckBox7 = New System.Windows.Forms.CheckBox()
        Me.CheckBox6 = New System.Windows.Forms.CheckBox()
        Me.CheckBox5 = New System.Windows.Forms.CheckBox()
        Me.CheckBox4 = New System.Windows.Forms.CheckBox()
        Me.CheckBox3 = New System.Windows.Forms.CheckBox()
        Me.CheckBox2 = New System.Windows.Forms.CheckBox()
        Me.CheckBox1 = New System.Windows.Forms.CheckBox()
        Me.DtrBox = New System.Windows.Forms.CheckBox()
        Me.RtsBox = New System.Windows.Forms.CheckBox()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.TCP_SerialSelector = New System.Windows.Forms.CheckBox()
        Me.PortNameBox = New System.Windows.Forms.ComboBox()
        Me.TcpIPBox = New System.Windows.Forms.TextBox()
        Me.GroupBox4 = New System.Windows.Forms.GroupBox()
        Me.TcpConnectBut = New System.Windows.Forms.Button()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.TcpPassBox = New System.Windows.Forms.TextBox()
        Me.TcpUserBox = New System.Windows.Forms.TextBox()
        Me.TcpPortBox = New System.Windows.Forms.TextBox()
        Me.GroupBox5 = New System.Windows.Forms.GroupBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.RS485AdressBox = New System.Windows.Forms.TextBox()
        Me.RS485Box = New System.Windows.Forms.CheckBox()
        Me.PortOpen = New System.Windows.Forms.Button()
        Me.PortBaudBox = New System.Windows.Forms.ComboBox()
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.OpenConfigFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SetAnonimusTcpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ResetTCPConfToDefaultToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SetupToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AddExtentionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SetupTimerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SyncRTCToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.I2CModuleToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.I2cToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SPIToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.OneWireToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.HelpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AboutToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IndexToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem2 = New System.Windows.Forms.ToolStripMenuItem()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.Button2 = New System.Windows.Forms.Button()
        Me.Button3 = New System.Windows.Forms.Button()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.Button10 = New System.Windows.Forms.Button()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.RTC_box = New System.Windows.Forms.TextBox()
        Me.RTC_get = New System.Windows.Forms.Button()
        Me.Button9 = New System.Windows.Forms.Button()
        Me.Button8 = New System.Windows.Forms.Button()
        Me.Button7 = New System.Windows.Forms.Button()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.KEY_1W = New System.Windows.Forms.TextBox()
        Me.Button6 = New System.Windows.Forms.Button()
        Me.Button5 = New System.Windows.Forms.Button()
        Me.Button4 = New System.Windows.Forms.Button()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.T2_ID = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.T1_ID = New System.Windows.Forms.TextBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.rtc_timer = New System.Windows.Forms.Timer(Me.components)
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        CType(Me.InPic_8, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_7, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_6, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_5, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_4, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_3, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.InPic_1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox4.SuspendLayout()
        Me.GroupBox5.SuspendLayout()
        Me.MenuStrip1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'SerialPort1
        '
        '
        'RdBox
        '
        Me.RdBox.Location = New System.Drawing.Point(4, 17)
        Me.RdBox.Multiline = True
        Me.RdBox.Name = "RdBox"
        Me.RdBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.RdBox.Size = New System.Drawing.Size(311, 372)
        Me.RdBox.TabIndex = 0
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.WdBut)
        Me.GroupBox1.Controls.Add(Me.WdBox)
        Me.GroupBox1.Controls.Add(Me.RdBox)
        Me.GroupBox1.Location = New System.Drawing.Point(211, 50)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(321, 424)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Serial module"
        '
        'WdBut
        '
        Me.WdBut.Location = New System.Drawing.Point(255, 397)
        Me.WdBut.Name = "WdBut"
        Me.WdBut.Size = New System.Drawing.Size(60, 20)
        Me.WdBut.TabIndex = 2
        Me.WdBut.Text = "Write"
        Me.WdBut.UseVisualStyleBackColor = True
        '
        'WdBox
        '
        Me.WdBox.Location = New System.Drawing.Point(6, 397)
        Me.WdBox.Name = "WdBox"
        Me.WdBox.Size = New System.Drawing.Size(245, 20)
        Me.WdBox.TabIndex = 1
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.CheckBox17)
        Me.GroupBox3.Controls.Add(Me.CheckBox9)
        Me.GroupBox3.Controls.Add(Me.TimerBox)
        Me.GroupBox3.Controls.Add(Me.CheckBox10)
        Me.GroupBox3.Controls.Add(Me.InPic_8)
        Me.GroupBox3.Controls.Add(Me.CheckBox11)
        Me.GroupBox3.Controls.Add(Me.InPic_7)
        Me.GroupBox3.Controls.Add(Me.CheckBox12)
        Me.GroupBox3.Controls.Add(Me.InPic_6)
        Me.GroupBox3.Controls.Add(Me.CheckBox13)
        Me.GroupBox3.Controls.Add(Me.InPic_5)
        Me.GroupBox3.Controls.Add(Me.CheckBox14)
        Me.GroupBox3.Controls.Add(Me.InPic_4)
        Me.GroupBox3.Controls.Add(Me.CheckBox15)
        Me.GroupBox3.Controls.Add(Me.InPic_3)
        Me.GroupBox3.Controls.Add(Me.CheckBox16)
        Me.GroupBox3.Controls.Add(Me.InPic_2)
        Me.GroupBox3.Controls.Add(Me.InPic_1)
        Me.GroupBox3.Controls.Add(Me.CheckBox8)
        Me.GroupBox3.Controls.Add(Me.CheckBox7)
        Me.GroupBox3.Controls.Add(Me.CheckBox6)
        Me.GroupBox3.Controls.Add(Me.CheckBox5)
        Me.GroupBox3.Controls.Add(Me.CheckBox4)
        Me.GroupBox3.Controls.Add(Me.CheckBox3)
        Me.GroupBox3.Controls.Add(Me.CheckBox2)
        Me.GroupBox3.Controls.Add(Me.CheckBox1)
        Me.GroupBox3.Controls.Add(Me.DtrBox)
        Me.GroupBox3.Controls.Add(Me.RtsBox)
        Me.GroupBox3.Location = New System.Drawing.Point(5, 213)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(200, 261)
        Me.GroupBox3.TabIndex = 5
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Extention"
        '
        'CheckBox17
        '
        Me.CheckBox17.AutoSize = True
        Me.CheckBox17.Location = New System.Drawing.Point(4, 229)
        Me.CheckBox17.Name = "CheckBox17"
        Me.CheckBox17.Size = New System.Drawing.Size(76, 17)
        Me.CheckBox17.TabIndex = 33
        Me.CheckBox17.Text = "Reset ALL"
        Me.CheckBox17.UseVisualStyleBackColor = True
        '
        'CheckBox9
        '
        Me.CheckBox9.AutoSize = True
        Me.CheckBox9.Location = New System.Drawing.Point(58, 206)
        Me.CheckBox9.Name = "CheckBox9"
        Me.CheckBox9.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox9.TabIndex = 32
        Me.CheckBox9.Text = "Out_16"
        Me.CheckBox9.UseVisualStyleBackColor = True
        '
        'TimerBox
        '
        Me.TimerBox.AutoSize = True
        Me.TimerBox.Checked = True
        Me.TimerBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.TimerBox.Location = New System.Drawing.Point(114, 22)
        Me.TimerBox.Name = "TimerBox"
        Me.TimerBox.Size = New System.Drawing.Size(52, 17)
        Me.TimerBox.TabIndex = 18
        Me.TimerBox.Text = "Timer"
        Me.TimerBox.UseVisualStyleBackColor = True
        '
        'CheckBox10
        '
        Me.CheckBox10.AutoSize = True
        Me.CheckBox10.Location = New System.Drawing.Point(58, 183)
        Me.CheckBox10.Name = "CheckBox10"
        Me.CheckBox10.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox10.TabIndex = 31
        Me.CheckBox10.Text = "Out_15"
        Me.CheckBox10.UseVisualStyleBackColor = True
        '
        'InPic_8
        '
        Me.InPic_8.Location = New System.Drawing.Point(146, 206)
        Me.InPic_8.Name = "InPic_8"
        Me.InPic_8.Size = New System.Drawing.Size(18, 17)
        Me.InPic_8.TabIndex = 17
        Me.InPic_8.TabStop = False
        '
        'CheckBox11
        '
        Me.CheckBox11.AutoSize = True
        Me.CheckBox11.Location = New System.Drawing.Point(58, 160)
        Me.CheckBox11.Name = "CheckBox11"
        Me.CheckBox11.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox11.TabIndex = 30
        Me.CheckBox11.Text = "Out_14"
        Me.CheckBox11.UseVisualStyleBackColor = True
        '
        'InPic_7
        '
        Me.InPic_7.Location = New System.Drawing.Point(146, 183)
        Me.InPic_7.Name = "InPic_7"
        Me.InPic_7.Size = New System.Drawing.Size(18, 17)
        Me.InPic_7.TabIndex = 16
        Me.InPic_7.TabStop = False
        '
        'CheckBox12
        '
        Me.CheckBox12.AutoSize = True
        Me.CheckBox12.Location = New System.Drawing.Point(58, 137)
        Me.CheckBox12.Name = "CheckBox12"
        Me.CheckBox12.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox12.TabIndex = 29
        Me.CheckBox12.Text = "Out_13"
        Me.CheckBox12.UseVisualStyleBackColor = True
        '
        'InPic_6
        '
        Me.InPic_6.Location = New System.Drawing.Point(146, 160)
        Me.InPic_6.Name = "InPic_6"
        Me.InPic_6.Size = New System.Drawing.Size(18, 17)
        Me.InPic_6.TabIndex = 15
        Me.InPic_6.TabStop = False
        '
        'CheckBox13
        '
        Me.CheckBox13.AutoSize = True
        Me.CheckBox13.Location = New System.Drawing.Point(58, 114)
        Me.CheckBox13.Name = "CheckBox13"
        Me.CheckBox13.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox13.TabIndex = 28
        Me.CheckBox13.Text = "Out_12"
        Me.CheckBox13.UseVisualStyleBackColor = True
        '
        'InPic_5
        '
        Me.InPic_5.Location = New System.Drawing.Point(146, 137)
        Me.InPic_5.Name = "InPic_5"
        Me.InPic_5.Size = New System.Drawing.Size(18, 17)
        Me.InPic_5.TabIndex = 14
        Me.InPic_5.TabStop = False
        '
        'CheckBox14
        '
        Me.CheckBox14.AutoSize = True
        Me.CheckBox14.Location = New System.Drawing.Point(58, 91)
        Me.CheckBox14.Name = "CheckBox14"
        Me.CheckBox14.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox14.TabIndex = 27
        Me.CheckBox14.Text = "Out_11"
        Me.CheckBox14.UseVisualStyleBackColor = True
        '
        'InPic_4
        '
        Me.InPic_4.Location = New System.Drawing.Point(146, 114)
        Me.InPic_4.Name = "InPic_4"
        Me.InPic_4.Size = New System.Drawing.Size(18, 17)
        Me.InPic_4.TabIndex = 13
        Me.InPic_4.TabStop = False
        '
        'CheckBox15
        '
        Me.CheckBox15.AutoSize = True
        Me.CheckBox15.Location = New System.Drawing.Point(58, 68)
        Me.CheckBox15.Name = "CheckBox15"
        Me.CheckBox15.Size = New System.Drawing.Size(61, 17)
        Me.CheckBox15.TabIndex = 26
        Me.CheckBox15.Text = "Out_10"
        Me.CheckBox15.UseVisualStyleBackColor = True
        '
        'InPic_3
        '
        Me.InPic_3.Location = New System.Drawing.Point(146, 91)
        Me.InPic_3.Name = "InPic_3"
        Me.InPic_3.Size = New System.Drawing.Size(18, 17)
        Me.InPic_3.TabIndex = 12
        Me.InPic_3.TabStop = False
        '
        'CheckBox16
        '
        Me.CheckBox16.AutoSize = True
        Me.CheckBox16.Location = New System.Drawing.Point(58, 45)
        Me.CheckBox16.Name = "CheckBox16"
        Me.CheckBox16.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox16.TabIndex = 25
        Me.CheckBox16.Text = "Out_9"
        Me.CheckBox16.UseVisualStyleBackColor = True
        '
        'InPic_2
        '
        Me.InPic_2.Location = New System.Drawing.Point(146, 68)
        Me.InPic_2.Name = "InPic_2"
        Me.InPic_2.Size = New System.Drawing.Size(18, 17)
        Me.InPic_2.TabIndex = 11
        Me.InPic_2.TabStop = False
        '
        'InPic_1
        '
        Me.InPic_1.Location = New System.Drawing.Point(146, 45)
        Me.InPic_1.Name = "InPic_1"
        Me.InPic_1.Size = New System.Drawing.Size(18, 17)
        Me.InPic_1.TabIndex = 10
        Me.InPic_1.TabStop = False
        '
        'CheckBox8
        '
        Me.CheckBox8.AutoSize = True
        Me.CheckBox8.Location = New System.Drawing.Point(4, 206)
        Me.CheckBox8.Name = "CheckBox8"
        Me.CheckBox8.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox8.TabIndex = 9
        Me.CheckBox8.Text = "Out_8"
        Me.CheckBox8.UseVisualStyleBackColor = True
        '
        'CheckBox7
        '
        Me.CheckBox7.AutoSize = True
        Me.CheckBox7.Location = New System.Drawing.Point(4, 183)
        Me.CheckBox7.Name = "CheckBox7"
        Me.CheckBox7.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox7.TabIndex = 8
        Me.CheckBox7.Text = "Out_7"
        Me.CheckBox7.UseVisualStyleBackColor = True
        '
        'CheckBox6
        '
        Me.CheckBox6.AutoSize = True
        Me.CheckBox6.Location = New System.Drawing.Point(4, 160)
        Me.CheckBox6.Name = "CheckBox6"
        Me.CheckBox6.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox6.TabIndex = 7
        Me.CheckBox6.Text = "Out_6"
        Me.CheckBox6.UseVisualStyleBackColor = True
        '
        'CheckBox5
        '
        Me.CheckBox5.AutoSize = True
        Me.CheckBox5.Location = New System.Drawing.Point(4, 137)
        Me.CheckBox5.Name = "CheckBox5"
        Me.CheckBox5.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox5.TabIndex = 6
        Me.CheckBox5.Text = "Out_5"
        Me.CheckBox5.UseVisualStyleBackColor = True
        '
        'CheckBox4
        '
        Me.CheckBox4.AutoSize = True
        Me.CheckBox4.Location = New System.Drawing.Point(4, 114)
        Me.CheckBox4.Name = "CheckBox4"
        Me.CheckBox4.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox4.TabIndex = 5
        Me.CheckBox4.Text = "Out_4"
        Me.CheckBox4.UseVisualStyleBackColor = True
        '
        'CheckBox3
        '
        Me.CheckBox3.AutoSize = True
        Me.CheckBox3.Location = New System.Drawing.Point(4, 91)
        Me.CheckBox3.Name = "CheckBox3"
        Me.CheckBox3.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox3.TabIndex = 4
        Me.CheckBox3.Text = "Out_3"
        Me.CheckBox3.UseVisualStyleBackColor = True
        '
        'CheckBox2
        '
        Me.CheckBox2.AutoSize = True
        Me.CheckBox2.Location = New System.Drawing.Point(4, 68)
        Me.CheckBox2.Name = "CheckBox2"
        Me.CheckBox2.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox2.TabIndex = 3
        Me.CheckBox2.Text = "Out_2"
        Me.CheckBox2.UseVisualStyleBackColor = True
        '
        'CheckBox1
        '
        Me.CheckBox1.AutoSize = True
        Me.CheckBox1.Location = New System.Drawing.Point(4, 45)
        Me.CheckBox1.Name = "CheckBox1"
        Me.CheckBox1.Size = New System.Drawing.Size(55, 17)
        Me.CheckBox1.TabIndex = 2
        Me.CheckBox1.Text = "Out_1"
        Me.CheckBox1.UseVisualStyleBackColor = True
        '
        'DtrBox
        '
        Me.DtrBox.AutoSize = True
        Me.DtrBox.Location = New System.Drawing.Point(58, 21)
        Me.DtrBox.Name = "DtrBox"
        Me.DtrBox.Size = New System.Drawing.Size(49, 17)
        Me.DtrBox.TabIndex = 1
        Me.DtrBox.Text = "DTR"
        Me.DtrBox.UseVisualStyleBackColor = True
        '
        'RtsBox
        '
        Me.RtsBox.AutoSize = True
        Me.RtsBox.Location = New System.Drawing.Point(4, 21)
        Me.RtsBox.Name = "RtsBox"
        Me.RtsBox.Size = New System.Drawing.Size(48, 17)
        Me.RtsBox.TabIndex = 0
        Me.RtsBox.Text = "RTS"
        Me.RtsBox.UseVisualStyleBackColor = True
        '
        'Timer1
        '
        Me.Timer1.Interval = 250
        '
        'TCP_SerialSelector
        '
        Me.TCP_SerialSelector.AutoSize = True
        Me.TCP_SerialSelector.Location = New System.Drawing.Point(9, 27)
        Me.TCP_SerialSelector.Name = "TCP_SerialSelector"
        Me.TCP_SerialSelector.Size = New System.Drawing.Size(78, 17)
        Me.TCP_SerialSelector.TabIndex = 6
        Me.TCP_SerialSelector.Text = "LAN/Serial"
        Me.TCP_SerialSelector.UseVisualStyleBackColor = True
        '
        'PortNameBox
        '
        Me.PortNameBox.FormattingEnabled = True
        Me.PortNameBox.Location = New System.Drawing.Point(4, 16)
        Me.PortNameBox.Name = "PortNameBox"
        Me.PortNameBox.Size = New System.Drawing.Size(190, 21)
        Me.PortNameBox.TabIndex = 7
        '
        'TcpIPBox
        '
        Me.TcpIPBox.Location = New System.Drawing.Point(42, 17)
        Me.TcpIPBox.Name = "TcpIPBox"
        Me.TcpIPBox.Size = New System.Drawing.Size(82, 20)
        Me.TcpIPBox.TabIndex = 8
        Me.TcpIPBox.Text = "192.168.103"
        Me.TcpIPBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.TcpConnectBut)
        Me.GroupBox4.Controls.Add(Me.Label4)
        Me.GroupBox4.Controls.Add(Me.Label3)
        Me.GroupBox4.Controls.Add(Me.Label1)
        Me.GroupBox4.Controls.Add(Me.TcpPassBox)
        Me.GroupBox4.Controls.Add(Me.TcpUserBox)
        Me.GroupBox4.Controls.Add(Me.TcpPortBox)
        Me.GroupBox4.Controls.Add(Me.TcpIPBox)
        Me.GroupBox4.Location = New System.Drawing.Point(5, 50)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(173, 122)
        Me.GroupBox4.TabIndex = 9
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "TCP/IP"
        Me.GroupBox4.Visible = False
        '
        'TcpConnectBut
        '
        Me.TcpConnectBut.Location = New System.Drawing.Point(72, 91)
        Me.TcpConnectBut.Name = "TcpConnectBut"
        Me.TcpConnectBut.Size = New System.Drawing.Size(94, 23)
        Me.TcpConnectBut.TabIndex = 16
        Me.TcpConnectBut.Text = "Connect"
        Me.TcpConnectBut.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(1, 69)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(30, 13)
        Me.Label4.TabIndex = 15
        Me.Label4.Text = "Pass"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(0, 46)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(29, 13)
        Me.Label3.TabIndex = 14
        Me.Label3.Text = "User"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(1, 19)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(41, 13)
        Me.Label1.TabIndex = 12
        Me.Label1.Text = "IP/Port"
        '
        'TcpPassBox
        '
        Me.TcpPassBox.Location = New System.Drawing.Point(72, 66)
        Me.TcpPassBox.Name = "TcpPassBox"
        Me.TcpPassBox.Size = New System.Drawing.Size(96, 20)
        Me.TcpPassBox.TabIndex = 11
        Me.TcpPassBox.Text = "toor"
        Me.TcpPassBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.TcpPassBox.UseSystemPasswordChar = True
        '
        'TcpUserBox
        '
        Me.TcpUserBox.Location = New System.Drawing.Point(72, 43)
        Me.TcpUserBox.Name = "TcpUserBox"
        Me.TcpUserBox.Size = New System.Drawing.Size(96, 20)
        Me.TcpUserBox.TabIndex = 10
        Me.TcpUserBox.Text = "root"
        Me.TcpUserBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'TcpPortBox
        '
        Me.TcpPortBox.Location = New System.Drawing.Point(127, 17)
        Me.TcpPortBox.Name = "TcpPortBox"
        Me.TcpPortBox.Size = New System.Drawing.Size(39, 20)
        Me.TcpPortBox.TabIndex = 9
        Me.TcpPortBox.Text = "23"
        Me.TcpPortBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'GroupBox5
        '
        Me.GroupBox5.Controls.Add(Me.Label2)
        Me.GroupBox5.Controls.Add(Me.RS485AdressBox)
        Me.GroupBox5.Controls.Add(Me.RS485Box)
        Me.GroupBox5.Controls.Add(Me.PortOpen)
        Me.GroupBox5.Controls.Add(Me.PortBaudBox)
        Me.GroupBox5.Controls.Add(Me.PortNameBox)
        Me.GroupBox5.Location = New System.Drawing.Point(5, 50)
        Me.GroupBox5.Name = "GroupBox5"
        Me.GroupBox5.Size = New System.Drawing.Size(200, 157)
        Me.GroupBox5.TabIndex = 16
        Me.GroupBox5.TabStop = False
        Me.GroupBox5.Text = "Serial port"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(60, 134)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(77, 13)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Address board"
        '
        'RS485AdressBox
        '
        Me.RS485AdressBox.Location = New System.Drawing.Point(4, 131)
        Me.RS485AdressBox.Name = "RS485AdressBox"
        Me.RS485AdressBox.Size = New System.Drawing.Size(50, 20)
        Me.RS485AdressBox.TabIndex = 11
        Me.RS485AdressBox.Text = "&hff"
        '
        'RS485Box
        '
        Me.RS485Box.AutoSize = True
        Me.RS485Box.Location = New System.Drawing.Point(7, 108)
        Me.RS485Box.Name = "RS485Box"
        Me.RS485Box.Size = New System.Drawing.Size(75, 17)
        Me.RS485Box.TabIndex = 10
        Me.RS485Box.Text = "rs485/232"
        Me.RS485Box.UseVisualStyleBackColor = True
        '
        'PortOpen
        '
        Me.PortOpen.Location = New System.Drawing.Point(116, 43)
        Me.PortOpen.Name = "PortOpen"
        Me.PortOpen.Size = New System.Drawing.Size(78, 48)
        Me.PortOpen.TabIndex = 9
        Me.PortOpen.Text = "Open"
        Me.PortOpen.UseVisualStyleBackColor = True
        '
        'PortBaudBox
        '
        Me.PortBaudBox.FormattingEnabled = True
        Me.PortBaudBox.Location = New System.Drawing.Point(4, 42)
        Me.PortBaudBox.Name = "PortBaudBox"
        Me.PortBaudBox.Size = New System.Drawing.Size(109, 21)
        Me.PortBaudBox.TabIndex = 8
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.SetupToolStripMenuItem, Me.I2CModuleToolStripMenuItem, Me.HelpToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(706, 24)
        Me.MenuStrip1.TabIndex = 17
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OpenConfigFileToolStripMenuItem, Me.SetAnonimusTcpToolStripMenuItem, Me.ResetTCPConfToDefaultToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(37, 20)
        Me.FileToolStripMenuItem.Text = "File"
        '
        'OpenConfigFileToolStripMenuItem
        '
        Me.OpenConfigFileToolStripMenuItem.Name = "OpenConfigFileToolStripMenuItem"
        Me.OpenConfigFileToolStripMenuItem.Size = New System.Drawing.Size(210, 22)
        Me.OpenConfigFileToolStripMenuItem.Text = "Open config file"
        '
        'SetAnonimusTcpToolStripMenuItem
        '
        Me.SetAnonimusTcpToolStripMenuItem.Name = "SetAnonimusTcpToolStripMenuItem"
        Me.SetAnonimusTcpToolStripMenuItem.Size = New System.Drawing.Size(210, 22)
        Me.SetAnonimusTcpToolStripMenuItem.Text = "Set anonimus tcp"
        '
        'ResetTCPConfToDefaultToolStripMenuItem
        '
        Me.ResetTCPConfToDefaultToolStripMenuItem.Name = "ResetTCPConfToDefaultToolStripMenuItem"
        Me.ResetTCPConfToDefaultToolStripMenuItem.Size = New System.Drawing.Size(210, 22)
        Me.ResetTCPConfToDefaultToolStripMenuItem.Text = "Reset TCP conf. to default"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(210, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'SetupToolStripMenuItem
        '
        Me.SetupToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddExtentionToolStripMenuItem, Me.SetupTimerToolStripMenuItem, Me.SyncRTCToolStripMenuItem})
        Me.SetupToolStripMenuItem.Name = "SetupToolStripMenuItem"
        Me.SetupToolStripMenuItem.Size = New System.Drawing.Size(49, 20)
        Me.SetupToolStripMenuItem.Text = "Setup"
        '
        'AddExtentionToolStripMenuItem
        '
        Me.AddExtentionToolStripMenuItem.Name = "AddExtentionToolStripMenuItem"
        Me.AddExtentionToolStripMenuItem.Size = New System.Drawing.Size(148, 22)
        Me.AddExtentionToolStripMenuItem.Text = "Add extention"
        '
        'SetupTimerToolStripMenuItem
        '
        Me.SetupTimerToolStripMenuItem.Name = "SetupTimerToolStripMenuItem"
        Me.SetupTimerToolStripMenuItem.Size = New System.Drawing.Size(148, 22)
        Me.SetupTimerToolStripMenuItem.Text = "Setup timer"
        '
        'SyncRTCToolStripMenuItem
        '
        Me.SyncRTCToolStripMenuItem.Name = "SyncRTCToolStripMenuItem"
        Me.SyncRTCToolStripMenuItem.Size = New System.Drawing.Size(148, 22)
        Me.SyncRTCToolStripMenuItem.Text = "Sync RTC"
        '
        'I2CModuleToolStripMenuItem
        '
        Me.I2CModuleToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.I2cToolStripMenuItem, Me.SPIToolStripMenuItem, Me.OneWireToolStripMenuItem})
        Me.I2CModuleToolStripMenuItem.Name = "I2CModuleToolStripMenuItem"
        Me.I2CModuleToolStripMenuItem.Size = New System.Drawing.Size(65, 20)
        Me.I2CModuleToolStripMenuItem.Text = "Modules"
        '
        'I2cToolStripMenuItem
        '
        Me.I2cToolStripMenuItem.Name = "I2cToolStripMenuItem"
        Me.I2cToolStripMenuItem.Size = New System.Drawing.Size(120, 22)
        Me.I2cToolStripMenuItem.Text = "I2c"
        '
        'SPIToolStripMenuItem
        '
        Me.SPIToolStripMenuItem.Name = "SPIToolStripMenuItem"
        Me.SPIToolStripMenuItem.Size = New System.Drawing.Size(120, 22)
        Me.SPIToolStripMenuItem.Text = "SPI"
        '
        'OneWireToolStripMenuItem
        '
        Me.OneWireToolStripMenuItem.Name = "OneWireToolStripMenuItem"
        Me.OneWireToolStripMenuItem.Size = New System.Drawing.Size(120, 22)
        Me.OneWireToolStripMenuItem.Text = "OneWire"
        '
        'HelpToolStripMenuItem
        '
        Me.HelpToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AboutToolStripMenuItem, Me.IndexToolStripMenuItem, Me.ToolStripMenuItem2})
        Me.HelpToolStripMenuItem.Name = "HelpToolStripMenuItem"
        Me.HelpToolStripMenuItem.Size = New System.Drawing.Size(44, 20)
        Me.HelpToolStripMenuItem.Text = "Help"
        '
        'AboutToolStripMenuItem
        '
        Me.AboutToolStripMenuItem.Name = "AboutToolStripMenuItem"
        Me.AboutToolStripMenuItem.Size = New System.Drawing.Size(107, 22)
        Me.AboutToolStripMenuItem.Text = "About"
        '
        'IndexToolStripMenuItem
        '
        Me.IndexToolStripMenuItem.Name = "IndexToolStripMenuItem"
        Me.IndexToolStripMenuItem.Size = New System.Drawing.Size(107, 22)
        Me.IndexToolStripMenuItem.Text = "Index"
        '
        'ToolStripMenuItem2
        '
        Me.ToolStripMenuItem2.Name = "ToolStripMenuItem2"
        Me.ToolStripMenuItem2.Size = New System.Drawing.Size(107, 22)
        Me.ToolStripMenuItem2.Text = "?"
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(6, 19)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(62, 23)
        Me.Button1.TabIndex = 18
        Me.Button1.Text = "Get T1"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'Button2
        '
        Me.Button2.Location = New System.Drawing.Point(74, 19)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(62, 23)
        Me.Button2.TabIndex = 19
        Me.Button2.Text = "Get T2"
        Me.Button2.UseVisualStyleBackColor = True
        '
        'Button3
        '
        Me.Button3.Location = New System.Drawing.Point(6, 48)
        Me.Button3.Name = "Button3"
        Me.Button3.Size = New System.Drawing.Size(75, 23)
        Me.Button3.TabIndex = 20
        Me.Button3.Text = "Scan t_ID"
        Me.Button3.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.Button10)
        Me.GroupBox2.Controls.Add(Me.Label9)
        Me.GroupBox2.Controls.Add(Me.RTC_box)
        Me.GroupBox2.Controls.Add(Me.RTC_get)
        Me.GroupBox2.Controls.Add(Me.Button9)
        Me.GroupBox2.Controls.Add(Me.Button8)
        Me.GroupBox2.Controls.Add(Me.Button7)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.KEY_1W)
        Me.GroupBox2.Controls.Add(Me.Button6)
        Me.GroupBox2.Controls.Add(Me.Button5)
        Me.GroupBox2.Controls.Add(Me.Button4)
        Me.GroupBox2.Controls.Add(Me.Label7)
        Me.GroupBox2.Controls.Add(Me.T2_ID)
        Me.GroupBox2.Controls.Add(Me.Label6)
        Me.GroupBox2.Controls.Add(Me.T1_ID)
        Me.GroupBox2.Controls.Add(Me.Button1)
        Me.GroupBox2.Controls.Add(Me.Button2)
        Me.GroupBox2.Controls.Add(Me.Button3)
        Me.GroupBox2.Location = New System.Drawing.Point(538, 50)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(156, 424)
        Me.GroupBox2.TabIndex = 22
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Macro"
        '
        'Button10
        '
        Me.Button10.Location = New System.Drawing.Point(83, 382)
        Me.Button10.Name = "Button10"
        Me.Button10.Size = New System.Drawing.Size(67, 23)
        Me.Button10.TabIndex = 36
        Me.Button10.Text = "Sync. SYS"
        Me.Button10.UseVisualStyleBackColor = True
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(7, 339)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(66, 13)
        Me.Label9.TabIndex = 35
        Me.Label9.Text = "System RTC"
        '
        'RTC_box
        '
        Me.RTC_box.Location = New System.Drawing.Point(6, 355)
        Me.RTC_box.Name = "RTC_box"
        Me.RTC_box.Size = New System.Drawing.Size(144, 20)
        Me.RTC_box.TabIndex = 34
        '
        'RTC_get
        '
        Me.RTC_get.Location = New System.Drawing.Point(6, 381)
        Me.RTC_get.Name = "RTC_get"
        Me.RTC_get.Size = New System.Drawing.Size(69, 23)
        Me.RTC_get.TabIndex = 33
        Me.RTC_get.Text = "Read back"
        Me.RTC_get.UseVisualStyleBackColor = True
        '
        'Button9
        '
        Me.Button9.Location = New System.Drawing.Point(6, 298)
        Me.Button9.Name = "Button9"
        Me.Button9.Size = New System.Drawing.Size(69, 25)
        Me.Button9.TabIndex = 32
        Me.Button9.Text = "Scan_KEY"
        Me.Button9.UseVisualStyleBackColor = True
        '
        'Button8
        '
        Me.Button8.Location = New System.Drawing.Point(6, 267)
        Me.Button8.Name = "Button8"
        Me.Button8.Size = New System.Drawing.Size(69, 25)
        Me.Button8.TabIndex = 31
        Me.Button8.Text = "Read_KEY"
        Me.Button8.UseVisualStyleBackColor = True
        '
        'Button7
        '
        Me.Button7.Location = New System.Drawing.Point(83, 267)
        Me.Button7.Name = "Button7"
        Me.Button7.Size = New System.Drawing.Size(67, 25)
        Me.Button7.TabIndex = 30
        Me.Button7.Text = "Write_KEY"
        Me.Button7.UseVisualStyleBackColor = True
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(7, 225)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(68, 13)
        Me.Label5.TabIndex = 29
        Me.Label5.Text = "License Key:"
        '
        'KEY_1W
        '
        Me.KEY_1W.Location = New System.Drawing.Point(6, 241)
        Me.KEY_1W.Name = "KEY_1W"
        Me.KEY_1W.Size = New System.Drawing.Size(144, 20)
        Me.KEY_1W.TabIndex = 28
        Me.KEY_1W.Text = "00,00,00,00,00,00,00,00"
        '
        'Button6
        '
        Me.Button6.Location = New System.Drawing.Point(6, 189)
        Me.Button6.Name = "Button6"
        Me.Button6.Size = New System.Drawing.Size(52, 25)
        Me.Button6.TabIndex = 27
        Me.Button6.Text = "SWAP"
        Me.Button6.UseVisualStyleBackColor = True
        '
        'Button5
        '
        Me.Button5.Location = New System.Drawing.Point(74, 189)
        Me.Button5.Name = "Button5"
        Me.Button5.Size = New System.Drawing.Size(76, 25)
        Me.Button5.TabIndex = 26
        Me.Button5.Text = "Write_T2_ID"
        Me.Button5.UseVisualStyleBackColor = True
        '
        'Button4
        '
        Me.Button4.Location = New System.Drawing.Point(74, 117)
        Me.Button4.Name = "Button4"
        Me.Button4.Size = New System.Drawing.Size(76, 25)
        Me.Button4.TabIndex = 25
        Me.Button4.Text = "Write_T1_ID"
        Me.Button4.UseVisualStyleBackColor = True
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(7, 147)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(40, 13)
        Me.Label7.TabIndex = 24
        Me.Label7.Text = "T2_ID:"
        '
        'T2_ID
        '
        Me.T2_ID.Location = New System.Drawing.Point(6, 163)
        Me.T2_ID.Name = "T2_ID"
        Me.T2_ID.Size = New System.Drawing.Size(144, 20)
        Me.T2_ID.TabIndex = 23
        Me.T2_ID.Text = "00,00,00,00,00,00,00,00"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(7, 73)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(40, 13)
        Me.Label6.TabIndex = 22
        Me.Label6.Text = "T1_ID:"
        '
        'T1_ID
        '
        Me.T1_ID.Location = New System.Drawing.Point(6, 91)
        Me.T1_ID.Name = "T1_ID"
        Me.T1_ID.Size = New System.Drawing.Size(144, 20)
        Me.T1_ID.TabIndex = 21
        Me.T1_ID.Text = "00,00,00,00,00,00,00,00"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(204, Byte))
        Me.Label8.ForeColor = System.Drawing.SystemColors.ControlDarkDark
        Me.Label8.Location = New System.Drawing.Point(538, 477)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(52, 13)
        Me.Label8.TabIndex = 23
        Me.Label8.Text = "build_info"
        '
        'rtc_timer
        '
        Me.rtc_timer.Enabled = True
        Me.rtc_timer.Interval = 1000
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.ClientSize = New System.Drawing.Size(706, 495)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox5)
        Me.Controls.Add(Me.GroupBox4)
        Me.Controls.Add(Me.TCP_SerialSelector)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.MenuStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximumSize = New System.Drawing.Size(722, 534)
        Me.MinimumSize = New System.Drawing.Size(722, 534)
        Me.Name = "Form1"
        Me.Text = "Serial Port IO manager v2.3 "
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        CType(Me.InPic_8, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_7, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_6, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_5, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_4, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_3, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.InPic_1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox4.PerformLayout()
        Me.GroupBox5.ResumeLayout(False)
        Me.GroupBox5.PerformLayout()
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents SerialPort1 As IO.Ports.SerialPort
    Friend WithEvents RdBox As TextBox
    Friend WithEvents GroupBox1 As GroupBox
    Friend WithEvents WdBut As Button
    Friend WithEvents WdBox As TextBox
    Friend WithEvents GroupBox3 As GroupBox
    Friend WithEvents DtrBox As CheckBox
    Friend WithEvents RtsBox As CheckBox
    Friend WithEvents CheckBox8 As CheckBox
    Friend WithEvents CheckBox7 As CheckBox
    Friend WithEvents CheckBox6 As CheckBox
    Friend WithEvents CheckBox5 As CheckBox
    Friend WithEvents CheckBox4 As CheckBox
    Friend WithEvents CheckBox3 As CheckBox
    Friend WithEvents CheckBox2 As CheckBox
    Friend WithEvents CheckBox1 As CheckBox
    Friend WithEvents InPic_8 As PictureBox
    Friend WithEvents InPic_7 As PictureBox
    Friend WithEvents InPic_6 As PictureBox
    Friend WithEvents InPic_5 As PictureBox
    Friend WithEvents InPic_4 As PictureBox
    Friend WithEvents InPic_3 As PictureBox
    Friend WithEvents InPic_2 As PictureBox
    Friend WithEvents InPic_1 As PictureBox
    Friend WithEvents Timer1 As Timer
    Friend WithEvents TimerBox As CheckBox
    Friend WithEvents TCP_SerialSelector As CheckBox
    Friend WithEvents PortNameBox As ComboBox
    Friend WithEvents TcpIPBox As TextBox
    Friend WithEvents GroupBox4 As GroupBox
    Friend WithEvents GroupBox5 As GroupBox
    Friend WithEvents RS485Box As CheckBox
    Friend WithEvents PortOpen As Button
    Friend WithEvents PortBaudBox As ComboBox
    Friend WithEvents Label4 As Label
    Friend WithEvents Label3 As Label
    Friend WithEvents Label1 As Label
    Friend WithEvents TcpPassBox As TextBox
    Friend WithEvents TcpUserBox As TextBox
    Friend WithEvents TcpPortBox As TextBox
    Friend WithEvents TcpConnectBut As Button
    Friend WithEvents MenuStrip1 As MenuStrip
    Friend WithEvents FileToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SetupToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents HelpToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents OpenConfigFileToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SetAnonimusTcpToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ResetTCPConfToDefaultToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents AddExtentionToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents AboutToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents IndexToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem2 As ToolStripMenuItem
    Friend WithEvents SetupTimerToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents I2CModuleToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents I2cToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SPIToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents OneWireToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SyncRTCToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents RS485AdressBox As TextBox
    Friend WithEvents Label2 As Label
    Friend WithEvents Button1 As Button
    Friend WithEvents Button2 As Button
    Friend WithEvents Button3 As Button
    Friend WithEvents GroupBox2 As GroupBox
    Friend WithEvents Label7 As Label
    Friend WithEvents T2_ID As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents T1_ID As TextBox
    Friend WithEvents Button6 As Button
    Friend WithEvents Button5 As Button
    Friend WithEvents Button4 As Button
    Friend WithEvents Button7 As Button
    Friend WithEvents Label5 As Label
    Friend WithEvents KEY_1W As TextBox
    Friend WithEvents Button9 As Button
    Friend WithEvents Button8 As Button
    Friend WithEvents Label8 As Label
    Friend WithEvents Button10 As Button
    Friend WithEvents Label9 As Label
    Friend WithEvents RTC_box As TextBox
    Friend WithEvents RTC_get As Button
    Friend WithEvents rtc_timer As Timer
    Friend WithEvents CheckBox9 As CheckBox
    Friend WithEvents CheckBox10 As CheckBox
    Friend WithEvents CheckBox11 As CheckBox
    Friend WithEvents CheckBox12 As CheckBox
    Friend WithEvents CheckBox13 As CheckBox
    Friend WithEvents CheckBox14 As CheckBox
    Friend WithEvents CheckBox15 As CheckBox
    Friend WithEvents CheckBox16 As CheckBox
    Friend WithEvents CheckBox17 As CheckBox
End Class
