#!/bin/sh

chown root:root -R *

echo "tail -n 500 vpad.log > vpad.tmp "
tail -n 500 vpad.log > vpad.log.tmp
mv vpad.log.tmp vpad.log

echo >> vpad.log
echo "====================================================================" >> vpad.log
echo "Initializing USB cleanup script created 08/27/08" >> vpad.log
echo "====================================================================" >> vpad.log
echo >> vpad.log


########################################################################################
# BEGIN OF CLEANUP UTILITY 
########################################################################################

if [ -e new_vpad_boot ]
then
	mv /Release/new_vpad_boot /root/vpad.sh
	echo 'mv /Release/new_vpad_boot /root/vpad.sh' >> vpad.log
fi

echo REMOVING EXTRANEOUS FILES >> vpad.log
if [ -L /usr/local/qtopia-core-arm/lib/fonts ]
then
	echo removing symlink /usr/local/qtopia-core-arm/lib/fonts >> vpad.log
	rm /usr/local/qtopia-core-arm/lib/fonts
	echo making /usr/local/qtopia-core-arm/lib/fonts directory >> vpad.log
	mkdir /usr/local/qtopia-core-arm/lib/fonts
else
	for x in /usr/local/qtopia-core-arm/lib/fonts/*
	do
		if [ "$x" = "/usr/local/qtopia-core-arm/lib/fonts/DejaVuSans.ttf" -o "$x" = "/usr/local/qtopia-core-arm/lib/fonts/Vera.ttf" ]
		then
			echo keeping $x >> vpad.log
		else
			echo removing $x >> vpad.log
			rm $x
		fi
	done
fi
if [ -e /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/Vera.ttf -a ! -e /usr/local/qtopia-core-arm/lib/fonts/Vera.ttf ]
then
	echo moving Vera.ttf from /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts to /usr/local/qtopia-core/lib/fonts >> vpad.log
	mv /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/Vera.ttf /usr/local/qtopia-core-arm/lib/fonts
fi
if [ -e /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/DejaVuSans.ttf -a ! -e /usr/local/qtopia-core-arm/lib/fonts/DejaVuSans.ttf ]
then
	echo moving DejaVuSans.ttf from /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts to /usr/local/qtopia-core/lib/fonts >> vpad.log
	mv /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/DejaVuSans.ttf /usr/local/qtopia-core-arm/lib/fonts
fi
if [ -d /usr/local/Trolltech ]
then
	echo removing /usr/local/Trolltech >> vpad.log
	rm -rf /usr/local/Trolltech
fi
if [ -d /usr/local/lib ]
then
	echo removing /usr/local/lib >> vpad.log
	rm -rf /usr/local/lib
fi
if [ -d /usr/local/wifi ]
then
	echo removing /usr/local/wifi >> vpad.log
	rm -rf /usr/local/wifi
fi
if [ -d /root/Settings ]
then
	echo removing /root/Settings dir >> vpad.log
	rm -rf /root/Settings
fi
if [ -e /root/hwtest.sh ] 
then
	echo removing /root/hwtest.sh >> vpad.log
	rm -f /root/hwtest.sh
fi
if [ -e /root/longKey.sh ]
then
	echo removing /root/longKey.sh >> vpad.log
	rm -f /root/longKey.sh
fi
if [ -e /root/vpad_mp.sh ]
then
	echo removing /root/vpad_mp.sh >> vpad.log
	rm -f /root/vpad_mp.sh
fi
if [ -d /Release/vpad_mp_test ]
then
	echo removing /Release/vpad_mp_test >> vpad.log
	rm -rf /Release/vpad_mp_test
fi
if [ -e /Release/old_kernel ]
then
	echo removing /Release/old_kernel >> vpad.log
	rm -f /Release/old_kernel
fi
if [ -e /Release/sbn_logo.yuv ]
then
	echo removing /Release/sbn_logo.yuv >> vpad.log
	rm -f /Release/sbn_logo.yuv
fi
if [ -e /Release/mousecalibration ]
then
	echo removing /Release/mousecalibration >> vpad.log
	rm -f /Release/mousecalibration
fi
if [ -e /Release/longKey ]
then
	echo removing /Release/longKey >> vpad.log
	rm -f /Release/longKey
fi
if [ -d /Release/ACIFData ]
then
	echo removing /Release/ACIFData >> vpad.log
	rm -rf /Release/ACIFData
fi
if [ -d /Release/HelpFile ]
then
	echo removing /Release/HelpFile >> vpad.log
	rm -rf /Release/HelpFile
fi
if [ -e /Release/hwtest_gui ]
then
	echo removing /Release/hwtest_gui >> vpad.log
	rm -f /Release/hwtest_gui
fi

echo END OF REMOVAL >> vpad.log

#######################################################################################
# END OF REMOVAL
#######################################################################################
			

#######################################################################################
# BEGIN OF DIAGNOSIS
#######################################################################################

if [ ! -e /usr/local/qtopia-core-arm/lib/fonts/Vera.ttf ]
then
	mkdir -p /usr/local/qtopia-core-arm/lib/fonts
	mv Vera.ttf /usr/local/qtopia-core-arm/lib/fonts/
	echo "/usr/local/qtopia-core-arm/lib/fonts/Vera.ttf did not exist." >> vpad.log
	echo "copying Vera.ttf to /usr/local/qtopia-core-arm/lib/fonts" >> vpad.log
else
	rm Vera.ttf
fi
	
echo >> vpad.log
echo 'running ifconfig' >> vpad.log
echo >> vpad.log
ifconfig eth0 up
ifconfig >> vpad.log

echo >> vpad.log
echo 'running ls -al /*' >> vpad.log
echo >> vpad.log
ls -al /* >> vpad.log
echo >> vpad.log
echo "running df" >> vpad.log
echo >> vpad.log
df >> vpad.log
echo >> vpad.log
echo 'running du /Release' >> vpad.log
echo >> vpad.log
du /Release >> vpad.log
echo >> vpad.log
echo 'running du /root' >> vpad.log
echo >> vpad.log
du /root >> vpad.log
echo >> vpad.log

VPADLOG=vpad.log
RANDNUM=`date +%s`
cp vpad.log /mnt/usb/${VPADLOG}_${RANDNUM}
rm /mnt/usb/new_vpad_usb.tar.aes

#######################################################################################
# END OF DIAGNOSIS
#######################################################################################

chmod 666 /etc/init.d/networking
if [ ! -d /mnt/mmc ]
then
	mkdir /mnt/mmc
fi

sync
sync
sync

sleep 3
echo rebooting now
./svp5000_reboot
