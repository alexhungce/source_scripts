#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( xenial bionic cosmic )
readonly GITHUB_REPO=( fwdt system_scripts script-fwts lfdk1 )

# assign default directories if there aren't any
SOURCE_DIRECTORY=${1:-'src'}
KERNEL_DIRECTORY=${2:-'kernel'}

cd $HOME
[ -e $SOURCE_DIRECTORY ] || mkdir $SOURCE_DIRECTORY
cd $SOURCE_DIRECTORY

# fwts
[ -e fwts ] || git clone git://kernel.ubuntu.com/hwe/fwts.git

# patchwork - pwclient
[ -e patchwork ] || git clone git://github.com/getpatchwork/patchwork

# source on github
for i in "${GITHUB_REPO[@]}"
do
	[ -e $i ] || git clone https://github.com/alexhungce/$i
done

# kernel source
[ -e $KERNEL_DIRECTORY ] || mkdir $KERNEL_DIRECTORY
cd $KERNEL_DIRECTORY

[ -e linux ] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux

for i in "${UBUNTU[@]}"
do
	[ -e ubuntu-$i ] || git clone git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/$i ubuntu-$i
done

if [ ! -e oem-bionic ] ; then
	if [ -d ubuntu-bionic ] ; then
		cp -r ubuntu-bionic oem-bionic
	else
		git clone git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/bionic oem-bionic
	fi
	pushd .
	cd oem-bionic
	git remote add oem git://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/bionic
	git fetch --all && git reset --hard oem/oem
	popd

fi

# install required package for lfdk
sudo apt -y install libncurses5-dev

#install required libraries for fwts
sudo apt -y build-dep fwts

#install required packages for linux kernel
sudo apt -y install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache
