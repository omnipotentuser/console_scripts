#!/bin/sh

VPAD_EXEC=vpad
VPAD_NEW=new_vpad
VPAD_MD5=new_chksum

VPAD_BOOT=vpad.sh
VPAD_BOOT_NEW=new_vpad_boot
VPAD_BOOT_MD5=chksum_vpad_boot

KERNEL_NEW=new_kernel
KERNEL_OLD=old_kernel
KERNEL_MD5=chksum_kernel

KERNEL_UP=kernel_up
KERNEL_UP_NEW=new_kernel_up
KERNEL_UP_MD5=chksum_kernel_up


DAVINCI_HRT_DRIVER_CODEC=davinci_HRT_driver.ko
DAVINCI_HRT_DRIVER_CODEC_NEW=new_davinci_HRT_driver.ko
DAVINCI_HRT_DRIVER_MD5=chksum_davinci_HRT_driver.ko

DAVINCI_RSZ_DRIVER_CODEC=davinci_rsz_driver.ko
DAVINCI_RSZ_DRIVER_CODEC_NEW=new_davinci_rsz_driver.ko
DAVINCI_RSZ_DRIVER_MD5=chksum_davinci_rsz_driver.ko

DSP_LINK_CODEC=dsplinkk.ko

DSP_LINK_CODEC_128=dsplinkk_128.ko
DSP_LINK_CODEC_128_NEW=new_dsplinkk_128.ko
DSP_LINK_128_MD5=chksum_dsplinkk_128.ko

DSP_LINK_CODEC_256=dsplinkk_256.ko
DSP_LINK_CODEC_256_NEW=new_dsplinkk_256.ko
DSP_LINK_256_MD5=chksum_dsplinkk_256.ko

IPVP_MKIT_DSP_CODEC=ipvp_mkit_dsp.out

IPVP_MKIT_DSP_CODEC_128=ipvp_mkit_dsp_128.out
IPVP_MKIT_DSP_CODEC_128_NEW=new_ipvp_mkit_dsp_128.out
IPVP_MKIT_DSP_128_MD5=chksum_ipvp_mkit_dsp_128.out

IPVP_MKIT_DSP_CODEC_256=ipvp_mkit_dsp_256.out
IPVP_MKIT_DSP_CODEC_256_NEW=new_ipvp_mkit_dsp_256.out
IPVP_MKIT_DSP_256_MD5=chksum_ipvp_mkit_dsp_256.out

CMEM_CODEC=cmemk.ko
CMEM_CODEC_NEW=new_cmemk.ko
CMEM_MD5=chksum_cmemk.ko

LOADMODULES=loadmodules.sh
LOADMODULES_NEW=new_loadmodules.sh
LOADMODULES_MD5=chksum_loadmodules.sh

EPCONFIG=EPConfig.val
EPCONFIG_NEW=new_EPConfig.val
EPCONFIG_MD5=chksum_EPConfig.val

USBINIT=usb
USBINIT_NEW=new_usb
USBINIT_MD5=chksum_usb

HIPTXT=hip.txt
SNTP=sntp
AESCRYPT=aescrypt
POINTERCAL=/etc/pointercal
DEJAVUSANSBOLD=DejaVuSans-Bold.ttf
DEJAVUSANS=DejaVuSans.ttf

rmfiles()
{

		rm $KERNEL_NEW
		rm $KERNEL_MD5
		rm $VPAD_NEW
		rm $DAVINCI_HRT_DRIVER_CODEC_NEW
		rm $DAVINCI_RSZ_DRIVER_CODEC_NEW
		rm $DSP_LINK_CODEC_256_NEW
		rm $IPVP_MKIT_DSP_CODEC_256_NEW
		rm $CMEM_CODEC_NEW
		rm $LOADMODULES_NEW
		rm $VPAD_MD5
		rm $DAVINCI_HRT_DRIVER_MD5
		rm $DAVINCI_RSZ_DRIVER_MD5
		rm $DSP_LINK_256_MD5		
		rm $IPVP_MKIT_DSP_256_MD5		
		rm $CMEM_MD5
		rm $LOADMODULES_MD5
		rm $VPAD_BOOT_NEW
		rm $VPAD_BOOT_MD5
		rm $USBINIT_NEW
		rm $USBINIT_MD5
		rm $KERNEL_UP_NEW
		rm $KERNEL_UP_MD5
		rm $EPCONFIG_NEW
		rm $EPCONFIG_MD5
		rm *.tar*

}

curdate=`date`
if [ ! -e revision.txt ]
then
        echo "revision file missing" > revision.txt
fi

echo "tail -n 500 vpad.log > vpad.tmp "
tail -n 500 vpad.log > vpad.log.tmp
mv vpad.log.tmp vpad.log

