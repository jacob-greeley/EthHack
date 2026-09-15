#This script will run 12 commands listing a bunch of important information about the machine

#defines the output folder
$Outfolder = "C:\temp"

#if the outputfolder does not exist
if (!(Test-Path -Path $OutFolder)) {
    New-Item -ItemType Directory -Path $OutFolder
}
#lists current user, groups, and privileges

whoami /all | Out-File $OutFolder\whoiseveryone.txt

#Lists running processes
tasklist /v | Out-File $OutFolder\processes.txt

#Lists any open network sockets and connections 

netstat -ano | Out-File $OutFolder\opensocksandconnections.txt

#Lists running services
net start | Out-File $OutFolder\services.txt

#lists all local user accounts
net user | Out-File $OutFolder\alllxtocalusers.txt

#lists all local groups
net localgroup | Out-File $OutFolder\alllocalgroups.txt

#lists all users in administrators groups

net localgroup administrators | Out-File $OutFolder\allusersinadmin.txt

#Shows the network configuration like Ip, gateway, and DNS

ipconfig /all | Out-File $OutFolder\netconfig.txt

#shows all firewall polices

netsh advfirewall firewall show rule name=all | Out-File $OutFolder\firwallpolices.txt

#Shows the ARP table

arp -a | Out-File $OutFolder\arptable.txt

#shows any active SMB sessions

net use | Out-File $OutFolder\activesmbsessions.txt

#Shows system information

systeminfo | Out-File $OutFolder\systeminfo.txt

