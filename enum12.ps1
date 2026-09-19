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

#Shows all scheduled tasks, their triggers, and the account and path they run as
#This is one of five additional commands this is useful for hackers because 
#it tells what tasks are running as SYSTEM and administrator with weak file and folder permissions

schtasks /query /fo LIST /v | Out-File $OutFolder\scheduledtasks.txt

#shows password policy
#This is two of five additional commands this would tell a hacker how aggressive they can be with password spray or
#to use brute force

net accounts | Out-File $OutFolder\passpolicy.txt

#Shows PID and full command lines of running processes
#This is three of five additional commands this could show hackers leaked passwords, API keys or
# connection strings as arguments, it is a bit more useful than tasklist

Get-CimInstance Win32_Process | Select Name,ProcessId, CommandLine | Out-File $OutFolder\processpidandcommandline.txt

#Shows installed thrid part software and versions
#This is four of five additional commands this would allow hackers to identify any 
#outdated software with known CVEs

wmic product get name,version,vendor | Out-File $OutFolder\3rdpartysoftware.txt

#shows other visible hosts and shared resources on the network
# this is number five of five additional commands, this would create
# a quick target list for lateral movement and shares could expose sensitive files

net view /all | Out-File $OutFolder\sharedinfo.txt


#Compression Section
#The following section will you 7-zip, command line version, tar, Compress-Archive, and makecab to compress all of the previous files that were made

#Compress all out files with 7-zip
# I added 7-Zip to path using  “[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\your\folder\path" otherwise
# you will have to specify the path everytime
# I might create a script that auto installs 7-zipcommand line but that is for future me

7za.exe a -tzip $OutFolder\output_7za.zip $OutFolder\*.txt

# a means it adds to archive
# -tzip changes the archive type to zip

#Compresses all out files with tar

tar -czvf $OutFolder\output_tar.tar.gz -C $OutFolder *.txt

# -c creates archive
# -z is gzip compression
# -v is verbose
# -C C:\temp changes to that directory first so paths inside the archive are relative and
# not absolute

#Compresses all out files with Compress-Archive

Compress-Archive -Path $OutFolder\*.txt -DestinationPath $OutFolder\output_compressarchive.zip

#Compresses with makecab
#makecab normally only takes one input file per invocation
# we need to use a Diamond Directive File, basicly a tiny script that tells makecab
# heres your output name, here's the folder, heres  the full list of files

$ddfPath = "$Outfolder\archive.ddf"

# this is the header of the DDF, they only need to be set once

$ddfContent = @"
.OPTION EXPLICIT
.Set CabinetNameTemplate=output_makecab.cab
.Set DiskDirectory1=$OutFolder
.Set Cabinet=on
.Set Compress=on
"@

#Looks through every .txt file in the folder and adds them one line at a time

Get-ChildItem $OutFolder\*.txt | Foreach-Object { 
    $ddfContent += "`n`"$($_.FullName)`""

# writes the finish DDF out to an actual file makecan can read

$ddfContent | Out-File $ddfPath -Encoding ASCII

# /F tells makecab to not expect a filename on the command line and to go read a 
# directive file instead

makecab /F $ddfPath 

