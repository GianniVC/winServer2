## install the Active Directory Domain Services (AD DS) role
Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools




Install-ADDSForest -DomainName "WS2-2425-gianni.hogent" -DomainMode "7" -ForestMode "7" -InstallDns:$true -NoRebootOnCompletion:$True -Force:$true

# Restart the server
Restart-Computer




$splat = @{
    Name = 'gianni'
    AccountPassword = vagrant | ConvertTo-SecureString -AsPlainText -Force
    Enabled = $true
}
New-ADUser @splat

