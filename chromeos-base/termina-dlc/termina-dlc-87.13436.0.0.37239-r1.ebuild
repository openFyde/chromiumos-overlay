# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# A DLC package for distributing termina.

EAPI=7

inherit dlc

DESCRIPTION="DLC package for termina."
SRC_URI="
	amd64? ( gs://termina-component-testing/uprev-test/amd64/${PV}/guest-vm-base.tbz -> termina_amd64.tbz )
	arm? ( gs://termina-component-testing/uprev-test/arm/${PV}/guest-vm-base.tbz -> termina_arm.tbz )
	arm64? ( gs://termina-component-testing/uprev-test/arm/${PV}/guest-vm-base.tbz -> termina_arm.tbz )
"

RESTRICT="nomirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

IUSE="kvm_host dlc amd64 arm"
REQUIRED_USE="
	dlc
	kvm_host
	^^ ( amd64 arm arm64 )
"

# Termina is ~350MB at present, so 1 GB is very conservative.
# 1GB = 256 x 1024 x 4KB blocks
DLC_PREALLOC_BLOCKS="$((256 * 1024))"

# TODO(crbug/953544): When termina's DLC is working, make the test pre-load it.
# DLC_PRELOAD=true

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
