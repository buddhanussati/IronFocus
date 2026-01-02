#Requires AutoHotkey v2.0
#SingleInstance Ignore
#NoTrayIcon 
Persistent

; Set high priority
ProcessSetPriority "High"

; --- 1. PREVENT RESET CHEAT ---
if WinExist(A_ScriptName " - Focus Mode Active") {
    MsgBox "Focus Mode is already active! You cannot reset the timer.", "Access Denied", "Icon! T3"
    ExitApp
}

; 2. Define Browser Group
GroupAdd "Browsers", "ahk_exe chrome.exe"
GroupAdd "Browsers", "ahk_exe msedge.exe"
GroupAdd "Browsers", "ahk_exe firefox.exe"
GroupAdd "Browsers", "ahk_exe brave.exe"
GroupAdd "Browsers", "ahk_exe coccoc.exe"

; 3. Ask for focus minutes
UserResponse := InputBox("How many minutes do you want to focus?", "Focus Timer", "w200 h130", "20")
if (UserResponse.Result = "Cancel" or UserResponse.Value = "")
    ExitApp

; 4. Ask for Allowed Titles
TitleInput := InputBox("Enter allowed keywords separated by commas:", "Allowed Websites", "w300 h150", "Gemini, copilot, new tab, grok, deepseek, settings")
if (TitleInput.Result = "Cancel")
    ExitApp

; Mark this instance as active
A_AllowMainWindow := true 
WinSetTitle(A_ScriptName " - Focus Mode Active", A_ScriptHwnd)

AllowedTitles := StrSplit(TitleInput.Value, ",")
for index, value in AllowedTitles
    AllowedTitles[index] := Trim(value)

FocusMinutes := Number(UserResponse.Value)
FocusSeconds := FocusMinutes * 60

; --- ANTI-CHEAT MECHANISM ---
SetTimer CheckTaskManager, 100

CheckTaskManager() {
    if WinExist("ahk_exe Taskmgr.exe")
        WinClose "ahk_exe Taskmgr.exe"
    if WinExist("ahk_exe resmon.exe")
        WinClose "ahk_exe resmon.exe"
}

; 5. Create the Progress UI
global FocusGui := Gui("+AlwaysOnTop -Caption +Border +ToolWindow") 
FocusGui.BackColor := "Black"
FocusGui.SetFont("s9 w700", "Segoe UI") 
FocusText := FocusGui.Add("Text", "Center w100 cWhite +0x0100", "Focus: " FocusMinutes "m 0s")

; --- DRAGGABLE LOGIC ---
OnMessage(0x0201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    PostMessage 0xA1, 2, , FocusGui.Hwnd 
}

; --- [NEW] UNIVERSAL POSITIONING LOGIC ---
; 1. Initialize the window hidden so we can measure it
FocusGui.Show("Hide") 

; 2. Get the exact width/height of the GUI (handles different fonts/scalings)
FocusGui.GetPos(,, &GuiW, &GuiH) 

; 3. Get the 'Work Area' (Screen size minus the Taskbar)
; The '1' argument means Primary Monitor
MonitorGetWorkArea(1, &WL, &WT, &WR, &WB)

; 4. Math: Right Edge - GUI Width - Padding (10px)
TargetX := WR - GuiW - 10 

; 5. Math: Bottom Edge - GUI Height - Padding (10px)
TargetY := WB - GuiH - 10 

; 6. Show the window at the calculated safe spot
FocusGui.Show("x" TargetX " y" TargetY " NoActivate")
; -------------------------------------------

; 6. Focus Countdown + Multi-Browser Guard Loop
Loop FocusSeconds {
    if WinActive("ahk_group Browsers") {
        CurrentTitle := WinGetTitle("A")
        IsAllowed := false
        
        if InStr(CurrentTitle, ":\") or InStr(CurrentTitle, ".html") {
            IsAllowed := true
        } else {
            for TitlePart in AllowedTitles {
                if (TitlePart != "" and InStr(CurrentTitle, TitlePart)) {
                    IsAllowed := true
                    break
                }
            }
        }
        
        if (!IsAllowed) {
            Send "^w"
            TrayTip "Focus Mode", "Distraction closed!", 1
        }
    }

    RemainingSec := FocusSeconds - A_Index
    Mins := Floor(RemainingSec / 60)
    Secs := Mod(RemainingSec, 60)
    
    ; --- VISUAL URGENCY UPDATE (Last 1 Minute) ---
    if (RemainingSec <= 60) {
        FocusGui.BackColor := "Red"
        FocusText.SetFont("cBlack") 
    }

    try {
        FocusText.Value := "Focus: " Mins "m " Secs "s"
    }
    
    Sleep 1000
}

FocusGui.Destroy()
SetTimer CheckTaskManager, 0 

; --- START OF LOCK LOGIC (3 MINUTES) ---
BlockInput "On" 
LockGui := Gui("+AlwaysOnTop -Caption +Border")
LockGui.BackColor := "Red"
LockGui.SetFont("s20 w700", "Segoe UI")
LockGui.Add("Text", "Center w380", "TIME IS UP!")
LockGui.SetFont("s14 w400")
DisplayText := LockGui.Add("Text", "Center w380", "Locking PC in: 180s")
LockGui.Show("w400 h150")

Loop 180 {
    CurrentCount := 180 - A_Index
    Sleep 1000
    DisplayText.Value := "Locking PC in: " CurrentCount "s"
}

BlockInput "Off"
LockGui.Destroy()

DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 1, "Int", 0)
ExitApp