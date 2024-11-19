## Controle installatie

Get-WindowsFeature –Name *DNS*

## DNS installeren via PowerShell:

Add-WindowsFeature –Name DNS -IncludeManagementTools
Add-WindowsFeature -Name RSAT-DNS-SERVER -IncludeManagementTools


Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.24.10"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.24.10"

REBOOT SERVER
## ADD server to AD IN CLI 

Add-Computer -DomainName "WS2-2425-gianni.hogent" -Credential (Get-Credential) -Restart
## vagrant vagrant

    (Get-WmiObject Win32_ComputerSystem).Domain # Check of server2 in domain zit

# Configureer de secundaire server om de zones van  de primaire server te repliceren
Add-DnsServerSecondaryZone -Name "WS2-2425-gianni.hogent" -ZoneFile "WS2-2425-gianni.hogent.dns" -MasterServers "192.168.24.10"
Add-DnsServerSecondaryZone -Name "24.168.192.in-addr.arpa" -ZoneFile "24.168.192.in-addr.arpa.dns" -MasterServers "192.168.24.10"


dnscmd localhost /RecordAdd WS2-2425-gianni.hogent "@" NS server1.WS2-2425-gianni.hogent