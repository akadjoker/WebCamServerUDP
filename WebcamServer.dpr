program WebcamServer;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  VFrames in 'VFrames.pas',
  VSample in 'VSample.pas',
  Direct3D9 in 'DirectX\Direct3D9.pas',
  DirectDraw in 'DirectX\DirectDraw.pas',
  DirectShow9 in 'DirectX\DirectShow9.pas',
  DirectSound in 'DirectX\DirectSound.pas',
  DXTypes in 'DirectX\DXTypes.pas',
  UGDIPlus in 'UGDIPlus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
