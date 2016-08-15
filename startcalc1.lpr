program startcalc1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
//  cthreads,
  {$ENDIF}{$ENDIF}
//  Interfaces, // this includes the LCL widgetset
//  Forms, startcalc_unit1,
  process
  { you can add units after this };

{$R *.res}
var
  AProcess: TProcess;

begin
  AProcess := TProcess.Create(nil);
  AProcess.CommandLine := 'calc.exe';
//   AProcess.Options := [poRunSuspended, poNoConsole];
  AProcess.Options := [poNoConsole];
  AProcess.Execute;
  AProcess.Free;
//  RequireDerivedFormResource:=True;
//  Application.Initialize;
//  Application.CreateForm(TForm1, Form1);
//  Application.Run;
end.

