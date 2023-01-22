unit DTMFMonitor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dtmfunit;

type
TDTMFEvent=procedure(var DTMFText:String)of object;
TDTMFError=procedure(const errorMsg:string)of object;
  TDTMFMonitor = class(TComponent)
  private
    { Private declarations }
  protected
  CBError:TDTMFError;
  CallBack:TDTMFEvent;
  HThread:THandle;
  Echo,booldtmf,bcon,swerr,bshut:Boolean;
  procedure setenable(enable:Boolean);
  function getOptions:Longword;
    { Protected declarations }
  public
  property Thread:THANDLE read hthread;
  property Enabled:Boolean read booldtmf write setenable;
  constructor Create(AOwner:TComponent);override;
    { Public declarations }
  published
  property Echoing:boolean read echo write echo;
  property ConsoleVisible:boolean read bCon write bcon;
  property ShowError:boolean read swerr write swerr;
  property UnsafeShutdown:Boolean read bshut write bshut;
  property OnError:tdtmferror read cberror write cberror;
  property OnDTMF:TDTMFEvent read callback write callback;
    { Published declarations }
  end;

procedure Register;

implementation

var defaultDTMF:TDTMFMonitor;

function tdtmfmonitor.getOptions;
begin
result:=(dtmfopt_showconsole*ord(bcon))or(dtmfopt_showerrors*ord(swerr))or
(dtmfopt_unsafeshutdown*ord(bshut))or(ord(echo)*dtmfopt_echo);
end;

procedure doDTMF(lpDTMFStr:PAnsiChar);stdcall;
var dtmfstr:string;
begin
dtmfstr:=strpas(lpdtmfstr);
if assigned(defaultdtmf.ondtmf)then
defaultdtmf.ondtmf(dtmfstr);
strplcopy(lpdtmfstr,dtmfstr,255);
end;

constructor TDTMFMonitor.Create;
begin
inherited;
defaultDTMF:=self;
booldtmf:=false;
hthread:=0;
bcon:=false;
swerr:=false;
bshut:=false;
dtmfSetCallbacka(@dodtmf);
end;

procedure tdtmfmonitor.setenable;
var lperror:array[0..1024]of char;
begin
booldtmf:=enable;
lperror[0]:=#0;
if enable then hthread:=dtmfstart(getoptions,nil) else begin
dtmfstop(hthread);
hthread:=0;
end;
dtmfgetlasterrora(lperror,1024);
if strlen(lperror)>0then if assigned(cberror)then cberror(lperror);
end;

procedure Register;
begin
  RegisterComponents('delphijustin Industries', [TDTMFMonitor]);
end;

end.
