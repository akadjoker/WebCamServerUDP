unit MainForm;


    {APPTYPE CONSOLE}

interface



uses
  Windows, Messages, Classes, Graphics, Controls, Forms,jpeg,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ShellAPI, sysutils,
  VFrames, ExtDlgs, ShellAnimations, ExtCtrlsX, DialogsX, XPMan, Menus,
  CoolTrayIcon, ScktComp, WinSock, WSockets,IniFiles;

type

TClient=record
SockAddrIn: TSockAddrIn;
socket:Integer;
end;


  TForm1 = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    xpmnfst1: TXPManifest;
    pm1: TPopupMenu;
    ShowWindow1: TMenuItem;
    CoolTrayIcon1: TCoolTrayIcon;
    bvl1: TBevel;
    img1: TImage;
    mm1: TMainMenu;
    Menu1: TMenuItem;
    Exit1: TMenuItem;
    Video1: TMenuItem;
    StartVideo1: TMenuItem;
    StopVideo1: TMenuItem;
    N1: TMenuItem;
    CameraOptions1: TMenuItem;
    VideoOptions1: TMenuItem;
    pnl1: TPanel;
    pnl2: TPanel;
    mmo1: TMemo;
    Net1: TMenuItem;
    GetMyIp1: TMenuItem;
    N2: TMenuItem;
    StartServer1: TMenuItem;
    StopServer1: TMenuItem;
    grp1: TGroupBox;
    ScrollBar1: TScrollBar;
    lbl1: TLabel;
    chk1: TCheckBox;
    tmr1: TTimer;
    lbl2: TLabel;
    ScrollBar2: TScrollBar;
    chk2: TCheckBox;
    Log: TLabel;
    Button2: TButton;
    Button3: TButton;
    RadioGroup1: TRadioGroup;
    server: TUDPJServer;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn_PropertiesClick(Sender: TObject);
    procedure BitBtn_StreamPropClick(Sender: TObject);
    procedure BitBtn_SaveBMPClick(Sender: TObject);
    procedure ShowWindow1Click(Sender: TObject);
    procedure StartVideo1Click(Sender: TObject);
    procedure StopVideo1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure CameraOptions1Click(Sender: TObject);
    procedure VideoOptions1Click(Sender: TObject);
    procedure GetMyIp1Click(Sender: TObject);
    procedure StartServer1Click(Sender: TObject);
    procedure StopServer1Click(Sender: TObject);
    procedure JvScrollBar1Change(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bPingClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure serverError(Sender: TObject; Error: Integer; Msg: String);
    procedure serverData(Sender: TObject; Socket: Integer);
    procedure Timer1Timer(Sender: TObject);


  private
    { Private declarations }
    fActivated  : boolean;
    fVideoImage : TVideoImage;
    fVideoBitmap: TBitmap;
    procedure OnNewVideoFrame(Sender : TObject; Width, Height: integer; DataPtr: pointer);
    procedure OnDeviceChange(VAR Msg: TMessage); message WM_DEVICECHANGE;
  public
      FStream: TMemoryStream;
    { Public declarations }
  end;

var
  Form1: TForm1;
  videoStart:Boolean=False;
  serverStart:Boolean=False;
  CompressionQuality:Integer=10;
  numCaptures:Integer=0;
  serverport:integer=1478;

 MTYPE:Integer=100;

 MTYPEPING:integer=101;
 MTYPEPONG:integer=102;

 MTYPECONFIG:integer=200;
 MTYPEIMAGE:integer=300;
 MTYPECAMERA:integer=103;

 MTYPECLOSE:integer=501;
 MTYPEBEGIN:integer=500;


 client:TClient;

 startTime:DWORD=0;

 // webClient: TSimpleTCPClient;

    maxWidth :integer;
   maxHeight :integer;

   configmudado:Boolean=False;


implementation

{$R *.dfm}

procedure sendPack(stm:TMemoryStream);
var

  i:Integer;
begin
  if  not serverStart then Exit;
  if (stm.Size> form1.server.MaxUDPSize) then Exit;

  if (client.socket<=0) then Exit;
  Form1.server.SendStreamTo(client.socket,stm,client.SockAddrIn);
end;



function WriteBuffer(m_file:TMemoryStream; const buffer; bufferSize: LongWord) : integer;
begin
   try
     Result:=m_file.Write(buffer, bufferSize);
   except
     result := 0;
   end;
end;
function WriteByte(m_file:TMemoryStream; value: integer) : integer;
begin
   WriteBuffer(m_file,value, 1);
   Result:=1;
end;

function writeShort(m_file:TMemoryStream; v: byte) : integer;
begin
  WriteByte(m_file, (v shr 8) and $ff);
  WriteByte(m_file, (v shr 0) and $ff);
  Result:=2;
end;

function writeChar(m_file:TMemoryStream; v: integer) : integer;
begin
  WriteByte(m_file, (v shr 8) and $ff);
  WriteByte(m_file, (v shr 0) and $ff);
  Result:=4;
end;
function writeInt(m_file:TMemoryStream; v: integer) : boolean;
begin
  WriteByte(m_file, (v shr 24) and $ff);
  WriteByte(m_file, (v shr 16) and $ff);
  WriteByte(m_file, (v shr 8) and $ff);
  WriteByte(m_file, (v shr 0) and $ff);
  Result:=True;
end;

//*******************************
function ReadBuffer(m_file:TMemoryStream;var buffer; bufferSize: LongWord) : integer;
begin
   try
   Result:=     m_file.Read(buffer, bufferSize);
    except
     result := 0;
   end;
end;







function WriteString(m_file:TMemoryStream;data:String):integer;
var
  i:Integer;
   len: cardinal;
   oString: UTF8String;
begin
  // oString := UTF8String(data);
   //len := length(oString);
    data:=Trim(data);
    len:=Length(data);
    writeInt(m_file,len);
    for i:=1 to  len do
    WriteBuffer(m_file,data[i], 1);
  //  writeChar(m_file,Ord(data[i]));
   //if len > 0 then
   //WriteBuffer(m_file,oString[1], len);
end;




function readByte(m_file:TMemoryStream):byte;
var
  ch:integer;
begin
   ReadBuffer(m_file,ch, 1);
   Result:=Byte(ch);
end;

function readInt(m_file:TMemoryStream):integer;
var
  ch1,ch2,ch3,ch4:Integer;
begin
  ch1:=ReadByte(m_file);
  ch2:=ReadByte(m_file);
  ch3:=ReadByte(m_file);
  ch4:=ReadByte(m_file);
  Result:=((ch1 shl 24) + (ch2 shl 16) + (ch3 shl 8) + (ch4 shl 0));
end;
function readChar(m_file:TMemoryStream):char;
var
  ch1,ch2:Integer;
begin
  ch1:=ReadByte(m_file);
  ch2:=ReadByte(m_file);
  Result:=char( (ch1 shl 8) + (ch2 shl 0));
end;
function readShort(m_file:TMemoryStream):Smallint;
var
  ch1,ch2:Integer;
begin
  ch1:=ReadByte(m_file);
  ch2:=ReadByte(m_file);
  Result:=Smallint( (ch1 shl 8) + (ch2 shl 0));
end;

function ReadString(m_file:TMemoryStream):string;
var
   len: cardinal;
   iString: UTF8String;
begin
   len:=readInt(m_file);
   if len > 0 then
   begin
      setLength(iString, len);
      ReadBuffer(m_file,iString[1], len);
      result := string(iString);
   end;
end;
procedure sendConfig;
var
  str:TMemoryStream;
  b:Byte;
begin
    if  not serverStart then Exit;
    str:=TMemoryStream.Create();
    WriteInt(str, MTYPECONFIG);
    WriteInt(str,form1.ScrollBar1.Position); //delay
    WriteInt(str,form1.ScrollBar2.Position);//compres
    WriteInt(str,form1.RadioGroup1.ItemIndex);//imagesize

    sendPack(str);
    str.Destroy;
end;

procedure sendImage;
var
  str:TMemoryStream;
  b:Byte;
begin
    if  not serverStart then Exit;
    str:=TMemoryStream.Create();
    WriteInt(str,MTYPEIMAGE);
    sendPack(str);
    str.Destroy;
end;



procedure sendClose;
var
  str:TMemoryStream;
  b:Byte;
begin
    if  not serverStart then Exit;
    str:=TMemoryStream.Create();
    WriteInt(str,MTYPECLOSE); 
    sendPack(str);
    str.Destroy;
end;
procedure Ping;
var
  str:TMemoryStream;
  b:Byte;
begin
    if  not serverStart then Exit;
    str:=TMemoryStream.Create();
    WriteInt(str,MTYPEPING);  //ping
    sendPack(str);
   str.Destroy;
end;

procedure Pong;
var
  str:TMemoryStream;
  b:Byte;
begin
    if  not serverStart then Exit;
    str:=TMemoryStream.Create();
    WriteInt(str,MTYPEPONG);  //ping
    sendPack(str);
   str.Destroy;
end;



procedure msg(m:string);
begin
  Form1.mmo1.Lines.Add(m);
  end;

procedure TForm1.FormDestroy(Sender: TObject);
var
   appINI : TIniFile;
 begin
   appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
 try
      appINI.WriteInteger('Server','Port',  serverport) ;
      appINI.WriteInteger('Server','Delay', ScrollBar1.Position ) ;
      appINI.WriteInteger('Server','CompressionQuality', CompressionQuality);

   finally
     appIni.Free;
   end;

   
 if Assigned(FStream) then
  begin
    FStream.Free;
    FStream := nil;
  end;

  
if(videoStart) then
begin


  FVideoImage.VideoStop;

  end;

if(serverStart) then

begin
    sendClose();

server.Close;
end;
end;



procedure TForm1.FormCreate(Sender: TObject);
var
   IniFile : TIniFile;
 begin
   iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
   try
     serverport:=iniFile.ReadInteger('Server','Port', 1478) ;
     ScrollBar1.Position := iniFile.ReadInteger('Server','Delay', 1000) ;
     CompressionQuality := iniFile.ReadInteger('Server','CompressionQuality', 50);
   finally
     iniFile.Free;
   end;

  fActivated      := false;
  fVideoBitmap    := TBitmap.create;
  fVideoImage     := TVideoImage.Create;
//  bPing.Enabled:=False;
  fVideoImage.OnNewVideoFrame := OnNewVideoFrame;
  img1.Canvas.Brush.Color:=clBlack;
  img1.Canvas.FillRect(img1.ClientRect);
  img1.Canvas.Brush.Color:=clred;
  img1.Canvas.Pen.Color:=clRed;
  img1.Canvas.MoveTo(0,0);
  img1.Canvas.LineTo(img1.Width,img1.Height);
  img1.Canvas.MoveTo(img1.Width,0);
  img1.Canvas.LineTo(0,img1.Height);

  lbl1.Caption:='Send Delay : '+inttostr(ScrollBar1.position)+' ms';
  CompressionQuality:=ScrollBar2.Position;
lbl2.Caption:='CompressionQuality :'+inttostr(CompressionQuality);
   grp1.Enabled:=False;
      TimeSeparator := '-';
       FStream := nil;

   msg(DateTimeToStr(now) +'  WinSocket Version: '+server.Version);
   msg(DateTimeToStr(now) + ' Max UDP Pack Size: '+inttostr(server.MaxUDPSize));
   msg(DateTimeToStr(now) +' Loacal Adress -'+ server.LocalHostAddress);
   msg(DateTimeToStr(now) +' Local Name - '+ server.LocalHostName);


end;


procedure TForm1.OnDeviceChange(VAR Msg: TMessage);
var
  DeviceList : TStringList;
  IIndex     : integer;
begin

  DeviceList := TStringList.Create;
  fVideoImage.GetListOfDevices(DeviceList);


  IIndex := ComboBox1.ItemIndex;
  Combobox1.items.Clear;
  IF (DeviceList.Count > 0) then
    begin

      Combobox1.items.Assign(DeviceList);
      IF IIndex < 0 then
        IIndex := 0;
      IF IIndex >= ComboBox1.Items.Count then
        IIndex := ComboBox1.Items.Count-1;
      Combobox1.ItemIndex := IIndex;

     StartVideo1.Enabled:=true;
    end
    else  StartVideo1.Enabled:=False;
end;


procedure TForm1.OnNewVideoFrame(Sender : TObject; Width, Height: integer; DataPtr: pointer);
var
  i, r : integer;
begin

  fVideoImage.GetBitmap(img1.Picture.Bitmap);

//  img1.Canvas.Draw(0,0,fVideoBitmap);


end;




procedure TForm1.FormActivate(Sender: TObject);
begin
  IF fActivated then
    exit;
  fActivated := true;

  PostMessage(self.Handle, WM_DeviceChange, 0, 0);
end;


procedure TForm1.BitBtn_PropertiesClick(Sender: TObject);
begin
  FVideoImage.ShowProperty;
end;


procedure TForm1.BitBtn_StreamPropClick(Sender: TObject);
begin
  FVideoImage.ShowProperty_Stream;
end;

procedure TForm1.BitBtn_SaveBMPClick(Sender: TObject);
VAR
  BMP : TBitmap;
begin
  {
  BMP := TBitmap.Create;
  BMP.Assign(fVideoBitmap);
  IF SavePictureDialog1.Execute then
    begin
      try
        // Will not save the flipping. Sorry, I'm a lazy guy...
        BMP.SaveToFile(SavePictureDialog1.FileName);
      except
        MessageDlg('Could not save file ' + SavePictureDialog1.FileName + '!', mterror, [mbOK], 0);
      end;
    end;
  BMP.Free;
  }
end;

procedure TForm1.ShowWindow1Click(Sender: TObject);
begin
self.Show;
end;

procedure TForm1.StartVideo1Click(Sender: TObject);
begin
  if( not videoStart) then
begin
   StopVideo1.Enabled:=True;
   StartVideo1.Enabled:=false;
   CameraOptions1.Enabled:=True;
   VideoOptions1.Enabled:=True;
 img1.Canvas.Brush.Color:=clBlack;
  img1.Canvas.FillRect(img1.ClientRect);
  img1.Canvas.Pen.Color:=clRed;
  img1.Canvas.Brush.Color:=cllime;
  img1.Canvas.TextOut(20,20 ,'Loading ...');
  videoStart:=True;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  fVideoImage.VideoStart(ComboBox1.Items[ComboBox1.itemindex]);
  Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.StopVideo1Click(Sender: TObject);
begin
if(videoStart) then
begin

   StopVideo1.Enabled:=false;
   StartVideo1.Enabled:=true;
    CameraOptions1.Enabled:=false;
   VideoOptions1.Enabled:=false;
      img1.Canvas.Brush.Color:=clBlack;
  img1.Canvas.FillRect(Rect(0,0,Width,Height));
  FVideoImage.VideoStop;
  videoStart:=False;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin

if(videoStart) then
begin
  FVideoImage.VideoStop;
end;
close;
end;

procedure TForm1.CameraOptions1Click(Sender: TObject);
begin
FVideoImage.ShowProperty;
end;

procedure TForm1.VideoOptions1Click(Sender: TObject);
begin
  FVideoImage.ShowProperty_Stream;
end;

procedure TForm1.GetMyIp1Click(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'http://www.whatismyip.com',nil,nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StartServer1Click(Sender: TObject);
begin
if(not serverStart)  then
begin

   server.Port:=IntToStr(serverport);
   server.Open();

   RadioGroup1Click(Self);

   grp1.Enabled:=True;
   StartServer1.Enabled:=false;
   StopServer1.Enabled:=True;
   serverStart:=True;

   msg(DateTimeToStr(now) + ' Server started ');








//   msg('Client :('+server.SockAddrInToName(client.SockAddrIn)+','+server.SockAddrInToAddress(client.SockAddrIn)+')  connect.');

//   msg(DateTimeToStr(now) +' - '+SimpleTCPServer1.LocalHostName);
//   msg(DateTimeToStr(now) +' - '+SimpleTCPServer1.LocalIP);

end;
end;

procedure TForm1.StopServer1Click(Sender: TObject);
begin
if(serverStart) then

begin
  mmo1.Lines.Clear;
  msg(DateTimeToStr(now) + ' Server stopped ');
  sendClose();
server.Close;

  StartServer1.Enabled:=True;
  StopServer1.Enabled:=False;
  grp1.Enabled:=false;
  serverStart:=False;
end;
end;

procedure TForm1.JvScrollBar1Change(Sender: TObject);
begin
lbl1.Caption:='Send Delay : '+inttostr(ScrollBar1.position)+' ms';
self.tmr1.Interval:=ScrollBar1.Position;
configmudado:=True;
end;

procedure TForm1.chk1Click(Sender: TObject);
begin

if (serverStart ) then
begin
  self.tmr1.Enabled:=chk1.Checked;
  self.tmr1.Interval:=ScrollBar1.Position;
end else
begin
  self.tmr1.Enabled:=false;
end;
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
CompressionQuality:=ScrollBar2.Position;
lbl2.Caption:='CompressionQuality :'+inttostr(CompressionQuality);
     configmudado:=True;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
var
  FilePath : String;
  MyJPEG : TJPEGImage;
  ErrMsg: string;

  str:TMemoryStream;
  imgstr:TMemoryStream;
  b:Byte;
  
   thumbnail : TBitmap;
   thumbRect : TRect;
begin
    if  not serverStart then Exit;

if (  Self.chk1.Checked) then
begin
  //FilePath := ExtractFilePath(ParamStr(0)+'capture_'+inttostr(numCaptures)+'_.jpeg');
  FilePath := ExtractFilePath(ParamStr(0))+'images\capture_('+inttostr(numCaptures)+')_'+TimetoStr(Time())+'.jpeg';

  MyJPEG := TJPEGImage.Create;
  MyJPEG.CompressionQuality := CompressionQuality;


  if (RadioGroup1.ItemIndex=0) then
  begin

        MyJPEG.Assign(img1.Picture.Bitmap);

  end else
  begin


   thumbnail := TBitmap.Create;
   thumbnail.Assign(img1.Picture.Bitmap);

   try
     thumbRect.Left := 0;
     thumbRect.Top := 0;
     if thumbnail.Width > thumbnail.Height then
     begin
       thumbRect.Right := maxWidth;
       thumbRect.Bottom := (maxWidth * thumbnail.Height) div thumbnail.Width;
     end
     else
     begin
       thumbRect.Bottom := maxHeight;
       thumbRect.Right := (maxHeight * thumbnail.Width) div thumbnail.Height;
     end;

     thumbnail.Canvas.StretchDraw(thumbRect, thumbnail) ;
     thumbnail.Width := thumbRect.Right;
     thumbnail.Height := thumbRect.Bottom;
      MyJPEG.Assign( thumbnail) ;
   finally
     thumbnail.Free;
   end;
  end;


//  MyJPEG.Assign(     img1.Picture.Bitmap);
  if (chk2.Checked) then
  begin
  MyJPEG.SaveToFile(FilePath); // Salva o JPG no diretório
   end;

    imgstr:=TMemoryStream.Create();
    MyJPEG.SaveToStream(imgstr);
    str:=TMemoryStream.Create();
    WriteInt(str,MTYPEIMAGE);
    WriteInt(str,imgstr.Size);
    imgstr.SaveToStream(str);
    sendPack(str);
    str.Destroy;
    imgstr.Destroy;


 //Caption:=FilePath;
  Inc(numCaptures);
  MyJPEG.Free;
end;


end;






{
procedure TForm1.SimpleTCPServer1ClientRead(Sender: TObject; Client: TSimpleTCPClient; Stream: TStream);
var
  buffer:array[0..255]of Char;
 len, msgType:Integer;
 estimatedTime:DWORD;
enable,index, time:Integer;
begin
//msg('Size of pack:'+inttostr(stream.Size));


msgType:= readInt(stream);  //id
//msg('MSG TYPE:'+inttostr(  msgType));

if (msgType=MTYPEPING) then
begin
    msg('Client PING you... send PONG.');
    Pong();
end else

if (msgType=MTYPEPONG) then
begin
 estimatedTime := GetTickCount -startTime;
msg('PONG ('+inttostr(estimatedTime)+'.ms) Delay');


end else
if (msgType=MTYPEDELAY) then
begin
  time:= readInt(stream);  //id
  ScrollBar1.position:=time;

  lbl1.Caption:='Send Delay : '+inttostr(ScrollBar1.position)+' ms';
self.tmr1.Interval:=ScrollBar1.Position;


end else
if (msgType=MTYPECOMPRESS) then
begin
CompressionQuality:= readInt(stream);
ScrollBar2.Position:=CompressionQuality ;
lbl2.Caption:='CompressionQuality :'+inttostr(CompressionQuality);
end else
if (msgType= MTYPESIZE) then
begin
index:= readInt(stream);
RadioGroup1.ItemIndex:=index;
RadioGroup1Click(Self);
end
 else
 if (msgType= MTYPECAMERA) then
begin
enable:= readInt(stream);

if (enable=1) then
begin
self.chk1.Checked:=True;
tmr1.Enabled:=true;
tmr1.Interval:=ScrollBar1.Position;
StartVideo1Click(Self);

end
else
begin
chk1.Checked:=False;
tmr1.Enabled:=false;
StopVideo1Click(Self);
end;

//chk1Click(Self);

end else
begin
  //que tipo de msg???
end;






end;
}

procedure TForm1.bPingClick(Sender: TObject);
begin

Ping();
startTime:=GetTickCount;
end;



procedure TForm1.Button1Click(Sender: TObject);
var
  FilePath : String;
  MyJPEG : TJPEGImage;
  ErrMsg: string;



   thumbnail : TBitmap;
   thumbRect : TRect;
   maxWidth :integer;
   maxHeight :integer;


  str:TMemoryStream;
  imgstr:TMemoryStream;
  b:Byte;
begin
   // if  not serverStart then Exit;

   maxWidth := 128;
   maxHeight := 128;


  MyJPEG := TJPEGImage.Create;
  MyJPEG.CompressionQuality := CompressionQuality;
//  MyJPEG.Assign(     img1.Picture.Bitmap);

   thumbnail := TBitmap.Create;
      thumbnail.Assign(img1.Picture.Bitmap);

//  thumbnail := img1.Picture.Bitmap;
   try
     thumbRect.Left := 0;
     thumbRect.Top := 0;
     if thumbnail.Width > thumbnail.Height then
     begin
       thumbRect.Right := maxWidth;
       thumbRect.Bottom := (maxWidth * thumbnail.Height) div thumbnail.Width;
     end
     else
     begin
       thumbRect.Bottom := maxHeight;
       thumbRect.Right := (maxHeight * thumbnail.Width) div thumbnail.Height;
     end;

     thumbnail.Canvas.StretchDraw(thumbRect, thumbnail) ;

//resize image
     thumbnail.Width := thumbRect.Right;
     thumbnail.Height := thumbRect.Bottom;
 
     //display in a TImage control
    MyJPEG.Assign( thumbnail) ;
   finally
     thumbnail.Free;
   end;


    MyJPEG.SaveToFile('save.jpeg');
    MyJPEG.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Ping();
startTime:=GetTickCount;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  FilePath : String;
  MyJPEG : TJPEGImage;
  ErrMsg: string;



   thumbnail : TBitmap;
   thumbRect : TRect;


  str:TMemoryStream;
  imgstr:TMemoryStream;
  b:Byte;
begin
    if  not serverStart then Exit;


  MyJPEG := TJPEGImage.Create;
  MyJPEG.CompressionQuality := CompressionQuality;


  if (RadioGroup1.ItemIndex=0) then
  begin

        MyJPEG.Assign(img1.Picture.Bitmap);

  end else
  begin


   thumbnail := TBitmap.Create;
   thumbnail.Assign(img1.Picture.Bitmap);

   try
     thumbRect.Left := 0;
     thumbRect.Top := 0;
     if thumbnail.Width > thumbnail.Height then
     begin
       thumbRect.Right := maxWidth;
       thumbRect.Bottom := (maxWidth * thumbnail.Height) div thumbnail.Width;
     end
     else
     begin
       thumbRect.Bottom := maxHeight;
       thumbRect.Right := (maxHeight * thumbnail.Width) div thumbnail.Height;
     end;

     thumbnail.Canvas.StretchDraw(thumbRect, thumbnail) ;
     thumbnail.Width := thumbRect.Right;
     thumbnail.Height := thumbRect.Bottom;
      MyJPEG.Assign( thumbnail) ;
   finally
     thumbnail.Free;
   end;
  end;

    imgstr:=TMemoryStream.Create();
    MyJPEG.SaveToStream(imgstr);
    str:=TMemoryStream.Create();
    WriteInt(str,MTYPEIMAGE);
    WriteInt(str,imgstr.Size);
    imgstr.SaveToStream(str);
    sendPack(str);
    str.Destroy;
    imgstr.Destroy;

  //  MyJPEG.SaveToFile('save.jpeg');
    MyJPEG.Free;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
case RadioGroup1.ItemIndex of
1:
begin
     maxWidth  :=32;
     maxHeight :=32;
end;
2:
begin
     maxWidth  :=64;
     maxHeight :=64;
end;
3:
begin
     maxWidth  :=128;
     maxHeight :=128;
end;
4:
begin
     maxWidth  :=256;
     maxHeight :=256;
end;
5:
begin
     maxWidth  :=512;
     maxHeight :=512;
end;





end;
sendConfig;
end;

procedure TForm1.serverError(Sender: TObject; Error: Integer; Msg: String);
begin
self.mmo1.Lines.Add('Server error : '+msg);
end;

procedure TForm1.serverData(Sender: TObject; Socket: Integer);
var
  Stream:TMemoryStream;
 buffer:array[0..255]of Char;
 len, msgType:Integer;
 ch:byte;
 estimatedTime:DWORD;
enable,index,i, time:Integer;
packsize:Integer;
ms:string[255];
begin




    Stream:=TMemoryStream.Create;
    client.socket:=socket;

// self.mmo1.Lines.Add(  server.Read(client.socket,client.SockAddrIn));





//packsize:=    server.ReadBuffer(client.socket,Stream.Memory,1024,client.SockAddrIn);


packsize:=  server.ReceiveStreamFrom(client.socket,Stream,client.SockAddrIn);
//server.Write(client.socket,'ola',client.SockAddrIn);



//msg('Size of pack:'+inttostr(stream.Size));






if (packsize<=0) then
begin
Stream.Destroy;
Exit;
end;




msgType:= readInt(stream);  //id
//msg('MSG TYPE:'+inttostr(  msgType));

if (msgType=MTYPEBEGIN) then
begin


msg('Client :('+server.SockAddrInToName(client.SockAddrIn)+','+server.SockAddrInToAddress(client.SockAddrIn)+')  connect.');


end else
if (msgType=MTYPECLOSE) then
begin


msg('Client :('+server.SockAddrInToName(client.SockAddrIn)+','+server.SockAddrInToAddress(client.SockAddrIn)+')  disconnect.');


end else

if (msgType=MTYPEPING) then
begin
    msg('Client PING you... send PONG.');
    Pong();
end else

if (msgType=MTYPEPONG) then
begin
 estimatedTime := GetTickCount -startTime;
msg('PONG ('+inttostr(estimatedTime)+'.ms) Delay');


end else
if (msgType= MTYPECONFIG) then
begin
  time:= readInt(stream);  //id

  //delay
    ScrollBar1.position:=time;
    lbl1.Caption:='Send Delay : '+inttostr(ScrollBar1.position)+' ms';
    self.tmr1.Interval:=ScrollBar1.Position;

        //compres
CompressionQuality:= readInt(stream);
ScrollBar2.Position:=CompressionQuality ;
lbl2.Caption:='CompressionQuality :'+inttostr(CompressionQuality);

//image size
index:= readInt(stream);
RadioGroup1.ItemIndex:=index;
RadioGroup1Click(Self);

end
 else
 if (msgType= MTYPECAMERA) then
begin
enable:= readInt(stream);

if (enable=1) then
begin
self.chk1.Checked:=True;
tmr1.Enabled:=true;
tmr1.Interval:=ScrollBar1.Position;
StartVideo1Click(Self);

end
else
begin
chk1.Checked:=False;
tmr1.Enabled:=false;
StopVideo1Click(Self);
end;

//chk1Click(Self);

end else
begin
// msg('Unknow Message'); //que tipo de msg???
 //Stream.Read(buffer,packsize);
 msg('Unknow Message:'+server.Read(client.socket,client.SockAddrIn));
 server.Write(client.socket,'Hello client ',client.SockAddrIn);
end;




    Stream.Destroy;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if(configmudado) then
begin
  configmudado:=False;
    sendConfig;
end;
       end;
end.
