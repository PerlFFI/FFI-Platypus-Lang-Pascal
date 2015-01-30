{ compile with: fpc add.pas                 |
| link with:    gcc -o add.so -shared add.o }

Unit Add;

Interface

Function Add( A: Integer; B: Integer): Integer;
Function Add( A: Real; B: Real ): Real;
Function Add2( A: Integer; B: Integer ): Integer;
Procedure OneArg( I: Integer );
Procedure NoArgs();
Procedure F1(I: Integer);
Procedure F1(R: Real);

Implementation

Function Add( A: Integer; B: Integer) : Integer;
Begin
  Add := A + B;
End;

Function Add2( A: Integer; B: Integer) : Integer;
Begin
  Add2 := A + B;
End;

Function Add( A: Real; B: Real) : Real;
Begin
  Add := A + B;
End;

Procedure OneArg( I: Integer );
Begin
End;

Procedure NoArgs();
Begin
End;

Procedure F1(I:Integer);
Begin
End;

Procedure F1(R:Real);
Begin
End;

End.
