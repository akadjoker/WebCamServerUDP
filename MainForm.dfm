object Form1: TForm1
  Left = 313
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WebCam UDP server v.0.2.1 By Djoker Soft.'
  ClientHeight = 460
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 460
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 19
      Top = 18
      Width = 44
      Height = 13
      Caption = 'Cameras:'
    end
    object bvl1: TBevel
      Left = 8
      Top = 8
      Width = 369
      Height = 41
    end
    object img1: TImage
      Left = 8
      Top = 72
      Width = 377
      Height = 369
      Stretch = True
    end
    object ComboBox1: TComboBox
      Left = 96
      Top = 16
      Width = 249
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object pnl1: TPanel
    Left = 401
    Top = 0
    Width = 383
    Height = 460
    Align = alClient
    TabOrder = 1
    object Log: TLabel
      Left = 8
      Top = 352
      Width = 18
      Height = 13
      Caption = 'Log'
    end
    object pnl2: TPanel
      Left = 1
      Top = 368
      Width = 381
      Height = 91
      Align = alBottom
      Caption = 'pnl2'
      TabOrder = 0
      object mmo1: TMemo
        Left = 1
        Top = 1
        Width = 379
        Height = 89
        Align = alClient
        Color = clMenuText
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object grp1: TGroupBox
      Left = 16
      Top = 16
      Width = 321
      Height = 321
      TabOrder = 1
      object lbl1: TLabel
        Left = 16
        Top = 16
        Width = 25
        Height = 13
        Caption = 'delay'
      end
      object lbl2: TLabel
        Left = 16
        Top = 64
        Width = 27
        Height = 13
        Caption = 'qualiti'
      end
      object ScrollBar1: TScrollBar
        Left = 8
        Top = 32
        Width = 289
        Height = 17
        Max = 5000
        Min = 10
        PageSize = 0
        Position = 1500
        TabOrder = 0
        OnChange = JvScrollBar1Change
      end
      object chk1: TCheckBox
        Left = 8
        Top = 112
        Width = 97
        Height = 17
        Caption = 'Send Captures.'
        TabOrder = 1
        OnClick = chk1Click
      end
      object ScrollBar2: TScrollBar
        Left = 8
        Top = 80
        Width = 289
        Height = 17
        Min = 10
        PageSize = 0
        Position = 50
        TabOrder = 2
        OnChange = ScrollBar2Change
      end
      object chk2: TCheckBox
        Left = 160
        Top = 112
        Width = 145
        Height = 17
        Caption = 'Save Captures to files'
        TabOrder = 3
      end
      object Button2: TButton
        Left = 48
        Top = 152
        Width = 75
        Height = 25
        Caption = 'Ping'
        TabOrder = 4
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 160
        Top = 152
        Width = 75
        Height = 25
        Caption = 'Send Single'
        TabOrder = 5
        OnClick = Button3Click
      end
      object RadioGroup1: TRadioGroup
        Left = 24
        Top = 192
        Width = 257
        Height = 105
        Caption = 'Resize Image'
        Columns = 2
        ItemIndex = 2
        Items.Strings = (
          'None'
          '32*32'
          '64*64'
          '128*128'
          '256*256'
          '512*512')
        TabOrder = 6
        OnClick = RadioGroup1Click
      end
    end
  end
  object xpmnfst1: TXPManifest
    Left = 168
    Top = 32
  end
  object pm1: TPopupMenu
    Left = 328
    Top = 40
    object ShowWindow1: TMenuItem
      Caption = 'Show Window'
      OnClick = ShowWindow1Click
    end
  end
  object CoolTrayIcon1: TCoolTrayIcon
    CycleInterval = 0
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
      FFFFFFFFF0000000FFFFFFFFFFFFFFFFFFFFFFFFF7000007FFFFFFFFFFFFFFFF
      FFFFFFFFFF00000FFFFFFFFFFFFFFFFFFFFFFFFFFFF878FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF88FFFFFFFFFFF88FFFFFFFFFFFF
      FFFFF008FFFFFFFFF800FFFFFFFFFFFFFFFF80007FFFFFFF70003FFFFFFFFFFF
      FFFFF80000778770000007FFFFFFFFFFFFFFFF83000000000387007FFFFFFFFF
      F88FFFFF870000078FFF3007FFFFFFFF8008FFFFFFFFFFFFFFFFF0008FFFFFF8
      00007FFFFFFFFFFFFFFF70008FFFFF800000008FFFFFFFFFF8700008FFFFF800
      08F7000078888888700007FFFFFF83008FFF87000000000000078FFFFF807007
      FFFFFF8870000000788FFFFFF700830078FFFFFFFF88888FFFFFFFF87000FF70
      008FFFFFFFFFFFFFFFFFFF800077FFF800038FFFFFFFFFFFFFFF830008FFFFFF
      870000788FFFFFFF887000078FFFFFFFFF870000003777300000278FFFFF78FF
      FFFFF8730000000003788FFFFFF8008FFFFFFFFF888888888FFFFFFFF8707007
      8FFFFFFFFFFFFFFFFFFFFFFF8700F8300788FFFFFFFFFFFFFFFFF8870038FF87
      30037888FFF888FFF8887300378FFFFF877000277778887773200078FFFFFFFF
      FFF8773200000000023778FFFFFFFFFFFFFFFF8888777778888FFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
    IconIndex = 0
    PopupMenu = pm1
    MinimizeToTray = True
    Left = 192
    Top = 32
  end
  object mm1: TMainMenu
    Left = 240
    Top = 32
    object Menu1: TMenuItem
      Caption = 'Menu'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Video1: TMenuItem
      Caption = 'Video'
      object StartVideo1: TMenuItem
        Caption = 'Start Video'
        OnClick = StartVideo1Click
      end
      object StopVideo1: TMenuItem
        Caption = 'Stop Video'
        Enabled = False
        OnClick = StopVideo1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object CameraOptions1: TMenuItem
        Caption = 'Camera Options'
        Enabled = False
        OnClick = CameraOptions1Click
      end
      object VideoOptions1: TMenuItem
        Caption = 'Video Options'
        Enabled = False
        OnClick = VideoOptions1Click
      end
    end
    object Net1: TMenuItem
      Caption = 'Net'
      object GetMyIp1: TMenuItem
        Caption = 'Get My Ip'
        OnClick = GetMyIp1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object StartServer1: TMenuItem
        Caption = 'Start Server'
        OnClick = StartServer1Click
      end
      object StopServer1: TMenuItem
        Caption = 'Stop Server'
        Enabled = False
        OnClick = StopServer1Click
      end
    end
  end
  object tmr1: TTimer
    Enabled = False
    OnTimer = tmr1Timer
    Left = 592
    Top = 48
  end
  object server: TUDPJServer
    OnError = serverError
    OnData = serverData
    Left = 168
    Top = 120
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 713
    Top = 72
  end
end
