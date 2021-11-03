unit uLibrary;

interface

type
  rProject = record // Project data record
    ID: integer;
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

function GetMessageText(Code: integer): string;

implementation

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
