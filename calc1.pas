unit calc1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fpexprpars, LclIntf, Grids, ExtCtrls, Windows, simpleipc, ShellAPI, XMLConf,
  Messages, LMessages;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    XMLConfig1: TXMLConfig;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
//    procedure FormMove(var Msg: TMessage); message WM_MOVE;
    procedure WMMove(var Message: TLMMove); message LM_MOVE;
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
  ShowEq: Boolean;
  SS: TSimpleIPCServer;
  ConfigFileName: String;


procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
var
  FParser: TFPExpressionParser;
  parserResult: TFPExpressionResult;
  resultValue: Double;
  i: Integer;
  Str: String;
  Int: Integer;
begin
  if (Key = char(VK_ESCAPE)) then
//    Application.Terminate;
    Application.Minimize;
//    Form1.WindowState := wsNormal;
  if (Key = char(13)) then begin
    FParser := TFPExpressionParser.Create(nil);
    try
      if(pos('=', Edit1.Text) > 0) then begin
        Str := Edit1.Text;
        Int := pos('=', Str);
        Delete(Str, 1, Int);
        Edit1.Text := Str;
        Edit1.SelStart := Length(Str);
      end else begin
        FParser.Builtins := [bcMath];
        FParser.Expression := Edit1.Caption;
        parserResult := FParser.Evaluate;   // or: FParser.EvaluateExpression(parserResult);
        resultValue := ArgToFloat(parserResult);
        ShowEq := True;
        if(StringGrid1.Cells[0, 0] <> '') then
          StringGrid1.RowCount := StringGrid1.RowCount + 1;
        for i := StringGrid1.RowCount-1 downto 1 do begin
          StringGrid1.Cells[0, i] := StringGrid1.Cells[0, i-1];
        end;
        StringGrid1.Cells[0, 0] := Edit1.Caption;
        Edit1.Caption := Edit1.Caption + '=' + FloatToStr(resultValue);
      end;
    finally
      FParser.Free;
    end;
    StringGrid1.ColWidths[0] := StringGrid1.ClientWidth;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ShowEq := False;
  StringGrid1.ColWidths[0] := StringGrid1.Width-4;
  SS.StartServer;

//  Form1.Top := XMLConfig1.GetValue('/form_top', 0);
//  Form1.Left := XMLConfig1.GetValue('/form_left', 0);
//  Form1.Width := XMLConfig1.GetValue('/form_width', 0);
//  Form1.Height := XMLConfig1.GetValue('/form_height', 0);
end;

//procedure TForm1.FormMove(var msg: TMessage);
//begin
procedure TForm1.WMMove(var Message: TLMMove);
begin
//  inherited;
  inherited WMMove(Message);
  XMLConfig1.SetValue('/form_top', IntToStr(Form1.Top));
  XMLConfig1.SetValue('/form_left', IntToStr(Form1.Left));
  XMLConfig1.SetValue('/form_width', IntToStr(Form1.Width));
  XMLConfig1.SetValue('/form_height', IntToStr(Form1.Height));
  XMLConfig1.Flush;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SS := TSimpleIPCServer.Create(self);
  SS.ServerID := 'SServer';
  SS.Global := True;
  SS.StartServer;

  ConfigFileName := 'calc_config.xml';
  XMLConfig1.Filename := ConfigFileName;

//  if(FileExists(ConfigFileName)) then begin
  if(FileExists(XMLConfig1.Filename)) then begin
    if(XMLConfig1.GetValue('/form_top', -1) > 0) then begin
      Form1.Top := XMLConfig1.GetValue('/form_top', 0);
      Form1.Left := XMLConfig1.GetValue('/form_left', 0);
//      Form1.Top := 50;
//      Form1.Left := 500;
      Form1.Width := XMLConfig1.GetValue('/form_width', 0);
      Form1.Height := XMLConfig1.GetValue('/form_height', 0);
    end;
//  end else begin
//      XMLConfig1.Filename := 'calc_config';
//      XMLConfig1.SetValue('/form_top', IntToStr(Form1.Top));
//      XMLConfig1.SetValue('/form_left', IntToStr(Form1.Left));
//      XMLConfig1.SetValue('/form_width', IntToStr(Form1.Width));
//      XMLConfig1.SetValue('/form_height', IntToStr(Form1.Height));
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SS.StopServer;
  SS.Free;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
  Str: String;
  Int: Integer;
  Cur: Integer;
begin
  if((pos('=', Edit1.Text) > 0) and not ShowEq) then begin
    Cur := Edit1.SelStart;
    Str := Edit1.Text;
    Int := pos('=', Str);
    SetLength(Str, Int-1);
    Edit1.Text := Str;
    Edit1.SelStart := Cur;
  end;
  ShowEq := False;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  StringGrid1.ColWidths[0] := StringGrid1.ClientWidth-4;
//  XMLConfig1.Filename := ConfigFileName;
  XMLConfig1.SetValue('/form_top', IntToStr(Form1.Top));
  XMLConfig1.SetValue('/form_left', IntToStr(Form1.Left));
  XMLConfig1.SetValue('/form_width', IntToStr(Form1.Width));
  XMLConfig1.SetValue('/form_height', IntToStr(Form1.Height));
  XMLConfig1.Flush;
end;

procedure TForm1.FormShow(Sender: TObject);
  //* Uses ShellAPI
  function IsTaskbarAutoHideOn: Boolean;
  var
    ABData: TAppBarData;
  begin
    ABData.cbSize := SizeOf(ABData);
//     Result := (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_AUTOHIDE) > 0;
     Result := False;
  end;

  function TaskBarHeight: integer;
  var
    hTB: HWND; // taskbar handle
    TBRect: TRect; // taskbar rectangle
  begin
    hTB:= FindWindow('Shell_TrayWnd', '');
    if hTB = 0 then
      Result := 0
    else begin
      GetWindowRect(hTB, TBRect);
      Result := TBRect.Bottom - TBRect.Top;
    end;
  end;

begin
  //* This code will force the window to the lower right corner of the screen
  //* taking into account if the user autohides the taskbar or not.
//  Form1.Left := (Screen.Width - Form1.Width);

  if IsTaskbarAutoHideOn then
//    Form1.Top := (Screen.Height - Form1.Height)
  else
//    Form1.Top := (Screen.Height - Form1.Height) - TaskBarHeight;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
//  if Form1.WindowState = wsMinimized then
//    Form1.Hide
//  else
////  if Form1.WindowState = wsNormal then
//    Form1.Show;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  Edit1.Text := StringGrid1.Cells[0, StringGrid1.Row];
  Form1.ActiveControl := Edit1;
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if (Key = char(13)) then begin
    Edit1.Text := StringGrid1.Cells[0, StringGrid1.Row];
    Form1.ActiveControl := Edit1;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if(SS.PeekMessage(100, True)) then begin
    Application.Restore;
    Form1.Show;
    Form1.WindowState := wsNormal;
    Form1.FormStyle := fsStayOnTop;
Form1.SetFocus;
  end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Application.Restore;
  Form1.Show;
  Form1.WindowState := wsNormal;
//  Form1.FormStyle := fsStayOnTop;
end;

end.

