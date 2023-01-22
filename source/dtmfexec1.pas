unit dtmfexec1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DTMFMonitor,shellapi, StdCtrls, Menus, FnugryTrayIcon, ExtCtrls,hjustin1;
{$RESOURCE dtmfexec-res.res}
type
  TDTMFExecuter = class(TForm)
    Memo1: TMemo;
    DTMFMonitor1: TDTMFMonitor;
    FnugryTrayIcon1: TFnugryTrayIcon;
    PopupMenu1: TPopupMenu;
    QuitDTMFExecuter1: TMenuItem;
    Enabled1: TMenuItem;
    ViewLog1: TMenuItem;
    Timer1: TTimer;
    AboutDTMFExecuter1: TMenuItem;
    Donate1: TMenuItem;
    Paypal1: TMenuItem;
    CashApp1: TMenuItem;
    procedure DTMFMonitor1DTMF(var DTMFText: String);
    procedure FormCreate(Sender: TObject);
    procedure DTMFMonitor1Error(const errorMsg: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QuitDTMFExecuter1Click(Sender: TObject);
    procedure Enabled1Click(Sender: TObject);
    procedure ViewLog1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AboutDTMFExecuter1Click(Sender: TObject);
    procedure Paypal1Click(Sender: TObject);
    procedure CashApp1Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure sendToTray(Sender:TObject);
    { Public declarations }
  end;

var
  DTMFExecuter: TDTMFExecuter;

implementation

{$R *.DFM}

procedure tdtmfexecuter.sendToTray;
begin
showwindow(handle,sw_hide);
showwindow(application.handle,sw_hide);
end;

procedure TDTMFExecuter.DTMFMonitor1DTMF(var DTMFText: String);
begin
memo1.Lines[memo1.Lines.Count-1]:=dtmftext;
if pos('#',dtmftext)>0then shellexecute(handle,nil,'dtmfexec.bat',@dtmftext[1],
nil,sw_hide);
if pos('*',dtmftext)or pos('#',dtmftext)>0then begin memo1.Lines.Add('');
dtmftext:=''; end;
end;

procedure TDTMFExecuter.FormCreate(Sender: TObject);
begin
memo1.Clear;
application.OnMinimize:=sendtotray;
memo1.Lines.Add('');
application.Title:=caption;
FnugryTrayIcon1.Visible:=true;
dtmfmonitor1.Enabled:=true;
timer1.Enabled:=(pos(' /hide',lowercase(getcommandline))>0);
end;

procedure TDTMFExecuter.DTMFMonitor1Error(const errorMsg: String);
begin
memo1.Lines.Add(errormsg+#13#10);
end;

procedure TDTMFExecuter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=cahide;
end;

procedure TDTMFExecuter.QuitDTMFExecuter1Click(Sender: TObject);
begin
exitprocess(0);
end;

procedure TDTMFExecuter.Enabled1Click(Sender: TObject);
begin
enabled1.Checked:=not enabled1.Checked;
dtmfmonitor1.Enabled:=enabled1.Checked;
end;

procedure TDTMFExecuter.ViewLog1Click(Sender: TObject);
begin
showwindow(application.handle,sw_restore);
showwindow(handle,sw_restore);
bringtofront;
end;

procedure TDTMFExecuter.FormDestroy(Sender: TObject);
begin
dtmfmonitor1.Enabled:=false;
end;

procedure TDTMFExecuter.Timer1Timer(Sender: TObject);
begin
showwindow(application.handle,sw_hide);
showwindow(handle,sw_hide);
timer1.Enabled:=false;
end;

procedure TDTMFExecuter.AboutDTMFExecuter1Click(Sender: TObject);
begin
aboutmessage(0,hinstance,PChar('DTMF Executer'),nil,sizeof(char),0);
end;

procedure TDTMFExecuter.Paypal1Click(Sender: TObject);
begin
donate(0,500,pay_paypal);
end;

procedure TDTMFExecuter.CashApp1Click(Sender: TObject);
begin
donate(0,500,pay_cashapp);
end;

end.
