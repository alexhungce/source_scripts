#!/bin/sh

DATE=`date +%F`
git pull >> pull_history.${DATE}

# acpi
cat pull_history.${DATE} | grep 'drivers\/acpi' >> filter_history.${DATE}
cat pull_history.${DATE} | grep 'drivers\/platform\/x86\/' | grep -E 'asus|hp|dell|intel|thinkpad' >> filter_history.${DATE}
cat pull_history.${DATE} | grep 'drivers\/input\/misc\/soc_button_array.c' >> filter_history.${DATE}

# efi
cat pull_history.${DATE} | grep 'efi\.[ch]' >> filter_history.${DATE}

# input events
cat pull_history.${DATE} | grep 'input-event-codes.h' >> filter_history.${DATE}

# Documentation
cat pull_history.${DATE} | grep 'kernel-parameters.txt' >> filter_history.${DATE}

vi filter_history.${DATE}
