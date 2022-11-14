unit appmove;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Tools;

type

  { TfrmMoveTo }

  TfrmMoveTo = class(TForm)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboGroups: TComboBox;
    lblGroups: TLabel;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
  private

  public

  end;

var
  frmMoveTo: TfrmMoveTo;

implementation

{$R *.lfm}

{ TfrmMoveTo }

procedure TfrmMoveTo.cmdOKClick(Sender: TObject);
begin
  if cboGroups.ItemIndex > -1 then
  begin
    Tools.ButtonPress := 1;
    Close;
  end;
end;

procedure TfrmMoveTo.cmdCancelClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

end.
