# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="47106c5ef57bb352f5265671471807fcbaf25c23"
CROS_WORKON_TREE=("7286f60f39ca7e7dd78e67c7b50fc4bda7c4d5a2" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a")
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
	>=dev-rust/chrono-0.4.2 <dev-rust/chrono-0.5.0
	>=dev-rust/dbus-0.6.1 <dev-rust/dbus-0.7.0
	dev-rust/libchromeos:=
	>=dev-rust/protobuf-2.3 <dev-rust/protobuf-3.0
	>=dev-rust/protoc-rust-2.3 <dev-rust/protoc-rust-3
	=dev-rust/syslog-6*
	=dev-rust/tempfile-3*
	=dev-rust/time-0.3*
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
