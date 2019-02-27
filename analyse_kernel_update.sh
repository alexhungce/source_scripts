#!/bin/sh

DATE=`date +%F`

CUR_TAG=$(git describe --tag)
git pull >> pull_history.${DATE}
NEW_TAG=$(git describe --tag)

# acpi
git show $CUR_TAG..$NEW_TAG -- drivers/acpi >> filter_history.${DATE}

# platform drivers
git show $CUR_TAG..$NEW_TAG -- drivers/platform/x86/dell* >> filter_history.${DATE}
git show $CUR_TAG..$NEW_TAG -- drivers/platform/x86/hp* >> filter_history.${DATE}
git show $CUR_TAG..$NEW_TAG -- drivers/platform/x86/intel* >> filter_history.${DATE}
git show $CUR_TAG..$NEW_TAG -- drivers/platform/x86/thinkpad_acpi.c >> filter_history.${DATE}
git show $CUR_TAG..$NEW_TAG -- drivers/input/misc/soc_button_array.c >> filter_history.${DATE}

# suspend
git show $CUR_TAG..$NEW_TAG -- *suspend.* >> filter_history.${DATE}

# efi
git show $CUR_TAG..$NEW_TAG -- *efi.* >> filter_history.${DATE}

# keymap
git show $CUR_TAG..$NEW_TAG -- include/uapi/linux/input-event-codes.h >> filter_history.${DATE}

# Documentation
git show $CUR_TAG..$NEW_TAG -- Documentation/admin-guide/kernel-parameters.txt >> filter_history.${DATE}

vi filter_history.${DATE}
