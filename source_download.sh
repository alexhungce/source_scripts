#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( xenial yakkety )
readonly GITHUB_REPO=( fwdt uefi_plugfest system_scripts script-fwts lfdk1 )

# assign default directories if there aren't any
SOURCE_DIRECTORY=${1:-'src'}
KERNEL_DIRECTORY=${2:-'kernel'}

cd $HOME
[ -e $SOURCE_DIRECTORY ] || mkdir $SOURCE_DIRECTORY
cd $SOURCE_DIRECTORY

# fwts
git clone git://kernel.ubuntu.com/hwe/fwts.git 

# source on github
for i in "${GITHUB_REPO[@]}"
do
	git clone https://github.com/alexhungce/$i
done

# kernel source
[ -e $KERNEL_DIRECTORY ] || mkdir $KERNEL_DIRECTORY
cd $KERNEL_DIRECTORY

# mainline
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# ubuntu
for i in "${UBUNTU[@]}"
do
	git clone git://kernel.ubuntu.com/ubuntu/ubuntu-$i.git
done

