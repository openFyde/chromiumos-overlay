# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="91181e7f74a369f51c79b13422c2a08b8590e6f9"
CROS_WORKON_TREE=("20f2fcbfbf92508cd7657880bf7ab16a86a23e68" "e44d7e66ab4ccaab888a42ade972724af9621706")
CROS_RUST_SUBDIR="metrics/memd"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} common-mk"
CROS_WORKON_INCREMENTAL_BUILD=1
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.

inherit cros-workon cros-rust

DESCRIPTION="Fine-grain memory metrics collector"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/metrics/memd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

BDEPEND="dev-libs/protobuf"
DEPEND="
	cros_host? ( dev-libs/protobuf:= )
	dev-rust/third-party-crates-src:=
	chromeos-base/system_api:=
	dev-rust/libchromeos:=
	sys-apps/dbus:=
"
RDEPEND="sys-apps/dbus"

src_install() {
	# cargo doesn't know how to install cross-compiled binaries.  It will
	# always install native binaries for the host system.  Install manually
	# instead.
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/memd"
	insinto /etc/init
	doins init/memd.conf
	insinto /usr/share/policy
	use seccomp && \
		newins "init/memd-seccomp-${ARCH}.policy" memd-seccomp.policy
}
