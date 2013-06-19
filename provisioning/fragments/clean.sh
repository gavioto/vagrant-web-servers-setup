# Script to remove system services and modules not used
#
# Based on script created by Benjamin KRAFT <benj@bkraft.fr>
# related to the article http://bkraft.fr/articles/Securing_CentOS_6_installation/
# Designed to run and secure CentOS 6.2 minimal installation
#
echo
echo "========== STARTED CLEANING THE SYSTEM =========="
echo

echo "Removing unnecessary services from default bootlevel..."
for i in rpcbind  nfslock  lldpad fcoe rpcidmapd; do
    service $i stop;
    chkconfig $i off;
done

echo "Blacklisting fcoe, wireless and other unnecessary kernel modules..."
for i in $(find /lib/modules/`uname -r`/kernel/drivers/net/wireless -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-wireless.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/scsi/fcoe -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-fcoe.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/net/wireless -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-wireless.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/scsi/fcoe -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-fcoe.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/bluetooth -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-bluetooth.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/pcmcia -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-pcmcia.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/infiniband -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-infiniband.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/isdn -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-isdn.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/firewire -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-firewire.conf ;
done
for i in $(find /lib/modules/`uname -r`/kernel/drivers/ieee802154 -name "*.ko" -type f) ; do
    echo blacklist $i >> /etc/modprobe.d/blacklist-ieee802154.conf ;
done

echo "removing unnecessary packages..."
yum remove lvm2\*   # unnecessary hard drive partitioning system
yum remove nfs\*    # nfs (legacy file sharing)
yum remove iscsi\*  # scsi over internet (also removes dracut-network)
yum remove fcoe\*   # fibre channel over ethernet
yum remove lldpad\* # for fibre channel over ethernet

echo "allowing only one single getty..."
sed -i 's/1-6/1/g' /etc/syconfig/init
sed -i 's/1-6/1/g' /etc/init/start-ttys.conf

echo
echo "========== FINISHED CLEANING THE SYSTEM =========="
echo