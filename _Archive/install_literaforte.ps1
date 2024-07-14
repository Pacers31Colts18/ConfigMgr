<#
.Synopsis
Install script for Litera Forte 12.3.2
Packaged by: Joe Loveless
Date: 8/30/2019
.Description
Install script for Litera Forte 12.3.2
.Notes
This installer does the following: Uninstalls Payne, installs pre-reqs, installs Forte, copies the MDF file, XML file, Word Template and Numbering Schemes
#>

$LogFile = "C:\InstallLogs\Install-LiteraForte-12.3.2.log"

$Word = Get-Process -Name 'WinWord' -ErrorAction SilentlyContinue


Function LogWrite
{
    Param ([string]$logstring)

    Add-content $Logfile -value $logstring
}

if ($Word)
{
    LogWrite -logstring 'Microsoft Word is open, cancelling install with error.'

    [System.Environment]::Exit(4)
}

else
{
    #Uninstall Payne

    Start-Process -FilePath "msiexec" -ArgumentList "/x {DC26176B-B263-4D1E-A3EB-0530BC36DED4} /quiet /norestart /log C:\InstallLogs\Uninstall-PayneNumberingAssistant.log " -Wait
    Start-Process -FilePath "msiexec" -ArgumentList "/x {F1491B8A-30D3-4933-9149-CF1325FB02E0} /quiet /norestart /log C:\InstallLogs\Uninstall-PayneFormsAssistant_11.1_021.log " -Wait
    Start-Process -FilePath "msiexec" -ArgumentList "/x {EDBBA12F-1EFF-4C05-9E4C-046598648788} /quiet /norestart /log C:\InstallLogs\Uninstall-PayneFormsAssistant_11.1.022.log " -Wait

    $pgGlobal = "C:\Program Files (x86)\FirmApps\Word16\Startup\pgGlobal.dotm"
    if (Test-Path $pgGlobal)
    {
        Remove-Item $pgGlobal
    }
    $pgPA = "C:\Program Files (x86)\FirmApps\Word16\Startup\pgPA.dotm"
    if (Test-Path $pgPA)
    {
        Remove-Item $pgPA
    }
    $pgAppEvent = "C:\Program Files (x86)\FirmApps\Word16\Startup\_pgAppEvent.dotm"
    if (Test-Path $pgAppEvent)
    {
        Remove-Item $pgAppEvent
    }

    #Remove Files From Previous Install
    $ForteMDF = "C:\Users\Public\Documents\Forte\Data\Forte.mdf"
    if (Test-Path $ForteMDF)
    {
        Remove-Item $ForteMDF
    }
    $ForteLog = "C:\Users\Public\Documents\Forte\Data\Forte_log.ldf"
    if (Test-Path $ForteLog)
    {
        Remove-Item $ForteLog
    }
    $PupLog = "C:\Users\Public\Documents\Forte\Data\PUP.log"
    if (Test-Path $PupLog)
    {
        Remove-Item $PupLog
    }
    $SyncErrors = "C:\Users\Public\Documents\Forte\Data\SyncErrors*.log"
    if (Test-Path $SyncErrors)
    {
        Remove-Item $SyncErrors
    }


    #Install Pre-Requisites

    Start-Process -FilePath "msiexec" -ArgumentList "/i SQLLocalDB.msi IACCEPTSQLLOCALDBLICENSETERMS=YES /quiet /norestart /log C:\InstallLogs\Install-SQLLocalDB2017.log" -Wait
    Start-Process -FilePath "vstor_redist.exe" -ArgumentList "/quiet /norestart /log C:\InstallLogs\Install-VisualStudioRuntime_10.0.60724.log" -Wait

    #Install Forte
    Start-Process -FilePath "msiexec" -ArgumentList '/i LiteraForte12.3.2_x86.msi LITERA_TAB="" LICENSEKEY=823dl15f1dh979ddhh DMS=3b CONTACTSOURCE=Outlook;IA6Web /qn /log C:\InstallLogs\Install-LiteraForte-12.3.2.log' -Wait

    #File Copies
    Copy-Item -Path "Faegre_Create.dotm" -Destination "C:\Program Files (x86)\FirmApps\Word16\Startup" -Force
    Copy-Item -Path "CIConfig.xml" -Destination "C:\Users\Public\Documents\Forte\CI\App" -Force
    Copy-Item -Path "ForteRibbon.xml" -Destination "C:\Program Files (x86)\Litera\Forte\Bin" -Force
    Copy-Item -Path "Forte.mdf" -Destination "C:\Users\Public\Documents\Forte\Data" -Force
    Copy-Item -Path "ForteNormal.dotx" -Destination "C:\Program Files (x86)\Litera\Forte\Templates" -Force
    Copy-Item -Path "ForteDMSConfig.xml" -Destination "C:\Users\Public\Documents\Forte\Data" -Force
    Copy-Item -Path "Numbering\*" -Destination "C:\Users\Public\Documents\Forte\Numbering\App" -Force     
    Start-Sleep -Seconds 20
}

#Run Sync

$computer = $env:COMPUTERNAME
$computerSystem = Get-WMIObject -class Win32_ComputerSystem -ComputerName $computer
$LoggedOnUser = $computerSystem.UserName

if (!$LoggedOnUser)
{
    $nouser_action = New-ScheduledTaskAction -Execute 'C:\Program Files (x86)\Litera\forte\Bin\LiteraMicrosystems.Create.Sync.Process.exe'
    $nouser_trigger = New-ScheduledTaskTrigger -AtLogOn
    $nouser_principal = New-ScheduledTaskPrincipal -UserId SYSTEM
    $nouser_task = New-ScheduledTask -Action $nouser_action -Trigger $nouser_trigger -Principal $nouser_principal
    Register-ScheduledTask LiteraMicrosystems.Create.Sync.Process -InputObject $nouser_task
    Start-ScheduledTask -TaskName LiteraMicrosystems.Create.Sync.Process
    LogWrite -logstring 'No logged on user. Creating scheduled task to run at logon.'

}

else
{

    $action = New-ScheduledTaskAction -Execute 'C:\Program Files (x86)\Litera\forte\Bin\LiteraMicrosystems.Create.Sync.Process.exe'
    $trigger = (New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(7))
    $principal = New-ScheduledTaskPrincipal $LoggedOnUser
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
    Register-ScheduledTask LiteraMicrosystems.Create.Sync.Process -InputObject $task
    Start-ScheduledTask -TaskName LiteraMicrosystems.Create.Sync.Process
    Start-Sleep -Seconds 15
    Unregister-ScheduledTask -TaskName LiteraMicrosystems.Create.Sync.Process -Confirm:$false
    LogWrite -logstring "$LoggedOnUser logged on, LiteraMicrosystems.Create.Sync.Process ran successfully"

    Start-Sleep -Seconds 15

}

