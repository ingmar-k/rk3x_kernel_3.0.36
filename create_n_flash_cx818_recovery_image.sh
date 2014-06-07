#!/bin/bash

if [ -f arch/arm/boot/zImage ]
then
	echo -e "\nzImage found.\n"
	ls -alh arch/arm/boot/zImage
	echo -e "\nNow creating a new recovery image.\n"
	if [ -f  ../cx818_recovery.img ]
	then
		echo -e "\nOld recovery image found.\nRemoving it first.\n"
		rm ../cx818_recovery.img
	fi
	if [ -f ../initramfs/fakeramdisk.gz ]
	then
		../rockchip-mkbootimg/mkbootimg --kernel arch/arm/boot/zImage --ramdisk ../initramfs/fakeramdisk.gz --base 60000000 -o ../cx818_recovery.img
		if [ "$?" = "0" ]
		then
			echo -e "\nNew reovery image successfully created!\n"
			ls -alh ../cx818_recovery.img
		else
			echo -e "\nSomething went wrong! Exiting now."
			exit 3
		fi
		found="0"
		echo -e "\nNow waiting for the RK3066 device to become available in recovery mode.\nPlease plug it in now, while pressing the recovery button!\n"
		while [ ! "${found}" = "1" ]
		do
			lsusb |grep 'ID 2207:300a'
			if [ "$?" = "0" ]
			then
				found="1"
				../rkflashtool/rkflashtool r 0x0 0x1 | head -n 11
			else
				sleep 5
			fi
		done
		echo -e "\nRK3066 device found!\nNow trying to flash the recovery image, via the command\n'../rkflashtool/rkflashtool w 0x00010000 0x00008000 < ../cx818_recovery.img'\n.\n\nDO NOT UNPLUG THE DEVICE NOW!!!!!!!!!!!!!!!!!!"
		sleep 5
		echo "Flashing now!"
		sleep 3
		../rkflashtool/rkflashtool w 0x00010000 0x00008000 < ../cx818_recovery.img
		if [ "$?" = "0" ]
		then
			echo -e "\nImage successfully flashed! Now rebooting the device.\n"
		else
			echo -e "\nSomething went wrong! Exiting now."
			exit 4
		fi
		sleep 3
		../rkflashtool/rkflashtool b && echo -e "\nDONE!!!\n"
	else
		exit 2
	fi
else
	exit 1
fi

exit 0
