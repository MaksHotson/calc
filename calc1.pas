unit calc1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, fpexprpars;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
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

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
var
  FParser: TFPExpressionParser;
  parserResult: TFPExpressionResult;
  resultValue: Double;
begin
  if (Key = char(13)) then begin
    FParser := TFPExpressionParser.Create(nil);
    try
      FParser.Builtins := [bcMath];
      FParser.Expression := Edit1.Caption;
      parserResult := FParser.Evaluate;   // or: FParser.EvaluateExpression(parserResult);
      resultValue := ArgToFloat(parserResult);
      Edit2.Caption := FloatToStr(resultValue);
    finally
      FParser.Free;
    end;
  end;
end;

end.

