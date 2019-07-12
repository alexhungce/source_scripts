#!/bin/bash
shopt -s -o nounset

DATE=`date +%F`

readonly DRIVERS=( drivers/acpi
		   drivers/platform/x86/dell*
		   drivers/platform/x86/hp*
		   drivers/platform/x86/intel*
		   drivers/platform/x86/thinkpad_acpi.c
		   drivers/input/misc/soc_button_array.c
		   *suspend.*
		   *efi.*
		   include/uapi/linux/input-event-codes.h
		   Documentation/admin-guide/kernel-parameters.txt
		   drivers/firmware/dmi_scan.c
		   drivers/pci/quirks.c
		 )

CUR_TAG=$(git describe --tag)
git pull >> pull_history.${DATE}
NEW_TAG=$(git describe --tag)

for i in "${DRIVERS[@]}"
do
	git show $CUR_TAG..$NEW_TAG -- $i >> filter_history.${DATE}
done

vi filter_history.${DATE}
