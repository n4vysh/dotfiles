#Requires AutoHotkey >=2
#SingleInstance Force

USERPROFILE := EnvGet("USERPROFILE")

; Reload configuration
F13 & c::
{
	if GetKeyState("Shift") {
		RunWait("glazewm.exe command wm-reload-config", , "Hide")
		RunWait("glazewm.exe command wm-redraw", , "Hide")
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
			RunWait("glazewm.exe command focus --direction left", , "Hide")
		}
	} else {
		RunWait("glazewm.exe command move --direction left", , "Hide")
	}
}

F13 & j::{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+^{end}")
		} else {
			Send("^{end}")
		}
	} else {
		if ! GetKeyState("Shift") {
			RunWait("glazewm.exe command focus --direction down", , "Hide")
		} else {
			RunWait("glazewm.exe command move --direction down", , "Hide")
		}
	}
}

F13 & k::
{
	if GetKeyState("Ctrl", "P") {
		if GetKeyState("Shift") {
			Send("+^{home}")
		} else {
			Send("^{home}")
		}
	} else {
		if ! GetKeyState("Shift") {
			RunWait("glazewm.exe command focus --direction up", , "Hide")
		} else {
			RunWait("glazewm.exe command move --direction up", , "Hide")
		}
	}
}

F13 & l::
{
	if ! GetKeyState("Shift") {
		if GetKeyState("Ctrl", "P") {
			DllCall("LockWorkStation")
		} else {
			RunWait("glazewm.exe command focus --direction right", , "Hide")
		}
	} else {
		RunWait("glazewm.exe command move --direction right", , "Hide")
	}
}

; Manipulate windows
F13 & -::
{
	if GetKeyState("Shift") {
		RunWait("glazewm.exe command toggle-minimized", , "Hide")
	}
}

F13 & space::
{
	if GetKeyState("Shift") {
		RunWait("glazewm.exe command toggle-floating --centered", , "Hide")
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
		RunWait("glazewm.exe command toggle-fullscreen", , "Hide")
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

F13 & u::
{
	if GetKeyState("Ctrl", "P") {
		Send("+{home}")
		Send("{backspace}")
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

; Workspaces
F13 & 1::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 1", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 1", , "Hide")
	}
}

F13 & 2::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 2", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 2", , "Hide")
	}
}

F13 & 3::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 3", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 3", , "Hide")
	}
}

F13 & 4::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 4", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 4", , "Hide")
	}
}

F13 & 5::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 5", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 5", , "Hide")
	}
}

F13 & 6::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 6", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 6", , "Hide")
	}
}

F13 & 7::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 7", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 7", , "Hide")
	}
}

F13 & 8::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 8", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 8", , "Hide")
	}
}

F13 & 9::
{
	if ! GetKeyState("Shift") {
		RunWait("glazewm.exe command focus --workspace 9", , "Hide")
	} else {
		RunWait("glazewm.exe command move --workspace 9", , "Hide")
	}
}

F13 & p::
{
	if ! GetKeyState("Shift") {
		if GetKeyState("Ctrl", "P") {
			Send("{up}")
		} else {
			RunWait("glazewm.exe command focus --prev-active-workspace", , "Hide")
		}
	} else {
		if GetKeyState("Ctrl", "P") {
			Send("+{up}")
		} else {
			RunWait("glazewm.exe command move --prev-active-workspace", , "Hide")
		}
	}
}

F13 & n::
{
	if ! GetKeyState("Shift") {
		if GetKeyState("Ctrl", "P") {
			Send("{down}")
		} else {
			RunWait("glazewm.exe command focus --next-active-workspace", , "Hide")
		}
	} else {
		if GetKeyState("Ctrl", "P") {
			Send("+{down}")
		} else {
			RunWait("glazewm.exe command move --next-active-workspace", , "Hide")
		}
	}
}

; Misc
F13 & q::
{
	if GetKeyState("Shift") {
		RunWait("glazewm.exe command close", , "Hide")
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

F13 & m::
{
		if GetKeyState("Ctrl", "P") {
			Send("{enter}")
		}
}

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

F13 & i::{
	if GetKeyState("Ctrl", "P") {
		Send("!{right}")
	}
}

IsLauncher := false

#HotIf !IsLauncher
	F13 & o::
	{
		global IsLauncher
		if ! GetKeyState("Shift") {
			if GetKeyState("Ctrl", "P") {
				Send("!{left}")
			} else {
				IsLauncher := true
			}
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
			Run("taskmgr.exe")
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
		if GetKeyState("Ctrl", "P") {
			Send "+{Enter}"
		} else {
			if ! (PID := ProcessExist("wezterm-gui.exe")) {
				Run(".\wezterm-gui.exe", "C:\Program Files\WezTerm")
			}
		}
	}
}

; clipboard manager
F13 & `;::
{
	Send("#v")
}

; super key
Pause::LWin

; thumb cluster
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

; disable tab
Tab::Return
+Tab::Return
^Tab::Return
+^Tab::Return

; space cadet shift
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
