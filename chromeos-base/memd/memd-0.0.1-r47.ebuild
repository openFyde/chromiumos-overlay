# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="8d55c2520a35331e9d06682424c7dc9ad0cbdaed"
CROS_WORKON_TREE="2757a9c32a132776910c47d97b886bf56e2d71c3"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="metrics/memd"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-rust cros-workon toolchain-funcs

DESCRIPTION="Fine-grain memory metrics collector"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp"

DEPEND="chromeos-base/system_api
	sys-apps/dbus
	~dev-rust/chrono-0.4.2:=
	~dev-rust/dbus-0.6.1:=
	=dev-rust/env_logger-0.6*:=
	~dev-rust/libc-0.2.44:=
	~dev-rust/log-0.4.5:=
	=dev-rust/protobuf-2.3*:=
	=dev-rust/protoc-rust-2.3*:=
	~dev-rust/syslog-4.0.0:=
	~dev-rust/time-0.1.40:=
	=dev-rust/tempfile-3*:=
	"

src_unpack() {
	# Unpack both the project and dependency source code.
	cros-workon_src_unpack

	# The compilation happens in the memd subdirectory.
	S+="/metrics/memd"

	cros-rust_src_unpack
}

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run
}

src_test() {
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		ecargo_test --all || die "memd test failed"
	fi
}

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
