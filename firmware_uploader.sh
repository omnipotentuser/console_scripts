#!/bin/sh

VPAD_CURRENT=vpad
VPAD_BACK=back_vpad
VPAD_NEW=new_vpad
VPAD_MD5=new_chksum

DELETE_VPAD=0

for x in *.tar*
do
	if [ -e $x ]
	then
		DELETE_VPAD=1
		echo "rm $x" >> vpad.log
		rm -f $x
	fi
	sync
	sync
done


for x in chksum_*
do
	if [ -e $x ]
	then
		DELETE_VPAD=1
		echo "rm $x" >> vpad.log
		rm -f $x
	fi
	sync
	sync
done

for x in new_*
do
	if [ $x != $VPAD_NEW -a $x != $VPAD_MD5 ]
	then
		DELETE_VPAD=1
		echo "rm $x" >> vpad.log
		rm -f $x
	fi
	sync
	sync
done


if [ -e $VPAD_NEW -a -e $VPAD_MD5 -a $DELETE_VPAD -eq 0 ]
then
	echo "file $VPAD_NEW found"

	if [ -e $VPAD_CURRENT ]
	then
		echo "VPAD old file exists: move to backup"
		mv $VPAD_CURRENT $VPAD_BACK
	fi

	SUM=$(md5sum $VPAD_NEW)
	DIGEST=$(cat $VPAD_MD5)
	echo SUM = $SUM
	echo DIGEST = $DIGEST

	echo "Start checksum comparison to digest"
	if [ "$SUM" != "$DIGEST" ] 
	then 
		echo "vpad checksum doesn't match digest: replace with backup" >> vpad.log
		mv $VPAD_BACK $VPAD_CURRENT
		rm $VPAD_MD5
		rm $VPAD_NEW
	else
		echo "vpad checksum ok: remove backup" >> vpad.log
		mv $VPAD_NEW $VPAD_CURRENT
		rm $VPAD_BACK
		rm $VPAD_MD5
	fi
else
	if [ -e $VPAD_NEW ]
	then
		echo "rm $VPAD_NEW" >> vpad.log
		rm $VPAD_NEW
	fi

	if [ -e $VPAD_MD5 ]
	then
		echo "rm $VPAD_MD5" >> vpad.log
		rm $VPAD_MD5
	fi
fi

if [ -e /bin/busybox_1.9.2 ]
then
	echo "replacing busybox 1.9.2 with busybox"
	echo "replacing busybox 1.9.2 with busybox" >> vpad.log
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

