#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetCapsLockState, AlwaysOff

; use caplock to switch input method mode
CapsLock::
Send {Ctrl down}{Space}{Ctrl up}
Return

; disable shift+space
; +{Space}::Return
