#
# Press 'F5' to run this script. Running this script will load the ConfigurationManager
# module for Windows PowerShell and will connect to the site.
#
# This script was auto-generated at '1/22/2019 3:49:36 PM'.

# Uncomment the line below if running in an environment where script signing is 
# required.
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Site configuration
$SiteCode = "DTM" # Site code 
$ProviderMachineName = "s01p-sccmprim.intfirm.com" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams



#Pre-Create the Collection Name in SCCM"  
$collectiondir = "C:\temp\Logs" 
$domain = "intfirm" 
$collectionname = "Joe Testing - VPN Users" 
 
#Add new collection based on the file name    
Get-CMUserCollection -Name $collectionname

　  
#Read list of users from the text file  
$Users = get-content "C:\temp\vpnjan25.txt" 
foreach($user in $users) {  
$User 
try {  
Add-CMUserCollectionDirectMembershipRule -CollectionName $collectionname -ResourceId $(get-cmuser -Name "$domain\$user").ResourceID  
} 
catch {  
"Invalid client or direct membership rule may already exist: $user" | Out-File "$collectiondir\$collectionname`_invalid.log" -Append  
}  
}