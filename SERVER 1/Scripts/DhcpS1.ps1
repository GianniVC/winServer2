##INSTALL DHCP SERVER
Install-WindowsFeature DHCP –IncludeManagementTools

netsh dhcp add securitygroups

##HERSTART DHCP SERVER
Restart-Service dhcpserver



# Creëer een DHCP-scope met het gewenste IP-bereik
Add-DhcpServerv4Scope -Name "scope1" -StartRange 192.168.24.101 -EndRange 192.168.24.200 -SubnetMask 255.255.255.0 -State Active

## exclude last 50 addresses
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.24.0 -StartRange 192.168.24.151 -EndRange 192.168.24.200


# Stel de DNS-serveropties in voor de scope
Set-DhcpServerv4OptionValue -ScopeId 192.168.24.0 -OptionId 006 -Value 192.168.24.10, 192.168.24.11

# Stel de domeinnaamoptie in voor DNS (optioneel maar aanbevolen)
Set-DhcpServerv4OptionValue -ScopeId 192.168.24.0 -OptionId 015 -Value "WS2-2425-gianni.hogent"

## in ADMIN Administrator@192.168.24.10
Add-DhcpServerInDC
get-DhcpServerInDC



