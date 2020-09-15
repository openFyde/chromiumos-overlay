# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# A DLC package for distributing termina.

EAPI=7

inherit dlc cros-workon

# This ebuild is upreved via PuPR, so disable the normal uprev process for
# cros-workon ebuilds.
CROS_WORKON_BLACKLIST="1"

DESCRIPTION="DLC package for termina."

if [[ ${PV} == 9999 ]]; then
	SRC_URI=""
else
	SRC_URI="
		amd64? ( gs://termina-component-testing/uprev-test/amd64/${PV}/guest-vm-base.tbz -> termina_amd64.tbz )
		arm? ( gs://termina-component-testing/uprev-test/arm/${PV}/guest-vm-base.tbz -> termina_arm.tbz )
		arm64? ( gs://termina-component-testing/uprev-test/arm/${PV}/guest-vm-base.tbz -> termina_arm.tbz )
	"
fi

RESTRICT="nomirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
S="${WORKDIR}"

IUSE="kvm_host dlc amd64 arm"
REQUIRED_USE="
	dlc
	kvm_host
	^^ ( amd64 arm arm64 )
"

# Termina is ~87MiB compressed at present, so 100 MiB should be plenty for
# now. Double this for test builds so we can fit test utilities in.
# 100MiB = 256 x 1024 x 4KB blocks
if [[ ${PV} == 9999 ]]; then
	DLC_PREALLOC_BLOCKS="$((200 * 256))"
else
	DLC_PREALLOC_BLOCKS="$((100 * 256))"
fi

# TODO(crbug/953544): When termina's DLC is working, make the test pre-load it.
# DLC_PRELOAD=true

# We need to inherit from cros-workon so people can do "cros-workon-${BOARD}
# start termina-dlc", but we don't want to actually run any of the cros-workon
# steps, so we override pkg_setup and src_unpack with the default
# implementations.
pkg_setup() {
	return
}

src_unpack() {
	if [[ -n ${A} ]]; then
		# $A should be tokenised here as it may contain multiple files
		# shellcheck disable=SC2086
		unpack ${A}
	fi
}

src_compile() {
	if [[ ${PV} == 9999 ]]; then
		if use amd64; then
			vm_board="tatl"
		else
			vm_board="tael"
		fi
		image_path="/mnt/host/source/src/build/images/${vm_board}/latest/chromiumos_test_image.bin"
		[[ ! -f "${image_path}" ]] && die "Couldn't find VM image, try building a test image for ${vm_board} first"

		/mnt/host/source/src/platform/container-guest-tools/termina/termina_build_image.py "${image_path}" "${S}/vm"
		mv "${S}/vm"/* "${WORKDIR}"
	fi
}

src_install() {
	# This is the subpath underneath the location that dlc mounts the image,
	# so we dont need additional directories.
	local install_dir="/"
	into "$(dlc_add_path ${install_dir})"
	insinto "$(dlc_add_path ${install_dir})"
	exeinto "$(dlc_add_path ${install_dir})"
	doins "${WORKDIR}"/*
	dlc_src_install
}
