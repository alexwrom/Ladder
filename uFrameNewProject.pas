unit uFrameNewProject;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Layouts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,uFrameInputData,uLibrary;

type
  TframeNewProject = class(TFrame)
    ToolBar: TToolBar;
    ShadowEffect1: TShadowEffect;
    Label2: TLabel;
    btnBack: TSpeedButton;
    VertScrollBox1: TVertScrollBox;
    GridLayout: TGridLayout;
    layLadder1: TLayout;
    Label1: TLabel;
    btnLadderLine: TCornerButton;
    Layout2: TLayout;
    Label3: TLabel;
    Image1: TImage;
    layLadder2: TLayout;
    CornerButton2: TCornerButton;
    Label4: TLabel;
    Image2: TImage;
    layLadder3: TLayout;
    CornerButton3: TCornerButton;
    Label5: TLabel;
    Image3: TImage;
    layLadder4: TLayout;
    CornerButton4: TCornerButton;
    Label6: TLabel;
    Image4: TImage;
    layLadder5: TLayout;
    CornerButton5: TCornerButton;
    Label7: TLabel;
    Image5: TImage;
    layLadder6: TLayout;
    CornerButton6: TCornerButton;
    Label8: TLabel;
    Image6: TImage;
    layLadder7: TLayout;
    Image7: TImage;
    CornerButton7: TCornerButton;
    Label9: TLabel;
    layLadder8: TLayout;
    Image8: TImage;
    CornerButton8: TCornerButton;
    Label10: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    btnCancel: TSpeedButton;
    btnNext: TSpeedButton;
    recSelType: TRectangle;
    procedure OnSelTypeProject(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Main;
{$R *.fmx}

procedure TframeNewProject.btnNextClick(Sender: TObject);
begin
   MainForm.Project.ID := 0;
   MainForm.Project.typeLadder := (recSelType.Parent as TCornerButton).Tag;

    MainForm.frameInputData := TFrameInputData.Create(MainForm);
    MainForm.frameInputData.Parent := MainForm;
    MyFreeAndNil(MainForm.frameNewProject);
end;

procedure TframeNewProject.OnSelTypeProject(Sender: TObject);
begin
    recSelType.Parent := Sender as TCornerButton;
    recSelType.Visible := true;
end;

end.
