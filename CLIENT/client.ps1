

Write-Output "Client script started"
Write-Output "Set dns Server"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.24.10"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.24.10"
Write-Output "Done"

Copy-Item -Path  C:\vagrant -Destination C:\Users\vagrant -Recurse -Force


Write-Output "Add host to domain"

$domainName = "WS2-2425-gianni.hogent"
$username = "WS2-2425-gianni\Administrator"
$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Add-Computer -DomainName $domainName -Credential $credential -Restart
Write-Output "Added host successfully to the domain"


$domain = (Get-WmiObject Win32_ComputerSystem).Domain
Write-Output "You are now in the domain: $domain"


