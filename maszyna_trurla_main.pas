//Maszyna Trurla Orszański Łukasz 141149 Rok III Wydzial Informatyki, semestr V
unit Maszyna_Trurla_Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnWykonaj: TButton;
    btnInfo: TButton;
    btnKoniec: TButton;
    btnHistoriaObliczen: TButton;
    edtLiczba1: TEdit;
    edtLiczba2: TEdit;
    edtWynik: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    mmoHistoria: TMemo;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure btnHistoriaObliczenClick(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure btnKoniecClick(Sender: TObject);
    procedure btnWykonajClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  start: Integer;
  x1, x2: Real;
  w: String;
  ex1, ey1, ex2, ey2: Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnWykonajClick(Sender: TObject);
var
  wynik, i: Integer;
  f: text;
  znaki: Array[1..10] of Char;
  losowy_ciag: string = '';
begin
  try
    x1 := StrToFloat(edtLiczba1.Text);
    x2 := StrToFloat(edtLiczba2.Text);

    if (x1 = 2) and (x2 = 2) then
       w := '7'
    else if (x1 = 2) and (x2 = 1) then
       w := '6'
    else if (x1 = 1) and (x2 = 1) then
       w := '0'
    else
    begin
      randomize();
      wynik := random(2);

      if wynik = 0 then
      begin
        randomize();
        w := FloatToStr(random(999999999));
      end
      else
      begin
        w := FloatToStr(x1*x2);
      end;
    end;
  except
    randomize();
    for i := 1 to 10 do
    begin
      znaki[i] := Chr(random(94) + 33);
    end;
    SetString(losowy_ciag, PChar(@znaki[0]), 10);
    w := losowy_ciag;
  end;

  ex1 := 117;
  ey1 := 117;
  ex2 := 117;
  ey2 := 117;
  Timer1.Interval := 100;
  Timer1.Enabled := True;
  start := 30;

  PaintBox1.Canvas.Rectangle(0,0,PaintBox1.Width,PaintBox1.Width);

  AssignFile(f, 'Maszyna Trurla.txt');
  try
    Append(f);
  except
    Rewrite(f);
  end;
  Writeln(f, x1, x2, w);
  CloseFile(f);

end;

procedure TForm1.btnInfoClick(Sender: TObject);
begin
  Application.MessageBox('Maszyna Trurla Orszański Łukasz 141149 Rok III Wydzial Informatyki, semestr V', 'Info');
end;

procedure TForm1.btnHistoriaObliczenClick(Sender: TObject);
var
  f: text;
begin
  mmoHistoria.clear;
  AssignFile(f, 'Maszyna Trurla.txt');
  try
    Reset(f);
  except
    exit;
  end;

  while not Eof(f) do
  begin
    Readln(f, x1, x2, w);
    mmoHistoria.Lines.Add(FloatToStr(x1) + ' ' + FloatToStr(x2) + ' ' + w);
  end;

  CloseFile(f);

end;

procedure TForm1.btnKoniecClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  liczba_losowa: Integer;
begin
  Dec(start);
  randomize();

  if (start mod 1 = 0) then
  begin
    liczba_losowa := random(999999999);
    edtWynik.Text := FloatToStr(liczba_losowa);

    Inc(ex1,10);
    Inc(ey1,10);
    Dec(ex2,10);
    Dec(ey2,10);
    PaintBox1.Canvas.Ellipse(ex1, ey1, ex2 ,ey2);
    PaintBox1.Canvas.Ellipse(ex1 - 10, ey1 - 10, ex2 + 10 ,ey2 + 10);
    PaintBox1.Canvas.Ellipse(ex1 - 20, ey1 - 20, ex2 + 20 ,ey2 + 20);
  end;

  if (start < 0) then begin
    Timer1.Enabled := False;
    edtWynik.Text := w;
    PaintBox1.Invalidate;
  end;
end;

end.

