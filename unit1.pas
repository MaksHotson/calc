unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

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

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Application.Restore;
  Form1.Show;
  Form1.WindowState := wsNormal;
end;

end.

