Write-Host "Configuring IP address 192.168.24.11 with subnet mask 255.255.255.0 on interface 'Ethernet 2'."
New-NetIPAddress -InterfaceAlias "Ethernet 2" -AddressFamily IPv4 -IPAddress 192.168.24.11 -PrefixLength 24

Write-Host "Copying files from C:\vagrant to C:\Users\vagrant recursively."
Copy-Item -Path  C:\vagrant -Destination C:\Users\vagrant -Recurse -Force

## Controle installatie

Write-Host "Setting DNS server to 192.168.24.10 for interface 'Ethernet'."
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.24.10"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.24.10"

Write-Host "Adding the server to the domain 'WS2-2425-gianni.hogent'."

## ADD server to AD IN CLI 
$domainName = "WS2-2425-gianni.hogent"
$username = "WS2-2425-gianni\Administrator"
$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Write-Host "Joining the domain '$domainName' and restarting the server."
Add-Computer -DomainName $domainName -Credential $credential -Restart

