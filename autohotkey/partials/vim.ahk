#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Esc 映射ESC
~Esc::
    ; 如果是 IDEA 先切换输入法、再按ESC
    if WinActive("ahk_exe pycharm64.exe") or WinActive("ahk_exe goland64.exe") or WinActive("ahk_exe Code.exe") or WinActive("ahk_exe wezterm-gui.exe") or WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe datagrip64.exe") {
        Send {Blind}{Esc Down}{Esc Up}
        ToggleToEnglish()
        Send {Blind}{Esc Down}{Esc Up}
        return
    }
Return

ToggleToEnglish() {
    if IsHalfwidthChinese() {
        SetENMode()
    }
}

; 是否为半角+中文标点
IsHalfwidthChinese() {
    return GetIMEConvMode() = 1025
}

; 全角+中文标点
IsFullwidthChinese() {
    return GetIMEConvMode() = 1033
}

; 是否为中文
IsENMode() {
    return GetIMEConvMode() = 0
}

; 设置为英文模式
SetENMode() {
    SetIMEConvMode(0)
}

; 获取窗口ID
GetWinID(WinTitle="A")
{
    ControlGet, hwnd, HWND,,, %WinTitle%
    if (WinActive(WinTitle)) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")
        return hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr", &stGTI)
                 ? NumGet(stGTI, 8+PtrSize, "Ptr") : hwnd
    }
    return hwnd
}

; 获取当前输入法的状态
GetIMEConvMode() {
    ; DetectHiddenWindows, On
    hwnd := GetWinID("A")
    result := DllCall("SendMessage"
        , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
        , "UInt", 0x0283          ;Message : WM_IME_CONTROL
        , "Int", 0x001            ;wParam  : IMC_GETCONVERSIONMODE
        , "Int", 0) & 0xffff      ;lParam  : 0 ， & 0xffff 表示只取低16位
    ; 0 英文状态; 1 非英文状态
    return result
}

; 设置输入法状态
SetIMEConvMode(ConvMode) {
    hwnd := GetWinID("A")
    return DllCall("SendMessage"
        , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
        , "UInt", 0x0283      ;Message : WM_IME_CONTROL
        , "UPtr", 0x002       ;wParam  : IMC_SETCONVERSIONMODE
        , "Ptr", ConvMode)    ;lParam  : CONVERSIONMODE
}
