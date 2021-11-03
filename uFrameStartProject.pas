unit uFrameStartProject;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,uFrameVisual;

type
  TFrameStartProject = class(TFrame)
    ToolBar: TToolBar;
    ShadowEffect1: TShadowEffect;
    labProjectNumber: TLabel;
    btnBack: TSpeedButton;
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
    procedure btnShowVisualizationClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
 uses Main;
{$R *.fmx}

procedure TFrameStartProject.btnShowVisualizationClick(Sender: TObject);
begin
   MainForm.frameVisual := TframeVisual.Create(MainForm);
   MainForm.frameVisual.Parent := MainForm;
   MainForm.frameVisual.CreateLadder;
end;

end.
