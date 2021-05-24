#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, 2
#IfWinActive, AutoHotKey.ahk
    ^s::
    SendInput, ^s
    sleep 500
    reload
#IfWinActive
Return


AppsKey::#Tab

#IfWinActive, Content Manager
NumpadDiv::p
NumpadMult::a
NumpadSub::s
Numpad7::d
Numpad8::f
Numpad9::g
NumpadAdd::h
Numpad4::j
Numpad5::k
Numpad6::l
Numpad1::z
Numpad2::x
Numpad3::c
NumpadEnter::Esc
#IfWinActive
Return



#IfWinActive, Assetto Corsa
NumpadDiv::p
NumpadMult::a
NumpadSub::s
Numpad7::d
Numpad8::f
Numpad9::g
NumpadAdd::h
Numpad4::j
Numpad5::k
Numpad6::l
Numpad1::z
Numpad2::x
Numpad3::c
NumpadEnter::Esc
#IfWinActive
Return

#IfWinActive, City Car Driving
NumpadDiv::p
NumpadMult::a
NumpadSub::s
Numpad7::d
Numpad8::f
Numpad9::g
NumpadAdd::h
Numpad4::j
Numpad5::k
Numpad6::l
Numpad1::z
Numpad2::x
Numpad3::c
NumpadEnter::Esc
#IfWinActive
Return





#IfWinActive, Euro Truck Simulator 2
NumpadDiv::p
NumpadMult::a
NumpadSub::s
Numpad7::d
Numpad8::f
Numpad9::g
NumpadAdd::h
Numpad4::j
Numpad5::k
Numpad6::l
Numpad1::z
Numpad2::x
Numpad3::c
NumpadEnter::Esc
#IfWinActive
Return


#+w::
WinActivate, Desktop Viewer

