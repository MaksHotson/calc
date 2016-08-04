unit calc1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fpexprpars, LclIntf, Grids, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    StringGrid1: TStringGrid;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
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
  ShowEq: Boolean;

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
//  if (Key = char(27)) then
    Application.Terminate;
  if (Key = char(13)) then begin
    FParser := TFPExpressionParser.Create(nil);
    try
      if(pos('=', Edit1.Text) > 0) then begin
        Str := Edit1.Text;
        Int := pos('=', Str);
        Delete(Str, 1, Int);
//        SetLength(Str, Int-1);
        Edit1.Text := Str;
        Edit1.SelStart := Length(Str);
      end else begin
        FParser.Builtins := [bcMath];
        FParser.Expression := Edit1.Caption;
        parserResult := FParser.Evaluate;   // or: FParser.EvaluateExpression(parserResult);
        resultValue := ArgToFloat(parserResult);
        ShowEq := True;
  //      Edit1.Caption := Edit1.Caption + '=' + FloatToStr(resultValue);
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
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ShowEq := False;
  StringGrid1.ColWidths[0] := StringGrid1.Width-4;
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
  Edit1.Width := Form1.Width - 15;
  StringGrid1.Width := Form1.Width - 15;
  StringGrid1.Height := Form1.Height - 50;
  StringGrid1.ColWidths[0] := StringGrid1.Width-4;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  Edit1.Text := StringGrid1.Cells[0, StringGrid1.Row];
end;

end.

