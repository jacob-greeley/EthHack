#This script will run 12 commands listing a bunch of important information about the machine

#lists current user, groups, and privileges

whoami /all > whoiseveryone.txt

#Lists running processes
tasklist /v > processes.txt

#Lists any open network sockets and connections 

netstat -ano > opensocksandconnections.txt

#Lists running services
net start > services.txt

#lists all local user accounts
net user > alllxtocalusers.txt

#lists all local groups
net localgroup > alllocalgroups.txt

#lists all users in administrators groups

net localgroup administrators > allusersinadmin.txt

#Shows the network configuration like Ip, gateway, and DNS

ipconfig /all > netconfig.txt

#shows all firewall polices

netsh advfirewall firewall show rule name=all > firwallpolices.txt

#Shows the ARP table

arp -a > arptable.txt

#shows any active SMB sessions

net use > active smb sessions

#Shows system information

systeminfo > systeminfo.txt

