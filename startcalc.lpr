program startcalc;

uses
  process;

var
  AProcess: TProcess;

begin
     AProcess := TProcess.Create(nil);
     AProcess.CommandLine := 'calc.exe';
     AProcess.Options := [poNoConsole];
     AProcess.Execute;
     AProcess.Free;
end.

