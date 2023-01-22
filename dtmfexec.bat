if "%1"=="#" nircmdc.exe muteappvolume mirc.exe 2
if "%1"=="110#" set emlexists=0
if "%1"=="110#" for %%f in (a:\mail\admin\*.eml) do cscript.exe sayemail.vbs /eml:%%f
if "%1"=="110#" for %%f in (a:\mail\admin\*.eml) do del %%f
if "%1"=="1#" FOR /F "usebackq tokens=*" %%s IN (`powershell -NoProfile -Command "Get-Content a:\mirc-log\flyback.libera.chat.log | Select-Object -Last 10"`) DO (
    nircmdc.exe speak text "%%s"
)
if "%1"=="00#" FOR /F "usebackq tokens=*" %%s IN (`powershell -NoProfile -Command "Get-Content a:\mirc-log\status.libera.chat.log | Select-Object -Last 10"`) DO (
    nircmdc.exe speak text "%%s"
)
if "%1"=="0#" FOR /F "usebackq tokens=*" %%s IN (`powershell -NoProfile -Command "Get-Content A:\mirc-log\##electronics.libera.chat.log | Select-Object -Last 10"`) DO (
    nircmdc.exe speak text "%%s"
)
if "%1"=="6661#" "c:\program files (x86)\mIRC\mirc.exe" -scygwinlibera
if "%1"=="6660#" taskkill /F /IM mirc.exe