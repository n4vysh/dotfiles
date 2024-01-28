#Requires AutoHotkey >=2
#SingleInstance Force

USERPROFILE := EnvGet("USERPROFILE")

if ! (PID := ProcessExist("komorebi.exe")) {
	RunWait("komorebic.exe start -c " USERPROFILE "\komorebi.json", , "Hide")
} else {
	RunWait("komorebic.exe reload-configuration", , "Hide")
}

Loop {
	ExitCode := RunWait("komorebic.exe state", , "Hide")
	if ExitCode = 0 {
		break
	} else {
		Sleep 1000
	}
}

; Load library
#Include komorebic.lib.ahk

; Reload configuration
F13 & c::
{
	if GetKeyState("Shift") {
		RunWait("taskkill /f /im komorebi.exe", , "Hide")
		RunWait("komorebic.exe start -c " USERPROFILE "\komorebi.json", , "Hide")
		Reload
	}
}

; Focus or move windows
F13 & h::
{
	if ! GetKeyState("Shift") {
		Focus("left")
	} else {
		Move("left")
	}
}

F13 & j::
{
	if ! GetKeyState("Shift") {
		Focus("down")
	} else {
		Move("down")
	}
}

F13 & k::
{
	if ! GetKeyState("Shift") {
		Focus("up")
	} else {
		Move("up")
	}
}

F13 & l::
{
	if ! GetKeyState("Shift") {
		Focus("right")
	} else {
		Move("right")
	}
}

; Manipulate windows
F13 & space::
{
	if GetKeyState("Shift") {
		ToggleFloat()
	}
}

F13 & f::ToggleMaximize()

; Workspaces
F13 & 1::
{
	if ! GetKeyState("Shift") {
		FocusWorkspace(0)
	} else {
		SendToWorkspace(0)
	}
}

F13 & 2::
{
	if ! GetKeyState("Shift") {
		FocusWorkspace(1)
	} else {
		SendToWorkspace(1)
	}
}

F13 & 3::
{
	if ! GetKeyState("Shift") {
		FocusWorkspace(2)
	} else {
		SendToWorkspace(2)
	}
}

F13 & 4::
{
	if ! GetKeyState("Shift") {
		FocusWorkspace(3)
	} else {
		SendToWorkspace(3)
	}
}

F13 & p::
{
	if ! GetKeyState("Shift") {
		CycleWorkspace("previous")
	} else {
		CycleSendToWorkspace("previous")
	}
}

F13 & n::
{
	if ! GetKeyState("Shift") {
		CycleWorkspace("next")
	} else {
		CycleSendToWorkspace("next")
	}
}

; Misc
F13 & q::
{
	if GetKeyState("Shift") {
		Close()
	}
}

F13 & d::
{
	if ! GetKeyState("Shift") {
		Send "!{Space}"
	}
}

IsLauncher := false

#HotIf !IsLauncher
	F13 & o::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			IsLauncher := true
		}
	}
#HotIf IsLauncher
	b::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			WinActivate("Program Manager")
			RunWait("C:\Program Files\Mozilla Firefox\firefox.exe", , "Hide")
			WinWaitActive("ahk_exe firefox.exe")
			IsLauncher := false
		}
	}

	f::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			Send "#e"
			IsLauncher := false
		}
	}

	#UseHook

	*i::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			if GetKeyState("Ctrl", "P") {
				; NOTE: hold down ctrl for a few seconds
				if ! (PID := ProcessExist("ms-teams.exe")) {
					; NOTE: pin teams to task bar before use
					Send("#4")
				}
				IsLauncher := false
			} else {
				if ! (PID := ProcessExist("slack.exe")) {
					; NOTE: pin slack to task bar before use
					Send("#3")
				}
				IsLauncher := false
			}
		}
	}

	m::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			Send "^+{ESC}"
			IsLauncher := false
		}
	}

	n::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			Send "#n"
			IsLauncher := false
		}
	}

	q::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			IsLauncher := false
		}
	}
#HotIf

F13 & Enter::
{
	if ! GetKeyState("Shift") {
		if ! (PID := ProcessExist("wezterm-gui.exe")) {
			; NOTE: pin wezterm to task bar before use
			Send("#1")
		}
	}
}

^;::
{
	Send("#v")
}

AppsKey::LWin

~LShift::
{
	KeyWait "LShift"
	if (A_TimeSinceThisHotkey < 300 and A_PriorKey = "LShift") {
		Send "("
	}
}

~RShift::
{
	KeyWait "RShift"
	if (A_TimeSinceThisHotkey < 300 and A_PriorKey = "RShift") {
		Send ")"
	}
}
