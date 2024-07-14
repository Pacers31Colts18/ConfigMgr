#Get Connection Type
$WirelessConnected = $null
$WiredConnected = $null
$VPNConnected = $null
 
$NetworkConfiguration = Get-WmiObject Win32_NetworkAdapterConfiguration
$WirelessAdapters = Get-WmiObject -Class MSNdis_PhysicalMediumType -Namespace "root\WMI" | Where-Object NdisPhysicalMediumType -eq 9
$WiredAdapters = Get-WmiObject -Class MSNdis_PhysicalMediumType -Namespace "root\WMI" | Where-Object NdisPhysicalMediumType -eq 0 | Where-Object {(($_.InstanceName -notlike "*pangp*") -and ($_.InstanceName -notlike "*cisco*") -and ($_.InstanceName -notlike "*juniper*"))} #| Select -First 1 *
$ConnectedAdapters = Get-WmiObject win32_networkadapter | Where-Object NetConnectionStatus -eq "2"
$VPNAdapters = $NetworkConfiguration | Where-Object {(($_.Description -ilike "*citrix*") -or ($_.Description -ilike "*juniper*"))}
 
Foreach($Adapter in $ConnectedAdapters) {
    If($WirelessAdapters.InstanceName -contains $Adapter.Name)
    {
        $WirelessConnected = $true
    }
}
 
Foreach($Adapter in $ConnectedAdapters) {
    If($WiredAdapters.InstanceName -contains $Adapter.Name)
    {
        $WiredConnected = $true
    }
}
 
Foreach($Adapter in $ConnectedAdapters) {
    If($VPNAdapters.Index -contains $Adapter.DeviceID)
    {
        $VPNConnected = $true
    }
}
 
If(($WirelessConnected -ne $true) -and ($WiredConnected -eq $true)){ $ConnectionType="WIRED"}
If(($WirelessConnected -eq $true) -and ($WiredConnected -eq $true)){$ConnectionType="WIRED AND WIRELESS"}
If(($WirelessConnected -eq $true) -and ($WiredConnected -ne $true)){$ConnectionType="WIRELESS"}
If($VPNConnected -eq $true){$ConnectionType="VPN"}
 
Write-Output "Connection type is: $ConnectionType"