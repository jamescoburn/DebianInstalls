#!/usr/bin/env bash
{
# Disable cramfs
/bin/cat << EOT >/etc/modprobe.d/cramfs.conf
install cramfs /bin/false
blacklist cramfs
EOT
    
# Disable squashfs
/bin/cat << EOT >/etc/modprobe.d/squashfs.conf
install squashfs /bin/false
blacklist squashfs
EOT
    
# Disable udf
/bin/cat << EOT >/etc/modprobe.d/udf.conf
install udf /bin/false
blacklist udf
EOT

# Disable usb-storage
/bin/cat << EOT >/etc/modprobe.d/usb-storage.conf
install usb-storage /bin/false
blacklist usb-storage
EOT

# File system configuration
/bin/sed -ri 's/^\s*([^#]+\s+\/tmp\s+)(\S+\s+)(\S+)?(\s+[0-9]\s+[0-9].*)$/\1\2\3,noexec\4/' /etc/fstab
/bin/echo -e "tmpfs\t\t/dev/shm\ttmpfs\tnodev,nosuid,noexec\t0\t0" >> /etc/fstab

# Secure boot settings
/bin/cat << EOT >/etc/grub.d/42_custom
cat <<EOF
set superusers="root"
password pbkdf2 root grub.pbkdf2.sha512.10000.080D3601C9F8BE1447DDAAA555D68D3952EF37B85AD60643F85FAD9FB22B0AB44D62F474BD6CADF8BD9C1E5CC3A2BFD719ED69FF91EB376E2173CA76F3DD79C9.7D241BF1338A9129600D559CE8DF57B5618019EEBCEE7F39A030D116C79F3F941A496CD411975B9DFCE3C82CE93AD48B6C1DA76093806BCDF7B4D5220F0D8582
EOF
EOT
chmod u-wx,go-rwx /boot/grub/grub.cfg
}


