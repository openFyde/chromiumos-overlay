# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f5905cb27d9b5dbf6bf6e338cf012ba9267a0523"
CROS_WORKON_TREE=("20f2fcbfbf92508cd7657880bf7ab16a86a23e68" "4d05be6aacce39f0ffed0cb00fc7d88926121b65")
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
