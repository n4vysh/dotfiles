#Requires AutoHotkey >=2
#SingleInstance Force

if ! (PID := ProcessExist("komorebi.exe")) {
	USERPROFILE := EnvGet("USERPROFILE")
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
!+c::Reload

; Focus windows
!h::Focus("left")
!j::Focus("down")
!k::Focus("up")
!l::Focus("right")

; Move windows
!+h::Move("left")
!+j::Move("down")
!+k::Move("up")
!+l::Move("right")

; Manipulate windows
!+space::ToggleFloat()
!f::ToggleMaximize()

; Workspaces
!1::FocusWorkspace(0)
!2::FocusWorkspace(1)
!3::FocusWorkspace(2)
!4::FocusWorkspace(3)
!p::CycleWorkspace("previous")
!n::CycleWorkspace("next")

; Send windows across workspaces
!+1::SendToWorkspace(0)
!+2::SendToWorkspace(1)
!+3::SendToWorkspace(2)
!+4::SendToWorkspace(3)
!+p::CycleSendToWorkspace("previous")
!+n::CycleSendToWorkspace("next")

; Misc
!+q::Close()

Capslock::LWin

F13 & b::Left
F13 & f::Right
F13 & p::Up
F13 & n::Down

F13 & a::Home
F13 & e::End

F13 & i::Tab

F13 & h::Backspace
F13 & d::Delete
F13 & m::Enter

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
