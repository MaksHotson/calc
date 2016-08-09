program calc;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, SysUtils, Windows, LCLIntf, // this includes the LCL widgetset
  Forms, calc1
  { you can add units after this };

{$R *.res}
var
  k, wnd: Integer;
begin
  CreateMutex(nil, false, 'HotsonCalcMute201608071256');
  k := GetLastError();
  if ((k = ERROR_ALREADY_EXISTS) or (k = ERROR_ACCESS_DENIED)) then
  begin
    //ищем окно (главную форму) по названию класса окна
    wnd := FindWindow('TForm1', nil);
    if wnd <> 0 then
     //при этом первая копия будет выведена на передний план
      SendMessage(wnd, WM_GOTOFOREGROUND, 0, 0);
//      SendMessage(wnd, WM_COPYDATA, Application.Handle, Integer(@datStruct));
//      SendMessage(wnd, WM_COPYDATA, 0, 0);
    Application.Terminate;
    Exit;
  end else begin
    RequireDerivedFormResource := True;
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
end.

