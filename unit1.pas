//Hasla Orszański Łukasz 141149 Rok III Wydzial Informatyki, semestr V
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnSprawdz: TButton;
    btnZapisz: TButton;
    btnOdgadnij: TButton;
    btnInfo: TButton;
    btnKoniec: TButton;
    cbxWielkieLitery: TCheckBox;
    cbxMaleLitery: TCheckBox;
    cbxCyfry: TCheckBox;
    cbxZnakiSpecjalne: TCheckBox;
    cbxZnakiDiakrytyczne: TCheckBox;
    cbxPokazHaslo: TCheckBox;
    edtZnakiDiakrytyczne: TEdit;
    edtHaslo: TEdit;
    edtDlugosc: TEdit;
    edtWielkieLitery: TEdit;
    edtMaleLitery: TEdit;
    edtCyfry: TEdit;
    edtZnakiSpecjalne: TEdit;
    edtCzas: TEdit;
    edtLiczbaProb: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lblHaslo: TLabel;
    lblDlugosc: TLabel;
    lblCzas: TLabel;
    lblLiczbaProb: TLabel;
    lblWyniki: TLabel;
    mmoWyniki: TMemo;
    Timer1: TTimer;
    procedure btnInfoClick(Sender: TObject);
    procedure btnKoniecClick(Sender: TObject);
    procedure btnOdgadnijClick(Sender: TObject);
    procedure btnSprawdzClick(Sender: TObject);
    procedure cbxCyfryChange(Sender: TObject);
    procedure cbxMaleLiteryChange(Sender: TObject);
    procedure cbxWielkieLiteryChange(Sender: TObject);
    procedure cbxZnakiDiakrytyczneChange(Sender: TObject);
    procedure cbxZnakiSpecjalneChange(Sender: TObject);
    procedure cbxPokazHasloChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    haslo: string;

  public

  end;

  TSArray = array of String;

