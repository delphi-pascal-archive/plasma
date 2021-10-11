program Plasma;

uses
  Forms,
  Unitprinc in 'Unitprinc.pas' {FormPrinc};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrinc, FormPrinc);
  Application.Run;
end.
