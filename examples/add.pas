{ compile with: fpc add.pas                 |
| link with:    gcc -o add.so -shared add.o }

Unit Add;

Interface

Function Add( A: Integer; B: Integer) : Integer;

Implementation

Function Add( A: Integer; B: Integer) : Integer;
Begin
  Add := A + B;
End;

End.
