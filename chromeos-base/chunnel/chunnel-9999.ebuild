# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="vm_tools/chunnel"

inherit cros-rust cros-workon user

DESCRIPTION="Tunnel between localhost in different netns"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools/chunnel"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="~*"
IUSE="kvm_host"

DEPEND="
	chromeos-base/system_api:=
	dev-rust/libchromeos:=
	dev-rust/sys_util:=
	=dev-rust/dbus-0.6*:=
	=dev-rust/getopts-0.2*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	=dev-rust/protobuf-2*:=
	=dev-rust/protoc-rust-2*:=
	=dev-rust/tempfile-3*:=
	dev-rust/remain:=
	sys-apps/dbus:=
"

src_unpack() {
	# Unpack both the project and dependency source code.
	cros-workon_src_unpack

	# The compilation happens in the vm_tools/chunnel subdirectory.
	S+="/vm_tools/chunnel"

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
		ecargo_test --all
	fi
}

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"

	if use kvm_host; then
		dobin "${build_dir}/chunneld"

		insinto /etc/init
		doins init/chunneld.conf

		insinto /etc/dbus-1/system.d
		doins dbus/org.chromium.Chunneld.conf

		insinto /usr/share/policy
		newins "seccomp/chunneld-seccomp-${ARCH}.policy" chunneld-seccomp.policy
	else
		dobin "${build_dir}/chunnel"
	fi
}

pkg_preinst() {
	if use kvm_host; then
		enewuser chunneld
		enewgroup chunneld
	fi
}
