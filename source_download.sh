#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( )
readonly GITHUB_REPO=( scripts system_scripts )

# assign default directories if there aren't any
SOURCE_DIRECTORY=${1:-'src'}
KERNEL_DIRECTORY=${2:-'kernel'}
PERSONAL_DIRECTORY='personal'

cd $HOME
[ -e $SOURCE_DIRECTORY ] || mkdir $SOURCE_DIRECTORY
cd $SOURCE_DIRECTORY

# fwts
[ -e fwts ] || git clone https://github.com/fwts/fwts.git

# acpica
[ -e acpica ] || git clone https://github.com/acpica/acpica

# patchwork - pwclient
[ -e patchwork ] || git clone https://github.com/getpatchwork/patchwork

# gpu-related sources
[ -e drm-tests ] || git clone https://chromium.googlesource.com/chromiumos/platform/drm-tests
[ -e igt-gpu-tools ] || git clone git@gitlab.freedesktop.org:drm/igt-gpu-tools.git
[ -e gpuvis ] || git clone https://github.com/mikesart/gpuvis.git
[ -e VRRTest ] || git clone https://github.com/Nixola/VRRTest.git
[ -e libdrm ] || git clone https://gitlab.freedesktop.org/mesa/drm libdrm
[ -e mesa ] || git clone https://gitlab.freedesktop.org/mesa/mesa.git mesa

# source on github
pushd "$PERSONAL_DIRECTORY"
for i in "${GITHUB_REPO[@]}"
do
	[ -e $i ] || git clone https://github.com/alexhungce/$i.git
done
popd

# kernel source
[ -e $KERNEL_DIRECTORY ] || mkdir $KERNEL_DIRECTORY

pushd $KERNEL_DIRECTORY
[ -e linux ] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux
[ -e linux-stable ] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-stable
[ -e amdgpu ] || git clone git@gitlab.freedesktop.org:agd5f/linux.git amdgpu

for i in "${UBUNTU[@]}"
do
	[ -e ubuntu-$i ] || git clone https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/$i ubuntu-$i
done
popd
