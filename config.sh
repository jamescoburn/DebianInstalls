#!/usr/bin/env bash
{
# Disable squashfs
/bin/cat << EOT >/etc/modprobe.d/squashfs.conf
    install squashfs /bin/false
    blacklist squashfs
EOT
    
    # File system configuration
    /bin/sed -ri 's/^\s*([^#]+\s+\/tmp\s+)(\S+\s+)(\S+)?(\s+[0-9]\s+[0-9].*)$/\1\2\3,noexec\4/' /etc/fstab
    /bin/echo -e "tmpfs\t\t/dev/shm\ttmpfs\tnodev,nosuid,noexec\t0\t0" >> /etc/fstab
}