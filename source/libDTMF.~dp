library libDTMF;
{$RESOURCE LIBDTMF32.RES}
uses
  SysUtils,
  mmsystem,
  windows,
  shellapi,
  Classes;
type TDTMFProcA=procedure(lpDTMFStr:PAnsiChar);stdcall;
var hDTMF:THandle;
multimonng:TShellExecuteinfo;
msBuff:TMemorystream;
slBuff:TStringlist;
OnDTMFA:TDTMFProcA;
SError:ansistring='';

procedure dtmfSetCallBackA(lpCallBack:Pointer);stdcall;
begin
@ondtmfa:=lpcallback;
end;

function dtmfShutdown(timeout:dword):dword;stdcall;
var exec:TShellexecuteinfo;
begin
result:=33;
zeromemory(@exec,sizeof(exec));
exec.cbSize:=sizeof(exec);
exec.fMask:=SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
exec.lpFile:='taskkill.exe';
exec.lpParameters:='/F /IM multimon-ng.exe';
exec.nShow:=sw_hide;
if not shellexecuteex(@exec)then result:=getlasterror else begin
waitforsingleobject(exec.hProcess,timeout);closehandle(exec.hprocess);
end;
end;

function dtmfThread(options:longword):DWORD;stdcall;
var lastSize:integer;
BytesRead:dword;
lpDTMF:array[0..255]of char;
begin
lastsize:=0;
hdtmf:=createfile('DTMF.INP',generic_read,filE_share_read or filE_share_write,
nil,create_always,file_attribute_normal,0);
msBuff:=tmemorystream.Create;
slBuff:=tstringlist.Create;
zeromemory(@multimonng,sizeof(multimonng));
multimonng.cbSize:=sizeof(multimonng);
multimonng.fMask:=SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_NO_UI or
SEE_MASK_DOENVSUBST;
multimonng.lpFile:='%ComSpec%';
multimonng.lpParameters:='/C multimon-ng.exe -a DTMF > DTMF.INP';
if options and 1>0then multimonng.nShow:=SW_SHOW;
if options and 2>0then multimonng.fMask:=multimonng.fMask and(
not SEE_MASK_FLAG_NO_UI);
result:=ord(shellexecuteex(@multimonng));
if result=0 then exit;
result:=still_active;
while result=still_active do begin
getexitcodeprocess(multimonng.hProcess,result);;
if(getfilesize(hdtmf,nil)<maxint)and(getfilesize(hdtmf,nil)>0)then begin
msbuff.SetSize(getfilesize(hdtmf,nil));
if lastsize<>msbuff.Size then begin
setfilepointer(hdtmf,0,nil,file_begin);
readfile(hdtmf,msbuff.memory^,msbuff.size,bytesRead,nil);
slbuff.LoadFromStream(msbuff);
lastsize:=msbuff.Size;
if pos('DTMF: ',slbuff[slbuff.count-1])=1then
if options and 8>0then PlaySound(makeintresource(ord(slbuff[slbuff.count-1][
length('DTMF: x')])),hinstance,SND_ASYNC or SND_RESOURCE or SND_NOWAIT);
ondtmfa(strlcat(lpdtmf,@slbuff[slbuff.count-1][length('DTMF: x')],255));
end;
end;
end;
end;

function dtmfStart(options:longword;lpReserved:Pointer):THandle;stdcall;
var tid:dword;
begin
result:=0;
if(options and 4=0)and(dtmfshutdown(3*60*1000)<>33)then begin serror:=serror+
'No taskkill.exe';exit;end;
result:=createthread(nil,0,@dtmfthread,pointer(options),0,tid);
if result=0then serror:=serror+format('DTMFThread: %s(%d)',[syserrormessage(
getlasterror),getlasterror]);
end;

procedure dtmfStop(handle:THandle);stdcall;
begin
if not terminatethread(handle,0)then
serror:=serror+format('terminateDTMF: %s(%d)',[syserrormessage(getlasterror),
getlasterror]);
closehandle(handle);
closehandle(hdtmf);
msbuff.Free;
slbuff.Free;
dtmfShutdown(3*60*1000);
end;

function dtmfGetLastErrorA(lpText:pansichar;maxlen:integer):integer;stdcall;
begin
result:=length(serror);
if maxlen=-1then serror:='';
if lptext=nil then exit;
strplcopy(lptext,serror,maxlen);
serror:='';
end;

exports dtmfSetCallBackA,dtmfStart,dtmfStop,dtmfGetLastErrorA,dtmfShutdown;
begin
end.
