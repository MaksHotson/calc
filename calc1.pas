unit calc1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fpexprpars, LclIntf, Grids, ExtCtrls, Windows, simpleipc, ShellAPI, XMLConf,
  LMessages;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    XMLConfig1: TXMLConfig;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
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
  str: String;
  strm: TStringStream;


procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
var
  FParser: TFPExpressionParser;
  parserResult: TFPExpressionResult;
  resultValue: Double;
  i: Integer;
  Str: String;
  Int: Integer;
begin
  if (Key = '-') or (Key = '+') or (Key = '/') or (Key = '+') then
    if(pos('=', Edit1.Text) > 0) then begin
      Str := Edit1.Text;
      Int := pos('=', Str);
      Delete(Str, 1, Int);
      Edit1.Text := Str;
      Edit1.SelStart := Length(Str);
    end;
  if (Key = ',') then
    Key := '.';
  if (Key = char(VK_ESCAPE)) then
    Form1.Hide;
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
        Edit1.Caption := Edit1.Caption + '=' + FloatToStr(resultValue);

        StringGrid1.SetFocus;
        if(StringGrid1.Cells[0, 0] <> '') then
          StringGrid1.RowCount := StringGrid1.RowCount + 1;
        for i := StringGrid1.RowCount-1 downto 1 do begin
          StringGrid1.Cells[0, i] := StringGrid1.Cells[0, i-1];
        end;
        StringGrid1.Cells[0, 0] := Edit1.Caption;

//        Edit1.SetFocus;
//        Edit1.SelStart := Length(Edit1.Text);
//        Edit1.SelLength := 0;
      end;
    finally
      FParser.Free;
    end;
    StringGrid1.ColWidths[0] := StringGrid1.ClientWidth;
    Edit1.SetFocus;
    Edit1.SelStart := Length(Edit1.Text);
    Edit1.SelLength := 0;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ShowEq := False;
  StringGrid1.ColWidths[0] := StringGrid1.Width-4;
  SS.StartServer;
end;

procedure TForm1.WMMove(var Message: TLMMove);
begin
  inherited WMMove(Message);
  XMLConfig1.SetValue('/form_top', IntToStr(Form1.Top));
  XMLConfig1.SetValue('/form_left', IntToStr(Form1.Left));
  XMLConfig1.SetValue('/form_width', IntToStr(Form1.Width));
  XMLConfig1.SetValue('/form_height', IntToStr(Form1.Height));
  XMLConfig1.Flush;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  strm.Create(str);

  SS := TSimpleIPCServer.Create(self);
  SS.ServerID := 'SServer';
  SS.Global := True;
  SS.StartServer;

  ConfigFileName := 'calc_config.xml';
  XMLConfig1.Filename := ConfigFileName;

  if(FileExists(XMLConfig1.Filename)) then begin
    if(XMLConfig1.GetValue('/form_top', -1) > 0) then begin
      Form1.Top := XMLConfig1.GetValue('/form_top', 0);
      Form1.Left := XMLConfig1.GetValue('/form_left', 0);
      Form1.Width := XMLConfig1.GetValue('/form_width', 0);
      Form1.Height := XMLConfig1.GetValue('/form_height', 0);
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SS.StopServer;
  SS.Free;
end;

procedure TForm1.Edit1Change(Sender: TObject);
//var
//  Str: String;
//  Int: Integer;
//  Cur: Integer;
begin
//  if((pos('=', Edit1.Text) > 0) and not ShowEq) then begin
//    Cur := Edit1.SelStart;
//    Str := Edit1.Text;
//    Int := pos('=', Str);
//    SetLength(Str, Int-1);
//    Edit1.Text := Str;
//    Edit1.SelStart := Cur;
//  end;
//  ShowEq := False;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  StringGrid1.ColWidths[0] := StringGrid1.ClientWidth-4;
  XMLConfig1.SetValue('/form_top', IntToStr(Form1.Top));
  XMLConfig1.SetValue('/form_left', IntToStr(Form1.Left));
  XMLConfig1.SetValue('/form_width', IntToStr(Form1.Width));
  XMLConfig1.SetValue('/form_height', IntToStr(Form1.Height));
  XMLConfig1.Flush;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if Form1.WindowState = wsMinimized then begin
    Form1.Hide;
  end else begin
    Form1.Show;
  end;
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
var
  str1: String;
begin
  if(SS.PeekMessage(10, True)) then begin
    str1 := SS.StringMessage;
    Application.Restore;
    Form1.Show;
    Form1.WindowState := wsNormal;
    Form1.SetFocus;
  end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Application.Restore;
  Form1.Show;
  Form1.WindowState := wsNormal;
end;

end.

