unit Tools;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function FixPath(S: string): string;
function GetFileTitle(S: string): string;
function IsVailFName(S: string): boolean;

var
  BasePath: string;
  ButtonPress: integer;

implementation

function IsVailFName(S: string): boolean;
var
  flag: boolean;
  X: integer;
begin
  flag := True;

  for X := 1 to Length(S) do
  begin
    if not (S[X] in ['a'..'z', 'A'..'Z', '0'..'9', '_', ' ']) then
    begin
      flag := False;
      Break;
    end;
  end;
  Result := flag;
end;

function FixPath(S: string): string;
begin
  if rightstr(S, 1) <> PathDelim then
  begin
    Result := S + PathDelim;
  end
  else
  begin
    Result := S;
  end;
end;

function GetFileTitle(S: string): string;
var
  sPos: integer;
begin
  Result := S;
  sPos := LastDelimiter('.', S);
  if sPos > 0 then
  begin
    Result := LeftStr(S, sPos - 1);
  end;
end;

end.
