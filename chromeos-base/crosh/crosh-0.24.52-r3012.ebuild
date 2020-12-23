# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="45b9a6d50c855f18fc70e38c1dfd04d6d2c0968c"
CROS_WORKON_TREE="155e00257ce4d3c69e33eb317356caaee2a0977b"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_SUBTREE="crosh"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS developer command-line shell"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/crosh/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="+rust-crosh"

DEPEND=">chromeos-base/system_api-rust-0.24.52-r261:=
	=dev-rust/dbus-0.8*:=
	>=dev-rust/regex-1.0.6:= <dev-rust/regex-2.0.0
	dev-rust/remain:=
	=dev-rust/rustyline-7*:=
	dev-rust/shell-words:=
	dev-rust/sys_util:=
	dev-rust/tempfile:=
	>dev-rust/tlsdate_dbus-0.24.52-r8:=
"
RDEPEND="app-admin/sudo
	chromeos-base/vboot_reference
	net-misc/iputils
	net-misc/openssh
	net-wireless/iw
	sys-apps/net-tools
"

src_compile() {
	# File order is important here.
	sed \
		-e '/^#/d' \
		-e '/^$/d' \
		inputrc.safe inputrc.extra \
		> "${WORKDIR}"/inputrc.crosh || die

	cros-rust_src_compile
}

src_test() {
	./run_tests.sh || die

	cros-rust_src_test
}

src_install() {
	if use rust-crosh; then
		dobin "$(cros-rust_get_build_dir)/crosh"
		newbin crosh crosh.sh
	else
		dobin crosh
	fi
	dobin network_diag
	local d="/usr/share/crosh"
	insinto "${d}/dev.d"
	doins dev.d/*.sh
	insinto "${d}/removable.d"
	doins removable.d/*.sh
	insinto "${d}"
	doins "${WORKDIR}"/inputrc.crosh
}
