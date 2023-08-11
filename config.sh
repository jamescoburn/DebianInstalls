#!/usr/bin/env bash

function ModprobeDisableAndBlackList()
{
        echo install $1 /bin/false >> /etc/modprobe.d/$1.conf
        echo blacklist $1 >> /etc/modprobe.d/$1.conf
        /sbin/modprobe -r $1
}

function Sysctl_Modifications()
{
        echo $1 >> /etc/sysctl.d/$2
        sysctl -p /etc/sysctl.d/$2
}

# secondary account to ssh and sudoers groups
adduser jamesc ssh
adduser jamesc sudo

# Disable cramfs
ModprobeDisableAndBlackList cramfs

# Disable squashfs
ModprobeDisableAndBlackList squashfs

# Disable udf
ModprobeDisableAndBlackList udf

# Disable usb-storage
ModprobeDisableAndBlackList usb-storage

# Disable dccp
ModprobeDisableAndBlackList dccp

# Disable sctp
ModprobeDisableAndBlackList sctp

# Disable rds
ModprobeDisableAndBlackList rds

# Disable tipc
ModprobeDisableAndBlackList tipc

# File system configuration
/bin/sed -ri 's/^\s*([^#]+\s+\/tmp\s+)(\S+\s+)(\S+)?(\s+[0-9]\s+[0-9].*)$/\1\2\3,noexec\4/' /etc/fstab
/bin/mount -o remount /tmp
/bin/echo -e "tmpfs\t\t/dev/shm\ttmpfs\tnodev,nosuid,noexec\t0\t0" >> /etc/fstab
/bin/mount -o remount /dev/shm

# Ensure filesystem integrity regularly checked
echo "0 5 * * * /usr/sbin/aide --check" | crontab -u root -

# Secure boot settings
/bin/cat << EOT >/etc/grub.d/42_custom
#!/bin/sh
cat <<EOF
set superusers="root"
password_pbkdf2 root grub.pbkdf2.sha512.10000.080D3601C9F8BE1447DDAAA555D68D3952EF37B85AD60643F85FAD9FB22B0AB44D62F474BD6CADF8BD9C1E5CC3A2BFD719ED69FF91EB376E2173CA76F3DD79C9.7D241BF1338A9129600D559CE8DF57B5618019EEBCEE7F39A030D116C79F3F941A496CD411975B9DFCE3C82CE93AD48B6C1DA76093806BCDF7B4D5220F0D8582
EOF
EOT
/sbin/update-grub
/bin/chmod u-wx,go-rwx /boot/grub/grub.cfg

# Additional Process Hardening
Sysctl_Modifications "kernel.randomize_va_space = 2" 60-kernel_sysctl.conf
Sysctl_Modifications "fs.suid_dumpable = 0" 61-coredumps_sysctl.conf
/bin/cat << EOT >/etc/security/limits.d/01_custom
*   hard    core    0
EOT

# Command Line Warning Banners
/bin/mv /etc/motd /etc/motd.orig
/bin/mv /etc/issue /etc/issue.orig
/bin/cat << EOT >/etc/issue

WARNING: To protect the system from fraud and abuse, activities
on this system are monitored and subject to audit. Use of this
system is expressed consent to monitor.

EOT
/bin/mv /etc/issue.net /etc/issue.net.orig
/bin/cp /etc/issue /etc/issue.net

# Configure systemd-timesyncd
/bin/sed -i "s/#NTP=/NTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org /g" /etc/systemd/timesyncd.conf
/bin/sed -i "s/#FallbackNTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org/FallbackNTP=2.debian.pool.ntp.org 3.debian.pool.ntp.org/g" /etc/systemd/timesyncd.conf

# Uninstalled/purge telnet client
apt purge -y -q telnet

# Disable IPv6
Sysctl_Modifications "net.ipv6.conf.all.disable_ipv6 = 1" 60-netipv6_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.default.disable_ipv6 = 1" 60-netipv6_sysctl.conf
Sysctl_Modifications "net.ipv6.route.flush = 1" 60-netipv6_sysctl.conf

# Disable Packet Redirect Sending
Sysctl_Modifications "net.ipv4.conf.all.send_redirects = 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv4.conf.default.send_redirects = 0" 60-netipv4_sysctl.conf

# Disable IP Forwarding
Sysctl_Modifications "net.ipv4.ip_forward = 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.all.forwarding = 0" 60-netipv6_sysctl.conf

# Ensure source routed packets are not accepted
Sysctl_Modifications "net.ipv4.conf.all.accept_source_route = 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv4.conf.default.accept_source_route = 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.all.accept_source_route = 0" 60-netipv6_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.default.accept_source_route = 0" 60-netipv6_sysctl.conf

# Ensure ICMP redirects are not accepted
Sysctl_Modifications "net.ipv4.conf.all.accept_redirects = 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv4.conf.default.accept_redirects= 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.all.accept_redirects = 0" 60-netipv6_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.default.accept_redirects = 0" 60-netipv6_sysctl.conf

