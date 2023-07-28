{ compile and link with: fpc arrays.pas }

Library Arrays;

type
  TStaticArr = Array [0 .. 2] of Integer;
  TDynamicArr = Array of Integer;

Procedure PrintArray(Vals: Array of Integer);
var
  I: Integer;
Begin
  Write('[');

  for I := Low(Vals) to High(Vals) do
    Write(Vals[I], ', ');

  WriteLn(']');
End;

Procedure PrintDynamicArr(Vals: TDynamicArr; Size: Integer); Cdecl;
Begin
  WriteLn('Dynamic array ', Low(Vals), ' .. ', High(Vals), ' (size ', Length(Vals), '):');
  if Length(Vals) <> Size then Begin
    WriteLn('Need resizing to ', Size);
    SetLength(Vals, Size);
  End;

  PrintArray(Vals);
End;

Procedure PrintStaticArr(Vals: TStaticArr); Cdecl;
Begin
  WriteLn('Static array:');
  PrintArray(Vals);
End;

Exports
  PrintStaticArr,
  PrintDynamicArr;

End.

