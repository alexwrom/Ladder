unit uLadderLine;

interface

uses System.Classes, FMX.Objects3D, uLibrary, SysUtils, System.Math.Vectors, FMX.Types, System.UITypes,
  System.Types;

type

  TLadderLine = class(TDummy)
  private
    typeLadder: integer; // 0- tlLeft, 1 - tlRight

    placeHeight: double;
    placeWidth: double;
    widthLadder: double;

    stepCount: integer;
    stepTickness: double;
    stepLedge: double;

    isTopStepBelow: boolean;

    stringerTickness: double;
    stringerWidth: double;

    isVisibleUnderStep: boolean;
    underStepTickness: double;

    handrailHeight: double;
    handrailWidth: double;
    handrailTickness: double;
    balusterRadius: double;
    alpha: double;
    procedure loadConfiguration;
    procedure CreateLadder;
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single; RayPos, RayDeir: TVector3D);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single; RayPos, RayDir: TVector3D);
    procedure CreateRoom;
  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

uses Main;
{ TLadderLine }

constructor TLadderLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  loadConfiguration;
  CreateLadder;
  CreateRoom;
end;

procedure TLadderLine.loadConfiguration;
begin
  // Load data from database with ID = MainForm.Project.ID

  typeLadder := tlLeft;

  placeHeight := 3000 / cScale;
  placeWidth := 4500 / cScale;
  widthLadder := 1000 / cScale;

  stepCount := 16;
  stepTickness := 40 / cScale;
  stepLedge := 50 / cScale;

  isTopStepBelow := false;

  stringerTickness := 60 / cScale;
  stringerWidth := 300 / cScale;

  isVisibleUnderStep := true;
  underStepTickness := 25 / cScale;

  handrailHeight := 900 / cScale;
  handrailWidth := 80 / cScale;
  handrailTickness := 40 / cScale;
  balusterRadius := 50 / cScale;

end;

procedure TLadderLine.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single; RayPos, RayDeir: TVector3D);
begin
  MainForm.frameVisual.FDown := PointF(X, Y);
end;

procedure TLadderLine.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single; RayPos, RayDir: TVector3D);
begin
  if (ssLeft in Shift) then
    if Self <> nil then
    begin
      with MainForm.frameVisual.DummyCamera do
      begin
        RotationAngle.X := RotationAngle.X - (Y - MainForm.frameVisual.FDown.Y) * cSpeed;
        RotationAngle.Y := RotationAngle.Y + (X - MainForm.frameVisual.FDown.X) * cSpeed;
      end;
      MainForm.frameVisual.FDown := PointF(X, Y);
    end;
end;

procedure TLadderLine.CreateRoom;
begin
  with TCube.Create(Self) do // Back wall
  begin
    Parent := Self;
    Width := placeWidth;
    Height := placeHeight;
    Depth := 1;
    Position.X := 0;
    Position.Y := 0;
    Position.Z := widthLadder / 2 + 1 / 2;
    MaterialSource := MainForm.frameVisual.material—oncrete;
    OnMouseDown := MouseDown;
    OnMouseMove := MouseMove;
    Tag := teWall;
  end;

  with TCube.Create(Self) do // Side wall
  begin

    Parent := Self;
    Width := widthLadder + 1;
    Height := placeHeight;
    Depth := 1;
    Position.X := typeLadder * (-placeWidth / 2 - 1 / 2);
    Position.Y := 0;
    Position.Z := 1 / 2;
    MaterialSource := MainForm.frameVisual.material—oncrete;
    OnMouseDown := MouseDown;
    OnMouseMove := MouseMove;
    RotationAngle.Y := 90;
    Tag := teWall;
  end;

  with TCube.Create(Self) do // Floor
  begin

    Parent := Self;
    Width := placeWidth + 3;
    Height := widthLadder + 3;
    Depth := 1;
    Position.X := -1 / 2;
    Position.Y := placeHeight / 2 + 1 / 2;
    Position.Z := 1 / 2;
    MaterialSource := MainForm.frameVisual.material—oncrete;
    OnMouseDown := MouseDown;
    OnMouseMove := MouseMove;
    RotationAngle.X := 90;
    Tag := teFloor;
  end;
end;

procedure TLadderLine.CreateLadder;
var
  depthStep: double;
  I: integer;
  step: double;
  heightStep: double;
  j: integer;
  w: double;
