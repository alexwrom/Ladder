unit uFrameInputData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, StrUtils,
  FMX.Effects, FMX.Controls.Presentation, FMX.Layouts, uLibrary, FMX.Edit, FMX.SpinBox, uFrameVisual;

type
  TframeInputData = class(TFrame)
    vertScroll: TVertScrollBox;
    Layout2: TLayout;
    btnNext: TSpeedButton;
    ToolBar: TToolBar;
    ShadowEffect2: TShadowEffect;
    Label11: TLabel;
    btnBack: TSpeedButton;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    procedure CreateGroupBox(TextName: string; Group: string);
    procedure CreateCheckBox(TextName, Key: string; DataValue: boolean; Group: string);
    procedure CreateEdit(TextName, Key, DataValue: string; Group: string);
    procedure CreateRadioItem(TextName, Key: string; DataValue: boolean; Group: string);
    procedure CreateSpinBox(TextName, Key: string; DataValue: integer; Group: string);
    procedure SaveDataToBase;
    { Private declarations }
  public
    PriorForm: integer;
    constructor Create(AOwner: TComponent);
    { Public declarations }
  end;

implementation

uses Main, uFrameNewProject, uFrameStartProject;
{$R *.fmx}

procedure TframeInputData.SaveDataToBase;
var
  I: integer;
  InKey: string;
  Hint: string;
  j: integer;
