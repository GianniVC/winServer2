ssh "ws2-2425-gianni.hogent\Administrator"@192.168.24.11

Get-Service | Where-Object { $_.DisplayName -like "*SQL Server*" }


cd \:d


`Get-PackageProvider -Name NuGet –ForceBootstrap`
`Install-Module -Name SqlServerDsc -Force`

`D:setup.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /SQLSYSADMINACCOUNTS="ws2-2425-gianni.hogent\Administrator" /SECURITYMODE=SQL /SAPWD="123Vagrant@" /UpdateEnabled=False /TCPENABLED=1 /NPENABLED=1`




$media_path = "C:\Installers\SSMS-Setup-ENU.exe"
$install_path = "$env:SystemDrive\SSMSto"
$params = "/Install /Quiet SSMSInstallRoot=`"$install_path`""

Start-Process -FilePath $media_path -ArgumentList $params -Wait



