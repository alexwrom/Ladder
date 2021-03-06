unit uFrameProjects;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.ImageList, FMX.ImgList, FMX.Objects,
  FMX.Effects, FMX.Gestures, FMX.Ani, uFrameStartProject, uFrameNewProject, uLibrary;

type
  TframeProjects = class(TFrame)
    imgListLadders: TImageList;
    VertScrollBox1: TVertScrollBox;
    GridLayout: TGridLayout;
    Layout1: TLayout;
    Label1: TLabel;
    btnNewProject: TCornerButton;
    imgOk: TImageList;
    layEditDel: TLayout;
    GestureManager: TGestureManager;
    bottomMenuEditDel: TRoundRect;
    Layout2: TLayout;
    animMenuEditDel: TFloatAnimation;
    ShadowEffect2: TShadowEffect;
    ToolBar: TToolBar;
    ShadowEffect3: TShadowEffect;
    Label3: TLabel;
    btnBack: TSpeedButton;
    btnMenuClose: TSpeedButton;
    btnEdit: TSpeedButton;
    btnDel: TSpeedButton;
    procedure btnBackClick(Sender: TObject);
    procedure OnLongTap(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btnMenuCloseClick(Sender: TObject);
    procedure animMenuEditDelFinish(Sender: TObject);
    procedure btnNewProjectClick(Sender: TObject);
  private
    procedure CreateNewProjectElement(nameProject: string; ID, TypeIndex: integer);
    procedure OnSelProject(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Main;

{$R *.fmx}

procedure TframeProjects.CreateNewProjectElement(nameProject: string; ID, TypeIndex: integer);
var
  tmpLay: TLayout;
  tmpBtn: TCornerButton;
begin
  tmpLay := TLayout.Create(self);
  with tmpLay do
  begin
    Parent := GridLayout;
    Margins.Top := 5;
    Margins.Bottom := 5;
    Margins.Left := 5;
    Margins.Right := 5;
  end;

  with TLabel.Create(tmpLay) do
  begin
    Parent := tmpLay;
    Text := nameProject;
    AutoSize := false;
    StyledSettings := [];
    TextSettings.WordWrap := true;
    TextSettings.HorzAlign := TTextAlign(0);
    TextSettings.FontColor := TAlphaColors.Brown;
    TextSettings.Font.Size := 11;
    Align := TAlignLayout.Bottom;
    Height := 30;
  end;

  with TImage.Create(self) do
  begin
    Parent := tmpLay;
    WrapMode := TImageWrapMode(2);
    Margins.Top := 10;
    Margins.Bottom := 10;
    Margins.Left := 10;
    Margins.Right := 10;
    MultiResBiTmap[0].BitMap.Assign(imgListLadders.Source[TypeIndex-1].MultiResBiTmap[0].BitMap);
    Align := TAlignLayout(9);
  end;

  tmpBtn := TCornerButton.Create(self);
  with tmpBtn do
  begin
    Parent := tmpLay;
    Align := TAlignLayout(9);
    Margins.Top := 2;
    Margins.Bottom := 2;
    Margins.Left := 2;
    Margins.Right := 2;
    Opacity := 0.8;
    Touch.GestureManager := GestureManager;
    Touch.InteractiveGestures := [TInteractiveGesture.LongTap];
    Tag := ID;
    ParentShowHint := false;
    StyleName := nameProject;
    Hint:= TypeIndex.ToString;
    OnGesture := OnLongTap;
    OnClick := OnSelProject;
  end;
  GridLayout.Height := Round((GridLayout.ItemWidth * GridLayout.ChildrenCount) / GridLayout.Width) * GridLayout.ItemHeight;
end;

procedure TframeProjects.animMenuEditDelFinish(Sender: TObject);
begin
  if animMenuEditDel.Inverse then
    bottomMenuEditDel.Visible := false;
end;

procedure TframeProjects.btnBackClick(Sender: TObject);
begin
  MainForm.MultiView.ShowMaster;
end;

procedure TframeProjects.OnLongTap(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin

  animMenuEditDel.StartValue := 48;
  animMenuEditDel.StopValue := 0;
  if Not bottomMenuEditDel.Visible then
  begin
    bottomMenuEditDel.Visible := true;
    btnMenuClose.Visible := true;
    animMenuEditDel.Inverse := false;
    animMenuEditDel.Start;
  end;
end;

procedure TframeProjects.OnSelProject(Sender: TObject);
begin
  if NOT btnMenuClose.Visible then
  begin
    MainForm.Project.ID := (Sender as TCornerButton).Tag;
    MainForm.Project.typeLadder := (Sender as TCornerButton).Hint.ToInteger;
    MainForm.frameStartProject := TFrameStartProject.Create(MainForm);
    MainForm.frameStartProject.Parent := MainForm;
    MainForm.frameStartProject.labProjectNumber.Text := (Sender as TCornerButton).StyleName;
    MyFreeAndNil(MainForm.frameProjects);
  end;
end;

procedure TframeProjects.btnMenuCloseClick(Sender: TObject);
begin
  btnMenuClose.Visible := false;
  animMenuEditDel.Inverse := true;
  animMenuEditDel.Start;
end;

procedure TframeProjects.btnNewProjectClick(Sender: TObject);
begin
  MainForm.frameNewProject := TFrameNewProject.Create(MainForm);
  MainForm.frameNewProject.Parent := MainForm;
  MyFreeAndNil(MainForm.frameProjects);
end;

constructor TframeProjects.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ExeActive('select * from projects;');
  tmpQuery.First;
  while NOT tmpQuery.Eof do
    with tmpQuery do
    begin
      CreateNewProjectElement(FieldByName('project_name').AsString, FieldByName('project_id').AsInteger, FieldByName('project_type').AsInteger);
      Next;
    end;
  MyFreeAndNil(tmpQuery);
end;

end.
