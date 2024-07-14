<#
To install the English version silently via the command line for all users on the machine, use the following syntax:

32-bit: msiexec /i ue_english.msi ALLUSERS=1 /qn
64-bit: msiexec /i ue_english_64.msi ALLUSERS=1 /qn

Further documentation on msiexec parameters and options is available on Microsoft's website.

IMPORTANT NOTE
====================
Due to technical limitations in MS Windows Installer, the MSI installation package must completely uninstall any previous version of the application before proceeding with the installation.  During uninstallation, the license will also be deactivated on the target system.  Therefore, updating the application with the MSI requires that you reactivate the license after the installation successfully completes.

This deactivation is usually not an issue for corporate customers, as the license is typically applied silently and automatically using the method described below.

SILENT REGISTRATION
====================
You can silently register/activate UltraEdit from the command line.  This is possible after UltraEdit has been successfully installed on the system.  The command line syntax for this is as follows:

For 32 bit
  uedit32.exe /lic,e="<LicenseID>|<Password>"
For 64 bit
  uedit64.exe /lic,e="<LicenseID>|<Password>"

...where "<LicenseID>" is your unique license ID and "<Password>" is your unique password. Example:

  uedit32.exe /lic,e="1234567|AzBxcYD"
#>


$Arguments = "/quiet /norestart /Log C:\InstallLogs\Install-UltraEdit26.log"

Start-Process -FilePath "msiexec" -ArgumentList "/i ue_english_64.msi $Arguments" -Wait

Set-Location -Path "C:\Program Files\IDM Computer Solutions\UltraEdit\"

.\uedit64.exe /lic,e="3847794|K8Z2PUZEM"
