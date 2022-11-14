program apprun;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
    {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
    {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  lazcontrols,
  main,
  Tools,
  newapp,
  appmove,
  about;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmmain, frmmain);
  Application.CreateForm(TfrmAddApp, frmAddApp);
  Application.CreateForm(TfrmMoveTo, frmMoveTo);
  Application.CreateForm(Tfrmabout, frmabout);
  Application.Run;
end.
