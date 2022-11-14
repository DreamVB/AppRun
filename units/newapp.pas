unit newapp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, EditBtn, Tools,
  StdCtrls;

type

  { TfrmAddApp }

  TfrmAddApp = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    lblBitmap: TLabel;
    txtFilename: TFileNameEdit;
    Label1: TLabel;
    lblCaption: TLabeledEdit;
    txtBitmap: TFileNameEdit;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblCaptionChange(Sender: TObject);
    procedure lblCaptionKeyPress(Sender: TObject; var Key: char);
    procedure txtFilenameKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmAddApp: TfrmAddApp;

implementation

{$R *.lfm}

{ TfrmAddApp }

procedure TfrmAddApp.FormCreate(Sender: TObject);
begin

end;

procedure TfrmAddApp.lblCaptionChange(Sender: TObject);
begin
  cmdOK.Enabled := Trim(lblCaption.Caption) <> '';
end;

procedure TfrmAddApp.lblCaptionKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) and (cmdOK.Enabled) then
  begin
    Key := #0;
    cmdOKClick(Sender);
  end;
end;

procedure TfrmAddApp.txtFilenameKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) and (cmdOK.Enabled) then
  begin
    cmdOKClick(Sender);
  end;
end;

procedure TfrmAddApp.cmdOKClick(Sender: TObject);
begin
  ButtonPress := 1;
  Close;
end;

procedure TfrmAddApp.cmdCloseClick(Sender: TObject);
begin
  ButtonPress := 0;
  Close;
end;

end.
