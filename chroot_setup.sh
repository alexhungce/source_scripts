#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( impish jammy )

SOURCE_DIRECTORY=src

[ -e $SOURCE_DIRECTORY ] || mkdir $SOURCE_DIRECTORY
cd $SOURCE_DIRECTORY

# download kteam-tools
git clone git://kernel.ubuntu.com/ubuntu/kteam-tools.git
cd kteam-tools/chroot-setup
sudo mkdir -p /usr3/chroots

# ubuntu flavours
for i in "${UBUNTU[@]}"
do
	sudo ./make_chroot $i amd64
done

sudo usermod -aG sbuild $USER
echo ""
echo "== username added to the sbuild in \"/etc/group\". Please reboot =="