# Ensure secure ICMP redirects are not accepted
Sysctl_Modifications "net.ipv4.conf.default.secure_redirects = 0" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv4.conf.all.secure_redirects = 0" 60-netipv4_sysctl.conf

# Ensure suspicious packets are logged
Sysctl_Modifications "net.ipv4.conf.all.log_martians = 1" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv4.conf.default.log_martians = 1" 60-netipv4_sysctl.conf

# Ensure broadcast ICMP requests are ignored
Sysctl_Modifications "net.ipv4.icmp_echo_ignore_broadcasts = 1" 60-netipv4_sysctl.conf

# Ensure bogus ICMP responses are ignored
Sysctl_Modifications "net.ipv4.icmp_ignore_bogus_error_responses = 1" 60-netipv4_sysctl.conf

# Ensure Reverse Path Filtering is enabled
Sysctl_Modifications "net.ipv4.conf.all.rp_filter = 1" 60-netipv4_sysctl.conf
Sysctl_Modifications "net.ipv4.conf.default.rp_filter = 1" 60-netipv4_sysctl.conf

# Ensure TCP SYN Cookies is enabled
Sysctl_Modifications "net.ipv4.tcp_syncookies = 1" 60-netipv4_sysctl.conf

# Ensure IPv6 router advertisements are not accepted
Sysctl_Modifications "net.ipv6.conf.all.accept_ra = 0" 60-netipv6_sysctl.conf
Sysctl_Modifications "net.ipv6.conf.default.accept_ra = 0" 60-netipv6_sysctl.conf

# Configure nftables
/bin/mv /etc/nftables.conf /etc/nftables.conf.orig
/bin/cat << EOT >/etc/nftables.conf
#!/usr/sbin/nft -f

flush ruleset

define LAN={ 10.0.0.0/8,164.64.0.0/16 }
define TCP-SERVICES = { 22 }
define UDP-SERVICES = {}

table inet filter {
        chain input {
                type filter hook input priority 0; policy drop;

                iif lo accept
                ip saddr 127.0.0.0/8 counter drop
                ip6 saddr ::1 counter drop

                ct state established,related accept
                ct state invalid drop

                icmp type { echo-request } ip saddr \$LAN ct state new accept

                tcp dport \$TCP-SERVICES ip saddr \$LAN ct state new accept
                #udp dport \$UDP-SERVICES ip saddr \$LAN ct state new accept
        }
        chain forward {
                type filter hook forward priority 0; policy drop;
        }
        chain output {
                type filter hook output priority 0; policy drop;

                ct state new,related,established accept
                ct state invalid drop
        }
}
EOT
/bin/systemctl enable nftables.service
/bin/systemctl start nftables.service

# Cron configuration
/bin/chmod og-rwx /etc/crontab
/bin/chmod og-rwx /etc/cron.hourly/
/bin/chmod og-rwx /etc/cron.daily/
/bin/chmod og-rwx /etc/cron.weekly/
/bin/chmod og-rwx /etc/cron.monthly/
/bin/chmod og-rwx /etc/cron.d/
/bin/touch /etc/cron.allow
/bin/chown root:root /etc/cron.allow
/bin/chmod g-wx,o-rwx /etc/cron.allow

# ssh configuration
/bin/chmod og-rwx /etc/ssh/sshd_config
/bin/printf "\n# Limit ssh access to group(s) and/or user(s)\nallowgroups ssh" >> /etc/ssh/sshd_config
/bin/sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no /g" /etc/ssh/sshd_config
/bin/sed -i "s/X11Forwarding yes/#X11Forwarding yes /g" /etc/ssh/sshd_config
/bin/sed -i "/^# Ciphers and keying/a MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" /etc/ssh/sshd_config
/bin/sed -i "s/#AllowTcpForwarding yes/AllowTcpForwarding no /g" /etc/ssh/sshd_config
/bin/sed -i "s/#Banner none/Banner \/etc\/issue.net /g" /etc/ssh/sshd_config
/bin/sed -i "s/#MaxAuthTries 6/MaxAuthTries 4 /g" /etc/ssh/sshd_config
/bin/sed -i "s/#MaxStartups 10:30:100/MaxStartups 10:30:60 /g" /etc/ssh/sshd_config
/bin/sed -i "s/#LoginGraceTime 2m/LoginGraceTime 1m /g" /etc/ssh/sshd_config
/bin/sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 15 /g" /etc/ssh/sshd_config

# sudo configuration
/bin/printf "Defaults\tuse_pty\n" >> /etc/sudoers.d/00_custom
/bin/printf 'Defaults\tlogfile="/var/log/sudo.log"\n' >> /etc/sudoers.d/00_custom
/sbin/groupadd sugroup
/bin/sed -i "15s/# auth       required   pam_wheel.so/auth       required   pam_wheel.so   use_uid   group=sugroup/g" /etc/pam.d/su
