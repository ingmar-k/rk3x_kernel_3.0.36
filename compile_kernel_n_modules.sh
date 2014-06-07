#!/bin/bash

echo -e "Now trying to compile the kernel 'zImage'.\n"

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j5 zImage
if [ "$?" = "0" ]
then
	echo -e "\nSuccessfully created the kernel zImage!\n"
	ls -alh arch/arm/boot/zImage
	sleep 3
else
	echo -e "Something went WRONG (zImage)! Exiting now."
	exit 1
fi

echo -e "\nCompiling the corresponding kernel modules now'.\n"

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j5 modules
if [ "$?" = "0" ]
then
	echo -e "\nSuccessfully compled the kernel modules!\n"
else
	echo -e "Something went WRONG (modules)! Exiting now."
	exit 2
fi

echo -e "\nDONE!!!\n"

exit 0