if [ -e /Release/$AESCRYPT ]
then
	mv -f /Release/$AESCRYPT /usr/bin
fi

if [ -e /Release/$SNTP ]
then
	mv -f /Release/$SNTP /bin
fi

echo >> vpad.log
echo "====================================================================" >> vpad.log
echo "revision: $(cat revision.txt)" >> vpad.log
echo "date: $curdate" >> vpad.log
echo "====================================================================" >> vpad.log
echo >> vpad.log

########################################################################################
# REMOVING EXTRANEOUS FILES 
########################################################################################

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
		if [ "$x" = "/usr/local/qtopia-core-arm/lib/fonts/DejaVuSans.ttf" ] \
			|| [ "$x" = "/usr/local/qtopia-core-arm/lib/fonts/DejaVuSans-Bold.ttf" ]
		then
			echo keeping $x >> vpad.log
		else
			echo removing $x >> vpad.log
			rm $x
		fi
	done
fi
if [ -e /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/DejaVuSans.ttf ] && [ ! -e /usr/local/qtopia-core-arm/lib/fonts/DejaVuSans.ttf ]
then
	echo moving DejaVuSans.ttf from /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts to /usr/local/qtopia-core/lib/fonts >> vpad.log
	mv /usr/local/Trolltech/QtopiaCore-4.3.0-arm/lib/fonts/DejaVuSans.ttf /usr/local/qtopia-core-arm/lib/fonts
fi
if [ ! -e /usr/local/qtopia-core-arm/lib/fonts/$DEJAVUSANSBOLD ]
then
	echo inserting $DEJAVUSANSBOLD to /usr/local/qtopia-core/lib/fonts >> vpad.log
	mv $DEJAVUSANSBOLD /usr/local/qtopia-core-arm/lib/fonts
else
	echo $DEJAVUSANSBOLD already exists. Removing from /Release >> vpad.log
	rm $DEJAVUSANSBOLD
fi
if [ ! -e /usr/local/qtopia-core-arm/lib/fonts/$DEJAVUSANS ]
then
	echo inserting $DEJAVUSANS to /usr/local/qtopia-core/lib/fonts >> vpad.log
	mv $DEJAVUSANS /usr/local/qtopia-core-arm/lib/fonts
else
	echo DejaVuSans.ttf already exists. Removing from /Release >> vpad.log
	rm $DEJAVUSANS
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
if [ -e /Release/$HIPTXT ]
then
	echo removing /Release/$HIPTXT >> vpad.log
	rm -f /Release/$HIPTXT
fi
echo END OF REMOVAL >> vpad.log

#######################################################################################
# END OF REMOVAL
#######################################################################################

if [ -e $KERNEL_UP_NEW ] && [ -e $KERNEL_UP_MD5 ] && [ -e $KERNEL_NEW ] && [ -e $KERNEL_MD5 ] \
	&& [ -e $VPAD_NEW ] && [ -e $VPAD_BOOT_NEW ] && [ -e $DAVINCI_HRT_DRIVER_CODEC_NEW ] \
	&& [ -e $DAVINCI_RSZ_DRIVER_CODEC_NEW ] && [ -e $DSP_LINK_CODEC_256_NEW ] \
	&& [ -e $IPVP_MKIT_DSP_CODEC_256_NEW ] && [ -e $CMEM_CODEC_NEW ] && [ -e $LOADMODULES_NEW ] \
	&& [ -e $VPAD_MD5 ] && [ -e $VPAD_BOOT_MD5 ] && [ -e $DAVINCI_HRT_DRIVER_MD5 ] \
	&& [ -e $DAVINCI_RSZ_DRIVER_MD5 ] && [ -e $DSP_LINK_256_MD5 ] && [ -e $IPVP_MKIT_DSP_256_MD5 ] \
	&& [ -e $CMEM_MD5 ] && [ -e $LOADMODULES_MD5 ] && [ -e $USBINIT_NEW ] && [ -e $USBINIT_MD5 ] \
	&& [ -e $EPCONFIG_NEW ] && [ -e $EPCONFIG_MD5 ] && [ -e /proc/board_memsize_256 ]
