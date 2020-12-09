//Hasla Orszański Łukasz 141149 Rok III Wydzial Informatyki, semestr V
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DateUtils,
  StrUtils, Math, DCPsha256, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnSprawdz: TButton;
    btnZapisz: TButton;
    btnOdgadnij: TButton;
    btnInfo: TButton;
    btnKoniec: TButton;
    btnSzyfrujXOR: TButton;
    btnDeszyfrujXOR: TButton;
    btnObliczSHA: TButton;
    btnSzyfrujKodemVernama: TButton;
    btnDeszyfrujKodemVernama: TButton;
    btnZlamSHA: TButton;
    cbxWielkieLitery: TCheckBox;
    cbxMaleLitery: TCheckBox;
    cbxCyfry: TCheckBox;
    cbxZnakiSpecjalne: TCheckBox;
    cbxPokazHaslo: TCheckBox;
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
    procedure btnDeszyfrujKodemVernamaClick(Sender: TObject);
    procedure btnDeszyfrujXORClick(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure btnKoniecClick(Sender: TObject);
    procedure btnObliczSHAClick(Sender: TObject);
    procedure btnOdgadnijClick(Sender: TObject);
    procedure btnSprawdzClick(Sender: TObject);
    procedure btnSzyfrujKodemVernamaClick(Sender: TObject);
    procedure btnSzyfrujXORClick(Sender: TObject);
    procedure btnZapiszClick(Sender: TObject);
    procedure btnZlamSHAClick(Sender: TObject);
    procedure cbxCyfryChange(Sender: TObject);
    procedure cbxMaleLiteryChange(Sender: TObject);
    procedure cbxWielkieLiteryChange(Sender: TObject);
    procedure cbxZnakiSpecjalneChange(Sender: TObject);
    procedure cbxPokazHasloChange(Sender: TObject);
    procedure edtHasloChange(Sender: TObject);
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
  cyfry: array[0..9] of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
  znakiSpecjalne: array[0..31] of String = ('!', '"', '#', '$', '%', '^', '&', '',  '*', '(', ')', '+', ',', '-', '.', '/', ':', ';', '<', '>', '=', '?', '@', '[', '\', ']', '_', '`', '{', '|', '}' , '~');
  liczbaWL: Integer = 0;
  liczbaML: Integer = 0;
  liczbaC: Integer = 0;
  liczbaZS: Integer = 0;
  start: Integer;
  dlugoscHasla: Integer;
  kluczXOR: string = 'sdf234fdsfJK78GLsdjf34uJH6ZXCNVf';
  skrotHasla: string;
  kluczVernama: string;
  noweHaslo: Boolean;

implementation

{$R *.lfm}

{ TForm1 }

function Oblicz_SHA256(Dane: String) : String;
var
  DCP_sha256 : TDCP_sha256;
  Skrot : array[1..32] of byte; // algorytm sha256 generuje skrót o dług. 32 bajtów
  i : integer;
  HexStr : string; // obliczony skrót w postaci heksadecymalnej
begin
  if length(Dane)=0 then
     Oblicz_SHA256:=''
  else
    begin
      DCP_sha256:=TDCP_sha256.Create(nil);
      DCP_sha256.Init;
      DCP_sha256.UpdateStr(Dane);
      DCP_sha256.Final(Skrot); // obliczony skrót w postaci binarnej
      DCP_sha256.Destroy;
      HexStr:= '';
      for i:= 1 to 32 do
      HexStr:= HexStr + IntToHex(Skrot[i],2);
      Oblicz_SHA256:=HexStr;
    end;
end;

procedure TForm1.btnSprawdzClick(Sender: TObject);
var
  dlugosc: Integer;
  i, pozycja: Integer;
  liczbaWielkichLiter: Integer = 0;
  liczbaMalychLiter: Integer = 0;
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

    if dlugosc <> haslo.Length then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(dlugosc) + ' znakow!'), 'Uwaga')
    else if liczbaWL <> liczbaWielkichLiter then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaWL) + ' wielkich liter!'), 'Uwaga')
    else if liczbaML <> liczbaMalychLiter then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaML) + ' malych liter!'), 'Uwaga')
    else if liczbaC <> liczbaCyfr then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaC) + ' cyfr!'), 'Uwaga')
    else if liczbaZS <> liczbaZnakowSpecjalnych then
       Application.MessageBox(PChar('Haslo powinno mieć ' + IntToStr(liczbaZS) + ' znakow specjalnych!'), 'Uwaga')
    else
      begin
        Application.MessageBox('Haslo poprawne!', 'Uwaga');
        noweHaslo := false;
      end;


  except
    Application.MessageBox('Wprowadź wszytskie wartosci!', 'Uwaga');
  end;

end;

procedure TForm1.btnSzyfrujKodemVernamaClick(Sender: TObject);
var
  datFile    : File of Char;
  chrContent : Char;
  tekstZPliku: String;
  dlugoscPliku: Integer;
  i: Integer;
begin
  AssignFile(datFile, 'tekst.txt');
  Reset(datFile);
  tekstZPliku := '';

   while not eof(datFile)           // keep reading as long as there is data to read
     do begin
       read(datFile, chrContent);   // reads a single character into chrContent variable
       tekstZPliku := tekstZPliku + chrContent;
     end;

   CloseFile(datFile);

   dlugoscPliku := Length(tekstZPliku);

   randomize();

   for i := 1 to dlugoscPliku do
   begin
     kluczVernama := kluczVernama + Chr(random(256));
   end;

   Assignfile(datFile, 'tekstZaszyfrowany.txt');  // Assigns the name of the file to the variable txtFile and opens the file
   ReWrite(datFile);                    // File will be overwritten if it exists

   for i := 1 to dlugoscPliku do
    begin
      chrContent := Chr(Ord(tekstZPliku[i]) xor Ord(kluczVernama[i]));
      Write(datFile, chrContent);
    end;

   CloseFile(datFile);
   Application.MessageBox('Plik tekst.txt został zaszyfrowany kodem Vernama', 'Zakończono szyfrowanie pliku');

end;

procedure TForm1.btnDeszyfrujKodemVernamaClick(Sender: TObject);
var
  datFile    : File of Char;
  chrContent : Char;
  tekstZPliku: String;
  dlugoscPliku: Integer;
  i: Integer;
begin
  AssignFile(datFile, 'tekstZaszyfrowany.txt');
  Reset(datFile);
  tekstZPliku := '';

   while not eof(datFile)           // keep reading as long as there is data to read
     do begin
       read(datFile, chrContent);   // reads a single character into chrContent variable
       tekstZPliku := tekstZPliku + chrContent;
     end;

   CloseFile(datFile);

   dlugoscPliku := Length(tekstZPliku);

   Assignfile(datFile, 'tekstOdszyfrowany.txt');  // Assigns the name of the file to the variable txtFile and opens the file
   ReWrite(datFile);                    // File will be overwritten if it exists

   for i := 1 to dlugoscPliku do
    begin
      chrContent := Chr(Ord(tekstZPliku[i]) xor Ord(kluczVernama[i]));
      Write(datFile, chrContent);
    end;

   CloseFile(datFile);
   Application.MessageBox('Plik tekstZaszyfrowany.txt został odszyfrowany kodem Vernama', 'Zakończono odszyfrowywanie pliku');

end;

procedure TForm1.btnSzyfrujXORClick(Sender: TObject);
var
  i, j: Integer;
  dlugosc, dlugoscKlucza: Integer;
  hasloZaszyfrowane, hasloZaszyfrowaneHEX: string;
begin
  haslo := edtHaslo.Text;
  dlugosc := Length(haslo);

  if dlugosc = 0 then
     Application.MessageBox('Podane hasło musi mieć przynajmniej jeden znak!', 'Uwaga')
  else if noweHaslo = true then
     Application.MessageBox('Sprawdź poprawność hasła', 'Uwaga')
  else
     begin
      dlugoscHasla := dlugosc;
      dlugoscKlucza := Length(kluczXOR);
      hasloZaszyfrowane := '';
      hasloZaszyfrowaneHEX := '';

      j := 1;

      while dlugosc mod dlugoscKlucza <> 0 do
       begin
            haslo := Concat(haslo, '0');
            dlugosc := Length(haslo);
       end;

       for i := 1 to dlugosc do
        begin
          hasloZaszyfrowane := hasloZaszyfrowane + Chr(Ord(haslo[i]) xor Ord(kluczXOR[j]));
          Inc(j);
          if i > j then
             j := 1;
        end;

       for i:= 1 to dlugosc do
        hasloZaszyfrowaneHEX := hasloZaszyfrowaneHEX + IntToHex(Ord(hasloZaszyfrowane[i]), 2);

       haslo := hasloZaszyfrowane;

      Form2.Caption := 'Hasło zaszyfrowane funkcją XOR';
      Form2.Memo1.Lines.Clear;
      Form2.Memo1.Lines.Add(hasloZaszyfrowaneHEX);
      Form2.ShowModal;

     end;
end;

procedure TForm1.btnDeszyfrujXORClick(Sender: TObject);
var
  i, j: Integer;
  dlugosc, dlugoscKlucza: Integer;
  hasloOdszyfrowane: string;
begin

  if noweHaslo = true then
     Application.MessageBox('Hasło zostało zmienione. Zaszyfruj hasło funkcją XOR przed odszyfrowaniem.', 'Uwaga')
  else
  begin
    dlugosc := dlugoscHasla;
    dlugoscKlucza := Length(kluczXOR);
    hasloOdszyfrowane := '';

    j := 1;

     for i := 1 to dlugosc do
      begin
        hasloOdszyfrowane := hasloOdszyfrowane + Chr(Ord(haslo[i]) xor Ord(kluczXOR[j]));
        Inc(j);
        if i > j then
           j := 1;
      end;

     haslo := hasloOdszyfrowane;

     Form2.Caption := 'Hasło odszyfrowane funkcją XOR';
     Form2.Memo1.Lines.Clear;
     Form2.Memo1.Lines.Add(hasloOdszyfrowane);
     Form2.ShowModal;
  end;




end;

procedure TForm1.btnZapiszClick(Sender: TObject);
var
  f: Text;
begin
  AssignFile(f, 'Hasla.txt');
  try
    Append(f);
  except
    Rewrite(f);
  end;
  Writeln(f, haslo);
  CloseFile(f);

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

procedure TForm1.btnZlamSHAClick(Sender: TObject);
var
  hasloWygenerowane: array of String;
  hasloWprowadzone: array of String;
  indexValue: array of Integer;
  dlugosc: SizeInt;
  zestawZnakow: TSArray;
  hasloWygenerowaneL, zestawZnakowL, index, i: Integer;
  hasloZnalezione: String = '';
  liczbaProb: Int64 = 0;
  T0: Double;
  skrotHaslaWygenerowany: String;
  hasloWygenerowaneStr: String;
begin
  if noweHaslo = true then
     Application.MessageBox('Hasło zostało zmienione. Oblicz skrót SHA przed odgadnięciem hasła.', 'Uwaga')
  else
  begin
    haslo := edtHaslo.Text;
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

    i := 1;

    while i <= Length(haslo) do
    begin
         hasloWprowadzone[i - 1] := haslo[i];
         Inc(i);
    end;

    hasloWygenerowaneL := Length(hasloWygenerowane);
    zestawZnakowL := Length(zestawZnakow);

    T0 := Now;

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

      if ((liczbaProb mod 500) = 0) then
      begin
        edtCzas.Text := FormatDateTime('nn:ss:zz', Now - T0);
        edtLiczbaProb.Text := IntToStr(liczbaProb);
        Form1.Refresh;
      end;

      hasloWygenerowaneStr := '';

      for i := 0 to hasloWygenerowaneL - 1 do
      begin
        hasloWygenerowaneStr := Concat(hasloWygenerowaneStr, hasloWygenerowane[i]);
      end;

      skrotHaslaWygenerowany := Oblicz_SHA256(hasloWygenerowaneStr)

    until skrotHasla = skrotHaslaWygenerowany;

    edtCzas.Text := FormatDateTime('nn:ss:zz', Now - T0);
    edtLiczbaProb.Text := IntToStr(liczbaProb);

    for i := 0 to hasloWygenerowaneL - 1 do
      begin
        hasloZnalezione := Concat(hasloZnalezione, hasloWygenerowane[i]);
      end;

    Application.MessageBox(PChar('Wprowadzone haslo to: ' + hasloZnalezione), 'Odgadywania hasla zakonczone sukcesem');
    mmoWyniki.Lines.Add('Haslo: ' + hasloZnalezione + ' znalezione zostalo po ' + IntToStr(liczbaProb) + ' probach i po czasie ' +  FormatDateTime('nn:ss:zz', Now - T0));

  end;
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
  T0: Double;
begin
  if noweHaslo = true then
     Application.MessageBox('Hasło zostało zmienione. Sprawdź poprawność hasła przed odgadnięciem.', 'Uwaga')
  else
  begin
    haslo := edtHaslo.Text;
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

    T0 := Now;

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

      if ((liczbaProb mod 500) = 0) then
      begin
        edtCzas.Text := FormatDateTime('nn:ss:zz', Now - T0);
        edtLiczbaProb.Text := IntToStr(liczbaProb);
        Form1.Refresh;
      end;

    until CompareArrays(hasloWygenerowane, hasloWprowadzone) = 1;

    edtCzas.Text := FormatDateTime('nn:ss:zz', Now - T0);
    edtLiczbaProb.Text := IntToStr(liczbaProb);

    for i := 0 to hasloWygenerowaneL - 1 do
      begin
        hasloZnalezione := Concat(hasloZnalezione, hasloWygenerowane[i]);
      end;

    Application.MessageBox(PChar('Wprowadzone haslo to: ' + hasloZnalezione), 'Odgadywania hasla zakonczone sukcesem');
    mmoWyniki.Lines.Add('Haslo: ' + hasloZnalezione + ' znalezione zostalo po ' + IntToStr(liczbaProb) + ' probach i po czasie ' +  FormatDateTime('nn:ss:zz', Now - T0));
  end;
end;

procedure TForm1.btnInfoClick(Sender: TObject);
begin
  Application.MessageBox('Hasla Orszański Łukasz 141149 Rok III Wydzial Informatyki, semestr V', 'Info');
end;

procedure TForm1.btnKoniecClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.btnObliczSHAClick(Sender: TObject);
begin
  haslo := edtHaslo.Text;

  if noweHaslo = true then
     Application.MessageBox('Sprawdź poprawność hasła', 'Uwaga')
  else
  begin
   skrotHasla := Oblicz_SHA256(haslo);

   Form2.Caption := 'Skrot SHA';
   Form2.Memo1.Lines.Clear;
   Form2.Memo1.Lines.Add(skrotHasla);
   Form2.ShowModal;
  end;



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

procedure TForm1.edtHasloChange(Sender: TObject);
begin
  noweHaslo := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  edtCzas.Text := Format('%d sec',[start]);
  Inc(start);
end;



end.

