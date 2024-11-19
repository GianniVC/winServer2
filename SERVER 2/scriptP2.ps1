(Get-WmiObject Win32_ComputerSystem).Domain # Check of server2 in domain zit

Get-WindowsFeature -Name *DNS*

## DNS installeren via PowerShell:

Add-WindowsFeature -Name DNS -IncludeManagementTools


Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.24.10"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.24.10"

# Configureer de secundaire server om de zones van  de primaire server te repliceren
Add-DnsServerSecondaryZone -Name "WS2-2425-gianni.hogent" -ZoneFile "WS2-2425-gianni.hogent.dns" -MasterServers "192.168.24.10"
Add-DnsServerSecondaryZone -Name "24.168.192.in-addr.arpa" -ZoneFile "24.168.192.in-addr.arpa.dns" -MasterServers "192.168.24.10"


dnscmd localhost /RecordAdd WS2-2425-gianni.hogent "@" NS server1.WS2-2425-gianni.hogent$domainName = "WS2-2425-gianni.hogent"



Get-Service | Where-Object { $_.DisplayName -like "*SQL Server*" }


cd D:



Get-PackageProvider -Name NuGet -ForceBootstrap
Install-Module -Name SqlServerDsc -Force

D:setup.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /SQLSYSADMINACCOUNTS="ws2-2425-gianni.hogent\Administrator" /SECURITYMODE=SQL /SAPWD="123Vagrant@" /UpdateEnabled=False /TCPENABLED=1 /NPENABLED=1


New-NetFirewallRule -DisplayName "Allow SQL Server Inbound TCP 1433" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
New-NetFirewallRule -DisplayName "Allow SQL Server Outbound TCP 1433" -Direction Outbound -Protocol TCP -LocalPort 1433 -Action Allow