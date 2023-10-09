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
  KeyWait, LShift
  If (A_TimeSinceThisHotkey < 300 and A_PriorKey = "LShift") {
    Send, (
  }
return

~RShift::
  KeyWait, RShift
  If (A_TimeSinceThisHotkey < 300 and A_PriorKey = "RShift") {
    Send, )
  }
return
