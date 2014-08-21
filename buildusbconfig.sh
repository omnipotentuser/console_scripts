#!/bin/bash


CONFIG=""
VALUE=""

counter=0
for x in `grep "table.insert" nick/foo/src/hack.cpp | cut -d "\"" -f 2`
do
	if [ "$x" != "--BEGIN--" ] && [ "$x" != "--END--" ]
	then
		CONFIG[$counter]=$x
		#echo counter $counter
		#echo ${CONFIG[$counter]}
		counter=`expr $counter + 1`
	fi
done
grep VDEF_CONFIG nick/foo/src/model/ACIFHandlerDefaults.h | cut -d \" -f 2 > tmpconfigfile.tmp
lines=`grep VDEF_CONFIG nick/foo/src/model/ACIFHandlerDefaults.h | cut -d \" -f 2 | wc -l`
for ((counter = 0, pos = 1; counter < $lines; counter += 1, pos += 1))
do
	VALUE[$counter]=`sed -n "$pos"p tmpconfigfile.tmp`
	#echo ${VALUE[$counter]}
done
#for x in `grep VDEF_CONFIG nick/foo/src/model/ACIFHandlerDefaults.h | cut -d \" -f 2`
#do
	#VALUE[$counter]="$x"
	#echo ${VALUE[$counter]}
	#counter=`expr $counter + 1`
	#echo $counter
#done
#echo "Erasing FW/config.xml"
rm FW/config.xml
#echo "press return to proceed"
#read
content()
{
	clear
	tput setf 6
	tput cup 9; echo "**********************************************************"
	tput cup 10 5; echo "Current list of configurations:"
	tput cup 12; echo "Selection )"
	for ((x = 0; x < ${#CONFIG[*]}; x += 1))
	do
		tput cup `expr $x + 13` 8; echo "$x ) ${CONFIG[$x]} = ${VALUE[$x]}"
	done
	tput cup `expr $x + 13`; echo "**********************************************************"
	echo
	echo
	tput setf 7
}

menu()
{
	content

	CHOICE="empty"
	echo -n "Enter your selection to edit or hit return for no changes: "
	read CHOICE
	echo
	until [ -z "$CHOICE" ]
	do
		if [ "$CHOICE" -ge 0 ] && [ "$CHOICE" -lt ${#CONFIG[*]} ] 
		then
			echo "selected config ${CONFIG[$CHOICE]}"
			echo -n "What value do you wish to attribute to this configuration? "
			read TMPVALUE
			VALUE[$CHOICE]=$TMPVALUE
		else
			echo "Entered an illegal choice. Aborting."
			exit
		fi
		echo -n "Update another configuration to edit or hit return to continue? [y/n]: "
		read DOAGAIN
		if [ -z "$DOAGAIN" ] || [ "$DOAGAIN" == "n" ]
		then
			break 
		fi
		echo 
		content
		echo -n "Enter your configuration to edit: "
		read CHOICE
	done
}

menu

for ((x = 0; x < ${#CONFIG[*]}; x += 1))
do
	echo "<${CONFIG[$x]}>${VALUE[$x]}</${CONFIG[$x]}>" >> FW/config.xml
done
echo "----" >> FW/config.xml

cat FW/config.xml
echo 
echo -n "Does the file look ok? [y/n] "
read VERIFY
if [ $VERIFY == "y" ]
then
	openssl dgst -md5 -sign FW/hack.pem FW/config.xml | openssl enc -base64 -out FW/config.xml.sig
	#openssl dgst -md5 -hex -sign FW/hack.pem -out FW/config.xml.sig FW/config.xml
	cat FW/config.xml.sig >> FW/config.xml
else
	echo "Aborting generating config file."
	rm FW/config.xml
	exit
fi


echo
echo
echo Done creating config file.
echo Copy FW/config.xml to your /mnt/usb directory after mounting USB.
echo
echo Please test the config file on your foo before distributing.
echo
