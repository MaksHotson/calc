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
//  SS: TSimpleIPCServer;

begin
  SC := TSimpleIPCClient.Create(nil);
  SC.ServerID := 'SServer';
  if(SC.ServerRunning) then begin
    SC.Connect;
    SC.SendStringMessage('QQ');
    Application.Terminate;
    Exit;
  end else begin
//    SS := TSimpleIPCServer.Create(self);
//    SS.ServerID := 'SServer';
//    SS.Global := True;
//    SS.StartServer;
    RequireDerivedFormResource:=True;
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
//    SS.StopServer;
//    SS.Free;
  end;
end.

