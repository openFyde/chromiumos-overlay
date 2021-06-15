# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="576984316ea188ad1a48570288ed56b912804178"
CROS_WORKON_TREE=("75f65f147da7feb0796cb97c434e13bc61d8ee8f" "791c6808b4f4f5f1c484108d66ff958d65f8f1e3")
CROS_RUST_SUBDIR="metrics/memd"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} common-mk"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon cros-rust

DESCRIPTION="Fine-grain memory metrics collector"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/metrics/memd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

DEPEND="chromeos-base/system_api:=
	sys-apps/dbus:=
	>=dev-rust/chrono-0.4.2:= <dev-rust/chrono-0.5.0
	>=dev-rust/dbus-0.6.1:= <dev-rust/dbus-0.7.0
	=dev-rust/env_logger-0.6*:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	>=dev-rust/log-0.4.5:= <dev-rust/log-0.5.0
	>=dev-rust/protobuf-2.3:= <dev-rust/protobuf-3.0
	>=dev-rust/protoc-rust-2.3:= <dev-rust/protoc-rust-3
	=dev-rust/syslog-4*:=
	=dev-rust/tempfile-3*:=
	>=dev-rust/time-0.1.40:= <dev-rust/time-0.2.0
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
