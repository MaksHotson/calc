unit test_ipc_cli_u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, simpleipc;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

var
  SC: TSimpleIPCClient;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SC := TSimpleIPCClient.Create(nil);
  SC.ServerID := 'SServer';
//  SS.InstanceID := 'SServer';
  SC.Connect;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SC.SendStringMessage('QQ');
end;

end.