then
	echo "files found"

	SUM=$(md5sum $VPAD_NEW)
	DIGEST=$(cat $VPAD_MD5)
	echo $SUM
	echo $DIGEST

	SUM1=$(md5sum $DAVINCI_HRT_DRIVER_CODEC_NEW)
	DIGEST1=$(cat $DAVINCI_HRT_DRIVER_MD5)
	echo $SUM1
	echo $DIGEST1

	SUM2=$(md5sum $DAVINCI_RSZ_DRIVER_CODEC_NEW)
	DIGEST2=$(cat $DAVINCI_RSZ_DRIVER_MD5)
	echo $SUM2
	echo $DIGEST2

	SUM4=$(md5sum $DSP_LINK_CODEC_256_NEW)
	DIGEST4=$(cat $DSP_LINK_256_MD5)
	echo $SUM4
	echo $DIGEST4

	SUM6=$(md5sum $IPVP_MKIT_DSP_CODEC_256_NEW)
	DIGEST6=$(cat $IPVP_MKIT_DSP_256_MD5)
	echo $SUM6
	echo $DIGEST6

	SUM7=$(md5sum $CMEM_CODEC_NEW)
	DIGEST7=$(cat $CMEM_MD5)
	echo $SUM7
	echo $DIGEST7

	SUM8=$(md5sum $LOADMODULES_NEW)
	DIGEST8=$(cat $LOADMODULES_MD5)
	echo $SUM8
	echo $DIGEST8

	SUM9=$(md5sum $VPAD_BOOT_NEW)
	DIGEST9=$(cat $VPAD_BOOT_MD5)
	echo $SUM9
	echo $DIGEST9

	SUM10=$(md5sum $KERNEL_NEW)
	DIGEST10=$(cat $KERNEL_MD5)
	echo $SUM10
	echo $DIGEST10

	SUM11=$(md5sum $KERNEL_UP_NEW)
	DIGEST11=$(cat $KERNEL_UP_MD5)
	echo $SUM11
	echo $DIGEST11

	SUM12=$(md5sum $USBINIT_NEW)
	DIGEST12=$(cat $USBINIT_MD5)
	echo $SUM12
	echo $DIGEST12

	SUM13=$(md5sum $EPCONFIG_NEW)
	DIGEST13=$(cat $EPCONFIG_MD5)
	echo $SUM13
	echo $DIGEST13
        
	echo "Start checksum comparison to digest"

	if [ "$SUM" != "$DIGEST" ] || [ "$SUM1" != "$DIGEST1" ] || [ "$SUM2" != "$DIGEST2" ] \
		|| [ "$SUM4" != "$DIGEST4" ] || [ "$SUM6" != "$DIGEST6" ] || [ "$SUM7" != "$DIGEST7" ] \
		|| [ "$SUM8" != "$DIGEST8" ] || [ "$SUM9" != "$DIGEST9" ] || [ "$SUM10" != "$DIGEST10" ] \
		|| [ "$SUM11" != "$DIGEST11" ] || [ "$SUM12" != "$DIGEST12" ] || [ "$SUM13" != "$DIGEST13" ]
	then 
		echo "at least one checksum doesn't match its digest: deleting all new files"
		rmfiles
		echo "$curdate: One or more checksum doesn't match digest: abort upgrade" >> vpad.log

		exit 2
	fi

	mv -f $KERNEL_UP_NEW $KERNEL_UP 2>> vpad.log
	if [ $? -eq 0 ]
	then

		./$KERNEL_UP $KERNEL_NEW 2>> vpad.log
		if [ $? -eq 0 ]
		then
			echo "KERNEL UPGRADE WORKED"
			rm -f $KERNEL_NEW
			rm -f /Release/ker_ver
			echo "$curdate: $KERNEL_NEW success. Replace all codecs with new ones" >> vpad.log
	
			mv -f $DAVINCI_HRT_DRIVER_CODEC_NEW $DAVINCI_HRT_DRIVER_CODEC              
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $DAVINCI_HRT_DRIVER_CODEC_NEW $DAVINCI_RSZ_DRIVER_CODEC" >> vpad.log
			fi
			mv -f $DAVINCI_RSZ_DRIVER_CODEC_NEW $DAVINCI_RSZ_DRIVER_CODEC
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $DAVINCI_RSZ_DRIVER_CODEC_NEW $DAVINCI_RSZ_DRIVER_CODEC" >> vpad.log
			fi

			mv -f $DSP_LINK_CODEC_256_NEW $DSP_LINK_CODEC_256
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $DSP_LINK_CODEC_256_NEW $DSP_LINK_CODEC_256" >> vpad.log
				rm -f $DSP_LINK_CODEC
				ln -s $DSP_LINK_CODEC_256 $DSP_LINK_CODEC
				echo "$curdate: executed ln -s $DSP_LINK_CODEC_256 $DSP_LINK_CODEC" >> vpad.log
			fi
			mv -f $IPVP_MKIT_DSP_CODEC_256_NEW $IPVP_MKIT_DSP_CODEC_256
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $IPVP_MKIT_DSP_CODEC_256_NEW $IPVP_MKIT_DSP_CODEC_256" >> vpad.log
				rm -f $IPVP_MKIT_DSP_CODEC
				ln -s $IPVP_MKIT_DSP_CODEC_256 $IPVP_MKIT_DSP_CODEC
				echo "$curdate: executed ln -s $IPVP_MKIT_DSP_CODEC_256 $IPVP_MKIT_DSP_CODEC" >> vpad.log
			fi

			if [ -e /Release/bootenv_up ]
			then
				if [ -e /Release/change_memsize_213M ]
				then
					echo '$curdate: Already changed memsize' >> vpad.log
				else
					chmod u+x /Release/bootenv_up
					/Release/bootenv_up memsize=213M 2> vpad.log
					echo 'memsize : 213M' >> change_memsize_213M
					if [ -e /Release/change_memsize_88M ]
					then
						rm /Release/change_memsize_88M
						echo "$curdate: rm change_memsize_88M" >> vpad.log
					fi
				fi
			fi
					
			if [ -e $DSP_LINK_CODEC_128 ]
			then
				rm $DSP_LINK_CODEC_128
				echo "$curdate: rm $DSP_LINK_CODEC_128" >> vpad.log
			fi

			if [ -e $IPVP_MKIT_DSP_CODEC_128 ]
			then
				rm $IPVP_MKIT_DSP_CODEC_128
				echo "$curdate: rm $IPVP_MKIT_DSP_CODEC_128" >> vpad.log
			fi

			mv -f $CMEM_CODEC_NEW $CMEM_CODEC
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $CMEM_CODEC_NEW $CMEM_CODEC" >> vpad.log
			fi
			mv -f $LOADMODULES_NEW $LOADMODULES
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $LOADMODULES_NEW $LOADMODULES" >> vpad.log
			fi

			mv -f $EPCONFIG_NEW $EPCONFIG
			if [ $? -eq 0 ]
			then
			        echo "$curdate: mv $EPCONFIG_NEW $EPCONFIG" >> vpad.log
			fi
	
			mv -f $VPAD_BOOT_NEW /root/$VPAD_BOOT
			if [ $? -eq 0 ]
			then	
				echo "$curdate: mv $VPAD_BOOT_NEW $VPAD_BOOT" >> vpad.log
			fi
	
	                mv -f $USBINIT_NEW /etc/init.d/$USBINIT
	                if [ $? -eq 0 ]
	                then
	                echo "$curdate: mv $USBINIT_NEW /etc/init.d/$USBINIT" >> vpad.log
			fi
	
			rm $POINTERCAL

			rm $KERNEL_MD5
			rm $VPAD_BOOT_MD5
			rm $DAVINCI_HRT_DRIVER_MD5           
			rm $DAVINCI_RSZ_DRIVER_MD5                
			rm $DSP_LINK_256_MD5               
			rm $IPVP_MKIT_DSP_256_MD5               
			rm $CMEM_MD5
			rm $LOADMODULES_MD5
			rm $EPCONFIG_MD5
			rm $USBINIT_MD5
			rm $KERNEL_UP_MD5
			rm *.tar*
	
			rm /Release/cfg/*
	
			echo "$curdate: rm $POINTERCAL" >> vpad.log
			echo "$curdate: rm $KERNEL_MD5" >> vpad.log
			echo "$curdate: rm $KERNEL_MD5" >> vpad.log
			echo "$curdate: rm $VPAD_BOOT_MD5" >> vpad.log
			echo "$curdate: rm $DAVINCI_HRT_DRIVER_MD5" >> vpad.log
			echo "$curdate: rm $DAVINCI_RSZ_DRIVER_MD5" >> vpad.log
			echo "$curdate: rm $DSP_LINK_256_MD5"  >> vpad.log
			echo "$curdate: rm $IPVP_MKIT_DSP_256_MD5" >> vpad.log
			echo "$curdate: rm $CMEM_MD5" >> vpad.log
			echo "$curdate: rm $LOADMODULES_MD5" >> vpad.log
			echo "$curdate: rm $EPCONFIG_MD5" >> vpad.log
			echo "$curdate: rm $USBINIT_MD5" >> vpad.log
			echo "$curdate: rm $KERNEL_UP_MD5" >> vpad.log
			echo "$curdate: rm *.tar*" >> vpad.log
		else
			echo "$curdate: $KERNEL_NEW failed to install" >> vpad.log
			echo "$curdate: removing all new files and restore to previous state" >> vpad.log
		
			rmfiles	
			exit 2
		fi
	else
		echo "new kernel_up failed to replace old kernel_up" >> vpad.log
		rmfiles
	fi

else
	echo "some files not found or board is not 256MB size" >> vpad.log
	rmfiles
fi
			
chmod 666 /etc/init.d/networking
if [ ! -d /mnt/mmc ]
then
	mkdir /mnt/mmc
fi

sync
sync
sync
