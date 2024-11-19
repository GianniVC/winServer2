New-NetIPAddress -InterfaceAlias "Ethernet 2" -AddressFamily IPv4 -IPAddress 192.168.24.11 -PrefixLength 24

## zet firewall af
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False

Copy-Item -Path  C:\vagrant -Destination C:\Users\vagrant -Recurse -Force

## Controle installatie


Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.24.10"

#REBOOT SERVER
## ADD server to AD IN CLI 
$domainName = "WS2-2425-gianni.hogent"
$username = "WS2-2425-gianni\Administrator"
$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Add-Computer -DomainName $domainName -Credential $credential -Restart

