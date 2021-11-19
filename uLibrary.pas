unit uLibrary;

interface
  uses FireDAC.Comp.Client;
type
  rProject = record // Project data record
    ID: integer;
    typeLadder: integer;
  end;

  // ----------------------------------Constants-----------------------------------------
const
  // --typeLadder---
  tlLeft = -1;
  tlRight = 1;
  // --Scale--
  cScale = 200;

  // Скорость вращения
  cSpeed = 0.6;
  // Type elements
  teStep = 1;
  teUnderStep = 2;
  teStringer = 3;
  teFloor = 4;
  teWall = 5;
  teBaluster = 6;
  teHandRail = 7;

  // -- Типы компонентов
  tcGroup = 1;
  tcRadio = 2;
  tcEdit = 3;
  tcCheck = 4;
  tcNumber = 5;

  // -- PriorForm --
  pfAdd = 0;
  pfEdit = 1;
 var
  tmpQuery: TFDQuery;
procedure ExeSQL(SQL: string);
procedure ExeActive(SQL: string);
procedure MyFreeAndNil(var Obj);
function GetMessageText(Code: integer): string;

implementation
uses Main;

procedure ExeActive(SQL: string);

begin
  if tmpQuery = nil then
  begin
    tmpQuery := TFDQuery.Create(nil);
    tmpQuery.Connection := MainForm.Conn;
  end;
  tmpQuery.Active := false;
  tmpQuery.SQL.clear;
  tmpQuery.SQL.Add(SQL);
  tmpQuery.Active := true;
end;

procedure ExeSQL(SQL: string);
var
  tmpQuery: TFDQuery;
begin
  tmpQuery := TFDQuery.Create(nil);
  tmpQuery.Connection := MainForm.Conn;
  tmpQuery.SQL.clear;
  tmpQuery.SQL.Add(SQL);
  tmpQuery.ExecSQL;
  tmpQuery.Free;
end;

procedure MyFreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);

  Pointer(Obj) := nil;
{$IFDEF WINDOWS}
  Temp.Free;
{$ELSE IF}
  Temp.DisposeOf;
{$ENDIF}
end;

function GetMessageText(Code: integer): string;
begin
  result := '';
  case Code of
    1:
      begin
        result := 'База данных недоступна';
      end;

  end;
end;

end.
