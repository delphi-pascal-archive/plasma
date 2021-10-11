unit Unitprinc;

/////////////////////////////////
// Plasma - 13/10/2001         //
/////////////////////////////////
// Dark Skull Software         //
// http://www.dark-skull.fr.st //
// edrad@wanadoo.fr            //
/////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SyncObjs;

type
  TPlasmaThread = class;

  TFormPrinc = class(TForm)
    PaintBox: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées}
    Plsm: TPlasmaThread;
  public
    { Déclarations publiques}
  published
    { Déclarations publiées }
  end;

  TPlasmaThread = class(TThread)
  private
    { Déclarations privées }
    Frame, Freq, FrameStart, FrameStop, FrameBegin, FrameEnd: int64;
    Instant, Average: Single;
    SleepTime: integer;
    Form: TFormPrinc;
    TmpBmp: TBitmap;
    DrawBmp: TBitmap;
    SinTab: array[byte] of integer;
    i1, i2, j1, j2, c: integer;
    procedure CreateBmp;
    procedure Init;
    procedure Render;
    procedure DrawFPS(Canvas: TCanvas);
    procedure Draw;
    procedure Wait;
    procedure QueryPerf;
    function GetPal: HPalette;
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
    constructor Create(Form: TFormPrinc);
    procedure Execute;override;
    destructor Destroy; override;
  end;

var
  FormPrinc: TFormPrinc;
  CanDraw: boolean;
  ShowStats: boolean;

const
  Mask: integer = $FF;

implementation

{$R *.DFM}

procedure TFormPrinc.FormCreate(Sender: TObject);
begin
  Screen.Cursor := crNone;
  CanDraw := true;
  ShowStats := true;
  Plsm := TPlasmaThread.Create(Self);
end;

procedure TFormPrinc.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanDraw := false;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormPrinc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
  if Key = 83 then ShowStats := not ShowStats;
end;

constructor TPlasmaThread.Create(Form: TFormPrinc);
begin
  inherited Create(false);
  CreateBmp;
  Init;
  Self.Form := Form;
  FreeOnTerminate := true;
end;

destructor TPlasmaThread.Destroy;
begin
  TmpBmp.Free;
end;

procedure TPlasmaThread.Init;
var
  x: byte;
begin
  for x := 0 to 255 do SinTab[x] := Round(Sin(2 * Pi * x / 255) * 128) + 128;
  i1 := 50;
  j1 := 90;
  QueryPerformanceFrequency(Freq);
  QueryPerformanceCounter(FrameStart);
  FrameBegin := FrameStart;
  Instant := 0;
  Frame := 0;
  SleepTime := 0;
end;

procedure TPlasmaThread.Execute;
begin
  while not Terminated do
    begin
      Render;
      QueryPerf;
      if CanDraw then Synchronize(Draw);
      Wait;
    end;
end;

procedure TPlasmaThread.Render;
var
  x, y: integer;
  Row: PByteArray;
begin
  i1 := i1 - 1;
  j1 := j1 + 2;
  for y := 0 to Pred(TmpBmp.Height) do
    begin
      i2 := SinTab[(y + i1) and Mask];
      j2 := SinTab[j1 and Mask];
      Row := TmpBmp.ScanLine[y];
      for x := 0 to Pred(TmpBmp.Width) do
        begin
          c := SinTab[(x + i2) and Mask] + SinTab[(y + j2) and Mask];
          if CanDraw then Row[x] := c;
        end;
    end;
end;

procedure TPlasmaThread.Draw;
var
  a, b: integer;
  i, j: integer;
begin
  if Assigned(Form) then
    begin
      DrawBmp.Canvas.Draw(0, 0, TmpBmp);
      a := Form.ClientWidth shr 8;
      b := Form.ClientHeight shr 8;
      for i := 0 to a do
        for j := 0 to b do
          Form.PaintBox.Canvas.Draw(i shl 8, j shl 8, DrawBmp);
      if ShowStats then DrawFPS(Form.PaintBox.Canvas);
    end;
end;

procedure TPlasmaThread.CreateBmp;
begin
  // Le bitmap suivant sert à effectuer tous les calculs
  TmpBmp := TBitmap.Create;
  TmpBmp.PixelFormat := pf8Bit;
  TmpBmp.Palette := GetPal;
  TmpBmp.Width := 256;
  TmpBmp.Height := 256;
  TmpBmp.Canvas.Brush.Color := clBlack;
  TmpBmp.Canvas.FillRect(Rect(0, 0, TmpBmp.Width, TmpBmp.Height));
  // Le bitmap suivant sert à dessiner plus rapidement sur l'écran
  DrawBmp := TBitmap.Create;
  DrawBmp.PixelFormat := pfDevice;
  DrawBmp.Width := 256;
  DrawBmp.Height := 256;
end;

function TPlasmaThread.GetPal: HPalette;
var
  Palette: TMaxLogPalette;
  i: integer;
begin
  Palette.palVersion := $300;
  Palette.palNumEntries := $FE;
  for i := 0 to Pred(Palette.palNumEntries) do
    begin
      with Palette.palPalEntry[i] do
        begin
          peFlags := 0;
          case i of
            0..63:    begin
                        peRed   := i;
                        peGreen := i * 2;
                        peBlue  := i * 4;
                      end;
            64..126:  begin
                        peRed   := (126 - i);
                        peGreen := (126 - i) * 2;
                        peBlue  := (126 - i) * 4
                      end;
            127..189: begin
                        peRed   := (i - 125) * 4;
                        peGreen := (i - 125);
                        peBlue  := (i - 125) * 2;
                      end;
            190..252: begin
                        peRed   := (255 - i) * 4;
                        peGreen := (255 - i);
                        peBlue  := (255 - i) * 2;
                      end;
            else      begin
                        peRed   := (255 - i) * 4;
                        peGreen := (255 - i);
                        peBlue  := (255 - i) * 2;
                      end;
          end;
        end;
    end;
  Result := CreatePalette(pLogPalette(@Palette)^)
end;

procedure TPlasmaThread.DrawFPS(Canvas: TCanvas);
begin
  Canvas.Font.Color := clWhite;
  Canvas.Brush.Style := bsClear;
  Canvas.TextOut(10, 10, Format('FPS Courant         : %0.2n', [Instant]));
  Canvas.TextOut(10, 25, Format('FPS Moyen           : %0.2n', [Average]));
  Canvas.TextOut(10, 40, Format('Temps de repos (ms) : %d', [SleepTime]));
end;

procedure TPlasmaThread.Wait;
begin
  // Réglage du FrameRate autour de 40-50 FPS
  if (Instant > 50) then Inc(SleepTime);
  if (Instant < 40) and (SleepTime > 0) then Dec(SleepTime);
  Sleep(SleepTime);
end;

procedure TPlasmaThread.QueryPerf;
begin
  QueryPerformanceCounter(FrameStop);
  FrameEnd := FrameStop;
  Instant := Freq / (FrameStop - FrameStart);
  Average := (Frame * Freq) / (FrameEnd - FrameBegin);
  Inc(Frame);
  QueryPerformanceCounter(FrameStart);
end;

end.
