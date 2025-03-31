function Export-CMConfigurationItems {
    <#
    .Synopsis
    Exports configuration items from an input file, policyName, or scope..
    .Description
    Exports configuration items from an input file, policyName, or scope. If using an input file, the headers required = policyName
    .Example
    Export-g46CMConfigurationItems -InputFilePath "C:\temp\backup.csv"
    Export-g46CMConfigurationItems -scope Unassigned
    Export-g46CMConfigurationItems -PolicyName "CIName"
    .Parameter InputFilePath
    Path to the file to be imported.
    .Parameter PolicyName
    Name of the configuration item, or multiple configuration items
    .Parameter Scope
    Can choose between Assigned (InUse = True), Unassigned (InUse = False), All
    .Notes
    Files need to be exported locally. I was getting errors when trying to export directly to the file share.
    #> 
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)]
        [string]$InputFilePath,
        [Parameter(Mandatory = $False)]
        [array]$PolicyName,
        [Parameter(Mandatory = $False)]
        [ValidateSet("All", "Assigned", "Unassigned")]$Scope
    )

    #region Declarations
    $FunctionName = $MyInvocation.MyCommand.Name.ToString()
    $date = Get-Date -Format yyyyMMdd-HHmm
    if ($outputdir.Length -eq 0) { $outputdir = $pwd }
    $LogFilePath = "$OutputDir\$FunctionName-$date.log"
    $configurationitemFiles = @()
    $ResultsArray = @()
    #endregion

    #region Input Validation
    if ($PolicyName -and ($InputFilePath -or $scope)) {
        Write-Error -message "Error: Only one of InputFilePath, PolicyName, or Scope can be provided."
        return
        if ($InputFilePath -and ($PolicyName -or $scope)) {
            Write-Error -message "Error: Only one of InputFilePath, PolicyName, or Scope can be provided."
            return
        }
        if ($Scope -and ($PolicyName -or $InputFilePath)) {
            Write-Error -message "Error: Only one of InputFilePath, PolicyName, or Scope can be provided."
            return
        }
    }
    #endregion

    #region Backup Folder Creation
    $folderDate = Get-Date -format FileDate
    $BackupDestination = "c:\temp\$folderDate"
    $ServerDestination = "\\fs01.joeloveless.com\CM_Backup\$folderdate" #Change this to match your environment
    $OutputFilePath = "$BackupDestination\$FunctionName-$date.csv" 

    if (Test-Path $BackupDestination) {
        #Folder already exists, do nothing
    }
    else {
        Try {
            New-Item -Path $BackupDestination -ItemType directory | Out-Null
            Write-Output "Folder created at $BackupDestination"
        }
        Catch {
            Write-Error -message "Error creating folder at $BackupDestination : $_"
            return
        }
    }

    if (Test-Path $ServerDestination) {
        #Folder already exists, do nothing
    }
    else {
        Try {
            New-Item -Path $ServerDestination -ItemType directory | Out-Null
            Write-Output "Folder created at $ServerDestination" -
        }
        Catch {
            Write-Error -message "Error creating folder at $ServerDestination : $_"
            return
        }
    }
    #endregion

    #InputFilePath specified
    if ($InputFilePath) {
        $InputFilePath = $InputFilePath.Trim('"')
        Try { 
            $csv = Import-Csv -path $InputFilePath -ErrorAction Stop
            Write-Output "CSV imported from $InputFilePath"
            $PolicyName = $csv.PolicyName
        }
        Catch {
            Write-Output "Error importing CSV file: $_"
            return
        }
    }

    Connect-g46CMProdSite
    # Scope specified
    if ($Scope) {
        switch ($Scope) {
            "All" {
                $PolicyName = (Get-CMConfigurationItem -name * -fast).LocalizedDisplayName
                $policycount = $PolicyName.count
                Write-Output "Gathering All configuration items"
                Write-Output "Configuration items found: $policycount"
            }
            "Unassigned" {
                $PolicyName = (Get-CMConfigurationItem -name * -fast | Where-Object { -not $_.InUse }).LocalizedDisplayName
                $policycount = $PolicyName.count
                Write-Output "Gathering unassigned configuration items"
                Write-Output "Configuration items found: $policycount"

            }
            "Assigned" {
                $PolicyName = (Get-CMConfigurationItem -name * -fast | Where-Object { $_.InUse }).LocalizedDisplayName
                $policycount = $PolicyName.count
                Write-Output "Gathering assigned configuration items"
                Write-Output "Configuration Items found: $policycount"
            }
        }
    }

    #PolicyName specified
    if ($PolicyName) {
        $PolicyName = $PolicyName.Trim('"')
    }

    foreach ($policy in $PolicyName) {
        $configurationItems = Get-CMConfigurationItem -Name $policy -Fast
        if (!$configurationItems) {
            Write-Warning -message "No configuration items found for $policy"
            continue
        }

        foreach ($item in $configurationItems) {
            Try {
                Export-CMConfigurationItem -id $item.CI_ID -path "$BackupDestination\$($item.CI_ID).cab" 
                $configurationitemFiles += "$($item.CI_ID).Cab"
                Write-Output "Exporting $($item.LocalizedDisplayName) to $BackupDestination\$($item.CI_ID).cab"
                
            }
            Catch {
                Write-Error -message "Error exporting $($item.LocalizedDisplayName): $_"
            }
            $result = New-Object -TypeName PSObject -Property @{
                PolicyName = $item.localizedDisplayName
                PolicyID   = $item.CI_ID
            }
            $ResultsArray += $result
        }
    }
    #endregion

    #region Set Location
    Try {
        Set-Location -Path $BackupDestination
    }
    Catch {
        Write-Error -message "Error setting location back to $BackupDestination : $_"
    }
    #endRegion

    #region Copy Files to Server
    Try {
        foreach ($file in $configurationitemFiles) {
            # Ensure only the specific file is copied
            $filePath = Join-Path -Path $BackupDestination -ChildPath $file
            $destinationPath = Join-Path -Path $ServerDestination -ChildPath $file

            if (Test-Path -Path $filePath) {
                Copy-Item -Path $filePath -Destination $ServerDestination -Force
                if (Test-Path -Path $destinationPath) {
                    Write-Output "Backup exists: $destinationPath"
                }
                else {
                    Write-Error -message "Backup does not exist: $destinationPath"
                }
            }
            else {
                Write-Error -message "Source file does not exist: $filePath"
            }
        }
    }
    Catch {
        Write-Error -message "Error copying files from $BackupDestination to $ServerDestination : $_"
        return
    }
    #endregion
    if ($resultsArray.count -ge 1) {
        $ResultsArray | Select-Object PolicyName, PolicyId | Sort-Object -Property PolicyName | Export-Csv -Path $outputfilepath -NoTypeInformation
        Copy-Item -path $outputfilePath -destination $serverDestination -force
    }
}
