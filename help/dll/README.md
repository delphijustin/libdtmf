<h1>Functions</h1>
<p>
<b>void dtmfSetCallBackA(DTMFProc callbackfunc)</b> Sets the callback to be used for new DTMF Data.<br>
<b>int dtmfGetLastErrorA(LPSTR lpText,int maxlen)</b> Gets or checks for error. If you need to figure out
  how big of a buffer you need set maxlen to -1. DO NOT SET maxlen to 0 as it will reset it. It resets on a
  successful call(except maxlen=-1)<br>
<B>HANDLE dtmfStart(DWORD options,PVOID lpReserved)</B> Starts listening for DTMF. For option values scroll
  down until you reached Options. For right now lpreserved must be NULL. Returns a handle to the monitor thread.<br>
<b>void dtmfStop(HANDLE Thread)</b> Stops listening and terminates the thread returned from dtmfStart.<br>
<b><i>void DTMFProc(LPSTR DTMFBuff)</i></b> Called for every DTMF recv. To reset the buffer set the first character
  NULL. The buffer can only hold up to 255 charactera(not including the null terminator).If 255 characters is
  reached then the new character is ignored, but the callback will still be called
</p>
<h1>Option constants</h1>
dtmfopt_showconsole=1;//show the multimon-ng console window.<br>
dtmfopt_showerrors=2;//Show shellexecute errors<br>
dtmfopt_unsafeshutdown=4;//DONT USE! Dont attempt to shutdown multimon-ng<br>
dtmfopt_echo=8;//Tell you what button you pushed<br>
