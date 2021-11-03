unit uFrameVisual;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Viewport3D, uLadderLine,
  System.Math.Vectors, FMX.Controls3D, FMX.Objects3D, FMX.Types3D,
  FMX.MaterialSources, uLibrary, System.ImageList, FMX.ImgList, FMX.Layouts,
  FMX.Objects;

type
  TFrameVisual = class(TFrame)
    ToolBar: TToolBar;
    ShadowEffect1: TShadowEffect;
    Label2: TLabel;
    btnBack: TSpeedButton;
    ViewPort: TViewport3D;
    materialWood: TLightMaterialSource;
    materialMetal: TLightMaterialSource;
    material—oncrete: TLightMaterialSource;
    DummyCamera: TDummy;
    Camera: TCamera;
    Light: TLight;
    Layout1: TLayout;
    Layout2: TLayout;
    Image2: TImage;
    btnRoomView: TSpeedButton;
    Image3: TImage;
    btnHaidRailView: TSpeedButton;
    Image4: TImage;
    btnUnderStepView: TSpeedButton;
    Image5: TImage;
    btnStringerView: TSpeedButton;
    Image6: TImage;
    btnStepView: TSpeedButton;
    procedure ViewPortMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ViewPortMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure ViewPortMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure btnStringerViewClick(Sender: TObject);
    procedure btnStepViewClick(Sender: TObject);
    procedure btnUnderStepViewClick(Sender: TObject);
    procedure btnHaidRailViewClick(Sender: TObject);
    procedure btnRoomViewClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    Ladder: TDummy;
    FDown: TPointF;
    procedure CreateLadder;

  end;

implementation

uses Main;
{$R *.fmx}

procedure TFrameVisual.CreateLadder;
begin
  case MainForm.Project.ID of
    0:
      begin
        Ladder := TLadderLine.Create(ViewPort);
        Ladder.Parent := ViewPort;
        Ladder.position.Y := 2;
      end;
  end;
  ViewPort.Multisample := TMultiSample.FourSamples;
  ViewPort.Repaint;
end;

procedure TFrameVisual.btnHaidRailViewClick(Sender: TObject);
var
  i: Integer;
  IsVisible: Boolean;
begin
  IsVisible := (btnHaidRailView.Parent as TImage).Opacity = 1;
  if IsVisible then
    (btnHaidRailView.Parent as TImage).Opacity := 0.5
  else
    (btnHaidRailView.Parent as TImage).Opacity := 1;

  for i := 0 to Ladder.ChildrenCount - 1 do
  begin
    if Ladder.Children[i].Tag in [teBaluster,teHandRail] then
       (Ladder.Children[i] as TCube).Visible := NOT IsVisible
  end;
end;

procedure TFrameVisual.btnRoomViewClick(Sender: TObject);
var
  i: Integer;
  IsVisible: Boolean;
begin
  IsVisible := (btnRoomView.Parent as TImage).Opacity = 1;
  if IsVisible then
    (btnRoomView.Parent as TImage).Opacity := 0.5
  else
    (btnRoomView.Parent as TImage).Opacity := 1;

  for i := 0 to Ladder.ChildrenCount - 1 do
  begin
    if Ladder.Children[i].Tag in [teFloor,teWall] then
       (Ladder.Children[i] as TCube).Visible := NOT IsVisible
  end;

end;

procedure TFrameVisual.btnStepViewClick(Sender: TObject);
var
  i: Integer;
  IsVisible: Boolean;
begin
  IsVisible := (btnStepView.Parent as TImage).Opacity = 1;
  if IsVisible then
    (btnStepView.Parent as TImage).Opacity := 0.5
  else
    (btnStepView.Parent as TImage).Opacity := 1;

  for i := 0 to Ladder.ChildrenCount - 1 do
  begin
    if Ladder.Children[i].Tag = teStep then
      if (Ladder.Children[i] is TPath3D) then
        (Ladder.Children[i] as TPath3D).Visible := NOT IsVisible
      else
        (Ladder.Children[i] as TCube).Visible := NOT IsVisible
  end;
end;

procedure TFrameVisual.btnStringerViewClick(Sender: TObject);
var
  i: Integer;
  IsVisible: Boolean;
begin
  IsVisible := (btnStringerView.Parent as TImage).Opacity = 1;
  if IsVisible then
    (btnStringerView.Parent as TImage).Opacity := 0.5
  else
    (btnStringerView.Parent as TImage).Opacity := 1;

  for i := 0 to Ladder.ChildrenCount - 1 do
  begin
    if Ladder.Children[i].Tag = teStringer then
      (Ladder.Children[i] as TPath3D).Visible := NOT IsVisible;
  end;
end;

procedure TFrameVisual.btnUnderStepViewClick(Sender: TObject);
var
  i: Integer;
  IsVisible: Boolean;
begin
  IsVisible := (btnUnderStepView.Parent as TImage).Opacity = 1;
  if IsVisible then
    (btnUnderStepView.Parent as TImage).Opacity := 0.5
  else
    (btnUnderStepView.Parent as TImage).Opacity := 1;

  for i := 0 to Ladder.ChildrenCount - 1 do
  begin
    if Ladder.Children[i].Tag = teUnderStep then
       (Ladder.Children[i] as TCube).Visible := NOT IsVisible
  end;
end;

procedure TFrameVisual.ViewPortMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  FDown := PointF(X, Y);
end;

procedure TFrameVisual.ViewPortMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if (ssLeft in Shift) then
    if Ladder <> nil then // DummyCamera
    begin
      with Ladder do // DummyCamera
      begin

        DummyCamera.RotationAngle.X := DummyCamera.RotationAngle.X - (Y - FDown.Y) * cSpeed;
        DummyCamera.RotationAngle.Y := DummyCamera.RotationAngle.Y + (X - FDown.X) * cSpeed;

      end;
      FDown := PointF(X, Y);

    end;
end;

procedure TFrameVisual.ViewPortMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  if Camera <> nil then
    if Camera.position.Z + WheelDelta / 100 <= -1 then
    begin
      Camera.position.Z := Camera.position.Z + WheelDelta / 100;
    end;
end;

end.
