## Controle installatie

Get-WindowsFeature –Name *DNS*

## DNS installeren via PowerShell:

Add-WindowsFeature –Name DNS -IncludeManagementTools
Add-WindowsFeature -Name RSAT-DNS-SERVER -IncludeManagementTools


# Start the DNS service (it should start automatically, but this ensures it's running)
Start-Service -Name DNS

#Set dns server voor juiste interface

Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("192.168.24.10")

# Create a new forward lookup zone (replace with your domain name) al gdn door DC
Add-DnsServerPrimaryZone -Name "WS2-2425-gianni.hogent" -ReplicationScope "Domain" -PassThru

Remove-DnsServerResourceRecord -ZoneName "WS2-2425-gianni.hogent" -RRType "A" -Name "server1"

Get-DnsServerZone # Check welke zones je S1 hebben

Get-DnsServerResourceRecord -ZoneName "WS2-2425-gianni.hogent" # CHeck records

# Maak een reverse lookup zone aan op de primaire server
Add-DnsServerPrimaryZone -NetworkId "192.168.24.0/24" -ReplicationScope "Domain"

# Voeg A-records toe aan de forward lookup zone
Add-DnsServerResourceRecordA -Name "server1" -ZoneName "WS2-2425-gianni.hogent" -IPv4Address "192.168.24.10"
Add-DnsServerResourceRecordA -Name "server2" -ZoneName "WS2-2425-gianni.hogent" -IPv4Address "192.168.24.11"

# Voeg PTR-records toe aan de reverse lookup zone
Add-DnsServerResourceRecordPtr -Name "10" -ZoneName "24.168.192.in-addr.arpa" -PtrDomainName "server1.WS2-2425-gianni.hogent"
Add-DnsServerResourceRecordPtr -Name "11" -ZoneName "24.168.192.in-addr.arpa" -PtrDomainName "server2.WS2-2425-gianni.hogent"


# Schakel zone transfers in op de primaire DNS-server
Set-DnsServerPrimaryZone -Name "WS2-2425-gianni.hogent" -SecureSecondaries TransferToSecureServers -SecondaryServers "192.168.24.11"
Set-DnsServerPrimaryZone -Name "24.168.192.in-addr.arpa" -ZoneTransferType ToSpecificServers -SecondaryServers "192.168.24.11"



Add-DnsServerClientSubnet -Name "AllowedSubnet" -IPv4Subnet 192.168.24.0/24 -PassThru
Add-DnsServerZoneTransferPolicy -Name "AllowedZoneTransfers" -Action IGNORE -ClientSubnet "ne,AllowedSubnet"

dnscmd localhost /RecordAdd WS2-2425-gianni.hogent "@" NS server1.WS2-2425-gianni.hogent

dnscmd server1.WS2-2425-gianni.hogent /RecordAdd WS2-2425-gianni.hogent "@" NS server2.WS2-2425-gianni.hogent


Get-DnsServerResourceRecord -ZoneName "WS2-2425-gianni.hogent" -RRType NS
