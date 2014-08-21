#!/bin/sh

DAVINCI_HRT_DRIVER_CODEC=davinci_HRT_driver.ko
DAVINCI_HRT_DRIVER_CODEC_NEW=new_davinci_HRT_driver.ko
DAVINCI_HRT_DRIVER_MD5=chksum_davinci_HRT_driver.ko

DAVINCI_RSZ_DRIVER_CODEC=davinci_rsz_driver.ko
DAVINCI_RSZ_DRIVER_CODEC_NEW=new_davinci_rsz_driver.ko
DAVINCI_RSZ_DRIVER_MD5=chksum_davinci_rsz_driver.ko

DSP_LINK_CODEC_128=dsplinkk_128.ko
DSP_LINK_CODEC_128_NEW=new_dsplinkk_128.ko
DSP_LINK_128_MD5=chksum_dsplinkk_128.ko

DSP_LINK_CODEC_256=dsplinkk_256.ko
DSP_LINK_CODEC_256_NEW=new_dsplinkk_256.ko
DSP_LINK_256_MD5=chksum_dsplinkk_256.ko

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

curdate=`date`


if [ -e $DAVINCI_HRT_DRIVER_CODEC_NEW -a -e $DAVINCI_RSZ_DRIVER_CODEC_NEW -a -e $DSP_LINK_CODEC_128_NEW -a -e $DSP_LINK_CODEC_256_NEW -a -e $IPVP_MKIT_DSP_CODEC_128_NEW -a -e $IPVP_MKIT_DSP_CODEC_256_NEW -a -e $CMEM_CODEC_NEW -a -e $LOADMODULES_NEW ]
then
	if [ ! -e revision.txt ]
	then
		echo "revision file missing" > revision.txt
	fi
	echo >> nick.log
	echo "====================================================================" >> nick.log
	echo "revision: $(cat revision.txt)" >> nick.log
	echo "date: $curdate" >> nick.log
	echo "====================================================================" >> nick.log
	echo >> nick.log
	echo "New codec files found"

	if [ ! -e $DAVINCI_HRT_DRIVER_MD5 -o ! -e $DAVINCI_RSZ_DRIVER_MD5 -o ! -e $DSP_LINK_128_MD5 -o ! -e $DSP_LINK_256_MD5 -o ! -e $IPVP_MKIT_DSP_128_MD5 -o -e $IPVP_MKIT_DSP_256_MD5 -o ! -e $CMEM_MD5 -o ! -e $LOADMODULES_MD5 ]
	then
		echo "Codec checksum file(s) missing: remove new codecs and abort codec upgrade"
		rm $DAVINCI_HRT_DRIVER_CODEC_NEW
		rm $DAVINCI_RSZ_DRIVER_CODEC_NEW
		rm $DSP_LINK_CODEC_128_NEW
		rm $DSP_LINK_CODEC_256_NEW
		rm $IPVP_MKIT_DSP_CODEC_128_NEW
		rm $IPVP_MKIT_DSP_CODEC_256_NEW
		rm $CMEM_CODEC_NEW
		rm $LOADMODULES_NEW
		rm $DAVINCI_HRT_DRIVER_MD5
		rm $DAVINCI_RSZ_DRIVER_MD5		
		rm $DSP_LINK_128_MD5		
		rm $DSP_LINK_256_MD5		
		rm $IPVP_MKIT_DSP_128_MD5		
		rm $IPVP_MKIT_DSP_256_MD5		
		rm $CMEM_MD5
		rm $LOADMODULES_MD5

		echo "$curdate: Codec checksum file(s) missing: remove new codecs and abort codec upgrade" >> nick.log

		exit
	fi


	echo "Start checksum comparisons to digest"

	SUM1=$(md5sum $DAVINCI_HRT_DRIVER_CODEC_NEW)
	DIGEST1=$(cat $DAVINCI_HRT_DRIVER_MD5)
	echo $SUM1
	echo $DIGEST1

	SUM2=$(md5sum $DAVINCI_RSZ_DRIVER_CODEC_NEW)
	DIGEST2=$(cat $DAVINCI_RSZ_DRIVER_MD5)
	echo $SUM2
	echo $DIGEST2

	SUM3=$(md5sum $DSP_LINK_CODEC_128_NEW)
	DIGEST3=$(cat $DSP_LINK_128_MD5)
	echo $SUM3
	echo $DIGEST3

	SUM4=$(md5sum $DSP_LINK_CODEC_256_NEW)
	DIGEST4=$(cat $DSP_LINK_256_MD5)
	echo $SUM4
	echo $DIGEST4

	SUM5=$(md5sum $IPVP_MKIT_DSP_CODEC_128_NEW)
	DIGEST5=$(cat $IPVP_MKIT_DSP_128_MD5)
	echo $SUM5
	echo $DIGEST5

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

	if [ "$SUM1" != "$DIGEST1" -o "$SUM2" != "$DIGEST2" -o "$SUM3" != "$DIGEST3" -o "$SUM4" != "$DIGEST4" -o "$SUM5" != "$DIGEST5" -o "$SUM6" != "$DIGEST6" -o "$SUM7" != "$DIGEST7" -o "$SUM8" != "$DIGEST8" ] 
	then 
		echo "One checksum doesn't match digest: abort codec upgrade"
                rm $DAVINCI_HRT_DRIVER_CODEC_NEW
                rm $DAVINCI_RSZ_DRIVER_CODEC_NEW
                rm $DSP_LINK_CODEC_128_NEW
                rm $DSP_LINK_CODEC_256_NEW
                rm $IPVP_MKIT_DSP_CODEC_128_NEW
                rm $IPVP_MKIT_DSP_CODEC_256_NEW
                rm $CMEM_CODEC_NEW
                rm $LOADMODULES_NEW
                rm $DAVINCI_HRT_DRIVER_MD5
                rm $DAVINCI_RSZ_DRIVER_MD5
                rm $DSP_LINK_128_MD5
                rm $DSP_LINK_256_MD5
                rm $IPVP_MKIT_DSP_128_MD5
                rm $IPVP_MKIT_DSP_256_MD5
                rm $CMEM_MD5
                rm $LOADMODULES_MD5
		echo "$curdate: One checksum doesn't match digest: abort codec upgrade" >> nick.log
	else
		echo "Checksums ok: replace all codecs with new ones"
		mv $DAVINCI_HRT_DRIVER_CODEC_NEW $DAVINCI_HRT_DRIVER_CODEC		
		mv $DAVINCI_RSZ_DRIVER_CODEC_NEW $DAVINCI_RSZ_DRIVER_CODEC
		mv $DSP_LINK_CODEC_128_NEW $DSP_LINK_CODEC_128 $DSP_LINK_CODEC_256_NEW $DSP_LINK_CODEC_256
		mv $IPVP_MKIT_DSP_CODEC_128_NEW $IPVP_MKIT_DSP_CODEC_128 $IPVP_MKIT_DSP_CODEC_256_NEW $IPVP_MKIT_DSP_CODEC_256
		mv $CMEM_CODEC_NEW $CMEM_CODEC
		mv $LOADMODULES_NEW $LOADMODULES
		rm $DAVINCI_HRT_DRIVER_MD5           
                rm $DAVINCI_RSZ_DRIVER_MD5                
                rm $DSP_LINK_MD5               
                rm $IPVP_MKIT_DSP_MD5               
                rm $CMEM_MD5
                rm $LOADMODULES_MD5

		echo "$curdate: Checksums ok: replace all codecs with new ones" >> nick.log
		echo "$curdate:	mv $DAVINCI_RSZ_DRIVER_CODEC_NEW $DAVINCI_RSZ_DRIVER_CODEC" >> nick.log
		echo "$curdate:	mv $DSP_LINK_CODEC_128_NEW $DSP_LINK_CODEC_128" >> nick.log
		echo "$curdate:	mv $DSP_LINK_CODEC_256_NEW $DSP_LINK_CODEC_256" >> nick.log
		echo "$curdate:	mv $IPVP_MKIT_DSP_CODEC_128_NEW $IPVP_MKIT_DSP_CODEC_128" >> nick.log
		echo "$curdate:	mv $IPVP_MKIT_DSP_CODEC_256_NEW $IPVP_MKIT_DSP_CODEC_256" >> nick.log
		echo "$curdate:	mv $CMEM_CODEC_NEW $CMEM_CODEC" >> nick.log
		echo "$curdate:	mv $LOADMODULES_NEW $LOADMODULES" >> nick.log
		echo "$curdate:	rm $DAVINCI_HRT_DRIVER_MD5" >> nick.log
		echo "$curdate: rm $DAVINCI_RSZ_DRIVER_MD5" >> nick.log
		echo "$curdate: rm $DSP_LINK_128_MD5"  >> nick.log
		echo "$curdate: rm $DSP_LINK_256_MD5"  >> nick.log
		echo "$curdate: rm $IPVP_MKIT_DSP_128_MD5" >> nick.log
		echo "$curdate: rm $IPVP_MKIT_DSP_256_MD5" >> nick.log
		echo "$curdate: rm $CMEM_MD5" >> nick.log
		echo "$curdate: rm $LOADMODULES_MD5" >> nick.log
	fi
fi

rm -f /Release/cfg/se_params.txt
rm -f /Release/cfg/init_params.txt

