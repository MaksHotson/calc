unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  AProcess: TProcess;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if(Form1.WindowState = wsMinimized) then
    Form1.Hide;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.Minimize;
  Form1.Hide;
end;

procedure TForm1.Button2Click(Sender: TObject);
//var
//  AProcess: TProcess;
begin
   AProcess := TProcess.Create(nil);
   AProcess.CommandLine := 'calc.exe';
//   AProcess.Options := [poRunSuspended, poNoConsole];
   AProcess.Options := [poNoConsole];
   AProcess.Execute;
   AProcess.Free;
   Application.Terminate;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  AProcess.Free;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Application.Restore;
  Form1.Show;
  Form1.WindowState := wsNormal;
end;

end.

