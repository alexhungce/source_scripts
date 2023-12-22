#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( jammy noble )
readonly GITHUB_REPO=( fwdt system_scripts script-fwts lfdk1 hwe_daily debug_scripts )

# assign default directories if there aren't any
SOURCE_DIRECTORY=${1:-'src'}
KERNEL_DIRECTORY=${2:-'kernel'}

cd $HOME
[ -e $SOURCE_DIRECTORY ] || mkdir $SOURCE_DIRECTORY
cd $SOURCE_DIRECTORY

# fwts
[ -e fwts ] || git clone https://git.launchpad.net/~firmware-testing-team/fwts/+git/fwts

# acpica
[ -e acpica ] || git clone git://github.com/acpica/acpica

# igt-gpu-tools
[ -e igt-gpu-tools ] || git clone git@gitlab.freedesktop.org:drm/igt-gpu-tools.git

# patchwork - pwclient
[ -e patchwork ] || git clone git://github.com/getpatchwork/patchwork

# source on github
for i in "${GITHUB_REPO[@]}"
do
	[ -e $i ] || git clone git://github.com/alexhungce/$i.git
done

# kernel source
[ -e $KERNEL_DIRECTORY ] || mkdir $KERNEL_DIRECTORY
cd $KERNEL_DIRECTORY

[ -e linux ] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux
[ -e linux-stable ] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-stable
[ -e amdgpu ] || git clone https://gitlab.freedesktop.org/agd5f/linux.git amdgpu

for i in "${UBUNTU[@]}"
do
	[ -e ubuntu-$i ] || git clone git://kernel.ubuntu.com/ubuntu/ubuntu-$i.git
	[ -e ubuntu-$i ] || git clone git clone https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/$i ubuntu-$i
done

# install required package for lfdk
sudo apt -y install libncurses5-dev

#install required libraries for fwts
sudo apt -y build-dep fwts

#install required libraries for bios-requirement
sudo apt -y install fop gawk qpdf python3-lxml

#install required packages for linux kernel
sudo apt -y install git build-essential fakeroot libncurses5-dev libssl-dev ccache
