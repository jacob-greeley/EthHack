#!/bin/bash
# Linux Enumeration Script (Task 1, commands 1-32)
# Each command's output (stdout AND errors) is saved to its own file
# in /tmp/enumeration/ so failures like "permission denied" are captured too.

# Output directory
OUTDIR="/tmp/enumeration"
mkdir -p "$OUTDIR"

# 1. Current user, groups, and privileges
{ id; sudo -l; } > "$OUTDIR/01_user_groups_privileges.txt" 2>&1

# 2. Running processes
ps aux > "$OUTDIR/02_running_processes.txt" 2>&1

# 3. Open network sockets and connections
ss -tulpn > "$OUTDIR/03_network_sockets.txt" 2>&1

# 4. Running services
systemctl list-units --type=service --state=running --no-pager > "$OUTDIR/04_running_services.txt" 2>&1

# 5. All local user accounts
getent passwd > "$OUTDIR/05_local_users.txt" 2>&1

# 6. All local groups
getent group > "$OUTDIR/06_local_groups.txt" 2>&1

# 7. Users in the sudo (administrators) group
getent group sudo > "$OUTDIR/07_sudo_group_members.txt" 2>&1

# 8. Network configuration (IP, gateway, DNS)
{ ip a; ip route; resolvectl status --no-pager; } > "$OUTDIR/08_network_config.txt" 2>&1

# 9. Firewall policies (requires root)
{ sudo ufw status verbose; sudo iptables -L -n -v; } > "$OUTDIR/09_firewall_policies.txt" 2>&1

# 10. ARP table
ip neigh > "$OUTDIR/10_arp_table.txt" 2>&1

# 11. SMB sessions (requires root)
sudo smbstatus > "$OUTDIR/11_smb_sessions.txt" 2>&1

# 12. System information
{ hostnamectl; uname -a; } > "$OUTDIR/12_system_info.txt" 2>&1

# 13. Sudo privileges granted to the current account, including NOPASSWD entries
{ sudo -l; sudo grep -r NOPASSWD /etc/sudoers /etc/sudoers.d/; } > "$OUTDIR/13_sudo_privileges_nopasswd.txt" 2>&1

# 14. Logged-in users, active sessions, and login history
{ w; last -a | head -20; } > "$OUTDIR/14_logged_in_users_login_history.txt" 2>&1

# 15. Shell command history left behind by local users
{ cat ~/.bash_history; sudo sh -c 'cat /home/*/.bash_history /root/.bash_history'; } > "$OUTDIR/15_shell_history.txt" 2>&1

# 16. Environment variables of the current shell and running processes
{ env; sudo sh -c 'cat /proc/*/environ' | tr '\0' '\n'; } > "$OUTDIR/16_environment_variables.txt" 2>&1

# 17. SUID and SGID binaries on the filesystem
find / -perm /6000 -type f > "$OUTDIR/17_suid_sgid_binaries.txt" 2>/dev/null

# 18. File capabilities assigned to installed binaries
getcap -r / > "$OUTDIR/18_file_capabilities.txt" 2>/dev/null

# 19. Scheduled tasks: cron jobs and systemd timers
{ crontab -l; cat /etc/crontab; ls -la /etc/cron.*; systemctl list-timers --all --no-pager; } > "$OUTDIR/19_cron_jobs_systemd_timers.txt" 2>&1

# 20. Installed security tools and EDR agents, and whether they are running
{ dpkg -l | grep -iE 'falcon|sentinel|osquery|auditd|wazuh|ossec|clamav|elastic|mdatp|apparmor|fail2ban'; systemctl list-units --type=service --no-pager | grep -iE 'falcon|sentinel|osquery|auditd|wazuh|ossec|clam|elastic|mdatp|fail2ban'; } > "$OUTDIR/20_security_tools_edr.txt" 2>&1

# 21. Installed software package inventory
{ dpkg -l; snap list; } > "$OUTDIR/21_installed_packages.txt" 2>&1

# 22. Kernel version and build information
{ uname -r; cat /proc/version; } > "$OUTDIR/22_kernel_version.txt" 2>&1

# 23. Mounted filesystems and free disk space
{ df -h; findmnt; } > "$OUTDIR/23_mounted_filesystems_disk_space.txt" 2>&1

# 24. SSH keys, authorized_keys files, and SSH client/server configuration
{ ls -la ~/.ssh; sudo find / \( -name "id_*" -o -name authorized_keys \) 2>/dev/null; cat /etc/ssh/sshd_config; cat ~/.ssh/config; } > "$OUTDIR/24_ssh_keys_config.txt" 2>&1

# 25. Password hash store - permissions and readability
{ ls -l /etc/passwd /etc/shadow /etc/gshadow; cat /etc/shadow; } > "$OUTDIR/25_password_hash_store.txt" 2>&1

# 26. Authentication events and failed login attempts recorded in system logs
{ sudo grep -E "Failed password|Invalid user|Accepted" /var/log/auth.log; sudo lastb | head -20; } > "$OUTDIR/26_auth_events_failed_logins.txt" 2>&1

# 27. Running containers and container runtime socket permissions
{ docker ps -a; ls -l /var/run/docker.sock; } > "$OUTDIR/27_containers_docker_socket.txt" 2>&1

# 28. SELinux or AppArmor status
{ sudo aa-status; sestatus; } > "$OUTDIR/28_selinux_apparmor_status.txt" 2>&1

# 29. Exported NFS / network file shares (LOLBin version)
{ grep -v '^#' /etc/exports; cat /var/lib/nfs/etab; grep -E '^\[|path' /etc/samba/smb.conf; ss -tln | grep -E ':2049|:111|:445|:139'; grep -E 'nfs|cifs' /proc/mounts; } > "$OUTDIR/29_nfs_smb_shares.txt" 2>&1

# 30. Hostname, FQDN, and configured domain membership (LOLBin version)
{ cat /etc/hostname; getent hosts "$(hostname)"; grep -E '^(search|domain)' /etc/resolv.conf; cat /etc/krb5.conf; ls -la /etc/sssd; } > "$OUTDIR/30_hostname_fqdn_domain.txt" 2>&1

# 31. World-writable files and directories in system locations
find /etc /usr /opt /var /bin /sbin -perm -0002 ! -type l > "$OUTDIR/31_world_writable_files.txt" 2>/dev/null

# 32. Files opened by running processes, including deleted-but-still-open files
{ sudo lsof; echo "----- Deleted but still open (lsof +L1) -----"; sudo lsof +L1; } > "$OUTDIR/32_open_and_deleted_files.txt" 2>&1

echo "Enumeration complete. Results saved in $OUTDIR"
