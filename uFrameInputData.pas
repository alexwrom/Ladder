unit uFrameInputData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Layouts, uLibrary, FMX.Edit;

type
  TframeInputData = class(TFrame)
    ToolBar: TToolBar;
    ShadowEffect1: TShadowEffect;
    Label2: TLabel;
    btnBack: TSpeedButton;
    vertScroll: TVertScrollBox;
    Layout2: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    btnNext: TSpeedButton;
    btnCancel: TSpeedButton;
  private
    procedure CreateGroupBox(TextName: string; Group: string);
    procedure CreateCheckBox(TextName: string; Value: boolean; Group: string);
    procedure CreateEdit(TextName: string; Group: string);
    procedure CreateRadioItem(TextName: string; Value: boolean; Group: string);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent);
    { Public declarations }
  end;

implementation

uses Main;
{$R *.fmx}

constructor TframeInputData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MainForm.ExeActive('select * from input_data where default_type = ' + MainForm.Project.ID.ToString + ' order by input_type ');
  MainForm.tmpQuery.First;
  while NOT MainForm.tmpQuery.Eof do
  begin
    with MainForm.tmpQuery do
    begin
      case FieldByName('input_type').AsInteger of
        tcGroup:
          begin
            CreateGroupBox(FieldByName('input_name').AsString, FieldByName('input_group').AsString);
          end;
        tcRadio:
          begin
            CreateRadioItem(FieldByName('input_name').AsString, FieldByName('input_data').AsBoolean, FieldByName('input_group').AsString);
          end;
        tcEdit:
          begin
            CreateEdit(FieldByName('input_name').AsString, FieldByName('input_group').AsString);
          end;
        tcCheck:
          begin
            CreateCheckBox(FieldByName('input_name').AsString, FieldByName('input_data').AsBoolean, FieldByName('input_group').AsString);
          end;
      end;
      Next;
    end;
  end;

end;

procedure TframeInputData.CreateGroupBox(TextName: string; Group: string);
begin
  with TGroupBox.Create(self) do
  begin
    Parent := vertScroll;
    Text := TextName;
    Height := 20;
    Padding.Top := 15;
    Padding.Bottom := 5;
    Padding.Left := 5;
    Padding.Right := 5;
    TextSettings.Font.Size := 14;
    Align := TAlignLayout.Top;
    Hint := Group;
  end;
end;

procedure TframeInputData.CreateRadioItem(TextName: string; Value: boolean; Group: string);
var
  I: integer;
begin
  with TRadioButton.Create(self) do
  begin
    Position.Y := self.Height;
    for I := 0 to vertScroll.Content.ChildrenCount - 1 do
      if vertScroll.Content.Controls[I] is TGroupBox then
      begin
        if (vertScroll.Content.Controls[I] as TGroupBox).Hint = Group then
        begin
          Parent := (vertScroll.Content.Controls[I] as TGroupBox);
          (vertScroll.Content.Controls[I] as TGroupBox).Height := (vertScroll.Content.Controls[I] as TGroupBox).Height + 30;
          break;
        end;
      end;

    if Parent = nil then
      Parent := vertScroll;

    Height := 30;
    Text := TextName;
    TextSettings.Font.Size := 14;
    IsChecked := Value;
    GroupName := Group;
    Align := TAlignLayout.Top;
  end;
end;

procedure TframeInputData.CreateEdit(TextName: string; Group: string);
var
  I: integer;
  Par: TGroupBox;
begin
  Par := nil;
  with TLabel.Create(self) do
  begin
    Position.Y := self.Height;
    for I := 0 to vertScroll.Content.ChildrenCount - 1 do
      if vertScroll.Content.Controls[I] is TGroupBox then
      begin
        if (vertScroll.Content.Controls[I] as TGroupBox).Hint = Group then
        begin
          Par := (vertScroll.Content.Controls[I] as TGroupBox);
          Par.Height := Par.Height + 20;
          Parent := Par;
          break;
        end;
      end;

    if Par = nil then
      Parent := vertScroll;
    Height := 20;
    Text := TextName + ':';
    TextSettings.Font.Size := 14;
    Align := TAlignLayout.Top;
  end;

  with TEdit.Create(self) do
  begin
    Position.Y := self.Height;
    if Par = nil then
      Parent := vertScroll
  else
  begin
    Parent := Par;
    Par.Height := Par.Height + 25;
  end;

  Height := 25;
  TextSettings.Font.Size := 14;
  Align := TAlignLayout.Top;
end;

end;

procedure TframeInputData.CreateCheckBox(TextName: string; Value: boolean; Group: string);
var
  I: integer;
begin
  with TCheckBox.Create(self) do
  begin
    Position.Y := self.Height;
    for I := 0 to vertScroll.Content.ChildrenCount - 1 do
      if vertScroll.Content.Controls[I] is TGroupBox then
      begin
        if (vertScroll.Content.Controls[I] as TGroupBox).Hint = Group then
        begin
          Parent := (vertScroll.Content.Controls[I] as TGroupBox);
          (vertScroll.Content.Controls[I] as TGroupBox).Height := (vertScroll.Content.Controls[I] as TGroupBox).Height + 30;
          break;
        end;
      end;

    if Parent = nil then
      Parent := vertScroll;

    Height := 30;
    Text := TextName;
    IsChecked := Value;
    TextSettings.Font.Size := 14;
    Align := TAlignLayout.Top;
  end;
end;

end.
