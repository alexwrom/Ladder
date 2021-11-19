unit uFrameStartProject;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,uFrameVisual,uLibrary,uFrameInputData;

type
  TFrameStartProject = class(TFrame)
    GridPanelLayout1: TGridPanelLayout;
    Layout1: TLayout;
    Label1: TLabel;
    btnShowInputData: TSpeedButton;
    Image1: TImage;
    Layout2: TLayout;
    Image2: TImage;
    Label2: TLabel;
    btnShowVisualization: TSpeedButton;
    Layout3: TLayout;
    Image3: TImage;
    Label3: TLabel;
    btnShowResult: TSpeedButton;
    ToolBar1: TToolBar;
    ShadowEffect2: TShadowEffect;
    labProjectNumber: TLabel;
    btnBack: TSpeedButton;
    procedure btnShowVisualizationClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnShowInputDataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
 uses Main, uFrameProjects;
{$R *.fmx}

procedure TFrameStartProject.btnBackClick(Sender: TObject);
begin
   MainForm.frameProjects := TFrameProjects.Create(MainForm);
   MainForm.frameProjects.Parent := MainForm;
   MyFreeAndNil(MainForm.frameStartProject);
end;

procedure TFrameStartProject.btnShowInputDataClick(Sender: TObject);
begin
  MainForm.frameInputData := TFrameInputData.Create(MainForm);
  MainForm.frameInputData.PriorForm := pfEdit;
  MainForm.frameInputData.Parent := MainForm;
  MyFreeAndNil(MainForm.frameStartProject);
end;

procedure TFrameStartProject.btnShowVisualizationClick(Sender: TObject);
begin
   MainForm.frameVisual := TframeVisual.Create(MainForm);
   MainForm.frameVisual.Parent := MainForm;
   MainForm.frameVisual.PriorForm := pfEdit;
   MainForm.frameVisual.CreateLadder;
   MyFreeAndNil(MainForm.frameStartProject);
end;

end.
