New-NetIPAddress -InterfaceAlias "Ethernet 2" -AddressFamily IPv4 -IPAddress 192.168.24.11 -PrefixLength 24

## zet firewall af
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False