var
  Form1: TForm1;
  wielkieLitery: array[0..25] of String = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
  maleLitery: array[0..25] of String = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
  znakiDiakrytyczne: array[0..17] of String = ('Ą', 'Ć', 'Ę', 'Ł', 'Ń', 'Ó', 'Ś', 'Ź', 'Ż', 'ą', 'ć', 'ę', 'ł', 'ń', 'ó', 'ś', 'ź', 'ż');
  cyfry: array[0..9] of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
  znakiSpecjalne: array[0..31] of String = ('!', '"', '#', '$', '%', '^', '&', '',  '*', '(', ')', '+', ',', '-', '.', '/', ':', ';', '<', '>', '=', '?', '@', '[', '\', ']', '_', '`', '{', '|', '}' , '~');
  liczbaWL: Integer = 0;
  liczbaML: Integer = 0;
  liczbaC: Integer = 0;
  liczbaZS: Integer = 0;
  liczbaZD: Integer = 0;
  start: Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnSprawdzClick(Sender: TObject);
var
  dlugosc, dlugoscCorr: Integer;
  i, j, pozycja: Integer;
  liczbaWielkichLiter: Integer = 0;
  liczbaMalychLiter: Integer = 0;
  liczbaZnakowD: Integer = 0;
  liczbaZnakowSpecjalnych: Integer = 0;
  liczbaCyfr: Integer = 0;
begin
  haslo := edtHaslo.Text;
  try
    dlugosc := StrToInt(edtDlugosc.Text);

    if cbxWielkieLitery.Checked = True then
    begin
      liczbaWL := StrToInt(edtWielkieLitery.Text);
      for i := 0 to Length(wielkieLitery) - 1 do
      begin
        pozycja := 1;
        repeat
          pozycja := PosEx(wielkieLitery[i], haslo, pozycja);
          if pozycja <> 0 then
             begin
               Inc(liczbaWielkichLiter);
               Inc(pozycja);
             end;
        until pozycja = 0;
      end;
    end;

    if cbxMaleLitery.Checked = True then
    begin
      liczbaML := StrToInt(edtMaleLitery.Text);
      for i := 0 to Length(maleLitery) - 1 do
      begin
        pozycja := 1;
        repeat
          pozycja := PosEx(maleLitery[i], haslo, pozycja);
          if pozycja <> 0 then
             begin
               Inc(liczbaMalychLiter);
               Inc(pozycja);
             end;
        until pozycja = 0;
      end;
    end;

    if cbxCyfry.Checked = True then
    begin
      liczbaC := StrToInt(edtCyfry.Text);
      for i := 0 to Length(cyfry) - 1 do
      begin
        pozycja := 1;
        repeat
          pozycja := PosEx(cyfry[i], haslo, pozycja);
          if pozycja <> 0 then
             begin
               Inc(liczbaCyfr);
               Inc(pozycja);
             end;
        until pozycja = 0;
      end;
    end;

    if cbxZnakiSpecjalne.Checked = True then
    begin
      liczbaZS := StrToInt(edtZnakiSpecjalne.Text);
      for i := 0 to Length(znakiSpecjalne) - 1 do
      begin
        pozycja := 1;
        repeat
          pozycja := PosEx(znakiSpecjalne[i], haslo, pozycja);
          if pozycja <> 0 then
             begin
               Inc(liczbaZnakowSpecjalnych);
               Inc(pozycja);
             end;
        until pozycja = 0;
      end;
    end;

    if cbxZnakiDiakrytyczne.Checked = True then
       begin
         liczbaZD := StrToInt(edtZnakiDiakrytyczne.Text);
         for i := 0 to Length(znakiDiakrytyczne) - 1 do
          begin
            pozycja := 1;
            repeat
              pozycja := PosEx(znakiDiakrytyczne[i], haslo, pozycja);
              if pozycja <> 0 then
                 begin
                   Inc(liczbaZnakowD);
                   Inc(pozycja);
                 end;
            until pozycja = 0;
          end;
       end;

    //Poprawka wynikajaca z niepoprawnego dzialania funkcji length w przypadku strinow ze znakami unicode - maja dwa bajty
    dlugoscCorr := dlugosc + liczbaZD;

    j := haslo.Length;

    if dlugoscCorr <> haslo.Length then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(dlugosc) + ' znakow!'), 'Uwaga')
    else if liczbaWL <> liczbaWielkichLiter then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaWL) + ' wielkich liter!'), 'Uwaga')
    else if liczbaML <> liczbaMalychLiter then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaWL) + ' malych liter!'), 'Uwaga')
    else if liczbaC <> liczbaCyfr then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaC) + ' cyfr!'), 'Uwaga')
    else if liczbaZS <> liczbaZnakowSpecjalnych then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaZS) + ' znakow specjalnych!'), 'Uwaga')
    else if liczbaZD <> liczbaZnakowD then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaZD) + ' znakow diakrytycznych!'), 'Uwaga')
    else
        Application.MessageBox('Haslo poprawne!', 'Uwaga');


  except
    Application.MessageBox('Wprowadź wszytskie wartosci!', 'Uwaga');
  end;



  //edtDlugosc.Text := IntToStr(PosEx(wielkieZnakiDiakrytyczne[0], haslo, 6));
  {if Copy(haslo, 1, Length(Ch1)) = Ch1 then
     edtDlugosc.Text := Ch1;}
     //edtDlugosc.Text := IntToStr(liczbaCyfr);
     //edtCzas.Text := IntToStr(Length(haslo));



end;

function JoinArrays(array1, array2: TSArray): TSArray;
var
  array1Length, array2Length: SizeInt;
  i, j: Integer;
begin
  array1Length := Length(array1);
  array2Length := Length(array2);
  SetLength(array1, array1Length + array2Length);

  j := 0;

  for i := Low(array2) to High(array2) do
   begin
     array1[array1Length + j] := array2[i];
     Inc(j);
   end;

  joinArrays := array1;
end;

function CompareArrays(array1, array2: TSArray): Integer;
var
  array1Length, array2Length: SizeInt;
  i: Integer;
begin
  array1Length := Length(array1);
  array2Length := Length(array2);

  if array1Length <> array2Length then
     Exit(0)
  else
  begin
    for i := Low(array1) to High(array1) do
      begin
        if array1[i] <> array2[i] then
           Exit(0);
      end;
  end;

  Exit(1);
end;

procedure TForm1.btnOdgadnijClick(Sender: TObject);
var
  hasloWygenerowane: array of String;
  hasloWprowadzone: array of String;
  indexValue: array of Integer;
  dlugosc: SizeInt;
  zestawZnakow: TSArray;
  hasloWygenerowaneL, zestawZnakowL, index, i: Integer;
  hasloZnalezione: String = '';
  liczbaProb: Int64 = 0;
begin
  haslo := edtHaslo.Text;
  //dlugosc := StrToInt(edtDlugosc.Text);
  dlugosc := Length(haslo);
  SetLength(hasloWygenerowane, dlugosc);
  SetLength(hasloWprowadzone, dlugosc);
  SetLength(indexValue, dlugosc);

  if cbxWielkieLitery.Checked = True then
  begin
    zestawZnakow := JoinArrays(zestawZnakow, wielkieLitery);
  end;

  if cbxMaleLitery.Checked = True then
  begin
    zestawZnakow := JoinArrays(zestawZnakow, maleLitery);
  end;

  if cbxCyfry.Checked = True then
  begin
    zestawZnakow := JoinArrays(zestawZnakow, cyfry);
  end;

  if cbxZnakiSpecjalne.Checked = True then
  begin
    zestawZnakow := JoinArrays(zestawZnakow, znakiSpecjalne);
  end;

  if cbxZnakiDiakrytyczne.Checked = True then
  begin
    zestawZnakow := JoinArrays(zestawZnakow, znakiDiakrytyczne);
  end;

  i := 1;

  while i <= Length(haslo) do
  begin
    if Ord(haslo[i]) > 127 then
      begin
         hasloWprowadzone[i - 1] := Concat(haslo[i], haslo[i + 1]);
         Inc(i,2);
      end
      else
      begin
          hasloWprowadzone[i - 1] := haslo[i];
          Inc(i);
      end;
  end;

  hasloWygenerowaneL := Length(hasloWygenerowane);
  zestawZnakowL := Length(zestawZnakow);

  Timer1.Enabled := True;

  repeat
    for i := 0 to hasloWygenerowaneL - 1 do
      begin
        hasloWygenerowane[i] := zestawZnakow[indexValue[i]];
      end;

    index := hasloWygenerowaneL - 1;
    while (index >= 0) and (indexValue[index] = zestawZnakowL - 1) do
    begin
      Dec(index);
    end;

    if index < 0 then
      break;

    Inc(indexValue[index]);

    for i := index + 1 to hasloWygenerowaneL do
      begin
        indexValue[i] := 0;
      end;

    Inc(liczbaProb);
    edtLiczbaProb.Text := IntToStr(liczbaProb);

  until CompareArrays(hasloWygenerowane, hasloWprowadzone) = 1;

  //Timer1.Enabled := False;

  for i := 0 to hasloWygenerowaneL - 1 do
    begin
      hasloZnalezione := Concat(hasloZnalezione, hasloWygenerowane[i]);
    end;

  Application.MessageBox(PChar('Wprowadzone haslo to: ' + hasloZnalezione), 'Odgadywania hasla zakonczone sukcesem')

end;

procedure TForm1.btnInfoClick(Sender: TObject);
begin
  Application.MessageBox('Maszyna Trurla Orszański Łukasz 141149 Rok III Wydzial Informatyki, semestr V', 'Info');
end;

procedure TForm1.btnKoniecClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.cbxCyfryChange(Sender: TObject);
begin
  if cbxCyfry.Checked = True then
     edtCyfry.Enabled := True
  else
      begin
        edtCyfry.Enabled := False;
        liczbaC := 0;
      end;
end;

procedure TForm1.cbxMaleLiteryChange(Sender: TObject);
begin
  if cbxMaleLitery.Checked = True then
     edtMaleLitery.Enabled := True
  else
      begin
        edtMaleLitery.Enabled := False;
        liczbaML := 0;
      end;
end;

procedure TForm1.cbxWielkieLiteryChange(Sender: TObject);
begin
  if cbxWielkieLitery.Checked = True then
     edtWielkieLitery.Enabled := True
  else
      begin
        edtWielkieLitery.Enabled := False;
        liczbaWL := 0;
      end;
end;

procedure TForm1.cbxZnakiDiakrytyczneChange(Sender: TObject);
begin
  if cbxZnakiDiakrytyczne.Checked = True then
     edtZnakiDiakrytyczne.Enabled := True
  else
      begin
        edtZnakiDiakrytyczne.Enabled := False;
        liczbaZD := 0;
      end;
end;

procedure TForm1.cbxZnakiSpecjalneChange(Sender: TObject);
begin
  if cbxZnakiSpecjalne.Checked = True then
     edtZnakiSpecjalne.Enabled := True
  else
      begin
        edtZnakiSpecjalne.Enabled := False;
        liczbaZS := 0;
      end;
end;

procedure TForm1.cbxPokazHasloChange(Sender: TObject);
begin
  if cbxPokazHaslo.Checked = True then
     edtHaslo.PasswordChar := Chr(0)
  else
    edtHaslo.PasswordChar := '*';

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  edtCzas.Text := Format('%d sec',[start]);
  Inc(start);
end;



end.

