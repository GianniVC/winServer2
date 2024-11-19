# Create a new user

Write-Output 'Creating a new user 'gianni'...'
$splat = @{
    Name = 'gianni'
    AccountPassword = 'GJPL04052003@' | ConvertTo-SecureString -AsPlainText -Force
    Enabled = $true
}
New-ADUser @splat

# Check the installation of DNS
Write-Output 'Checking the installation of DNS...'
Get-WindowsFeature -Name *DNS*

# Install DNS using PowerShell (if not already installed)
Write-Output 'Installing DNS and RSAT-DNS-Server tools if not already installed...'
Add-WindowsFeature -Name DNS -IncludeManagementTools
Add-WindowsFeature -Name RSAT-DNS-SERVER -IncludeManagementTools

# Start the DNS service
Write-Output 'Starting the DNS service...'
Start-Service -Name DNS

Set-DnsServerForwarder -IPAddress "8.8.8.8"

# Set the DNS server address for the Ethernet 2 interface
Write-Output 'Setting the DNS server address for the Ethernet 2 interface...'
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet 2' -ServerAddresses ('192.168.24.10')

#https://learn.microsoft.com/en-us/windows-server/networking/dns/manage-dns-zones?tabs=powershell
# Remove any existing A record for server1
Write-Output 'Removing any existing zone for server1...'
Remove-DnsServerZone "WS2-2425-gianni.hogent" -Force 

# Create a new forward lookup zone
Write-Output 'Creating a new forward lookup zone for the domain 'WS2-2425-gianni.hogent'...'
Add-DnsServerPrimaryZone -Name 'WS2-2425-gianni.hogent' -ReplicationScope 'Forest' -PassThru
Add-DnsServerPrimaryZone -NetworkID "192.168.24.0/24" -ReplicationScope "Forest" -PassThru

Remove-DnsServerResourceRecord -name "server1" -Zonename "WS2-2425-gianni.hogent" -RRType A

# Check the DNS zones
# Write-Output 'Checking the DNS zones...'
# Get-DnsServerZone

# Check the DNS records
# Write-Output 'Checking the DNS records for the zone 'WS2-2425-gianni.hogent'...'
# Get-DnsServerResourceRecord -ZoneName 'WS2-2425-gianni.hogent'

# Create a reverse lookup zone
#Write-Output 'Creating a reverse lookup zone for the network 192.168.24.0/24...'
#Add-DnsServerPrimaryZone -NetworkId '192.168.24.0/24' -ReplicationScope 'Domain'

# Add A records to the forward lookup zone
Write-Output 'Adding A records for server1 and server2 to the forward lookup zone...'
Add-DnsServerResourceRecordA -Name 'server1' -ZoneName 'WS2-2425-gianni.hogent' -IPv4Address '192.168.24.10'
Add-DnsServerResourceRecordA -Name 'server2' -ZoneName 'WS2-2425-gianni.hogent' -IPv4Address '192.168.24.11'



# Add PTR records to the reverse lookup zone
Write-Output 'Adding PTR records for server1 and server2 to the reverse lookup zone...'
Add-DnsServerResourceRecordPtr -Name '10' -ZoneName '24.168.192.in-addr.arpa' -PtrDomainName 'server1.WS2-2425-gianni.hogent'
Add-DnsServerResourceRecordPtr -Name '11' -ZoneName '24.168.192.in-addr.arpa' -PtrDomainName 'server2.WS2-2425-gianni.hogent'

###################### ZONE TRANSFER ######################
# Enable secure zone transfers
Write-Output 'Enabling secure zone transfers for the primary DNS server...'
Set-DnsServerPrimaryZone -name "WS2-2425-gianni.hogent" -SecureSecondaries "TransferToZoneNameServer" -PassThru


# Add a client subnet and zone transfer policy
Write-Output 'Adding a client subnet and zone transfer policy...'
Add-DnsServerClientSubnet -Name 'AllowedSubnet' -IPv4Subnet 192.168.24.0/24 -PassThru
Add-DnsServerZoneTransferPolicy -Name 'AllowedZoneTransfers' -Action IGNORE -ClientSubnet 'AllowedSubnet'


# Add NS records
Write-Output 'Adding NS records for the domain 'WS2-2425-gianni.hogent'...'
dnscmd localhost /RecordAdd WS2-2425-gianni.hogent '@' NS server1.WS2-2425-gianni.hogent
dnscmd server1.WS2-2425-gianni.hogent /RecordAdd WS2-2425-gianni.hogent '@' NS server2.WS2-2425-gianni.hogent

# Check the NS records
Write-Output 'Checking the NS records for the zone 'WS2-2425-gianni.hogent'...'
Get-DnsServerResourceRecord -ZoneName 'WS2-2425-gianni.hogent' -RRType NS



###################### DHCP ######################

# Install the DHCP server role
Write-Output 'Installing the DHCP server role...'
Install-WindowsFeature DHCP -IncludeManagementTools

# Add security groups for DHCP
Write-Output 'Adding security groups for DHCP...'
netsh dhcp add securitygroups

# Restart the DHCP server service
Write-Output 'Restarting the DHCP server service...'
Restart-Service dhcpserver

# Create a DHCP scope
Write-Output 'Creating a DHCP scope with the IP range 192.168.24.101-200...'
Add-DhcpServerv4Scope -Name 'scope1' -StartRange 192.168.24.101 -EndRange 192.168.24.200 -SubnetMask 255.255.255.0 -State Active

# Exclude the last 50 addresses from the scope
Write-Output 'Excluding the last 50 addresses from the DHCP scope...'
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.24.0 -StartRange 192.168.24.151 -EndRange 192.168.24.200

# Set the DNS server options for the DHCP scope
Write-Output 'Setting the DNS server options for the DHCP scope...'
Set-DhcpServerv4OptionValue -ScopeId 192.168.24.0 -OptionId 006 -Value 192.168.24.10, 192.168.24.11

# Set the domain name option for DNS (optional but recommended)
Write-Output 'Setting the domain name option for DNS...'
Set-DhcpServerv4OptionValue -ScopeId 192.168.24.0 -OptionId 015 -Value 'WS2-2425-gianni.hogent'

# Authorize the DHCP server in Active Directory
Write-Output 'Authorizing the DHCP server in Active Directory...'
Add-DhcpServerInDC
Get-DhcpServerInDC

# Install the Active Directory Certificate Services (AD CS) roles
Write-Output 'Installing the Active Directory Certificate Services (AD CS) roles...'
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools

# Configure the Certification Authority as a standalone root CA
Write-Output 'Configuring the Certification Authority as a standalone root CA...'
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CryptoProviderName 'RSA#Microsoft Software Key Storage Provider' -HashAlgorithmName SHA256 -KeyLength 2048 -ValidityPeriod Years -ValidityPeriodUnits 5 -Force

# Create a new group policy
Write-Output 'Creating a new group policy 'Trusted Root CA'...'
New-GPO -Name 'Trusted Root CA' -ErrorAction SilentlyContinue

# Link the group policy to the domain
Write-Output 'Linking the group policy to the domain...'
$DomainDN = (Get-ADDomain).DistinguishedName
New-GPLink -Name 'Trusted Root CA' -Target $DomainDN

Install-WindowsFeature ADCS-Web-Enrollment -IncludeManagementTools
# Install the AD CS web enrollment and enrollment web service
Write-Output 'Installing the AD CS web enrollment and enrollment web service...'
Install-WindowsFeature ADCS-Enroll-Web-Svc -IncludeManagementTools
Install-AdcsEnrollmentWebService -Force
Install-AdcsWebEnrollment -Force