# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_SUBTREE="crosh"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS developer command-line shell"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/crosh/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="~*"
IUSE=""

COMMON_DEPEND="
	chromeos-base/vboot_reference:=
	sys-apps/dbus
"

DEPEND="${COMMON_DEPEND}
	>=dev-rust/bitflags-1.3.2 <dev-rust/bitflags-2.0.0_alpha
	=dev-rust/chrono-0.4*
	=dev-rust/dbus-0.9*
	=dev-rust/getopts-0.2*
	dev-rust/libchromeos:=
	=dev-rust/rand-0.7*
	>=dev-rust/regex-1.0.6 <dev-rust/regex-2.0.0_alpha
	dev-rust/remain
	=dev-rust/rustyline-9*
	dev-rust/shell-words
	dev-rust/sys_util:=
	dev-rust/system_api:=
	dev-rust/tempfile
	>dev-rust/tlsdate_dbus-0.24.52-r8:=
	=dev-rust/textwrap-0.11*
"
RDEPEND="${COMMON_DEPEND}
	app-admin/sudo
	net-misc/iputils
	net-misc/openssh
	net-wireless/iw
	sys-apps/net-tools
"

src_test() {
	./run_tests.sh || die

	local args=()
	# (b/197637613) reduce the number of futex calls to reduce the risk of a hang
	# when running inside qemu.
	if ! cros_rust_is_direct_exec; then
		args+=( -- --test-threads=1 )
	fi

	cros-rust_src_test "${args[@]}"
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/crosh"
	newbin crosh crosh.sh
	dobin network_diag
	local d="/usr/share/crosh"
	insinto "${d}/dev.d"
	doins dev.d/*.sh
	insinto "${d}/removable.d"
	doins removable.d/*.sh
}
