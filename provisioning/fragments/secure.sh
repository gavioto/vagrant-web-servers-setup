# Script to make the system secure
#
# Based on script created by Benjamin KRAFT <benj@bkraft.fr>
# related to the article http://bkraft.fr/articles/Securing_CentOS_6_installation/
# Designed to run and secure CentOS 6.2 minimal installation
#
echo
echo "========== STARTED SECURING THE SYSTEM =========="
echo



echo "Installing and customizing fail2ban"
yum -y install fail2ban
curl http://bkraft.fr/files/Configurations/fail2ban/jail.conf -o /etc/fail2ban/jail.conf
chkconfig fail2ban on
service fail2ban start

echo "In single user mode, ask for password"
perl -i -pe 's/sushell/sulogin/' /etc/sysconfig/init

echo "Lower available gettys number"
perl -i -pe 's/1-6/1/' /etc/sysconfig/init
perl -i -pe 's/1-6/1/' /etc/init/start-ttys.conf

echo "Disable interactive boot"
perl -i -pe 's/PROMPT=yes/PROMPT=no/' /etc/sysconfig/init

echo "Don't reboot when CTRL-ALT-DELETE is pressed"
perl -i -pe 's/exec.*/exec \/bin\/echo "Control-Alt-Delete pressed, but no action will be taken"/' /etc/init/control-alt-delete.conf

echo "Change default password length requirement"
perl -i -pe 's/PASS_MIN_LEN\s+5/PASS_MIN_LEN  9/' /etc/login.defs

echo "Disconnect idle users after 15 minutes"
cat > /etc/profile.d/inactive-users-disconnect.sh << EOF
readonly TMOUT=900
readonly HISTFILE
EOF
chmod +x /etc/profile.d/inactive-users-disconnect.sh

echo "Prevent cron and at script to everyone but root"
touch /etc/cron.allow
chmod 600 /etc/cron.allow
awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/cron.deny
touch /etc/at.allow
chmod 600 /etc/at.allow
awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/at.deny

echo "Change /etc/issue to something scary"
cat >/etc/issue << EOF
USE OF THIS COMPUTER SYSTEM, AUTHORIZED OR UNAUTHORIZED, CONSTITUTES CONSENT TO MONITORING OF THIS SYSTEM.
UNAUTHORIZED USE MAY SUBJECT YOU TO CRIMINAL PROSECUTION.
EVIDENCE OF UNAUTHORIZED USE COLLECTED DURING MONITORING MAY BE USED FOR ADMINISTRATIVE, CRIMINAL, OR OTHER ADVERSE ACTION.
USE OF THIS SYSTEM CONSTITUTES CONSENT TO MONITORING FOR THESE PURPOSES.
EOF

echo "Narrow down right on /root"
chmod 700 /root

echo "Audit logs should be available only for root"
chmod 700 /var/log/audit

echo "Remove too wide rights on iptables binary and init scripts"
chmod 740 /etc/rc.d/init.d/iptables
chmod 740 /sbin/iptables

echo "Change the rights of the default user skeleton"
chmod -R 700 /etc/skel

echo "Restrict access to rsyslog configuration to root"
chmod 600 /etc/rsyslog.conf

echo "Locking down LNX00440"
chmod 640 /etc/security/access.conf

echo "Sysctl configuration should only accessible to root"
chmod 600 /etc/sysctl.conf

echo "Secure networking by tuning sysctl values"
cat << 'EOF' >> /etc/sysctl.conf
    # disable packet forwarding
    net.ipv4.ip_forward = 0
    # drop icmp redirects
    net.ipv4.conf.all.send_redirects = 0
    net.ipv4.conf.default.send_redirects = 0
    net.ipv4.conf.all.accept_redirects = 0
    net.ipv4.conf.all.secure_redirects = 0
    net.ipv4.conf.default.accept_redirects = 0
    net.ipv4.conf.default.secure_redirects = 0
    # double the syn backlog size
    net.ipv4.tcp_max_syn_backlog = 2048
    # ignore ping broadcasts
    net.ipv4.icmp_echo_ignore_broadcasts = 1
    # drop the source routing ability
    net.ipv4.conf.all.accept_source_route = 0
    net.ipv4.conf.default.accept_source_route = 0
    # log packets destinated to impossible addresses
    net.ipv4.conf.all.log_martians = 1
    # ignore bogus icmp error responses
    net.ipv4.icmp_ignore_bogus_error_responses = 1
    # protect a bit from SYN flood attacks
    net.ipv4.tcp_syncookies = 1
    # drop packets that come in using a bad interface
    # (they will be logged as martian)
    net.ipv4.conf.all.rp_filter = 1
    net.ipv4.conf.default.rp_filter = 1
    # don't send timestamps
    net.ipv4.tcp_timestamps = 0
EOF

echo "Delete unnecessary users"
/usr/sbin/userdel shutdown
/usr/sbin/userdel halt
/usr/sbin/userdel games
/usr/sbin/userdel operator
/usr/sbin/userdel ftp
/usr/sbin/userdel gopher

echo "Prevent ssh connections from root"
perl -i -pe 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
echo "Set our scary issue message as ssh banner"
perl -i -pe 's/#Banner.*/Banner \/etc\/issue/g' /etc/ssh/sshd_config

echo "Make the server keys a bit bigger"
perl -i -pe 's/^#ServerKeyBits 1024/ServerKeyBits 2048/g' /etc/ssh/sshd_config
echo "We need now to drop previously created 1024 keys and regenerate them."
rm -vf /etc/ssh/ssh_host*
/etc/init.d/sshd restart

echo "Restrict max authentications"
perl -i -pe 's/^#MaxAuthTries 6/MaxAuthTries 3/g' /etc/ssh/sshd_config


echo
echo "========== FINISHED SECURING THE SYSTEM =========="
echo
