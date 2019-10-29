#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( bionic focal )
readonly GITHUB_REPO=( fwdt system_scripts script-fwts lfdk1 hwe_daily )

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

if [ ! -e oem-bionic ] ; then
	if [ -d ubuntu-bionic ] ; then
		cp -r ubuntu-bionic oem-bionic
	else
		git clone git://kernel.ubuntu.com/ubuntu/ubuntu-bionic.git oem-bionic
	fi
	pushd .
	cd oem-bionic
	git remote add oem git://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/bionic
	git fetch --all && git reset --hard oem/oem
	popd
fi

# OEM SP1
if [ ! -e oem-bionic-sp1 ] ; then
	if [ -d ubuntu-bionic ] ; then
		cp -r ubuntu-bionic oem-bionic-sp1
	else
		git clone git://kernel.ubuntu.com/ubuntu/ubuntu-bionic.git oem-bionic-sp1
	fi
	pushd .
	cd oem-bionic-sp1
	git remote add oem git://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem-osp1/+git/bionic
	git fetch --all && git reset --hard oem/oem
	popd
fi

# install required package for lfdk
sudo apt -y install libncurses5-dev

#install required libraries for fwts
sudo apt -y build-dep fwts

#install required libraries for bios-requirement
sudo apt -y install fop gawk

#install required packages for linux kernel
sudo apt -y install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache
