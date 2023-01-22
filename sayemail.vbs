dim adoStream
dim cdoMsg
dim namedArgs
dim sapi
set sapi = CreateObject("SAPI.SpVoice")
set namedArgs = Wscript.Arguments.Named
set adoStream = CreateObject("ADODB.Stream")
adoStream.Open
adoStream.LoadFromFile(namedArgs.Item("eml"))
set cdoMsg = CreateObject("CDO.Message")
cdoMsg.DataSource.OpenObject adoStream,"_Stream"
sapi.Speak "From "&cdoMsg.From&", Subject is "&cdoMsg.Subject
Wscript.Quit 0