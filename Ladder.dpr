program Ladder;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  uFrameProjects in 'uFrameProjects.pas' {frameProjects: TFrame},
  uFrameVisual in 'uFrameVisual.pas' {FrameVisual: TFrame},
  uLadderLine in 'uLadderLine.pas',
  uLibrary in 'uLibrary.pas',
  uFrameStartProject in 'uFrameStartProject.pas' {FrameStartProject: TFrame},
  uFrameNewProject in 'uFrameNewProject.pas' {frameNewProject: TFrame},
  uFrameInputData in 'uFrameInputData.pas' {frameInputData: TFrame},
  uFrameDrawing in 'uFrameDrawing.pas' {FrameDrawing: TFrame},
  uLadderLineCalc in 'uLadderLineCalc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
