https://learn.microsoft.com/en-us/powershell/module/adcsdeployment/install-adcscertificationauthority?view=windowsserver2022-ps
```ps1

ssh "ws2-2425-gianni.hogent\Administrator"@192.168.24.10

# Step 1: Install AD CS and the Web Enrollment Role

Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
Install-WindowsFeature ADCS-Web-Enrollment -IncludeManagementTools
Install-WindowsFeature ADCS-Enroll-Web-Svc -IncludeManagementTools
Install-WindowsFeature Adcs-Enroll-Web-Pol -IncludeManagementTools


# Step 2: Configure the Certification Authority as an Standalone Root CA
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName SHA256 -KeyLength 2048 -ValidityPeriod Years -ValidityPeriodUnits 5



https://learn.microsoft.com/en-us/powershell/module/grouppolicy/?view=windowsserver2022-ps 
# create group policy

New-GPO -Name "Trusted Root CA" -ErrorAction SilentlyContinue


# fqdm = http://server1.WS2-2425-gianni.hogent/CertSrv

# Link to domain
$DomainDN = (Get-ADDomain).DistinguishedName
New-GPLink -Name "Trusted Root CA" -Target $DomainDN



Install-AdcsWebEnrollment -CAConfig "server1.WS2-2425-gianni.hogent\\Trusted Root CA" -Force:$true
Install-AdcsEnrollmentWebService -Force:$true


## rsat tools install
#https://www.pdq.com/blog/how-to-install-remote-server-administration-tools-rsat/ 










# Get-WindowsFeature RSAT-ADCS-Mgmt
# Get-CertificationAuthority -Standalone
# Powershell start-process Powershell -Verb RunAs

