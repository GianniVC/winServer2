## WIN SERV 2

### IP adressen

# Get the network adapter
Get-NetAdapter


# Create a new IP address
New-NetIPAddress -InterfaceAlias "Ethernet 2" -AddressFamily IPv4 -IPAddress 192.168.24.10

### veriefy
Get-NetIPAddress -InterfaceAlias "Ethernet 2"


# Assign the IP address to the network adapter
Set-VagrantNetworkAdapter -VM $vm -Adapter $adapter -IPAddress $ip