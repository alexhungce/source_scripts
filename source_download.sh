#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( focal hirsute )
readonly GITHUB_REPO=( fwdt system_scripts script-fwts lfdk1 hwe_daily debug_scripts )

# assign default directories if there aren't any
SOURCE_DIRECTORY=${1:-'src'}
KERNEL_DIRECTORY=${2:-'kernel'}

cd $HOME
[ -e $SOURCE_DIRECTORY ] || mkdir $SOURCE_DIRECTORY
cd $SOURCE_DIRECTORY

# fwts
[ -e fwts ] || git clone git://kernel.ubuntu.com/hwe/fwts.git

# acpica
[ -e acpica ] || git clone git://github.com/acpica/acpica

# patchwork - pwclient
[ -e patchwork ] || git clone git://github.com/getpatchwork/patchwork

# source on github
for i in "${GITHUB_REPO[@]}"
do
	[ -e $i ] || git clone https://github.com/alexhungce/$i.git
done

# kernel source
[ -e $KERNEL_DIRECTORY ] || mkdir $KERNEL_DIRECTORY
cd $KERNEL_DIRECTORY

[ -e linux ] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux

for i in "${UBUNTU[@]}"
do
	[ -e ubuntu-$i ] || git clone git://kernel.ubuntu.com/ubuntu/ubuntu-$i.git
done

# OEM-5.10
if [ ! -e oem-5.10 ] ; then
	if [ -d ubuntu-focal ] ; then
		cp -r ubuntu-focal oem-5.10
	else
		git clone git://kernel.ubuntu.com/ubuntu/ubuntu-focal.git oem-5.10
	fi
	pushd .
	cd oem-5.10
	git remote add oem https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/
	git fetch --all && git reset --hard oem/oem-5.10-next
	popd
fi

# install required package for lfdk
sudo apt -y install libncurses5-dev

#install required libraries for fwts
sudo apt -y build-dep fwts

#install required libraries for bios-requirement
sudo apt -y install fop gawk qpdf python3-lxml

#install required packages for linux kernel
sudo apt -y install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache
