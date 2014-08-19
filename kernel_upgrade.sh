#!/bin/sh

NEW_KERNEL=new_kernel

if [ -e $NEW_KERNEL ]
then
	echo "file $NEW_KERNEL found"
	./kernel_up $NEW_KERNEL
	if [ $? -eq 0 ]
	then
		echo "Kernel upgrade worked!!"
		rm $NEW_KERNEL
	else
		rm $NEW_KERNEL
	fi
fi

