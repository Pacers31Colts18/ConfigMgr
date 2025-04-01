function Connect-CMSite {
    <#
    .Synopsis
    Helper function to connecto to a CM site.
    .Description
    Will connect to a CM site. Defaults to JL1, can be changed to any site code or provider machine name.
    .Example
    Connect-CMProdSite
    #>

    param (
        [string]$SiteCode = "JL1",
        [string]$ProviderMachineName = "cm01.joeloveless.com"
    )
    
    # Customizations
    $initParams = @{}
    #$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
    #$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors
    
    # Do not change anything below this line
    
    # Import the ConfigurationManager.psd1 module 
    if ((Get-Module ConfigurationManager) -eq $null) {
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
    }
    
    # Connect to the site's drive if it is not already present
    if ((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
        New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
    }
    
    # Set the current location to be the site code.
    Set-Location "$($SiteCode):\" @initParams
    }