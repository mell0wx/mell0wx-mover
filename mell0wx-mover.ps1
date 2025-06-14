Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# File Type Categories
$docExts   = @(".doc", ".docx", ".pdf", ".ppt", ".pptx", ".xls", ".xlsx", ".txt", ".odt", ".ods", ".odp")
$musicExts = @(".mp3", ".wav", ".flac", ".aac", ".ogg", ".wma", ".m4a")
$picExts   = @(".jpg", ".jpeg", ".png", ".tiff", ".gif", ".bmp", ".webp")
$videoExts = @(".mp4", ".mov", ".avi", ".mkv", ".wmv", ".flv", ".mpeg", ".mpg", ".webm")

$Downloads = "$env:USERPROFILE\Downloads"
$Documents = "$env:USERPROFILE\Documents"
$Music     = "$env:USERPROFILE\Music"
$Pictures  = "$env:USERPROFILE\Pictures"
$Videos    = "$env:USERPROFILE\Videos"
$ScriptPath = $MyInvocation.MyCommand.Path
$TaskName = "OrganizeDownloadsTask"

# Log File location (set via GUI)
$global:LogFolder = "$env:USERPROFILE\Documents"
$global:LogFile = Join-Path $global:LogFolder "OrganizeDownloads.log"

function Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp`t$message" | Out-File -FilePath $global:LogFile -Append
}

function Move-Files {
    $files = Get-ChildItem -Path $Downloads -File
    foreach ($file in $files) {
        $ext = $file.Extension.ToLower()
        $destination = $null

        if ($docExts -contains $ext) {
            $destination = $Documents
        } elseif ($musicExts -contains $ext) {
            $destination = $Music
        } elseif ($picExts -contains $ext) {
            $destination = $Pictures
        } elseif ($videoExts -contains $ext) {
            $destination = $Videos
        }

        if ($destination) {
            try {
                Move-Item -Path $file.FullName -Destination $destination -Force
                Log "Moved $($file.Name) to $destination"
            } catch {
                Log "Failed to move $($file.Name): $_"
            }
        } else {
            Log "Skipped $($file.Name) - Unrecognized file type"
        }
    }
}

function Set-Schedule($frequency) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
    switch ($frequency) {
        "Hourly" {
            $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 60) -RepetitionDuration ([TimeSpan]::MaxValue)
        }
        "Daily" {
            $trigger = New-ScheduledTaskTrigger -Daily -At 9am
        }
        "Weekly" {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9am
        }
    }
    if ($frequency -ne "None") {
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -RunLevel Highest -User $env:USERNAME -Force
        Log "Scheduled task set to run $frequency."
        [System.Windows.Forms.MessageBox]::Show("Task scheduled: $frequency", "Success")
    } else {
        Log "Task schedule disabled."
        [System.Windows.Forms.MessageBox]::Show("Scheduled task removed", "Disabled")
    }
}

function Select-LogFolder {
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Choose where to store the log file"
    $dialog.SelectedPath = $global:LogFolder
    if ($dialog.ShowDialog() -eq "OK") {
        $global:LogFolder = $dialog.SelectedPath
        $global:LogFile = Join-Path $global:LogFolder "OrganizeDownloads.log"
        [System.Windows.Forms.MessageBox]::Show("Log file will be stored at:`n$global:LogFile", "Log Location Set")
    }
}

# ---------- GUI ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "Downloads Organizer Scheduler"
$form.Size = New-Object System.Drawing.Size(320,300)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Choose how often to run the organizer:"
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Location = New-Object System.Drawing.Point(20,20)
$form.Controls.Add($label)

$btnHourly = New-Object System.Windows.Forms.Button
$btnHourly.Text = "Schedule Hourly"
$btnHourly.Size = New-Object System.Drawing.Size(260,30)
$btnHourly.Location = New-Object System.Drawing.Point(20,50)
$btnHourly.Add_Click({ Set-Schedule "Hourly" })
$form.Controls.Add($btnHourly)

$btnDaily = New-Object System.Windows.Forms.Button
$btnDaily.Text = "Schedule Daily"
$btnDaily.Size = New-Object System.Drawing.Size(260,30)
$btnDaily.Location = New-Object System.Drawing.Point(20,90)
$btnDaily.Add_Click({ Set-Schedule "Daily" })
$form.Controls.Add($btnDaily)

$btnWeekly = New-Object System.Windows.Forms.Button
$btnWeekly.Text = "Schedule Weekly"
$btnWeekly.Size = New-Object System.Drawing.Size(260,30)
$btnWeekly.Location = New-Object System.Drawing.Point(20,130)
$btnWeekly.Add_Click({ Set-Schedule "Weekly" })
$form.Controls.Add($btnWeekly)

$btnDisable = New-Object System.Windows.Forms.Button
$btnDisable.Text = "Disable Schedule"
$btnDisable.Size = New-Object System.Drawing.Size(260,30)
$btnDisable.Location = New-Object System.Drawing.Point(20,170)
$btnDisable.Add_Click({ Set-Schedule "None" })
$form.Controls.Add($btnDisable)

$btnLogPath = New-Object System.Windows.Forms.Button
$btnLogPath.Text = "Set Log File Location"
$btnLogPath.Size = New-Object System.Drawing.Size(260,30)
$btnLogPath.Location = New-Object System.Drawing.Point(20,210)
$btnLogPath.Add_Click({ Select-LogFolder })
$form.Controls.Add($btnLogPath)

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Close"
$btnClose.Size = New-Object System.Drawing.Size(260,30)
$btnClose.Location = New-Object System.Drawing.Point(20,250)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# Run organizer once and show GUI
Move-Files
$form.Topmost = $true
$form.ShowDialog()
