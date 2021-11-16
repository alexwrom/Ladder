unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList,
  FMX.Objects, FMX.ListBox, uFrameProjects, FMX.MultiView, uFrameVisual, uLibrary, uFrameStartProject, uFrameNewProject,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, IoUtils, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,uFrameInputData,
  FMX.Edit;

type

  TMainForm = class(TForm)
    MultiView: TMultiView;
    SpeedButton1: TSpeedButton;
    Conn: TFDConnection;

    procedure FormCreate(Sender: TObject);
  private


    { Private declarations }
  public
    frameProjects: TframeProjects;
    frameNewProject: TframeNewProject;
    frameVisual: TFrameVisual;
    frameStartProject: TFrameStartProject;
    frameInputData: TFrameInputData;
    Project: rProject; // Project data
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  
  Conn.Connected := false;

{$IFDEF ANDROID}
  Conn.Params.Values['Database'] := IoUtils.TPath.Combine(IoUtils.TPath.GetDocumentsPath, 'base.db');
{$ELSE}
  Conn.Params.Database := ExtractFilePath(paramstr(0)) + '\base.db';
{$ENDIF}
  try
    Conn.Connected := true;
  except
    ShowMessage(GetMessageText(23));
  end;

  frameProjects := TframeProjects.Create(self);
  frameProjects.Parent := self;
end;

end.
