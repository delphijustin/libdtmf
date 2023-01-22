unit DTMFUnit;

interface
uses windows;

const
dtmfopt_showconsole=1;
dtmfopt_showerrors=2;
dtmfopt_unsafeshutdown=4;
dtmfopt_echo=8;
type TdtmfSetCallBackA=procedure(lpCallBack:Pointer);stdcall;
TdtmfStart=function(options:longword;lpReserved:Pointer):THandle;stdcall;
TdtmfShutdown=function(timeout:dword):dword;stdcall;
TdtmfStop=procedure(handle:THandle);stdcall;
TdtmfGetLastErrorA=function(lpText:pansichar;maxlen:integer):integer;stdcall;
var hlibDTMF:HModule;
dtmfStart:TdtmfStart;
dtmfStop:TdtmfStop;
dtmfSetCallBackA:TdtmfSetCallBackA;
dtmfShutdown:TdtmfShutdown;
dtmfGetLastErrorA:tdtmfgetlasterrora;
implementation
initialization
hlibdtmf:=loadlibrary('libDTMF.dll');
@dtmfstart:=getprocaddress(hlibdtmf,'dtmfStart');
@dtmfstop:=getprocaddress(hlibdtmf,'dtmfStop');
@dtmfgetlasterrora:=getprocaddress(hlibdtmf,'dtmfGetLastErrorA');
@dtmfsetcallbacka:=getprocaddress(hlibdtmf,'dtmfSetCallBackA');
@dtmfShutdown:=getprocaddress(hlibdtmf,'dtmfShutdown');
finalization
freelibrary(hlibdtmf);
end.
