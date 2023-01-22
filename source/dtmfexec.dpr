program dtmfexec;

uses
  Forms,
  dtmfexec1 in 'dtmfexec1.pas' {DTMFExecuter},
  FnugryTrayIcon in 'N:\delphi4\trayicon\source\FnugryTrayIcon.pas',
  hjustin1 in '..\..\Documents\justindll\hjustin1.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDTMFExecuter, DTMFExecuter);
  Application.Run;
end.
