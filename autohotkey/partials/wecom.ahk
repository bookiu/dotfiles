#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


~LAlt::
if (lalt_presses > 0) {
    lalt_presses += 1
    return
}
lalt_presses = 1
SetTimer, KeyLAlt, -300
Return

KeyLAlt:
if (lalt_presses = 2) {
    Send +!s
}
lalt_presses = 0
return
