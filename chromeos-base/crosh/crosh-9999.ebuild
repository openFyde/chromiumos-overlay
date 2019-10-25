# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_SUBTREE="crosh"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS developer command-line shell"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/crosh/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="+rust-crosh"

DEPEND="chromeos-base/system_api-rust:=
	>=dev-rust/dbus-0.6.1:= <dev-rust/dbus-0.7.0
	>=dev-rust/regex-1.0.6:= <dev-rust/regex-2.0.0
	dev-rust/remain:=
	>=dev-rust/rustyline-5.0.4:= <dev-rust/rustyline-6.0.0
	dev-rust/sys_util:=
	dev-rust/tempfile:=
	dev-rust/tlsdate_dbus:=
"
RDEPEND="app-admin/sudo
	chromeos-base/vboot_reference
	net-misc/iputils
	net-misc/openssh
	net-wireless/iw
	sys-apps/net-tools
"

src_unpack() {
	cros-workon_src_unpack
	S+="/crosh"

	cros-rust_src_unpack
}

src_compile() {
	# File order is important here.
	sed \
		-e '/^#/d' \
		-e '/^$/d' \
		inputrc.safe inputrc.extra \
		> "${WORKDIR}"/inputrc.crosh || die
	ecargo_build

	use test && ecargo_test --no-run
}

src_test() {
	./run_tests.sh || die

	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
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
