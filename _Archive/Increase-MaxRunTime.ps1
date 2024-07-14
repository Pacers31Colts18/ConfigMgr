<#
.Synopsis
This will set the Max Run Time for Cumulative Updates and Security Monthly Quality Rollups to 120 minutes.
.Description
Max Run Time will be set to 120 minutes for Cumulative and Security Monthly Quality Rollups.
.Notes
Created by: Joe Loveless
Last Modified: 5/17/2019
#>

$SiteCode = "DTM"
$ProviderMachineName = "s01p-sccmprim.intfirm.com"

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


Get-CMSoftwareUpdate -Name "*Cumulative Update*" -Fast | Set-CMSoftwareUpdate -MaximumExecutionMins 120 -Verbose

Get-CMSoftwareUpdate -Name "*Security Monthly Quality Rollup*" -Fast | Set-CMSoftwareUpdate -MaximumExecutionMins 120 -Verbose