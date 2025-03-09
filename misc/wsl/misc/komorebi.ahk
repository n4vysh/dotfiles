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
		USERPROFILE := EnvGet("USERPROFILE")
		RunWait("komorebic.exe start -c " USERPROFILE "\komorebi.json", , "Hide")
		Reload
	} else if GetKeyState("Ctrl", "P") {
		; for ScreenToGif
		Send "{F8}"
	}
}

; Focus or move windows
F13 & h::
{
	if ! GetKeyState("Shift") {
		if GetKeyState("Ctrl", "P") {
			Send("{backspace}")
		} else {
			Focus("left")
		}
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
		if GetKeyState("Ctrl", "P") {
			DllCall("LockWorkStation")
		} else {
			Focus("right")
		}
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

F13 & f::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+{right}")
		} else {
			Send("{right}")
		}
	} else {
		ToggleMaximize()
	}
}

F13 & b::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+{left}")
		} else {
			Send("{left}")
		}
	}
}

F13 & a::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+{home}")
		} else {
			Send("{home}")
		}
	}
}

F13 & e::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+{end}")
		} else {
			Send("{end}")
		}
	}
}

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
		if GetKeyState("Ctrl", "P") {
			Send("{up}")
		} else {
			CycleWorkspace("previous")
		}
	} else {
		if GetKeyState("Ctrl", "P") {
			Send("+{up}")
		} else {
			CycleSendToWorkspace("previous")
		}
	}
}

F13 & n::
{
	if ! GetKeyState("Shift") {
		if GetKeyState("Ctrl", "P") {
			Send("{down}")
		} else {
			CycleWorkspace("next")
		}
	} else {
		if GetKeyState("Ctrl", "P") {
			Send("+{down}")
		} else {
			CycleSendToWorkspace("next")
		}
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
		if GetKeyState("Ctrl", "P") {
			Send("{delete}")
		} else {
			Send "!{Space}"
		}
	}
}

F13 & w::
{
	if GetKeyState("Ctrl", "P") {
		Send("^{backspace}")
	}
}

F13 & u::
{
	if GetKeyState("Ctrl", "P") {
		Send("+{home}")
		Send("{backspace}")
	}
}

F13 & m::
{
	if GetKeyState("Ctrl", "P") {
		Send("enter")
	}
}

IsPowerMenu := false

F13 & e::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+{end}")
		} else {
			Send("{end}")
		}
	}
}

#HotIf !IsPowerMenu
F13 & e::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+{end}")
		} else {
			Send("{end}")
		}
	} else if GetKeyState("Shift") {
		global IsPowerMenu
		if GetKeyState("Shift") {
			IsPowerMenu := true
		}
	}
}

#HotIf IsPowerMenu
	e::
	{
		global IsPowerMenu
		if ! GetKeyState("Shift") {
			Shutdown 0
			IsPowerMenu := false
		}
	}
	s::
	{
		global IsPowerMenu
		if ! GetKeyState("Shift") {
			Shutdown 9
			IsPowerMenu := false
		}
	}
	r::
	{
		global IsPowerMenu
		if ! GetKeyState("Shift") {
			Shutdown 2
			IsPowerMenu := false
		}
	}
#HotIf

IsScreenShot := false

#HotIf !IsScreenShot
	F13 & s::
	{
		global IsScreenShot
		if GetKeyState("Ctrl", "P") {
			IsScreenShot := true
		}
	}
#HotIf IsScreenShot
	w::
	{
		global IsScreenShot
		if ! GetKeyState("Shift") {
			Send "#{PrintScreen}"
			IsScreenShot := false
		}
	}
	p::
	{
		global IsScreenShot
		if ! GetKeyState("Shift") {
			Send "#+s"
			IsScreenShot := false
		}
	}
#HotIf

IsScreenRecord := false

#HotIf !IsScreenRecord
	F13 & r::
	{
		global IsScreenRecord
		if GetKeyState("Ctrl", "P") {
			IsScreenRecord := true
		}
	}
#HotIf IsScreenRecord
	w::
	{
		global IsScreenRecord
		if ! GetKeyState("Shift") {
			Run("C:\Program Files\ScreenToGif\ScreenToGif.exe -o screen-recorder -c")
			IsScreenRecord := false
		}
	}
#HotIf

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
			Run("C:\Program Files\Mozilla Firefox\firefox.exe")
			IsLauncher := false
		}
	}

	f::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			Run("explorer.exe")
			IsLauncher := false
		}
	}

	#UseHook

	*i::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			if GetKeyState("Ctrl", "P") {
				if ! (PID := ProcessExist("ms-teams.exe")) {
					; NOTE: pin teams to task bar before use
					Send("#4")
				}
				IsLauncher := false
			} else {
				if ! (PID := ProcessExist("slack.exe")) {
					Run(USERPROFILE "\AppData\Local\slack\slack.exe")
				}
				IsLauncher := false
			}
		}
	}

	m::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			RunWait("taskmgr.exe")
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

~RCtrl up::
{
	If (A_PriorKey = "RControl") {
		Send "{Esc}"
	}
}

F13 & Enter::
{
	if ! GetKeyState("Shift") {
		if ! (PID := ProcessExist("wezterm-gui.exe")) {
			Run(".\wezterm-gui.exe", "C:\Program Files\WezTerm")
		}
	}
}

F13 & `;::
{
	Send("#v")
}

AppsKey::LWin

~LShift::
{
	KeyWait "LShift"
	if (A_TimeSinceThisHotkey < 200 and A_PriorKey = "LShift") {
		Send "("
	}
}

~RShift::
{
	KeyWait "RShift"
	if (A_TimeSinceThisHotkey < 200 and A_PriorKey = "RShift") {
		Send ")"
	}
}

~LAlt::
{
	KeyWait "LAlt"
	if (A_TimeSinceThisHotkey < 200 and A_PriorKey = "LAlt") {
		Send "{Tab}"
	}
}

~+LAlt::
{
	KeyWait "LAlt"
	if (A_TimeSinceThisHotkey < 200 and A_PriorKey = "LAlt") {
		Send "+{Tab}"
	}
}

~^LAlt::
{
	KeyWait "LAlt"
	if (A_TimeSinceThisHotkey < 200 and A_PriorKey = "LAlt") {
		Send "^{Tab}"
	}
}

~+^LAlt::
{
	KeyWait "LAlt"
	if (A_TimeSinceThisHotkey < 200 and A_PriorKey = "LAlt") {
		Send "+^{Tab}"
	}
}
