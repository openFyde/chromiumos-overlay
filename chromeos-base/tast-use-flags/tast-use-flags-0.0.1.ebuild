# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Text file listing USE flags for Tast test dependencies"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# NB: Flags listed here are off by default unless prefixed with a '+'.
IUSE="
	android-container-pi
	arc
	asan
	betty
	chrome_internal
	chromeless_tty
	containers
	cups
	+display_backlight
	grunt
	+internal_mic
	kvm_host
	lxc
	memd
	ml_service
	mocktpm
	rialto
	rk3399
	selinux
	selinux_experimental
	skate
	snow
	spring
	tegra
	touchview
	transparent_hugepage
	veyron_mickey
	veyron_rialto
"

S=${WORKDIR}

src_install() {
	# Install a file containing a list of currently-set USE flags.
	local path="${WORKDIR}/tast_use_flags.txt"
	cat <<EOF >"${path}"
# This file is used by the Tast integration testing system to
# determine which software features are present in the system image.
# Don't use it for anything else. Your code will break.
EOF

	# If you need to inspect a new flag, add it to $IUSE at the top of the file.
	local flags=( ${IUSE} )
	local flag
	for flag in ${flags[@]/#[-+]} ; do
		usev ${flag}
	done | sort -u >>"${path}"

	insinto /etc
	doins "${path}"
}
