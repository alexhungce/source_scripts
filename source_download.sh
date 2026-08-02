#!/bin/bash
set -euo pipefail

readonly UBUNTU=()
readonly GITHUB_REPO=(scripts system_scripts)

# optional sources flag (default: off)
DO_ALL=0

# --all: also clone optional sources (fwts, acpica, gpu-related)
#        skipped by default; must be passed to download them
while [[ $# -gt 0 ]]; do
	case "$1" in
		--all)    DO_ALL=1 ;;
		--) shift; break ;;
		-*) echo "Unknown option: $1" >&2; exit 1 ;;
		*) break ;;
	esac
	shift
done

# assign default directories if there aren't any
SOURCE_DIRECTORY=${1:-'src'}
KERNEL_DIRECTORY=${2:-'kernel'}
PERSONAL_DIRECTORY='personal'

cd "$HOME"
[[ -e "$SOURCE_DIRECTORY" ]] || mkdir "$SOURCE_DIRECTORY"
cd "$SOURCE_DIRECTORY"

# optional sources (all: fwts, acpica, gpu-related)
if [[ "$DO_ALL" -eq 1 ]]; then
	# fwts
	[[ -e fwts ]] || git clone https://github.com/fwts/fwts.git

	# acpica
	[[ -e acpica ]] || git clone https://github.com/acpica/acpica

	# gpu-related sources
	[[ -e drm-tests ]] || git clone https://chromium.googlesource.com/chromiumos/platform/drm-tests
	[[ -e igt-gpu-tools ]] || git clone git@gitlab.freedesktop.org:drm/igt-gpu-tools.git
	[[ -e gpuvis ]] || git clone https://github.com/mikesart/gpuvis.git
	[[ -e VRRTest ]] || git clone https://github.com/Nixola/VRRTest.git
	[[ -e libdrm ]] || git clone https://gitlab.freedesktop.org/mesa/drm libdrm
	[[ -e mesa ]] || git clone https://gitlab.freedesktop.org/mesa/mesa.git mesa
fi

# source on github
pushd "$PERSONAL_DIRECTORY"
for i in "${GITHUB_REPO[@]}"; do
	[[ -e "$i" ]] || git clone "https://github.com/alexhungce/$i.git"
done
popd

# kernel source
[[ -e "$KERNEL_DIRECTORY" ]] || mkdir "$KERNEL_DIRECTORY"

pushd "$KERNEL_DIRECTORY"
[[ -e linux ]] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux
[[ -e linux-stable ]] || git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-stable
[[ -e amdgpu ]] || git clone git@gitlab.freedesktop.org:agd5f/linux.git amdgpu

for i in "${UBUNTU[@]}"; do
	[[ -e "ubuntu-$i" ]] || git clone "https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/$i" "ubuntu-$i"
done
popd
