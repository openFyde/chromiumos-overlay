# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="331c7db90a15896fbacb4e4606e69a3f5ee1cccd"
CROS_WORKON_TREE=("8b65993bc3f08535d77b96149ea9059af59070a1" "ebcce78502266e81f55c63ade8f25b8888e2c103")
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

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/system_api:=
	sys-apps/dbus:=
	>=dev-rust/dbus-0.6.1 <dev-rust/dbus-0.7.0
	dev-rust/libchromeos:=
	>=dev-rust/protobuf-2.3 <dev-rust/protobuf-3.0
	>=dev-rust/protoc-rust-2.3 <dev-rust/protoc-rust-3
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
