function Export-CMDeviceCollectionPilotMembers {
    <#
    .Synopsis
    Will return a list of random workstations to form a pilot based on a percentage given.
    .Description
    Will return a list of random workstations to form a pilot based on a percentage given.
    .Example
    Export-CMDeviceCollectionPilotMembers -SourceCollectionName "CollectionName" -Percentage "5"
    #> 

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)]
        [array]$SourceCollectionName,
        [Parameter(Mandatory = $True)]
        [int]$Percentage = (Read-Host -Prompt 'Percentage')
    )

    #region Declarations
    $FunctionName = $MyInvocation.MyCommand.Name.ToString()
    $date = Get-Date -Format yyyyMMdd-HHmm
    if ($outputdir.Length -eq 0) { $outputdir = $pwd }
    $OutputFilePath = "$OutputDir\$FunctionName-$date.csv"
    $LogFilePath = "$OutputDir\$FunctionName-$date.log"
    $resultsArray = @()
    $exclusionMembersArray = @()
    #endregion
    

    #region Parameter Logic
    if ($SourceCollectionName.Count -eq 0) { $SourceCollectionName = (Get-CMCollection | Select-Object CollectionID, Name, LimitToCollectionName, MemberCount | Out-GridView -PassThru).Title }
    #endregion

    #region Collection Processing
    foreach ($collection in $sourceCollectionName) { 
        try {
            $collMembers = Get-CMCollection -Name $collection | Get-CMCollectionMember | Select-Object Name, ResourceId, PrimaryUser, Domain, AADDeviceID, AADTenantID
            Write-Output "Processing Collection: $collection (Member Count: $($collmembers.Count))" 

        }
        catch {
            Write-Error -message "An error occurred : $_"
        }
    #EXCLUSION MEMBERS
    $exclusionCollections = @(
        #Add exclusion collection names here
    )

    foreach ($exclusionCollection in $exclusionCollections) {
        try {
            $exclusionMembers = $null
            $exclusionMembers = Get-CMCollectionMember -CollectionName $exclusionCollection | Select-Object ResourceID
            Write-Output "Excluding collection: '$exclusionCollection' (Member Count: $($exclusionMembers.count)"
            $exclusionMembersArray += $exclusionMembers
        }
        catch {
            Write-Error "Unable to exclude collection '$exclusionCollection'." -level error
        }
    }

    $CollMemberswithExclusion = $CollMembers | Where-Object { $_.ResourceID -NotIn $exclusionMembersArray.ResourceID }

    #RANDOMIZATION

    #Get 10% of workstations
    $Decimal = $Percentage / 100
    $NumberofMembers = [int]($CollMemberswithExclusion.Count * $Decimal)

    #Randomizing and selecting first x members
    $CollMemberswithExclusion = $CollMemberswithExclusion | Sort-Object { Get-Random }
    $CollMemberswithExclusion = $CollMemberswithExclusion | Select-Object -First $NumberofMembers

    Try {
        foreach ($member in $CollMemberswithExclusion) {
            $domainName = (Get-ADDomain -Identity $member.Domain).DNSRoot
            $result = New-Object -TypeName PSObject -Property @{
                CollectionName = $Collection
                DeviceName     = $member.Name
                ResourceId     = $member.ResourceId
                PrimaryUser    = $member.PrimaryUser
                DomainName     = $domainName
                EntraObjectId  = $member.AADDeviceId
                EntraTenantId  = $member.AADTenantId
            }
            $resultsArray += $result
        }
    }
    Catch {
        Write-Error "Error gathering pilot collection : $_"

    }    
}
#endregion

    #region Results
    if ($ResultsArray.Count -ge 1) {
        $ResultsArray | Sort-Object -Property CollectionName | Export-Csv -Path $outputfilepath -NoTypeInformation
    }

    # Test if output file was created
    if (Test-Path $outputfilepath) {
        Write-Output "Output file = $outputfilepath."
    }
    else {
        Write-Warning -Message "No output file created."
    }
    #endregion
}
