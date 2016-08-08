unit test_ipc_srv_u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, simpleipc;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

//  SS: TSimpleIPCServer;

implementation

{$R *.lfm}

{ TForm1 }

var
  SS: TSimpleIPCServer;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SS := TSimpleIPCServer.Create(self);
  SS.ServerID := 'SServer';
  SS.Global := True;
  SS.StartServer;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if(SS.PeekMessage(10, True)) then
    Label1.Caption := SS.StringMessage;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SS.StopServer;
  SS.Free;
end;

end.

