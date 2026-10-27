#!/bin/bash
# Linux Enumeration Script (Task 1, commands 1-12)
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

echo "Enumeration complete. Results saved in $OUTDIR"
