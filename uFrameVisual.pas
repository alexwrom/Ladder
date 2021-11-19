unit uFrameVisual;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Viewport3D, uLadderLine,
  System.Math.Vectors, FMX.Controls3D, FMX.Objects3D, FMX.Types3D,
  FMX.MaterialSources, uLibrary, System.ImageList, FMX.ImgList, FMX.Layouts,
  FMX.Objects, Generics.Collections, FMX.Gestures;

type
  TFrameVisual = class(TFrame)
    ViewPort: TViewport3D;
    materialWood: TLightMaterialSource;
    materialMetal: TLightMaterialSource;
    materialСoncrete: TLightMaterialSource;
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
    GestureManager1: TGestureManager;
    layMoveViewport: TLayout;
    ToolBar: TToolBar;
    ShadowEffect1: TShadowEffect;
    Label2: TLabel;
    btnBack: TSpeedButton;

    procedure btnStringerViewClick(Sender: TObject);
    procedure btnStepViewClick(Sender: TObject);
    procedure btnUnderStepViewClick(Sender: TObject);
    procedure btnHaidRailViewClick(Sender: TObject);
    procedure btnRoomViewClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure layMoveViewportGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure layMoveViewportMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure layMoveViewportMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure layMoveViewportMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
  private
    FLastDistance: Integer;
    DontRotate : boolean;
    procedure ShowHide(Sender: TObject; list: TList<Integer>);
    { Private declarations }

  public
    { Public declarations }
    PriorForm: Integer;
    Ladder: TDummy;
    FDown: TPointF;
    procedure CreateLadder;

  end;

implementation

uses Main, uFrameStartProject, uFrameInputData;
{$R *.fmx}

procedure TFrameVisual.CreateLadder;
begin
  DontRotate := false;
  FLastDistance := 0;
  case MainForm.Project.typeLadder of
    1:
      begin
        Ladder := TLadderLine.Create(ViewPort);
        Ladder.Parent := ViewPort;
        Ladder.position.Y := 2;
      end;
  end;
  ViewPort.Multisample := TMultiSample.FourSamples;
  ViewPort.Repaint;
  ViewPort.Align := TAlignLayout.Client;
end;

procedure TFrameVisual.layMoveViewportGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    igiZoom:
      begin

        if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
        begin
          if (Camera.position.Z + (EventInfo.Distance - FLastDistance) / 10 <= -10) and (Camera.position.Z + (EventInfo.Distance - FLastDistance) / 10 >= -80) then
          begin
            Camera.position.Z := Camera.position.Z + (EventInfo.Distance - FLastDistance) / 10;
          end;
        end;
        FLastDistance := EventInfo.Distance;
        DontRotate := true;
      end;
  end;
end;

procedure TFrameVisual.layMoveViewportMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  FDown := PointF(X, Y);
  DontRotate := false;
end;

procedure TFrameVisual.layMoveViewportMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if (ssLeft in Shift) and (NOT DontRotate)then
    if Ladder <> nil then
    begin
      with Ladder do
      begin

        DummyCamera.RotationAngle.X := DummyCamera.RotationAngle.X - (Y - FDown.Y) * cSpeed;
        DummyCamera.RotationAngle.Y := DummyCamera.RotationAngle.Y + (X - FDown.X) * cSpeed;

      end;
      FDown := PointF(X, Y);

    end;
end;

procedure TFrameVisual.layMoveViewportMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  if Camera <> nil then
    if Camera.position.Z + WheelDelta / 100 <= -1 then
    begin
      Camera.position.Z := Camera.position.Z + WheelDelta / 100;
    end;
end;

procedure TFrameVisual.ShowHide(Sender: TObject; list: TList<Integer>);
var
  i: Integer;
  IsVisible: Boolean;
begin
  IsVisible := ((Sender as TSpeedButton).Parent as TImage).Opacity = 1;
  if IsVisible then
    ((Sender as TSpeedButton).Parent as TImage).Opacity := 0.5
  else
    ((Sender as TSpeedButton).Parent as TImage).Opacity := 1;

  for i := 0 to Ladder.ChildrenCount - 1 do
  begin
    if list.IndexOf(Ladder.Children[i].Tag) >= 0 then
      if (Ladder.Children[i] is TPath3D) then
        (Ladder.Children[i] as TPath3D).Visible := NOT IsVisible
      else
        (Ladder.Children[i] as TCube).Visible := NOT IsVisible
  end;

end;

// Показать/ скрыть Поручень
procedure TFrameVisual.btnBackClick(Sender: TObject);
begin
  case PriorForm of
    pfAdd:
      begin
        MainForm.frameInputData := TFrameInputData.Create(MainForm);
        MainForm.frameInputData.PriorForm := pfAdd;
        MainForm.frameInputData.Parent := MainForm;
      end;
    pfEdit:
      begin
        MainForm.frameStartProject := TFrameStartProject.Create(MainForm);
        MainForm.frameStartProject.Parent := MainForm;
      end;
  end;
  MyFreeAndNil(Ladder);
  MyFreeAndNil(MainForm.frameVisual);
end;

procedure TFrameVisual.btnHaidRailViewClick(Sender: TObject);
begin
  ShowHide(Sender, TList<Integer>.Create([teBaluster, teHandRail]));
end;

// Показать/ скрыть Комнату
procedure TFrameVisual.btnRoomViewClick(Sender: TObject);
begin
  ShowHide(Sender, TList<Integer>.Create([teFloor, teWall]));
end;

// Показать/ скрыть Ступени
procedure TFrameVisual.btnStepViewClick(Sender: TObject);
begin
  ShowHide(Sender, TList<Integer>.Create([teStep]));
end;

// Показать/ скрыть Тетивы
procedure TFrameVisual.btnStringerViewClick(Sender: TObject);
begin
  ShowHide(Sender, TList<Integer>.Create([teStringer]));
end;

// Показать/ скрыть Подступни
procedure TFrameVisual.btnUnderStepViewClick(Sender: TObject);
begin
  ShowHide(Sender, TList<Integer>.Create([teUnderStep]));
end;

end.
