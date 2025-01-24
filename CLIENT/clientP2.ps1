Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ResetServerAddresses | Out-Null
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ResetServerAddresses | Out-Null

Write-Output "install RSAT TOOLS"

Write-Output "Install DHCP Server Tools"
# Install DHCP Server Tools
Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0
Write-Output "Done"
Write-Output "Install DNS Server Tools"
# Install DNS Server Tools
Add-WindowsCapability -Online -Name Rsat.Dns.Tools~~~~0.0.1.0
Write-Output "Done"
Write-Output "Install ActiveDirectory Services Tools"
# Install Active Directory Domain Services and Lightweight Directory Services Tools
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Write-Output "Done"
Write-Output "Install Active Directory Certificate Services Tools"
# Install Active Directory Certificate Services Tools
Add-WindowsCapability -Online -Name Rsat.CertificateServices.Tools~~~~0.0.1.0
Write-Output "Done"

Write-Output "RSAT TOOLS installed successfully"

Write-Output "Install SSMS"

# Define the URL of the SSMS installer
$ssmsInstallerUrl = "https://aka.ms/ssmsfullsetup"

# Define the path to save the SSMS installer
$installerPath = "C:\Temp\SSMS-Setup-ENU.exe"

# Create directory for temp files if it doesn't exist
if (-Not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Download the SSMS installer
Write-Host "Downloading SSMS installer..."
Invoke-WebRequest -Uri $ssmsInstallerUrl -OutFile $installerPath

# Start the SSMS installer in silent mode
Write-Host "Starting SSMS installation..."
Start-Process -FilePath $installerPath -ArgumentList "/quiet" -Wait

# Clean up the installer file after installation
Remove-Item $installerPath

Write-Host "SSMS installation complete!"


Write-Output "Client script finished"
