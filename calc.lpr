program calc;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, calc1
  { you can add units after this }
  , simpleipc;

{$R *.res}
var
  SC: TSimpleIPCClient;

begin
  SC := TSimpleIPCClient.Create(nil);
  SC.ServerID := 'SServer';
//  SS.InstanceID := 'SServer';
  if(SC.ServerRunning) then begin
    SC.Connect;
    SC.SendStringMessage('QQ');
    Application.Terminate;
    Exit;
  end else begin
    RequireDerivedFormResource:=True;
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
end.

