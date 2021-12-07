unit uFrameDrawing;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,uLadderLineCalc;

type
  TFrameDrawing = class(TFrame)
    ToolBar: TToolBar;
    ShadowEffect1: TShadowEffect;
    Label2: TLabel;
    btnBack: TSpeedButton;
    ListListImg: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation
 uses Main;
{$R *.fmx}

{ TFrameDrawing }

constructor TFrameDrawing.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  case MainForm.Project.typeLadder of
    1:
      begin
         LadderLineCalc;
      end;
  end;

end;

end.