begin

  if isVisibleUnderStep then
  begin
    step := (placeWidth - stepLedge - underStepTickness) / stepCount;
    depthStep := step + stepLedge + underStepTickness;
  end
  else
  begin
    step := (placeWidth - stepLedge) / stepCount;
    depthStep := step + stepLedge;
  end;

  if isTopStepBelow then
    heightStep := (placeHeight) / (stepCount + 1)
  else
    heightStep := (placeHeight) / stepCount;

  alpha := Arctan(heightStep / step) * 180 / PI;
  // Steps
  for I := 0 to stepCount - 1 do
  begin
    with TCube.Create(Self) do
    begin
      Parent := Self;
      Width := widthLadder;
      Height := stepTickness;
      Depth := depthStep;
      Position.X := typeLadder * (placeWidth / 2 - I * step - depthStep / 2);
      Position.Y := placeHeight / 2 - (I) * (heightStep) - stepTickness / 2 - heightStep + stepTickness;
      Position.Z := 0;
      RotationAngle.Y := 90;
      MaterialSource := MainForm.frameVisual.materialWood;
      Visible := true;
      OnMouseDown := MouseDown;
      OnMouseMove := MouseMove;
      Tag := teStep;
    end;
    // UnderSteps
    if isVisibleUnderStep then
    begin
      with TCube.Create(Self) do
      begin
        Parent := Self;
        Width := widthLadder;
        Height := heightStep - stepTickness;
        Depth := underStepTickness;
        Position.X := typeLadder * (placeWidth / 2 - I * step - underStepTickness / 2 - stepLedge);
        Position.Y := placeHeight / 2 - Height / 2 - I * (stepTickness + Height);
        Position.Z := 0;
        RotationAngle.Y := 90;
        MaterialSource := MainForm.frameVisual.materialWood;
        Visible := true;
        OnMouseDown := MouseDown;
        OnMouseMove := MouseMove;
        Tag := teUnderStep;
      end;
    end;
  end;
  // Stringers
  for j := 1 to 2 do
    with TPath3D.Create(Self) do
    begin
      Parent := Self;

      if isVisibleUnderStep then
        Width := placeWidth - stepLedge - underStepTickness
      else
        Width := placeWidth - stepLedge;

      if isTopStepBelow then
        Height := placeHeight - heightStep - stepTickness
      else
        Height := placeHeight - stepTickness;

      Depth := stringerTickness;
      Path.Data := 'm0,0 ';

      for I := 0 to stepCount - 1 do
      begin
        Path.Data := Path.Data + 'l' + StringReplace(FloatToStr(step), ',', '.', [rfReplaceAll]) + ',0 ';
        if I = stepCount - 1 then
          Path.Data := Path.Data + 'l0,' + StringReplace(FloatToStr(heightStep - stepTickness), ',', '.', [rfReplaceAll]) + ' '
        else
          Path.Data := Path.Data + 'l0,' + StringReplace(FloatToStr(heightStep), ',', '.', [rfReplaceAll]) + ' ';
      end;

      Path.Data := Path.Data + 'l-' + StringReplace(FloatToStr(((stringerWidth * SQRT(SQR(step) + SQR(heightStep)) - step * heightStep) / heightStep)), ',', '.', [rfReplaceAll]) + ',0 ';
      Path.Data := Path.Data + 'L0,' + StringReplace(FloatToStr(((stringerWidth * SQRT(SQR(step) + SQR(heightStep)) - step * heightStep) / step)), ',', '.', [rfReplaceAll]) + ' ';
      Path.Data := Path.Data + 'z';

      if isVisibleUnderStep then
        Position.X := typeLadder * (-stepLedge / 2 - underStepTickness / 2)
      else
        Position.X := typeLadder * (-stepLedge / 2);

      if isTopStepBelow then
        Position.Y := (placeHeight - Height) / 2
      else
        Position.Y := stepTickness / 2;

      Position.Z := -widthLadder / 2 + stringerTickness / 2;

      if j = 2 then
        Position.Z := Position.Z * (-1);

      if typeLadder = tlLeft then
        RotationAngle.Y := 180;
      MaterialSource := MainForm.frameVisual.materialWood;
      MaterialBackSource := MainForm.frameVisual.materialWood;
      MaterialShaftSource := MainForm.frameVisual.materialWood;
      Visible := true;
      OnMouseDown := MouseDown;
      OnMouseMove := MouseMove;
      Tag := teStringer;
    end;
  // Balusters
  for I := 0 to stepCount - 1 do
  begin
    with TCube.Create(Self) do
    begin
      Parent := Self;
      Width := balusterRadius;
      Height := handrailHeight - handrailTickness;
      Depth := balusterRadius;
      Position.X := typeLadder * (placeWidth / 2 - I * step - depthStep / 2);
      Position.Y := placeHeight / 2 - (I) * (heightStep) - heightStep - Height / 2;
      Position.Z := -widthLadder / 2 + balusterRadius / 2;
      RotationAngle.Y := 90;
      MaterialSource := MainForm.frameVisual.materialWood;
      Visible := true;
      OnMouseDown := MouseDown;
      OnMouseMove := MouseMove;
      Tag := teBaluster;
    end;
  end;
  // HandRail
  with TCube.Create(Self) do
  begin
    Parent := Self;
    MaterialSource := MainForm.frameVisual.materialWood;
    Width := placeWidth / Cos(alpha * PI / 180);
    Height := handrailTickness;
    Depth := handrailWidth;
    Position.Y := -handrailHeight - balusterRadius * Tangent(alpha * PI / 180) - handrailTickness / 2;
    Position.Z := -widthLadder / 2 + handrailTickness / 2;
    RotationAngle.Z := typeLadder * (alpha);

    OnMouseDown := MouseDown;
    OnMouseMove := MouseMove;
    Tag := teHandRail;
  end;
end;

end.
