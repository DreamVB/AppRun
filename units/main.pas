unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus, Tools, newapp,
  IniFiles, lclintf, appmove, FileUtil, FileBag, about;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    ImageList1: TImageList;
    mnuRemoveAppApps: TMenuItem;
    mnuAppRemoveAll: TMenuItem;
    mnuRunAllApps: TMenuItem;
    mnuAppRunAll: TMenuItem;
    mnuAbout: TMenuItem;
    mnuHelp: TMenuItem;
    mnuRestore: TMenuItem;
    Separator6: TMenuItem;
    mnuBackup: TMenuItem;
    mnuRefreshApps: TMenuItem;
    mnuAppRefresh: TMenuItem;
    mnuImportGrp: TMenuItem;
    mnuExportGrp: TMenuItem;
    Separator5: TMenuItem;
    mnuExit: TMenuItem;
    mnuFile: TMenuItem;
    mnuOpenAppPath: TMenuItem;
    mnuAppOpenPath: TMenuItem;
    mnuRunApp: TMenuItem;
    Separator4: TMenuItem;
    mnuAppMoveTo1: TMenuItem;
    Separator3: TMenuItem;
    mnuAppMoveTo: TMenuItem;
    Separator2: TMenuItem;
    mnuApps: TMenuItem;
    mnuAppAdd1: TMenuItem;
    mnuAppEdit1: TMenuItem;
    mnuAddRem1: TMenuItem;
    mnuGRename: TMenuItem;
    mnuGRemove: TMenuItem;
    mnuGAdd: TMenuItem;
    mnuGroup: TMenuItem;
    mnuMain: TMainMenu;
    mnuAppRun: TMenuItem;
    Separator1: TMenuItem;
    mnuAppRemove: TMenuItem;
    mnuAppEdit: TMenuItem;
    mnuAppAdd: TMenuItem;
    PageCtrl: TPageControl;
    LstMenu: TPopupMenu;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ListView1KeyPress(Sender: TObject; var Key: char);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure LstMenuPopup(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuAddRem1Click(Sender: TObject);
    procedure mnuAppAdd1Click(Sender: TObject);
    procedure mnuAppEdit1Click(Sender: TObject);
    procedure mnuAppMoveTo1Click(Sender: TObject);
    procedure mnuAppMoveToClick(Sender: TObject);
    procedure mnuAppOpenPathClick(Sender: TObject);
    procedure mnuAppRefreshClick(Sender: TObject);
    procedure mnuAppRemoveAllClick(Sender: TObject);
    procedure mnuAppRunAllClick(Sender: TObject);
    procedure mnuAppsClick(Sender: TObject);
    procedure mnuAppAddClick(Sender: TObject);
    procedure mnuAppEditClick(Sender: TObject);
    procedure mnuAppRemoveClick(Sender: TObject);
    procedure mnuAppRunClick(Sender: TObject);
    procedure mnuBackupClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuExportGrpClick(Sender: TObject);
    procedure mnuGAddClick(Sender: TObject);
    procedure mnuGRemoveClick(Sender: TObject);
    procedure mnuGRenameClick(Sender: TObject);
    procedure mnuImportGrpClick(Sender: TObject);
    procedure mnuOpenAppPathClick(Sender: TObject);
    procedure mnuRefreshAppsClick(Sender: TObject);
    procedure mnuRemoveAppAppsClick(Sender: TObject);
    procedure mnuRestoreClick(Sender: TObject);
    procedure mnuRunAllAppsClick(Sender: TObject);
    procedure mnuRunAppClick(Sender: TObject);
    procedure PageCtrlChange(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    procedure LoadAppTabs;
    procedure AddApps(lv: TListView; Filename: string);
    function GetLV: TListView;
    procedure OnItemSelect(Sender: TObject; Item: TListItem; Selected: boolean);
    procedure LVOnClick(Sender: TObject);
    procedure LVDblClick(Sender: TObject);
    function GetExecFile(Filename, Selection: string): string;
    function GetBitmapFile(Filename, Selection: string): string;
    procedure SaveApp(Filename, Selection, BitmapFile, ExecFile: string);
    procedure AppAddItem(sCaption: string);
    procedure AppEditItem(Filename, oldSelection, NewSelection, BitmapFile,
      ExeFile: string);
    procedure AppRemoveItem(Filename, sCaption: string);
    procedure AddAppTab(Filename, sCaption: string);
  public

  end;

var
  frmmain: Tfrmmain;
  lSelectedItem: TListItem;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.AppAddItem(sCaption: string);
var
  lv: TListItem;
begin
  //Add a new app item to the listview in the tab control
  lv := GetLV.Items.Add;
  //Caption
  lv.Caption := sCaption;
  //Default icon
  lv.ImageIndex := 0;
end;

procedure Tfrmmain.AppEditItem(Filename, oldSelection, NewSelection,
  BitmapFile, ExeFile: string);
var
  ini: TIniFile;
begin
  //This renames an exsiting app item
  ini := TIniFile.Create(Filename);
  //Remove the old selection
  ini.EraseSection(oldSelection);
  //Rewrite the same data to the ini with a new selection and exec value
  ini.WriteString(NewSelection, 'exec', ExeFile);
  ini.WriteString(NewSelection, 'Bitmap', BitmapFile);
end;

procedure Tfrmmain.AppRemoveItem(Filename, sCaption: string);
var
  ini: TIniFile;
begin
  //Remove an exsiting app item
  ini := TIniFile.Create(Filename);
  //Delete the selection in the ini file.
  ini.EraseSection(sCaption);
end;

procedure Tfrmmain.SaveApp(Filename, Selection, BitmapFile, ExecFile: string);
var
  ini: TIniFile;
begin
  //Add a new app to the ini file.
  ini := TIniFile.Create(Filename);
  ini.WriteString(Selection, 'exec', ExecFile);
  ini.WriteString(Selection, 'bitmap', BitmapFile);
end;

function Tfrmmain.GetExecFile(Filename, Selection: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(Filename);
  Result := ini.ReadString(Selection, 'exec', '');
end;

function Tfrmmain.GetBitmapFile(Filename, Selection: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(Filename);
  Result := ini.ReadString(Selection, 'bitmap', '');
end;

procedure Tfrmmain.AddAppTab(Filename, sCaption: string);
var
  ts: TTabSheet;
  lv: TListView;
begin
  ts := TTabSheet.Create(PageCtrl);
  ts.Parent := PageCtrl;
  ts.Caption := sCaption;
  ts.Hint := Filename;
  ts.ShowHint := False;
  //Create listview
  lv := TListView.Create(ts);
  lv.Parent := ts;
  lv.Align := alClient;
  lv.ViewStyle := vsIcon;
  lv.ReadOnly := True;
  lv.LargeImages := ImageList1;
  lv.PopupMenu := LstMenu;
  lv.OnSelectItem := @OnItemSelect;
  lv.OnClick := @LVOnClick;
  lv.OnDblClick := @LVDblClick;
end;

procedure Tfrmmain.LVDblClick(Sender: TObject);
var
  lzExec: string;
begin
  if (lSelectedItem <> nil) then
  begin
    if lSelectedItem.Selected then
    begin
      //Get executable file
      lzExec := GetExecFile(PageCtrl.ActivePage.Hint, lSelectedItem.Caption);
      //Open the file
      if not OpenDocument(lzExec) then
      begin
        MessageDlg(Text, 'There was an error executing the application..',
          mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure Tfrmmain.LVOnClick(Sender: TObject);
begin

end;

procedure Tfrmmain.OnItemSelect(Sender: TObject; Item: TListItem; Selected: boolean);
begin
  if Item <> nil then
  begin
    lSelectedItem := item;
  end;
end;

function Tfrmmain.GetLV: TListView;
begin
  //Return a TListView Object
  Result := PageCtrl.ActivePage.Controls[0] as TListView;
end;

procedure TFrmmain.AddApps(lv: TListView; Filename: string);
var
  ini: TIniFile;
  sl: TStringList;
  X: integer;
  li: TListItem;
  bmp: TBitmap;
  lzBitmapFile: string;
begin
  //Create ini obj
  ini := TIniFile.Create(Filename);
  //Create string list obj
  sl := TStringList.Create;
  //Read all selections in ini
  ini.ReadSections(sl);

  if sl.Count > 0 then
  begin
    //Clear list items
    lv.Clear;
    //Clear the image list
    ImageList1.Clear;
    //Load the images
    for X := 0 to sl.Count - 1 do
    begin
      lzBitmapFile := GetBitmapFile(Filename, sl[X]);
      bmp := TBitmap.Create;
      bmp.LoadFromFile(lzBitmapFile);
      ImageList1.Add(bmp, nil);
    end;
    for X := 0 to sl.Count - 1 do
    begin
      //Add listview item
      li := lv.Items.Add;
      li.Caption := sl[x];
      li.ImageIndex := X;
    end;
    //Clear up
    FreeAndNil(sl);
  end;
end;

procedure Tfrmmain.LoadAppTabs;
var
  ts: TTabSheet;
  lv: TListView;
  sr: TSearchRec;
  FileName: string;
  X: integer;
begin

  if PageCtrl.PageCount > 0 then
  begin
    //Desrtrory the tabs
    for X := PageCtrl.PageCount - 1 to 0 do
    begin
      PageCtrl.Pages[X].Free;
    end;
  end;
  //Search the data path for ini files.
  if FindFirst(BasePath + '*.ini', faAnyFile, sr) = 0 then
  begin
    repeat
      //ini file
      FileName := BasePath + sr.Name;
      //Create the tab sheet for tab control
      ts := TTabSheet.Create(PageCtrl);
      ts.Parent := PageCtrl;
      ts.Caption := GetFileTitle(sr.Name);
      ts.Hint := FileName;
      ts.ShowHint := False;
      //Create listview to place on the tabsheet
      lv := TListView.Create(ts);
      lv.Parent := ts;
      lv.Align := alClient;
      lv.ViewStyle := vsIcon;
      lv.ReadOnly := True;
      lv.LargeImages := ImageList1;
      lv.PopupMenu := LstMenu;
      lv.OnSelectItem := @OnItemSelect;
      lv.OnClick := @LVOnClick;
      lv.OnDblClick := @LVDblClick;
    until FindNext(sr) <> 0;
  end;
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  BasePath := FixPath(ExtractFileDir(Application.ExeName)) + 'data' + PathDelim;

  if not DirectoryExists(BasePath) then
  begin
    CreateDir(BasePath);
  end;
  //Load the items into the tabs listview.
  LoadAppTabs;

  //Test if we have any tabs on the tab control
  if PageCtrl.PageCount > 0 then
  begin
    //Select tab
    PageCtrlChange(Sender);
    GetLV.IconOptions.AutoArrange := True;
  end;

end;

procedure Tfrmmain.ListView1Click(Sender: TObject);
begin

end;

procedure Tfrmmain.ListView1DblClick(Sender: TObject);
begin

end;

procedure Tfrmmain.ListView1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

end;

procedure Tfrmmain.ListView1KeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tfrmmain.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin

end;

procedure Tfrmmain.LstMenuPopup(Sender: TObject);
begin
end;

procedure Tfrmmain.mnuAboutClick(Sender: TObject);
var
  frm: Tfrmabout;
begin
  frm := Tfrmabout.Create(self);
  frm.ShowModal;
  frm.Destroy;
end;

procedure Tfrmmain.mnuAddRem1Click(Sender: TObject);
begin
  mnuAppRemoveClick(Sender);
end;

procedure Tfrmmain.mnuAppAdd1Click(Sender: TObject);
begin
  mnuAppAddClick(Sender);
end;

procedure Tfrmmain.mnuAppEdit1Click(Sender: TObject);
begin
  mnuAppEditClick(Sender);
end;

procedure Tfrmmain.mnuAppMoveTo1Click(Sender: TObject);
begin
  mnuAppMoveToClick(Sender);
end;

procedure Tfrmmain.mnuAppMoveToClick(Sender: TObject);
var
  frm: TfrmMoveTo;
  sSel, NewGroup: string;
  lzOldFile, lzNewFile: string;
  X: integer;
begin
  lzOldFile := '';
  lzNewFile := '';

  if assigned(PageCtrl.ActivePage) and (lSelectedItem <> nil) and
    (lSelectedItem.Selected) then
  begin
    ButtonPress := 0;
    //Old ini file we are moving the app from
    lzOldFile := PageCtrl.ActivePage.Hint;

    frm := TfrmMoveTo.Create(self);
    //Add the groups to the combo box
    sSel := PageCtrl.ActivePage.Caption;

    //Fill the form combobox with the group names except the group name we are
    //moving from
    for X := 0 to PageCtrl.PageCount - 1 do
    begin
      if lowercase(sSel) <> lowercase(PageCtrl.Pages[X].Caption) then
      begin
        frm.cboGroups.Items.Add(PageCtrl.Pages[X].Caption);
      end;
    end;

    //Set combobox enabled state
    frm.cboGroups.Enabled := frm.cboGroups.Items.Count > 0;
    //Show the form
    frm.ShowModal;

    //Check button press is 1
    if ButtonPress = 1 then
    begin
      NewGroup := frm.cboGroups.Items[frm.cboGroups.ItemIndex];
      //Add the app to the new group and remove the exsiting one
      //also remove the selected list item

      //Path to move the item to
      lzNewFile := BasePath + NewGroup + '.ini';
      //Save the app in the ini file above
      SaveApp(lzNewFile, lSelectedItem.Caption,
        GetBitmapFile(lzOldFile, lSelectedItem.Caption),
        GetExecFile(lzOldFile, lSelectedItem.Caption));
      //Remove all from old ini file
      AppRemoveItem(lzOldFile, lSelectedItem.Caption);
      //Remove the listitem
      lSelectedItem.Delete;
      lSelectedItem := nil;
    end;
    GetLV.IconOptions.AutoArrange := True;
  end;
end;

procedure Tfrmmain.mnuAppOpenPathClick(Sender: TObject);
var
  lzPath: string;
begin
  if assigned(PageCtrl.ActivePage) and (lSelectedItem <> nil) and
    (lSelectedItem.Selected) then
  begin
    lzPath := GetExecFile(PageCtrl.ActivePage.Hint, lSelectedItem.Caption);
    OpenDocument(ExtractFileDir(lzPath));
  end;
end;

procedure Tfrmmain.mnuAppRefreshClick(Sender: TObject);
begin
  if assigned(PageCtrl.ActivePage) then
  begin
    AddApps(GetLV, PageCtrl.ActivePage.Hint);
  end;
end;

procedure Tfrmmain.mnuAppRemoveAllClick(Sender: TObject);
var
  X: integer;
begin
    //Run all appliactions in selected group
    if assigned(PageCtrl.ActivePage) and (GetLV.Items.Count > 0) then
    begin
      if MessageDlg(Text, 'Are you sure you want to remove all the items in this group?',
        mtInformation, [mbYes,mbNo], 0) = mrYes then
      begin
      for X := GetLV.Items.Count - 1 downto 0 do
      begin
        //Remove app
        AppRemoveItem(PageCtrl.ActivePage.Hint, GetLV.Items[x].Caption);
        //Delete the listitem
        GetLV.Items[X].Delete;
      end;
    end;
  end;
end;

procedure Tfrmmain.mnuAppRunAllClick(Sender: TObject);
var
  X: integer;
  fExe: string;
begin
  //Run all appliactions in selected group
  if assigned(PageCtrl.ActivePage) then
  begin
    for X := 0 to GetLV.Items.Count - 1 do
    begin
      //Get ececutable file
      fExe := GetExecFile(PageCtrl.ActivePage.Hint, GetLv.items[x].Caption);
      OpenDocument(fExe);
    end;
  end;
end;

procedure Tfrmmain.mnuAppsClick(Sender: TObject);
begin

end;

procedure Tfrmmain.mnuAppAddClick(Sender: TObject);
var
  frm: TfrmAddApp;
begin

  if assigned(PageCtrl.ActivePage) then
  begin
    ButtonPress := 0;
    frm := TfrmAddApp.Create(self);
    frm.Caption := 'Add';
    frm.ShowModal;
    if ButtonPress = 1 then
    begin
      //Save app data to the ini file.
      SaveApp(PageCtrl.ActivePage.Hint,
        frm.lblCaption.Text, frm.txtBitmap.Text, frm.txtFilename.Text);
      //Add app item
      AddApps(GetLV, PageCtrl.ActivePage.Hint);
      //Update the icons
      GetLV.IconOptions.AutoArrange := True;
    end;
    FreeAndNil(frm);
  end;
end;

procedure Tfrmmain.mnuAppEditClick(Sender: TObject);
var
  frm: TfrmAddApp;
  lzExe: string;
  lzBmp: string;
begin
  if assigned(PageCtrl.ActivePage) and (lSelectedItem <> nil) and
    (lSelectedItem.Selected) then
  begin
    //Get old exe name
    lzExe := GetExecFile(PageCtrl.ActivePage.Hint, lSelectedItem.Caption);
    lzBmp := GetBitmapFile(PageCtrl.ActivePage.Hint, lSelectedItem.Caption);
    ButtonPress := 0;
    frm := TfrmAddApp.Create(self);
    frm.Caption := 'Edit - ' + lSelectedItem.Caption;
    frm.lblCaption.Text := lSelectedItem.Caption;
    frm.txtBitmap.Text := lzBmp;
    frm.txtFilename.Text := lzExe;
    frm.ShowModal;
    if ButtonPress = 1 then
    begin
      //Update the ini file for the app
      AppEditItem(PageCtrl.ActivePage.Hint, lSelectedItem.Caption,
        frm.lblCaption.Caption, frm.txtBitmap.Text,
        frm.txtFilename.Text);
      //Reload the items in the list and select the last selected item
      AddApps(GetLV, PageCtrl.ActivePage.Hint);
      GetLV.Items[lSelectedItem.Index].Selected := True;
      //lSelectedItem.Caption := frm.lblCaption.Text;
    end;
    FreeAndNil(frm);
  end;
end;

procedure Tfrmmain.mnuAppRemoveClick(Sender: TObject);
begin
  if assigned(PageCtrl.ActivePage) and (lSelectedItem <> nil) and
    (lSelectedItem.Selected) then
  begin
    if MessageDlg(Text, 'Are you sure you want to remove the following item. "' +
      lSelectedItem.Caption + '"', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      //Delete selection from ini file.
      AppRemoveItem(PageCtrl.ActivePage.Hint, lSelectedItem.Caption);
      //Reload the items
      GetLV.Clear;
      AddApps(GetLV, PageCtrl.ActivePage.Hint);
      //Update the icons
      GetLV.IconOptions.AutoArrange := True;
    end;
  end;
end;

procedure Tfrmmain.mnuAppRunClick(Sender: TObject);
begin
  LVDblClick(Sender);
end;

procedure Tfrmmain.mnuBackupClick(Sender: TObject);
var
  sr: TSearchRec;
  fb: TBagFile;
  sd: TSaveDialog;
begin
  fb := TBagFile.Create;

  if FindFirst(BasePath + '*.ini', faAnyFile, sr) = 0 then
  begin
    repeat
      fb.AddFile(BasePath + sr.Name);
    until FindNext(sr) <> 0;
  end;

  sd := TSaveDialog.Create(self);
  sd.Title := 'Backup';
  sd.Filter := 'Bag Files(*.bag)|*.bag';
  sd.DefaultExt := 'bag';

  if sd.Execute then
  begin
    fb.Pak(sd.FileName);
  end;

  FreeAndNil(fb);
  sd.Destroy;

end;

procedure Tfrmmain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrmmain.mnuExportGrpClick(Sender: TObject);
var
  sd: TSaveDialog;
  lzFilename: string;
begin
  if assigned(PageCtrl.ActivePage) then
  begin
    sd := TSaveDialog.Create(self);
    sd.Title := 'Export Group';
    sd.Filter := 'INI Files(*.ini)|*.ini';
    sd.DefaultExt := 'ini';
    lzFilename := PageCtrl.ActivePage.Hint;
    sd.FileName := ExtractFileName(lzFilename);
    if sd.Execute then
    begin
      CopyFile(lzFilename, sd.FileName, [cffOverwriteFile]);
    end;
    sd.Destroy;
  end;
end;

procedure Tfrmmain.mnuGAddClick(Sender: TObject);
var
  tf: TextFile;
  isOk: boolean;
  Filename: string;
  S: string;
begin
  S := '';
  isOk := InputQuery(Text, 'Please enter a new name for the group:', S);

  if (isOk) and (Trim(S) <> '') then
  begin
    if not IsVailFName(S) then
    begin
      MessageDlg(Text, 'The group name entered was not in the correct format.' +
        sLineBreak + 'Please use alpha numeric, space or underscore',
        mtInformation, [mbOK], 0);
    end
    else
    begin
      //Ini filename to create
      Filename := BasePath + S + '.ini';
      //Create empty file
      assignfile(tf, Filename);
      rewrite(tf);
      closefile(tf);
      //Add the tab
      AddAppTab(Filename, S);
    end;
  end;
end;

procedure Tfrmmain.mnuGRemoveClick(Sender: TObject);
begin
  if PageCtrl.ActivePage <> nil then
  begin
    if MessageDlg(Text, 'Are you sure you want to remove the following group "' +
      PageCtrl.ActivePage.Caption + '"', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      //Delete the ini file.
      DeleteFile(PageCtrl.ActivePage.Hint);
      //Remove the tab
      PageCtrl.ActivePage.Free;
      lSelectedItem := nil;
    end;
  end;
  if Assigned(PageCtrl.ActivePage) then mnuRefreshAppsClick(Sender);
end;

procedure Tfrmmain.mnuGRenameClick(Sender: TObject);
var
  isOk: boolean;
  S, oldFile, newFile: string;
begin

  if Assigned(PageCtrl.ActivePage) then
  begin
    //Get tab caption
    S := PageCtrl.ActivePage.Caption;
    //Get input from user
    isOk := InputQuery(Text, 'Enter a new name:', S);

    if (isOk) and (Trim(S) <> '') then
    begin
      //Check for vaild filename
      if not IsVailFName(S) then
      begin
        MessageDlg(Text, 'The group name entered was not in the correct format.' +
          sLineBreak + 'Please use alpha numeric, space or underscore',
          mtInformation, [mbOK], 0);
      end
      else
      begin
        if lowercase(S) <> lowercase(PageCtrl.ActivePage.Caption) then
        begin
          //Old filename
          oldFile := PageCtrl.ActivePage.Hint;
          //New filename
          newFile := BasePath + S + '.ini';
          //Rename ini file
          RenameFile(oldFile, newFile);
          //Update the tab caption and hint
          PageCtrl.ActivePage.Caption := S;
          PageCtrl.ActivePage.Hint := newFile;
        end;
      end;
    end;
  end;
end;

procedure Tfrmmain.mnuImportGrpClick(Sender: TObject);
var
  od: TOpenDialog;
  lzGrpFile: string;
  sCaption: string;
begin
  od := TOpenDialog.Create(Self);
  od.Title := 'Import Group';
  od.Filter := 'INI Files(*.ini)|*.ini';
  if od.Execute then
  begin
    lzGrpFile := BasePath + ExtractFileName(od.filename);
    CopyFile(od.FileName, lzGrpFile, [cffOverwriteFile]);
    //Add the tab
    sCaption := GetFileTitle(ExtractFileName(lzGrpFile));
    AddAppTab(lzGrpFile, sCaption);
  end;
  od.Destroy;
end;

procedure Tfrmmain.mnuOpenAppPathClick(Sender: TObject);
begin
  mnuAppOpenPathClick(Sender);
end;

procedure Tfrmmain.mnuRefreshAppsClick(Sender: TObject);
begin
  mnuAppRefreshClick(Sender);
end;

procedure Tfrmmain.mnuRemoveAppAppsClick(Sender: TObject);
begin
  mnuAppRemoveAllClick(Sender);
end;

procedure Tfrmmain.mnuRestoreClick(Sender: TObject);
var
  od: TOpenDialog;
  fb: TBagFile;
begin
  fb := TBagFile.Create;
  od := TOpenDialog.Create(self);
  od.Title := 'Restore';
  od.Filter := 'Bag Files(*.bag)|*.bag';
  if od.Execute then
  begin
    //Restore all the group files.
    fb.UnPak(od.FileName, BasePath);

    MessageDlg(Text,
      'Restore is complete you may need to restart the application to take effect.',
      mtInformation, [mbOK], 0);

    FreeAndNil(fb);
    od.Destroy;
  end;
end;

procedure Tfrmmain.mnuRunAllAppsClick(Sender: TObject);
begin
  mnuAppRunAllClick(Sender);
end;

procedure Tfrmmain.mnuRunAppClick(Sender: TObject);
begin
  mnuAppRunClick(Sender);
end;

procedure Tfrmmain.PageCtrlChange(Sender: TObject);
begin
  lSelectedItem := nil;
  AddApps(GetLV, PageCtrl.ActivePage.Hint);
end;

procedure Tfrmmain.ToggleBox1Change(Sender: TObject);
begin
  GetLV.Refresh;
end;

end.