begin
  if MainForm.Project.ID = 0 then
  begin
    ExeSQL('insert into projects (project_name, project_type) values  ('''',' + MainForm.Project.typeLadder.ToString + ')');
    ExeActive('select MAX(project_id) as id from projects');
    MainForm.Project.ID := tmpQuery.FieldByName('ID').AsInteger;
    ExeSQL('update projects set project_name = ''Project # '' || project_id where project_id = ' + MainForm.Project.ID.ToString);
    ExeSQL('insert into input_data (input_key, project_id ,input_name,input_type, input_group,value, default_type,sort)' + ' select input_key,' + MainForm.Project.ID.ToString +
      ' ,input_name,input_type, input_group,value, default_type,sort from input_data where default_type = ' + MainForm.Project.typeLadder.ToString + ' and project_id = 0');

  end;
  for I := 0 to vertScroll.Content.ChildrenCount - 1 do
    if (vertScroll.Content.Controls[I] is TLabel) and (vertScroll.Content.Controls[I].Hint <> '') then
      for j := 0 to (vertScroll.Content.Controls[I] as TLabel).ChildrenCount - 1 do
      begin
        Hint := '';
        if (vertScroll.Content.Controls[I] as TLabel).Children[j] is TRadioButton then
        begin
          InKey := IfThen(((vertScroll.Content.Controls[I] as TLabel).Children[j] as TRadioButton).isChecked, 'true', 'false');
          Hint := ((vertScroll.Content.Controls[I] as TLabel).Children[j] as TRadioButton).Hint;
        end;

        if (vertScroll.Content.Controls[I] as TLabel).Children[j] is TEdit then
        begin
          InKey := ((vertScroll.Content.Controls[I] as TLabel).Children[j] as TEdit).Text;
          Hint := ((vertScroll.Content.Controls[I] as TLabel).Children[j] as TEdit).Hint;
        end;

        if (vertScroll.Content.Controls[I] as TLabel).Children[j] is TCheckBox then
        begin
          InKey := IfThen(((vertScroll.Content.Controls[I] as TLabel).Children[j] as TCheckBox).isChecked, 'true', 'false');
          Hint := ((vertScroll.Content.Controls[I] as TLabel).Children[j] as TCheckBox).Hint;
        end;

        if (vertScroll.Content.Controls[I] as TLabel).Children[j] is TSpinbox then
        begin
          InKey := ((vertScroll.Content.Controls[I] as TLabel).Children[j] as TSpinbox).Value.ToString;
          Hint := ((vertScroll.Content.Controls[I] as TLabel).Children[j] as TSpinbox).Hint;
        end;

        if Hint <> '' then
          ExeSQL('update input_data set value = ''' + InKey + '''  where input_key = ''' + Hint + ''' and project_id = ' + MainForm.Project.ID.ToString);
      end;
end;

procedure TframeInputData.btnBackClick(Sender: TObject);
begin
  MessageDlg('Введенные данные будут потеряны. Продолжить?', TMsgDlgType.mtWarning, mbYesNo, 0,
    procedure(const AResult: TModalResult)
    var
      ID: integer;
    begin
      if (AResult = mrYes) then
      begin
        case PriorForm of
          pfAdd:
            begin
              MainForm.frameNewProject := TframeNewProject.Create(MainForm);
              MainForm.frameNewProject.Parent := MainForm;
            end;
          pfEdit:
            begin
              MainForm.frameStartProject := TFrameStartProject.Create(MainForm);
              MainForm.frameStartProject.Parent := MainForm;
            end;
        end;

        MyFreeAndNil(MainForm.frameInputData);
      end;
    end);
end;

procedure TframeInputData.btnNextClick(Sender: TObject);
begin
  SaveDataToBase;
  MainForm.frameVisual := TframeVisual.Create(MainForm);
  MainForm.frameVisual.Parent := MainForm;
  if MainForm.Project.ID = 0 then
    MainForm.frameVisual.PriorForm := pfAdd
  else
    MainForm.frameVisual.PriorForm := pfEdit;
  MainForm.frameVisual.CreateLadder;
  MyFreeAndNil(MainForm.frameInputData);
end;

constructor TframeInputData.Create(AOwner: TComponent); // Constructor
begin
  inherited Create(AOwner);
  ExeActive('select * from input_data where default_type = ' + MainForm.Project.typeLadder.ToString + ' and project_id = ' + MainForm.Project.ID.ToString + ' order by input_group,sort ');
  tmpQuery.First;
  while NOT tmpQuery.Eof do
  begin
    with tmpQuery do
    begin
      case FieldByName('input_type').AsInteger of
        tcGroup:
          begin
            CreateGroupBox(FieldByName('input_name').AsString, FieldByName('input_group').AsString);
          end;
        tcRadio:
          begin
            CreateRadioItem(FieldByName('input_name').AsString, FieldByName('input_key').AsString, FieldByName('value').AsBoolean, FieldByName('input_group').AsString);
          end;
        tcEdit:
          begin
            CreateEdit(FieldByName('input_name').AsString, FieldByName('input_key').AsString, FieldByName('value').AsString, FieldByName('input_group').AsString);
          end;
        tcCheck:
          begin
            CreateCheckBox(FieldByName('input_name').AsString, FieldByName('input_key').AsString, FieldByName('value').AsBoolean, FieldByName('input_group').AsString);
          end;
        tcnumber:
          begin
            CreateSpinBox(FieldByName('input_name').AsString, FieldByName('input_key').AsString, FieldByName('value').AsInteger, FieldByName('input_group').AsString);
          end;
      end;
      Next;
    end;
  end;

end;

procedure TframeInputData.CreateGroupBox(TextName: string; Group: string);
begin
  with TLabel.Create(self) do
  begin
    Parent := vertScroll;
    StyledSettings := [];
    Text := TextName;
    Height := 20;
    Padding.Top := 15;
    Padding.Bottom := 5;
    Padding.Left := 15;
    Padding.Right := 5;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Style := [TFontStyle.fsBold];
    TextSettings.VertAlign := TTextAlign.Leading;
    TextSettings.FontColor := TAlphaColors.Brown;
    Align := TAlignLayout.Top;
    ShowHint := false;
    Hint := Group;
  end;
end;

procedure TframeInputData.CreateRadioItem(TextName, Key: string; DataValue: boolean; Group: string);
var
  I: integer;
begin
  with TRadioButton.Create(self) do
  begin
    Position.Y := self.Height;
    StyledSettings := [];
    Text := TextName;
    TextSettings.Font.Size := 12;
    TextSettings.FontColor := TAlphaColors.Brown;
    Height := 30;
    isChecked := DataValue;
    GroupName := Group;
    Align := TAlignLayout.Top;
    ShowHint := false;
    Hint := Key;
    if Group <> '' then
      for I := 0 to vertScroll.Content.ChildrenCount - 1 do
        if vertScroll.Content.Controls[I] is TLabel then
        begin
          if (vertScroll.Content.Controls[I] as TLabel).Hint = Group then
          begin
            Parent := (vertScroll.Content.Controls[I] as TLabel);
            (vertScroll.Content.Controls[I] as TLabel).Height := (vertScroll.Content.Controls[I] as TLabel).Height + Height;
            break;
          end;
        end;

    if Parent = nil then
      Parent := vertScroll;
  end;
end;

procedure TframeInputData.CreateEdit(TextName, Key, DataValue: string; Group: string);
var
  I: integer;
  Par: TLabel;
begin
  Par := nil;
  with TLabel.Create(self) do
  begin
    Position.Y := self.Height;
    StyledSettings := [];
    Height := 15;
    Text := TextName + ':';
    TextSettings.FontColor := TAlphaColors.Brown;
    TextSettings.Font.Style := [TFontStyle.fsBold];
    TextSettings.Font.Size := 12;
    Align := TAlignLayout.Top;
    if Group <> '' then
      for I := 0 to vertScroll.Content.ChildrenCount - 1 do
        if vertScroll.Content.Controls[I] is TLabel then
        begin
          if (vertScroll.Content.Controls[I] as TLabel).Hint = Group then
          begin
            Par := (vertScroll.Content.Controls[I] as TLabel);
            Par.Height := Par.Height + Height;
            Parent := Par;
            break;
          end;
        end;

    if Par = nil then
      Parent := vertScroll;

  end;

  with TEdit.Create(self) do
  begin
    Position.Y := self.Height;
    StyledSettings := [];
    TextSettings.Font.Size := 12;
    KeyboardType := TVirtualKeyboardType.NumbersAndPunctuation;
    TextSettings.FontColor := TAlphaColors.Brown;
    Align := TAlignLayout.Top;
    Margins.Right := 40;
    TextPrompt := '0 мм';
    Text := DataValue;
    ShowHint := false;
    Hint := Key;

    if Par = nil then
      Parent := vertScroll
    else
    begin
      Parent := Par;
      Par.Height := Par.Height + Height;
    end;

  end;

end;

procedure TframeInputData.CreateCheckBox(TextName, Key: string; DataValue: boolean; Group: string);
var
  I: integer;
begin
  with TCheckBox.Create(self) do
  begin
    Position.Y := self.Height;
    StyledSettings := [];
    Text := TextName;
    isChecked := DataValue;
    TextSettings.Font.Size := 12;
    TextSettings.FontColor := TAlphaColors.Brown;
    Align := TAlignLayout.Top;
    Height := 25;
    ShowHint := false;
    Hint := Key;

    if Group <> '' then
      for I := 0 to vertScroll.Content.ChildrenCount - 1 do
        if vertScroll.Content.Controls[I] is TLabel then
        begin
          if (vertScroll.Content.Controls[I] as TLabel).Hint = Group then
          begin
            Parent := (vertScroll.Content.Controls[I] as TLabel);
            (vertScroll.Content.Controls[I] as TLabel).Height := (vertScroll.Content.Controls[I] as TLabel).Height + Height;
            break;
          end;
        end;

    if Parent = nil then
      Parent := vertScroll;

  end;
end;

procedure TframeInputData.CreateSpinBox(TextName, Key: string; DataValue: integer; Group: string);
var
  I: integer;
  Par: TLabel;
  tmpSpin: TSpinbox;
begin
  Par := nil;
  with TLabel.Create(self) do
  begin
    Position.Y := self.Height;
    StyledSettings := [];
    Height := 15;
    Text := TextName + ':';
    TextSettings.Font.Size := 12;
    TextSettings.Font.Style := [TFontStyle.fsBold];
    TextSettings.FontColor := TAlphaColors.Brown;
    Align := TAlignLayout.Top;
    if Group <> '' then
      for I := 0 to vertScroll.Content.ChildrenCount - 1 do
        if vertScroll.Content.Controls[I] is TLabel then
        begin
          if (vertScroll.Content.Controls[I] as TLabel).Hint = Group then
          begin
            Par := (vertScroll.Content.Controls[I] as TLabel);
            Par.Height := Par.Height + Height;
            Parent := Par;
            break;
          end;
        end;

    if Par = nil then
      Parent := vertScroll;

  end;
  tmpSpin := TSpinbox.Create(self);
  with tmpSpin do
  begin
    Position.Y := self.Height;
    StyledSettings := [];
    TextSettings.Font.Size := 12;
    TextSettings.FontColor := TAlphaColors.Brown;
    Align := TAlignLayout.Top;
    Margins.Right := 40;
    tmpSpin.Max := 30;
    tmpSpin.Min := 1;
    Value := DataValue;
    ShowHint := false;
    Hint := Key;
    if Par = nil then
      Parent := vertScroll
    else
    begin
      Parent := Par;
      Par.Height := Par.Height + Height;
    end;

  end;
end;

end.
