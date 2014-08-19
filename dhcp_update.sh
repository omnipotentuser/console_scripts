#! /bin/sh
killall udhcpc
sleep 1
mv /mnt/usb/busybox_1.9.2 /bin/
sleep 1
cd /sbin
rm -f ifconfig ifup ifdown udhcpc
ln -s ../bin/busybox_1.9.2 ifconfig
ln -s ../bin/busybox_1.9.2 ifup
ln -s ../bin/busybox_1.9.2 ifdown
ln -s ../bin/busybox_1.9.2 udhcpc
