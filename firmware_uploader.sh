#!/bin/sh

HACK_CURRENT=hack
HACK_BACK=back_hack
HACK_NEW=new_hack
HACK_MD5=new_chksum

DELETE_HACK=0

for x in *.tar*
do
	if [ -e $x ]
	then
		DELETE_HACK=1
		echo "rm $x" >> hack.log
		rm -f $x
	fi
	sync
	sync
done


for x in chksum_*
do
	if [ -e $x ]
	then
		DELETE_HACK=1
		echo "rm $x" >> hack.log
		rm -f $x
	fi
	sync
	sync
done

for x in new_*
do
	if [ $x != $HACK_NEW -a $x != $HACK_MD5 ]
	then
		DELETE_HACK=1
		echo "rm $x" >> hack.log
		rm -f $x
	fi
	sync
	sync
done


if [ -e $HACK_NEW -a -e $HACK_MD5 -a $DELETE_HACK -eq 0 ]
then
	echo "file $HACK_NEW found"

	if [ -e $HACK_CURRENT ]
	then
		echo "HACK old file exists: move to backup"
		mv $HACK_CURRENT $HACK_BACK
	fi

	SUM=$(md5sum $HACK_NEW)
	DIGEST=$(cat $HACK_MD5)
	echo SUM = $SUM
	echo DIGEST = $DIGEST

	echo "Start checksum comparison to digest"
	if [ "$SUM" != "$DIGEST" ] 
	then 
		echo "hack checksum doesn't match digest: replace with backup" >> hack.log
		mv $HACK_BACK $HACK_CURRENT
		rm $HACK_MD5
		rm $HACK_NEW
	else
		echo "hack checksum ok: remove backup" >> hack.log
		mv $HACK_NEW $HACK_CURRENT
		rm $HACK_BACK
		rm $HACK_MD5
	fi
else
	if [ -e $HACK_NEW ]
	then
		echo "rm $HACK_NEW" >> hack.log
		rm $HACK_NEW
	fi

	if [ -e $HACK_MD5 ]
	then
		echo "rm $HACK_MD5" >> hack.log
		rm $HACK_MD5
	fi
fi

if [ -e /bin/busybox_1.9.2 ]
then
	echo "replacing busybox 1.9.2 with busybox"
	echo "replacing busybox 1.9.2 with busybox" >> hack.log
	killall udhcpc
	sleep 1
	rm /bin/busybox_1.9.2 /sbin/ifconfig /sbin/ifup /sbin/ifdown /sbin/udhcpc
	ln -s /bin/busybox /sbin/ifconfig
	ln -s /bin/busybox /sbin/ifup
	ln -s /bin/busybox /sbin/ifdown
	ln -s /bin/busybox /sbin/udhcpc
fi
	
sync
sync
sync

