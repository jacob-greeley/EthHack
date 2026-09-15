#This script will run 12 commands listing a bunch of important information about the machine

#lists current user, groups, and privileges

whoami /all

#Lists running processes
tasklist /v

#Lists any open network sockets and connections 

netstat -ano

#Lists running services
net start

#lists all local user accounts
net user

#lists all local groups
net localgroup

#lists all users in administrators groups

net localgroup administrators

#Shows the network configuration like Ip, gateway, and DNS

ipconfig /all

#shows all firewall polices

netsh advfirewall firewall show rule name=all

#Shows the ARP table

arp -a

#shows any active SMB sessions

net use

#Shows system information

systeminfo

