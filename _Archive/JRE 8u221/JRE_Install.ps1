#Log File For IE Being Open
$Logfile = "C:\InstallLogs\Error-Java.log"

$Process = Get-Process -Name iexplore -ErrorAction SilentlyContinue

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

if(($Process)) {LogWrite -logstring 'IE is open, cancelling install with error.'
exit (4)
}

else {


#Uninstall Java 7u71 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F06417071FF} /qn" -Wait

#Uninstall Java 7u71 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F03217071FF} /qn" -Wait

#Uninstall Java 7u75 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F06417075FF} /qn" -Wait 

#Uninstall Java 7u75 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F03217075FF} /qn" -Wait

#Uninstall Java 8u45 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F86418045F0} /qn" -Wait

#Uninstall Java 8u45 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F83218045F0} /qn" -Wait

#Uninstall Java 8u51 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F86418051F0} /qn" -Wait

#Uninstall Java 8u51 32 bit 
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F83218051F0} /qn" -Wait

#Uninstall Java 8u65 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F86418065F0} /qn" -Wait

#Uninstall Java 8u65 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F83218065F0} /qn" -Wait

#Uninstall Java 8u71 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F86418071F0} /qn" -Wait

#Uninstall Java 8u71 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F83218071F0} /qn" -Wait

#Uninstall Java 8u91 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F86418091F0} /qn" -Wait

#Uninstall Java 8u91 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F83218091F0} /qn" -Wait

#Uninstall Java 8u101 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180101F0} /qn" -Wait

#Uninstall Java 8u101 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180101F0} /qn" -Wait

#Uninstall Java 8u111 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180111F0} /qn" -Wait

#Uninstall Java 8u111 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180111F0} /qn" -Wait

#Uninstall Java 8u121 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180121F0} /qn" -Wait

#Uninstall Java 8u121 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180121F0} /qn" -Wait

#Uninstall Java 8u131 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180131F0} /qn" -Wait

#Uninstall Java 8u131 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180131F0} /qn" -Wait

#Uninstall Java 8u141 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180141F0} /qn" -Wait

#Uninstall Java 8u141 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180141F0} /qn" -Wait

#Uninstall Java 8u151 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180151F0} /qn" -Wait

#Uninstall Java 8u151 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180151F0} /qn" -Wait

#Uninstall Java 8u161 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180161F0} /qn" -Wait

#Uninstall Java 8u161 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180161F0} /qn" -Wait

#Uninstall Java 8u171 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180171F0} /qn" -Wait

#Uninstall Java 8u171 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180171F0} /qn" -Wait

#Uninstall Java 8u181 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180181F0} /qn" -Wait

#Uninstall Java 8u181 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180181F0} /qn" -Wait

#Uninstall Java 8u191 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180191F0} /qn" -Wait

#Uninstall Java 8u191 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180191F0} /qn" -Wait

#Uninstall Java 8u201 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180201F0} /qn" -Wait

#Uninstall Java 8u201 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180201F0} /qn" -Wait

#Uninstall Java 8u211 64 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F64180211F0} /qn" -Wait

#Uninstall Java 8u211 32 bit
Start-Process -FilePath "Msiexec.exe" -ArgumentList "/x {26A24AE4-039D-4CA4-87B4-2F32180211F0} /qn" -Wait


#Check to see if Java 7 is uninstalled
$Reg1 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F06417075FF}'
if(Test-Path $Reg1){
 LogWrite -logstring 'Java 7 still detected'
 }
$Reg2 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F03217075FF}'
if(Test-Path $Reg2){
 LogWrite -logstring 'Java 7 still detected'
 }
$Reg3 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F06417071FF}'
if(Test-Path $Reg3){
 LogWrite -logstring 'Java 7 still detected'
 }
$Reg4 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F03217071FF}'
if(Test-Path $Reg4){
 LogWrite -logstring 'Java 7 still detected'
 }
$Reg5 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F86418045F0}'
if(Test-Path $Reg5){
 LogWrite -logstring 'Java 7 still detected'
 }
$Reg6 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F83218045F0}'
if(Test-Path $Reg6){
 LogWrite -logstring 'Java 7 still detected'
 }


#Install Arguments
$Switches32 = "AgreeToLicense=YES IEXPLORER=1 MOZILLA=1 REBOOT=SUPRESS JAVAUPDATE=0 STATIC=1 /qn /L C:\InstallLogs\Install-Java32.log"
$Switches64 = "AgreeToLicense=YES IEXPLORER=1 MOZILLA=1 REBOOT=SUPRESS JAVAUPDATE=0 STATIC=1 /qn /L C:\InstallLogs\Install-Java64.log"


#Install 32 bit Java, update to new filename
Start-Process -FilePath "msiexec" -ArgumentList "/i jre1.8.0_221.msi $Switches32" -Wait

#Install 64 bit Java, update to new filename
Start-Process -FilePath "msiexec" -ArgumentList "/i jre1.8.0_22164.msi $Switches64" -Wait
}