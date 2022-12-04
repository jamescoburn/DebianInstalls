#!/usr/bin/env bash

# 1 - Initial Setup
# 1.1 - Filesystem Configuration
# 1.1.1 - Disable unused filesystems
# 1.1.1.1 - Ensure mounting of cramfs filesystems is disabled
sudo ./audit_cramfs.sh

# 1.1.1.2 - Ensure mounting of squashfs filesystems is disabled
sudo ./audit_squashfs.sh

# 1.1.1.3 - Ensure mounting of udf filesystems is disabled
sudo ./audit_udf.sh

# 1.1.2 - Configure /tmp
sudo ./audit_partition-tmp.sh

# 1.1.3 - Configure /var
sudo ./audit_partition-var.sh

# 1.1.4 - Configure /var/tmp
sudo ./audit_partition-vartmp.sh

# 1.1.5 - Configure /var/log
sudo ./audit_partition-varlog.sh

# 1.1.6 - Configure /var/log/audit
sudo ./audit_partition-varlogaudit.sh

# 1.1.7 - Configure /home
sudo ./audit_partition-home.sh

# 1.1.8 - Configure /dev/shm
sudo ./audit_partition-devshm.sh

# 1.1.9 - Disable Automounting
sudo ./audit_automounting.sh

# 1.1.10 - Disable USB Storage
sudo ./audit_usbstorage.sh

# 1.2 - Configure Software Updates
# 1.2.1 - 
# 1.2.2 - 

# 1.3 - Filesystem Integrity Checking
# 1.3.1 - Ensure AIDE is installed
sudo ./audit_isinstalled-aide.sh

# 1.3.2 - Ensure filesystem integrity is regularly checked
sudo ./audit_ensure-filesystem-integrity-regularly-checked.sh

# 1.4 - Secure Boot Settings
# 1.4.1 - Ensure bootloader password is set
sudo ./audit_ensure-bootloader-password-set.sh

# 1.4.2 - Ensure permissions on bootloader config are configured
sudo ./audit_ensure-permissions-configured-bootloader.sh

# 1.4.3 - Ensure authentication required for single user mode
sudo ./audit_ensure-authentication-required-single-user-mode.sh

# 1.5 - Additional Process Hardening
# 1.5.1 - Ensure address space layout randomization (ASLR) is enabled
sudo ./audit_aslr.sh

# 1.5.2 - Ensure prelink is not installed
sudo ./audit_prelink.sh

# 1.5.3 - Ensure Automatic Error Reporting is not enabled
sudo ./audit_ensure-automatic-error-reporting-disabled.sh

# 1.5.4 - Ensure core dumps are restricted
sudo ./audit_ensure-core-dumps-restricted.sh

# 1.6 - Mandatory Access Control
# 1.6.1 - Configure AppArmor
# 1.6.1.1 - Ensure AppArmor is installed
sudo ./audit_isinstalled-apparmor.sh

# 1.6.1.2 - Ensure AppArmor is enabled in the bootloader configuration
sudo ./audit_ensure-apparmor-enabled-bootloader.sh

# 1.6.1.3 - Ensure all AppArmor Profiles are in enforce or complain mode
sudo ./audit_ensure-apparmor-profiles-enforce-complain.sh

# 1.6.1.4 - Ensure all AppArmor Profiles are enforcing
sudo ./audit_ensure-apparmor-profiles-enforcing.sh

# 1.7 - Command Line Warning Banners
# 1.7.1 - Ensure message of the day is configured properly
sudo ./audit_ensure-motd-configured-properly.sh

# 1.7.2 - Ensure local login warning banner is configured properly
sudo ./audit_ensure-local-login-banner-configured-properly.sh

# 1.7.3 - Ensure remote login warning banner is configured properly
sudo ./audit_ensure-remote-login-banner-configured-properly.sh

# 1.7.4 - Ensure permissions on /etc/motd are configured
sudo ./audit_ensure-permissions-configured-motd.sh

