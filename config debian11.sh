#
#________        ___.   .__                 ____ ____                                                   
#\______ \   ____\_ |__ |__|____    ____   /_   /_   |                                                  
# |    |  \_/ __ \| __ \|  \__  \  /    \   |   ||   |                                                  
# |    `   \  ___/| \_\ \  |/ __ \|   |  \  |   ||   |                                                  
#/_______  /\___  >___  /__(____  /___|  /  |___||___|                                                  
#        \/     \/    \/        \/     \/                                                               
#_________                _____.__                            __                                        
#\_   ___ \  ____   _____/ ____\__| ____  __ ______________ _/  |_  ___________                         
#/    \  \/ /  _ \ /    \   __\|  |/ ___\|  |  \_  __ \__  \\   __\/  _ \_  __ \                        
#\     \___(  <_> )   |  \  |  |  / /_/  >  |  /|  | \// __ \|  | (  <_> )  | \/                        
# \______  /\____/|___|  /__|  |__\___  /|____/ |__|  (____  /__|  \____/|__|                           
#        \/            \/        /_____/                   \/                                           
#__________              ____.                              _________       ___.                        
#\______   \___.__.     |    |____    _____   ____   ______ \_   ___ \  ____\_ |__  __ _________  ____  
# |    |  _<   |  |     |    \__  \  /     \_/ __ \ /  ___/ /    \  \/ /  _ \| __ \|  |  \_  __ \/    \ 
# |    |   \\___  | /\__|    |/ __ \|  Y Y  \  ___/ \___ \  \     \___(  <_> ) \_\ \  |  /|  | \/   |  \
# |______  // ____| \________(____  /__|_|  /\___  >____  >  \______  /\____/|___  /____/ |__|  |___|  /
#        \/ \/                    \/      \/     \/     \/          \/           \/                  \/ 



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

# File system configuration
/bin/sed -ri 's/^\s*([^#]+\s+\/tmp\s+)(\S+\s+)(\S+)?(\s+[0-9]\s+[0-9].*)$/\1\2\3,noexec\4/' /etc/fstab
/bin/mount -o remount /tmp
/bin/echo -e "tmpfs\t\t/dev/shm\ttmpfs\tnodev,nosuid,noexec\t0\t0" >> /etc/fstab
/bin/mount -o remount /dev/shm

# Secure boot settings
/bin/cat << EOT >/etc/grub.d/42_custom
cat <<EOF
set superusers="root"
password pbkdf2 root grub.pbkdf2.sha512.10000.080D3601C9F8BE1447DDAAA555D68D3952EF37B85AD60643F85FAD9FB22B0AB44D62F474BD6CADF8BD9C1E5CC3A2BFD719ED69FF91EB376E2173CA76F3DD79C9.7D241BF1338A9129600D559CE8DF57B5618019EEBCEE7F39A030D116C79F3F941A496CD411975B9DFCE3C82CE93AD48B6C1DA76093806BCDF7B4D5220F0D8582
EOF
EOT
/usr/sbin/update-grub
/bin/chmod u-wx,go-rwx /boot/grub/grub.cfg

# Additional Process Hardening
/bin/printf "kernel.randomize_va_space = 2\n" >> /etc/sysctl.d/60-kernel_sysctl.conf
/sbin/sysctl -w kernel.randomize_va_space=2

# Restrict Core Dumps
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
/bin/cat << EOT >/etc/issue.net

WARNING: To protect the system from fraud and abuse, activities
on this system are monitored and subject to audit. Use of this
system is expressed consent to monitor.

EOT

# Configure systemd-timesyncd
/bin/sed -i "s/#NTP=/NTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org /g" /etc/systemd/timesyncd.conf
/bin/sed -i "s/#FallbackNTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org/FallbackNTP=2.debian.pool.ntp.org 3.debian.pool.ntp.org/g" /etc/systemd/timesyncd.conf

# Uninstalled/purge telnet client
apt purge -y -q telnet

# Disable IPv6
/bin/printf "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\n" >> /etc/sysctl.d/60-disable_ipv6.conf
/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1
/sbin/sysctl -w net.ipv6.conf.default.disable_ipv6=1
/sbin/sysctl -w net.ipv6.route.flush=1