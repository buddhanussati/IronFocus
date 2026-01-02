# IronFocus 

**IronFocus** is a lightweight, "scorched earth" productivity tool for Windows built with AutoHotkey v2. It is designed for those who find themselves bypassing their own focus timers. Unlike standard apps, IronFocus actively prevents you from closing it or accessing distractions until your work is done.

## 🚀 Key Features

* **Browser Guard:** Automatically closes tabs in Chrome, Edge, Firefox, and Brave that don't match your "Allowed Keywords."
* **Anti-Cheat Protection:**
    * Automatically closes Task Manager and Resource Monitor to prevent the script from being killed.
    * Prevents multiple instances (you cannot "reset" the timer by launching the app again).
* **Draggable Overlay:** A sleek, "Always on Top" countdown timer that stays in view without stealing keyboard focus.
* **The "Final Lockdown":** When the timer hits zero, the app enforces a 3-minute cooldown period where inputs are blocked before putting the PC to sleep—ensuring you actually take a break.

## Installation

1.  Download the `IronFocus.exe` from the [Releases](#) page.
2.  Run the executable.
3.  **Note:** Because this script interacts with Task Manager and monitors window titles, your Antivirus or Windows Defender may flag it as a "False Positive." You may need to add an exclusion for the app to function correctly.

## 📖 How to Use

1.  **Set Your Time:** Enter the duration of your deep-work session in minutes.
2.  **Define Allowed Sites:** Enter keywords (comma-separated) for sites you *need* for work (e.g., `StackOverflow, GitHub, Gmail`).
3.  **Work:** The timer will appear in the bottom-right corner. If you navigate to a website not on your allowed list, the tab will be closed instantly.
4. **Forced Sleep:** After the 3-minute cooldown, the PC will trigger a system suspend (Sleep/Hibernate).

## ⚠️ Warning

This application is designed to be **intrusive** to help maintain discipline. 
* It **will** close Task Manager.
* It **will** block inputs during the final 3-minute cooldown.
* Use with caution if you have unsaved work in other background applications. But don't worry too much, since the PC only sleeps, none of your work will be forever lost.
## How to Emergency Exit
If there was an easy exit button, you would use it when you got bored. IronFocus removes that option.
## Requirements

* Windows PC
* No installation required (Standalone EXE)

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
