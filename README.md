# mell0wx-mover

🗂️ **mell0wx-mover** is a smart Windows file organizer that automatically sorts your `Downloads` folder into appropriate directories based on file type — with a sleek GUI, scheduling options, and logging.

> Created by [@mell0wx](https://github.com/mell0wx) to automate digital clutter cleanup ✨

---

## 🚀 Features

- 🔁 **Auto-Moves Files** by type:
  - **Documents**: `.doc`, `.pdf`, `.xlsx`, etc. → `Documents/`
  - **Music**: `.mp3`, `.wav`, etc. → `Music/`
  - **Pictures**: `.jpg`, `.png`, etc. → `Pictures/`
  - **Videos**: `.mp4`, `.mov`, etc. → `Videos/`
- 🧠 **Smart Filter** — leaves unknown file types untouched.
- 🖼️ GUI to:
  - Set/Change task **schedule** (Hourly, Daily, Weekly, Disable)
  - Select **log file** save location
- 📝 Logging of all actions (moved, skipped, errors).
- 🧩 Lightweight `.exe` app — no PowerShell scripting required for end users.

---

## ⚙️ How to Use

1. 📥 [Download the latest `.exe`](https://github.com/mell0wx/mell0wx-mover/releases) from the Releases page.
2. 🖱️ **Double-click** `mell0wx-mover.exe` to run.
3. The app will:
   - ✅ Immediately organize your `Downloads` folder
   - 🧭 Launch a GUI to:
     - Schedule the task (Hourly, Daily, Weekly)
     - Disable scheduling if desired
     - Pick where to save logs

> ℹ️ The app runs silently in the background after you set your schedule.

---

## 📝 Logging

- All operations are logged in a timestamped `.log` file.
- You choose the log file location during first run or via GUI.
- Example log entries:
2025-06-14 14:22:01 Moved file1.pdf to C:\Users\User\Documents
2025-06-14 14:22:01 Skipped installer.exe – Unrecognized file type


---

## 📁 File Types Handled

| Category   | File Types                                  |
|------------|---------------------------------------------|
| Documents  | `.doc`, `.docx`, `.pdf`, `.xls`, `.ppt`, etc |
| Music      | `.mp3`, `.wav`, `.flac`, `.aac`, `.ogg`     |
| Pictures   | `.jpg`, `.jpeg`, `.png`, `.tiff`, `.webp`   |
| Videos     | `.mp4`, `.mov`, `.avi`, `.mkv`, `.webm`     |

All other files remain in your `Downloads` folder.

---

## 📦 Developer Instructions (Optional)

If you'd rather work with the PowerShell script directly:

```powershell
# Clone the repo
git clone https://github.com/mell0wx/mell0wx-mover.git
cd mell0wx-mover

# Run the script
.\Organize-Downloads.ps1
```

To convert .ps1 to .exe, use:
```powershell
Install-Module -Name PS2EXE -Scope CurrentUser -Force

Invoke-PS2EXE -InputFile "Organize-Downloads.ps1" `
              -OutputFile "mell0wx-mover.exe" `
              -iconFile "mell0wx-folder.ico" `
              -NoConsole
```

💡 Tips

    📂 Add the EXE to Windows Startup:
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

🧼 Use the Weekly schedule to keep Downloads tidy without reminders.

🧑‍💻 Contributing

Want to improve or add file rules? Open a PR or issue at github.com/mell0wx/mell0wx-mover

🔒 License

MIT © mell0wx

---
