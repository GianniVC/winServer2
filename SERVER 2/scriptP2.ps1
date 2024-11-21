
$domain = (Get-WmiObject Win32_ComputerSystem).Domain
Write-Output "You are now in the domain: $domain"


Write-Host "Checking the status of DNS features on this server."
Get-WindowsFeature -Name *DNS*

## DNS installeren via PowerShell:
Write-Host "Installing the DNS role and management tools."
Add-WindowsFeature -Name DNS -IncludeManagementTools

Write-Host "Setting DNS server address to 192.168.24.10 for interfaces  'Ethernet' en Ethernet 2."
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.24.10"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.24.10"


# Configureer de secundaire server om de zones van  de primaire server te repliceren
Write-Host "Configuring the secondary DNS zone 'WS2-2425-gianni.hogent' to replicate from the primary server."
Add-DnsServerSecondaryZone -Name "WS2-2425-gianni.hogent" -ZoneFile "WS2-2425-gianni.hogent.dns" -MasterServers "192.168.24.10"
Add-DnsServerSecondaryZone -Name "24.168.192.in-addr.arpa" -ZoneFile "24.168.192.in-addr.arpa.dns" -MasterServers "192.168.24.10"

Write-Host "Adding an NS record to the primary zone using dnscmd."
dnscmd localhost /RecordAdd WS2-2425-gianni.hogent "@" NS server1.WS2-2425-gianni.hogent$domainName = "WS2-2425-gianni.hogent"



Write-Host "Changing directory to drive D."
cd D:

Get-PackageProvider -Name NuGet -ForceBootstrap
Install-Module -Name SqlServerDsc -Force

D:setup.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /SQLSYSADMINACCOUNTS="ws2-2425-gianni.hogent\Administrator" /SECURITYMODE=SQL /SAPWD="123Vagrant@" /UpdateEnabled=False /TCPENABLED=1 /NPENABLED=1

Get-Service | Where-Object { $_.DisplayName -like "*SQL Server*" }

New-NetFirewallRule -DisplayName "Allow SQL Server Inbound TCP 1433" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
New-NetFirewallRule -DisplayName "Allow SQL Server Outbound TCP 1433" -Direction Outbound -Protocol TCP -LocalPort 1433 -Action Allow