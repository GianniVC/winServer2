# Assign a static IP address to the Ethernet 2 interface
Write-Output 'Assigning a static IP address to the Ethernet 2 interface...'
New-NetIPAddress -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4 -IPAddress 192.168.24.10 -PrefixLength 24


Copy-Item -Path  C:\vagrant -Destination C:\Users\vagrant -Recurse -Force


# Install the Active Directory Domain Services (AD DS) and DNS roles
Write-Output 'Installing the Active Directory Domain Services (AD DS) and DNS roles...'
Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools

$securePassword = ConvertTo-SecureString "GJPL04052003@" -AsPlainText -Force

# Install the Active Directory forest
Write-Output 'Installing the Active Directory forest...'
Install-ADDSForest -DomainName 'WS2-2425-gianni.hogent' -SafeModeAdministratorPassword $securePassword -DomainMode '7' -ForestMode '7' -InstallDns:$true -NoRebootOnCompletion:$True -Force:$true

# Restart the server
Write-Output 'Restarting the server...'
Restart-Computer -Force

