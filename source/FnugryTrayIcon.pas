(*
   fnugrytrayicon.pas
   version 1.0.0.1

   TFnugryTrayIcon - a simple tray icon component.

   Copyright (C) 1997-98 Gleb Yourchenko

   Contact:
   eip__@hotmail.com
   Please include "TFnugryTrayIcon" in the subject string.

*)
unit FnugryTrayIcon;

interface
uses
   Windows, ShellAPI, SysUtils, Messages, Classes, Menus, Graphics;

type

  ETrayIconError = class(Exception);

  TFnugryTrayIcon = class(TComponent)
  private
     FIconData     :TNotifyIconData;
     FHandle       :HWND;
     FRightMenu    :TPopupMenu;
     FLeftMenu     :TPopupMenu;
     FIcon         :TIcon;
     FTip          :String;
     FOnChange     :TNotifyEvent;
     FOnMouseMove  :TNotifyEvent;
     FOnLBtnDown   :TNotifyEvent;
     FOnRBtnDown   :TNotifyEvent;
     FOnLBtnUp     :TNotifyEvent;
     FOnRBtnUp     :TNotifyEvent;
     FOnLBtnDblClk :TNotifyEvent;
     FOnRBtnDblClk :TNotifyEvent;
     procedure SetVisible(Value :Boolean);
     function GetVisible :Boolean;
     procedure SetIcon(Value :TIcon);
     procedure SetTip(const Value :String);
     procedure SetRightMenu(Value :TPopupMenu);
     procedure SetLeftMenu(Value :TPopupMenu);
     procedure AllocateTrayIcon;
     procedure ReleaseTrayIcon;
     procedure UpdateTrayIcon;
     procedure TrayWndProc(var Msg :TMessage);
     procedure evIconChange(Sender :TObject);
  protected
     procedure CheckError(fCond :Boolean; MsgID :Integer);
     procedure MouseMove; virtual;
     procedure MouseLBtnUp; virtual;
     procedure MouseRBtnUp; virtual;
     procedure MouseLBtnDown; virtual;
     procedure MouseRBtnDown; virtual;
     procedure MouseLBtnDblClk; virtual;
     procedure MouseRBtnDblClk; virtual;
     procedure Notification(AComponent: TComponent;
        Operation: TOperation); override;
     procedure Change; virtual;
  public
     constructor Create(AOwner :TComponent); override;
     destructor Destroy; override;
  published
     property Icon :TIcon
        read FIcon write SetIcon;
     property RightMenu :TPopupMenu
        read FRightMenu write SetRightMenu;
     property LeftMenu :TPopupMenu
        read FLeftMenu write SetLeftMenu;
     property Tip :String
        read FTip write SetTip;
     property Visible :Boolean
        read GetVisible write SetVisible;
     property OnChange :TNotifyEvent
        read FOnChange write FOnChange;
     property OnMouseMove  :TNotifyEvent
        read FOnMouseMove write FOnMouseMove;
     property OnMouseLBtnDown   :TNotifyEvent
        read FOnLBtnDown write FOnLBtnDown;
     property OnRBtnDown   :TNotifyEvent
        read FOnRBtnDown write FOnRBtnDown;
     property OnMouseLBtnUp     :TNotifyEvent
        read FOnLBtnUp write FOnLBtnUp;
     property OnMouseRBtnUp     :TNotifyEvent
        read FOnRBtnUp write FOnRBtnUp;
     property OnMouseLBtnDblClk :TNotifyEvent
        read FOnLBtnDblClk write FOnLBtnDblClk;
     property OnMouseRBtnDblClk :TNotifyEvent
        read FOnRBtnDblClk write FOnRBtnDblClk;
  end;



procedure Register;

implementation
uses
   forms;

procedure Register;
begin
   RegisterComponents('Fnugry UI', [TFnugryTrayIcon]);
end;

{$Resource FnugryTrayIcon.Res}
{$Include FnugryTrayIcon.Inc}

const

  WM_ICONNOTIFY            = WM_USER + $100;


procedure TFnugryTrayIcon.SetVisible(Value :Boolean);
begin
  if Value <> Visible then
     begin
        if Value then
           AllocateTrayIcon
        else
           ReleaseTrayIcon;
        Change;
     end;
end;


function TFnugryTrayIcon.GetVisible :Boolean;
begin
   result := FHandle <> 0;
end;


procedure TFnugryTrayIcon.SetIcon(Value :TIcon);
begin
   assert(assigned(FIcon));
   FIcon.Assign(Value);
   if Visible then UpdateTrayIcon;
end;


procedure TFnugryTrayIcon.SetTip(const Value :String);
begin
   if Value <> FTip then
      begin
         FTip := Value;
         if Visible then UpdateTrayIcon;
         Change;
      end;
end;


procedure TFnugryTrayIcon.SetRightMenu(Value :TPopupMenu);
begin
   FRightMenu := Value;
end;

procedure TFnugryTrayIcon.SetLeftMenu(Value :TPopupMenu);
begin
   FLeftMenu := Value;
end;

procedure TFnugryTrayIcon.Notification(
   AComponent: TComponent;  Operation: TOperation);
begin
   if ( Operation = opRemove ) then
      if AComponent = FRightMenu then
         FRightMenu := Nil
      else
         if AComponent = FLeftMenu then
            FLeftMenu := Nil;
