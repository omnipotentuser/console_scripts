#!/bin/sh

chown root:root -R *

echo "tail -n 500 hack.log > hack.tmp "
tail -n 500 hack.log > hack.log.tmp
mv hack.log.tmp hack.log

echo >> hack.log
echo "====================================================================" >> hack.log
echo "Initializing USB cleanup script created 08/27/08" >> hack.log
echo "====================================================================" >> hack.log
echo >> hack.log


########################################################################################
# BEGIN OF CLEANUP UTILITY 
########################################################################################

if [ -e new_hack ]
then
	mv /Release/new_hack /root/hack.sh
	echo 'mv /Release/new_hack /root/hack.sh' >> hack.log
fi

echo REMOVING EXTRANEOUS FILES >> hack.log
if [ -L /usr/local/qtopia-core-arm/lib/fonts ]
then
	echo removing symlink /usr/local/qtopia-core-arm/lib/fonts >> hack.log
	rm /usr/local/qtopia-core-arm/lib/fonts
	echo making /usr/local/qtopia-core-arm/lib/fonts directory >> hack.log
	mkdir /usr/local/qtopia-core-arm/lib/fonts
else
	for x in /usr/local/qtopia-core-arm/lib/fonts/*
	do
		if [ "$x" = "/usr/local/qtopia-core-arm/lib/fonts/DejaVuSans.ttf" -o "$x" = "/usr/local/qtopia-core-arm/lib/fonts/Vera.ttf" ]
		then
			echo keeping $x >> hack.log
		else
			echo removing $x >> hack.log
			rm $x
		fi
	done
fi
if [ -e /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/Vera.ttf -a ! -e /usr/local/qtopia-core-arm/lib/fonts/Vera.ttf ]
then
	echo moving Vera.ttf from /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts to /usr/local/qtopia-core/lib/fonts >> hack.log
	mv /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/Vera.ttf /usr/local/qtopia-core-arm/lib/fonts
fi
if [ -e /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/DejaVuSans.ttf -a ! -e /usr/local/qtopia-core-arm/lib/fonts/DejaVuSans.ttf ]
then
	echo moving DejaVuSans.ttf from /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts to /usr/local/qtopia-core/lib/fonts >> hack.log
	mv /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/DejaVuSans.ttf /usr/local/qtopia-core-arm/lib/fonts
fi
if [ -d /usr/local/Trolltech ]
then
	echo removing /usr/local/Trolltech >> hack.log
	rm -rf /usr/local/Trolltech
fi
if [ -d /usr/local/lib ]
then
	echo removing /usr/local/lib >> hack.log
	rm -rf /usr/local/lib
fi
if [ -d /usr/local/wifi ]
then
	echo removing /usr/local/wifi >> hack.log
	rm -rf /usr/local/wifi
fi
if [ -d /root/Settings ]
then
	echo removing /root/Settings dir >> hack.log
	rm -rf /root/Settings
fi
if [ -e /root/hwtest.sh ] 
then
	echo removing /root/hwtest.sh >> hack.log
	rm -f /root/hwtest.sh
fi
if [ -e /root/longKey.sh ]
then
	echo removing /root/longKey.sh >> hack.log
	rm -f /root/longKey.sh
fi
if [ -e /root/hack.sh ]
then
	echo removing /root/hack.sh >> hack.log
	rm -f /root/hack.sh
fi
if [ -d /Release/hack ]
then
	echo removing /Release/hack >> hack.log
	rm -rf /Release/hack
fi
if [ -e /Release/old_kernel ]
then
	echo removing /Release/old_kernel >> hack.log
	rm -f /Release/old_kernel
fi
if [ -e /Release/sbn_logo.yuv ]
then
	echo removing /Release/sbn_logo.yuv >> hack.log
	rm -f /Release/sbn_logo.yuv
fi
if [ -e /Release/mousecalibration ]
then
	echo removing /Release/mousecalibration >> hack.log
	rm -f /Release/mousecalibration
fi
if [ -e /Release/longKey ]
then
	echo removing /Release/longKey >> hack.log
	rm -f /Release/longKey
fi
if [ -d /Release/ACIFData ]
then
	echo removing /Release/ACIFData >> hack.log
	rm -rf /Release/ACIFData
fi
if [ -d /Release/HelpFile ]
then
	echo removing /Release/HelpFile >> hack.log
	rm -rf /Release/HelpFile
fi
if [ -e /Release/hwtest_gui ]
then
	echo removing /Release/hwtest_gui >> hack.log
	rm -f /Release/hwtest_gui
fi

echo END OF REMOVAL >> hack.log

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
	echo "/usr/local/qtopia-core-arm/lib/fonts/Vera.ttf did not exist." >> hack.log
	echo "copying Vera.ttf to /usr/local/qtopia-core-arm/lib/fonts" >> hack.log
else
	rm Vera.ttf
fi
	
echo >> hack.log
echo 'running ifconfig' >> hack.log
echo >> hack.log
ifconfig eth0 up
ifconfig >> hack.log

echo >> hack.log
echo 'running ls -al /*' >> hack.log
echo >> hack.log
ls -al /* >> hack.log
echo >> hack.log
echo "running df" >> hack.log
echo >> hack.log
df >> hack.log
echo >> hack.log
echo 'running du /Release' >> hack.log
echo >> hack.log
du /Release >> hack.log
echo >> hack.log
echo 'running du /root' >> hack.log
echo >> hack.log
du /root >> hack.log
echo >> hack.log

hack=hack.log
RANDNUM=`date +%s`
cp hack.log /mnt/usb/${hack}_${RANDNUM}
rm /mnt/usb/new_hachachack.tar.aes

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