# 1.7.5 - Ensure permissions on /etc/issue are configured
sudo ./audit_ensure-permissions-configured-local-login-banner.sh

# 1.7.6 - Ensure permissions on /etc/issue.net are configured
sudo ./audit_ensure-permissions-configured-remote-login-banner.sh

# 1.8 - GNOME Display Manager
# 1.8.1 - Ensure GNOME Display Manager is removed
# 1.8.2 - Ensure GDM login banner is configured
# 1.8.3 - Ensure GDM disable-user-list option is enabled
# 1.8.4 - Ensure GDM screen locks when the user is idle
# 1.8.5 - Ensure GDM screen locks cannot be overridden
# 1.8.6 - Ensure GDM automatic mounting of removable media is disabled
# 1.8.7 - Ensure GDM disabling automatic mounting of removable media is not overridden
# 1.8.8 - Ensure GDM autorun-never is enabled
# 1.8.9 - Ensure GDM autorun-never is not overridden
# 1.8.10 - Ensure XDCMP is not enabled
# 1.9 - Ensure updates, patches, and additional security software is installed

# 2 - Services
# 2.1 - Configre Time Synchronization
# 2.1.1 - Ensure time synchronization is in use
# 2.1.1.1 - Ensure a single time synchronization is in use
sudo ./audit_timesyncdaemons.sh

# 2.1.2 - Configure chrnoy
# 2.1.2.1 - Ensure chrony is configured with authorized timeserver
# 2.1.2.2 - Ensure chrony is running as user _chrony
# 2.1.2.3 - Ensure chrony is enabled and running

# 2.1.3 - Configure systemd-timesyncd
# 2.1.3.1 - Ensure systemd-timesyncd configured with authorized timeserver
sudo ./audit_ensure-configured-systemd-timesyncd.sh

# 2.1.3.1 - Ensure systemd-timesyncd is enabled and running
sudo ./audit_ensure-service-enabled-active-systemd-timesyncd.sh

# 2.1.4 - Configure ntp
# 2.1.4.1 - Ensure ntp access control is configured
# 2.1.4.2 - Ensure ntp is configured with authorized timeserver
# 2.1.4.3 - Ensure ntp is running as user ntp
# 2.1.4.4 - Ensure ntp is enabled and running

# 2.2 - Special Purpose Services
# 2.2.1 - Ensure X Window System is not installed
sudo ./audit_ensure-is-not-installed-x-windows-system.sh

# 2.2.2 - Ensure Avahi Server is not installed
sudo ./audit_ensure-is-not-installed-avahi-server.sh

# 2.2.3 - Ensure CUPS is not installed
sudo ./audit_ensure-is-not-installed-cups.sh

# 2.2.4 - Ensure DHCP Server is not installed
sudo ./audit_ensure-is-not-installed-dhcp-server.sh

# 2.2.5 - Ensure LDAP server is not installed
sudo ./audit_ensure-is-not-installed-ldap-server.sh

# 2.2.6 - Ensure NFS is not installed
sudo ./audit_ensure-is-not-installed-nfs.sh

# 2.2.7 - Ensure DNS Server is not installed
sudo ./audit_ensure-is-not-installed-dns-server.sh

# 2.2.8 - Ensure FTP Server is not installed
sudo ./audit_ensure-is-not-installed-ftp-server.sh

# 2.2.9 - Ensure HTTP server is not installed
sudo ./audit_ensure-is-not-installed-http-server.sh

# 2.2.10 - Ensure IMAP and POP3 server are not installed
sudo ./audit_ensure-is-not-installed-imap-pop3-server.sh

# 2.2.11 - Ensure Samba is not installed
sudo ./audit_ensure-is-not-installed-samba.sh

# 2.2.12 - Ensure HTTP Proxy Server is not installed
sudo ./audit_ensure-is-not-installed-http-proxy-server.sh

