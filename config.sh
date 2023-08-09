#!/usr/bin/env bash

# secondary account to ssh and sudoers groups
adduser jamesc ssh
adduser jamesc sudo

# Disable cramfs
/bin/cat << EOT >/etc/modprobe.d/cramfs.conf
install cramfs /bin/false
blacklist cramfs
EOT
/sbin/modprobe -r cramfs

# Disable squashfs
/bin/cat << EOT >/etc/modprobe.d/squashfs.conf
install squashfs /bin/false
blacklist squashfs
EOT
/sbin/modprobe -r squashfs

# Disable udf
/bin/cat << EOT >/etc/modprobe.d/udf.conf
install udf /bin/false
blacklist udf
EOT
/sbin/modprobe -r udf

# Disable usb-storage
/bin/cat << EOT >/etc/modprobe.d/usb-storage.conf
install usb-storage /bin/false
blacklist usb-storage
EOT
/sbin/modprobe -r usb-storage

# Disable dccp
/bin/cat << EOT >/etc/modprobe.d/dccp.conf
install dccp /bin/false
blacklist dccp
EOT
/sbin/modprobe -r dccp

# Disable sctp
/bin/cat << EOT >/etc/modprobe.d/sctp.conf
install sctp /bin/false
blacklist sctp
EOT
/sbin/modprobe -r sctp

# Disable rds
/bin/cat << EOT >/etc/modprobe.d/rds.conf
install rds /bin/false
blacklist rds
EOT
/sbin/modprobe -r rds

# Disable tipc
/bin/cat << EOT >/etc/modprobe.d/tipc.conf
install tipc /bin/false
blacklist tipc
EOT
/sbin/modprobe -r tipc

# File system configuration
/bin/sed -ri 's/^\s*([^#]+\s+\/tmp\s+)(\S+\s+)(\S+)?(\s+[0-9]\s+[0-9].*)$/\1\2\3,noexec\4/' /etc/fstab
/bin/mount -o remount /tmp
/bin/echo -e "tmpfs\t\t/dev/shm\ttmpfs\tnodev,nosuid,noexec\t0\t0" >> /etc/fstab
/bin/mount -o remount /dev/shm

# Secure boot settings
/bin/cat << EOT >/etc/grub.d/42_custom
cat <<EOF
set superusers="root"
password_pbkdf2 root grub.pbkdf2.sha512.10000.080D3601C9F8BE1447DDAAA555D68D3952EF37B85AD60643F85FAD9FB22B0AB44D62F474BD6CADF8BD9C1E5CC3A2BFD719ED69FF91EB376E2173CA76F3DD79C9.7D241BF1338A9129600D559CE8DF57B5618019EEBCEE7F39A030D116C79F3F941A496CD411975B9DFCE3C82CE93AD48B6C1DA76093806BCDF7B4D5220F0D8582
EOF
EOT
/usr/sbinupdate-grub
/bin/chmod u-wx,go-rwx /boot/grub/grub.cfg

# Additional Process Hardening
/bin/printf "kernel.randomize_va_space = 2\n" >> /etc/sysctl.d/60-kernel_sysctl.conf
/sbin/sysctl -w kernel.randomize_va_space=2
/bin/cat << EOT >/etc/security/limits.d/01_custom
*   hard    core    0
EOT
/bin/printf "fs.suid_dumpable = 0\n" >> /etc/sysctl.d/61-coredumps_sysctl.conf
/sbin/sysctl -w fs.suid_dumpable=0

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
/bin/printf "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\n" >> /etc/sysctl.d/60-netipv6_sysctl.conf
/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1
/sbin/sysctl -w net.ipv6.conf.default.disable_ipv6=1
/sbin/sysctl -w net.ipv6.route.flush=1

# Disable Packet Redirect Sending
/bin/printf "net.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
/sbin/sysctl -w net.ipv4.conf.all.send_redirects=0
/sbin/sysctl -w net.ipv4.conf.default.send_redirects=0

# Disable IP Forwarding
/bin/printf "net.ipv4.ip_forwarding = 0\nnet.ipv6.conf.all.forwarding = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
/sbin/sysctl -w net.ipv4.ip_forwarding=0
/sbin/sysctl -w net.ipv6.conf.all.forwarding=0

# Ensure source routed packets are not accepted
/bin/printf "net.ipv4.conf.all.accept_source_route = 0\nnet.ipv4.conf.default.accept_source_route = 0\nnet.ipv6.conf.all.accept_source_route = 0\nnet.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.d/63-disable_source_routed_packets.conf
/sbin/sysctl -w net.ipv4.conf.all.accept_source_route=0
/sbin/ssyctl -w net.ipv4.conf.default.accept_source_route=0
/sbin/ssyctl -w net.ipv6.conf.all.accept_source_route=0
/sbin/ssyctl -w net.ipv6.conf.default.accept_source_route=0

# Ensure ICMP redirects are not accepted
/bin/printf "net.ipv4.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects= 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.d/64-disable_icmp_redirects.conf
/sbin/sysctl -w net.ipv4.conf.all.accept_redirects=0
/sbin/sysctl -w net.ipv4.conf.default.accept_redirects=0
/sbin/sysctl -w net.ipv6.conf.all.accept_redirects=0
/sbin/sysctl -w net.ipv6.conf.default.accept_redirects=0

# Ensure secure ICMP redirects are not accepted
/bin/printf "net.ipv4.conf.default.secure_redirects = 0\nnet.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.d/65-disable_secure_icmp_redirects.conf
/sbin/sysctl -w net.ipv4.conf.default.secure_redirects=0
/sbin/sysctl -w net.ipv4.conf.all.secure_redirects=0

# Ensure suspicious packets are logged
/bin/printf "net.ipv4.conf.all.log_martians = 1\nnet.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.d/66-log-suspicious-packets.conf
/sbin/sysctl -w net.ipv4.conf.all.log_martians=1
/sbin/sysctl -w net.ipv4.conf.default.log_martians=1

# Ensure broadcast ICMP requests are ignored
/bin/printf "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/67-ignore-broadcast-icmp-requests.conf
/sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1

# Ensure bogus ICMP responses are ignored
/bin/printf "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/68-ignore-bogus-icmp-responses.conf
/sbin/sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1

# Ensure Reverse Path Filtering is enabled
/bin/printf "net.ipv4.conf.all.rp_filter = 1\nnet.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/69-enable-reverse-path-filtering.conf
/sbin/sysctl -w net.ipv4.conf.all.rp_filter=1
/sbin/sysctl -w net.ipv4.conf.default.rp_filter=1

# Ensure TCP SYN Cookies is enabled
/bin/printf "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/69-enable-tcp-syn-cookies.conf
/sbin/sysctl -w net.ipv4.tcp_syncookies=1

# Ensure IPv6 router advertisements are not accepted
/bin/printf "net.ipv6.conf.all.accept_ra = 0\nnet.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.d/70-enable-ipv6-router-advertisements-not-accepted.conf
/sbin/sysctl -w net.ipv6.conf.all.accept_ra=0
/sbin/sysctl -w net.ipv6.conf.default.accept_ra=0

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