end;

procedure TFnugryTrayIcon.Change;
begin
   if assigned(FOnChange) then
      FOnChange(Self);
end;

procedure TFnugryTrayIcon.AllocateTrayIcon;
begin
  assert(assigned(FIcon));
  if FHandle = 0 then
     begin
        FHandle := AllocateHWnd(TrayWndProc);
        CheckError(FHandle <> 0, msg_err_allocwnd);
        try
           fillchar(FIconData, Sizeof(FIconData), 0);
           FIconData.cbSize := sizeof(FIconData);
           FIconData.uFlags := NIF_ICON OR NIF_MESSAGE OR NIF_TIP;
           FIconData.uCallbackMessage := WM_ICONNOTIFY;
           FIconData.Wnd := FHandle;
           FIconData.hIcon := FIcon.Handle;
           StrCopy(FIconData.szTip, PChar(FTip));
           CheckError(Shell_NotifyIcon(NIM_ADD, @FIconData), msg_err_trayadd);
        except
           DeallocateHWnd(FHandle);
           FHandle := 0;
           raise;
        end;
     end;
end;


procedure TFnugryTrayIcon.ReleaseTrayIcon;
begin
   if FHandle <> 0 then
      begin
         CheckError(Shell_NotifyIcon(NIM_DELETE, @FIconData), msg_err_traydelete);
         DeallocateHWnd(FHandle);
         FHandle := 0;
      end;
end;

procedure TFnugryTrayIcon.UpdateTrayIcon;
begin
   assert(FHandle <> 0);
   FIconData.cbSize := sizeof(FIconData);
   FIconData.Wnd := FHandle;
   FIconData.uFlags := NIF_ICON OR NIF_TIP;
   FIconData.uCallbackMessage := WM_ICONNOTIFY;
   FIconData.Wnd := FHandle;
   FIconData.hIcon := FIcon.Handle;
   StrCopy(FIconData.szTip, PChar(FTip));
   CheckError(Shell_NotifyIcon(NIM_MODIFY, @FIconData), msg_err_traymodify);
end;

constructor TFnugryTrayIcon.Create(AOwner :TComponent);
begin
   inherited Create(AOwner);
   FIcon := TIcon.Create;
   FIcon.ReleaseHandle;
   FIcon.Handle := LoadIcon(0, IDI_APPLICATION);
   FIcon.OnChange := evIconChange;
end;

destructor TFnugryTrayIcon.Destroy;
begin
   if Visible then ReleaseTrayIcon;
   FTip := '';
   FIcon.Free;
   inherited Destroy;
end;


procedure TFnugryTrayIcon.CheckError(fCond :Boolean; MsgID :Integer);
begin
   if not fCond then
      raise ETrayIconError.CreateRes(MsgID);
end;

procedure TFnugryTrayIcon.TrayWndProc(var Msg :TMessage);
begin
   msg.result := 0;
   case Msg.lParam of
     WM_MOUSEMOVE : MouseMove;
     WM_LBUTTONDBLCLK : MouseLBtnDblClk;
     WM_RBUTTONDBLCLK : MouseRBtnDblClk;
     WM_LBUTTONUP     : MouseLBtnUp;
     WM_RBUTTONUP     : MouseRBtnUp;
     WM_LBUTTONDOWN   : MouseLBtnDown;
     WM_RBUTTONDOWN   : MouseRBtnDown;
     else
       msg.result := DefWindowProc(FHandle, Msg.Msg, msg.wParam, msg.lParam);
   end;
end;


procedure TFnugryTrayIcon.MouseMove;
begin
   if assigned(FOnMouseMove) then
      FOnMouseMove(Self);
end;


procedure TFnugryTrayIcon.MouseLBtnUp;
var
   ptCursor :TPoint;
begin
   if assigned(FLeftMenu) then
      begin
         GetCursorPos(ptCursor);
         FLeftMenu.Popup(ptCursor.x, ptCursor.y);
      end
   else
      if assigned(FOnLBtnUp) then
         FOnLBtnUp(Self);
end;

procedure TFnugryTrayIcon.MouseRBtnUp;
var
   ptCursor :TPoint;
begin
   if assigned(FRightMenu) then
      begin
         GetCursorPos(ptCursor);
         FRightMenu.Popup(ptCursor.x, ptCursor.y);
      end
   else
      if assigned(FOnRBtnUp) then
         FOnRBtnUp(Self);
end;

procedure TFnugryTrayIcon.MouseLBtnDown;
begin
   if assigned(FOnLBtnDown) then
      FOnLBtnDown(Self);
end;

procedure TFnugryTrayIcon.MouseRBtnDown;
begin
   if assigned(FOnRBtnDown) then
      FOnRBtnDown(Self);
end;

procedure TFnugryTrayIcon.MouseLBtnDblClk;
begin
   if assigned(FOnLBtnDblClk) then
      FOnLBtnDblClk(Self);
end;

procedure TFnugryTrayIcon.MouseRBtnDblClk;
begin
   if assigned(FOnRBtnDblClk) then
      FOnRBtnDblClk(Self);
end;


procedure TFnugryTrayIcon.evIconChange(Sender :TObject);
begin
  if Visible then UpdateTrayIcon;
end;

end.
