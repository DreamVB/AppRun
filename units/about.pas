unit about;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { Tfrmabout }

  Tfrmabout = class(TForm)
    cmdOk: TButton;
    Image1: TImage;
    lblTitle: TLabel;
    lblVer: TLabel;
    lblInfo: TLabel;
    lblDevOp: TLabel;
    procedure cmdOkClick(Sender: TObject);
  private

  public

  end;

var
  frmabout: Tfrmabout;

implementation

{$R *.lfm}

{ Tfrmabout }

procedure Tfrmabout.cmdOkClick(Sender: TObject);
begin
  Close;
end;

end.
