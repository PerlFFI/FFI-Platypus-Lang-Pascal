{ compile and link with: fpc state.pas }

Library State;

var
  LastIdentifier: Integer;

Procedure SetLastIdentifier(Id: Integer); Cdecl;
Begin
  LastIdentifier := Id;
End;

Function GetNextIdentifier(): Integer; Cdecl;
Begin
  LastIdentifier := LastIdentifier + 1;
  GetNextIdentifier := LastIdentifier;
End;

Exports
  SetLastIdentifier,
  GetNextIdentifier;

Initialization
  LastIdentifier := 0;

End.