# 2.2.13 - Ensure SNMP Server is not installed
sudo ./audit_ensure-is-not-installed-snmp-server.sh

# 2.2.14 - Ensure NIS Server is not installed
sudo ./audit_ensure-is-not-installed-nis-server.sh

# 2.2.15 - Ensure mail transfer agent is configured for local-only mode
sudo ./audit_ensure-mta-configured-local-only.sh

# 2.2.16 - Ensure rsync service is either not installed or masked
sudo ./audit_ensure-is-not-installed-rsync-service.sh

# 2.3 - Client Services
# 2.3.1 - Ensure NIS Client is not installed
# 2.3.1 - Ensure rsh client is not installed
# 2.3.1 - Ensure talk client is not installed
# 2.3.1 - Ensure telnet client is not installed
# 2.3.1 - Ensure LDAP client is not installed
# 2.3.1 - Ensure RPC is not installed
# 2.4 - Ensure nonessential services are removed or masked

# 3 - Network Configuration
# 3.1 - Disable unused network protocols and devices
# 3.1.1 - Ensure system is checked to determine if IPv6 is enabled
sudo ./audit_ipv6.sh

# 3.1.2 - Ensure wireless interfaces are disabled
sudo ./audit_wirelessinterface.sh

# 3.1.3 - Ensure DCCP is disabled
sudo ./audit_dccp.sh

# 3.1.4 - Ensure SCTP is disabled
sudo ./audit_sctp.sh

# 3.1.5 - Ensure RDS is disabled
sudo ./audit_rds.sh

# 3.1.6 - Ensure TIPC is disabled
sudo ./audit_tipc.sh

# 3.2 - Network Parameters (Host Only)
# 3.2.1 - Ensure packet redirect sending is disabled
sudo ./audit_sendredirects.sh

# 3.2.2 - Ensure IP forwarding is disabled
sudo ./audit_ipforwarding.sh

# 3.3 - Network Parameters (Host and Router)
# 3.3.1 - Ensure source routed packets are not accepted
# 3.3.2 - Ensure ICMP redirects are not accepted
# 3.3.3 - Ensure secure ICMPredirects are not accepted
# 3.3.4 - Ensure suspicious packets are logged
# 3.3.5 - Ensure broadcast ICMP requests are ignored
# 3.3.6 - Ensure bogus ICMP responses are ignored
# 3.3.7 - Ensure Reverse Path Filtering is enabled
# 3.3.8 - Ensure TCP SYN Cookies are enabled
# 3.3.9 - Ensure IPv6 router advertisements are not accepted

# 3.5 - Firewall Configuration
# 3.5.1 - Configure UncomplicatedFirewall
# 3.5.1.1 - 
# 3.5.1.2 - 
# 3.5.1.3 - 
# 3.5.1.4 - 
# 3.5.1.5 - 
# 3.5.1.6 - 
# 3.5.1.7 - 

# 3.5.2 - Configure nftables
# 3.5.2.1 - 
# 3.5.2.2 - 
# 3.5.2.3 - 
# 3.5.2.4 - 
# 3.5.2.5 - 
# 3.5.2.6 - 
# 3.5.2.7 - 
# 3.5.2.8 - 
# 3.5.2.9 - 
# 3.5.2.10 - 

# 3.5.3 - Configure iptables
# 3.5.3.1 - Configure iptables software
# 3.5.3.1.1 - 
# 3.5.3.1.2 - 
# 3.5.3.1.3 - 

# 3.5.3.2 - Configure IPv4 iptables
# 3.5.3.2.1 - 
# 3.5.3.2.2 - 
# 3.5.3.2.3 - 
# 3.5.3.2.4 - 

# 3.5.3.3 - Configure IPv6 ip6tables
# 3.5.3.3.1 - 
# 3.5.3.3.2 - 
# 3.5.3.3.3 - 
# 3.5.3.3.4 - 

















