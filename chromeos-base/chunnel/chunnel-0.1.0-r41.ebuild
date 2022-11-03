# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="666db4fd2dedc2bf2e70cb0f9bb93e26715489d6"
CROS_WORKON_TREE="d8f8f176318b4a9163a952a2b46503354b66fb64"
CROS_RUST_SUBDIR="vm_tools/chunnel"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust user

DESCRIPTION="Tunnel between localhost in different netns"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools/chunnel"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="kvm_host"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/system_api:=
	dev-rust/libchromeos:=
	dev-rust/sys_util:=
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-tree-0.9*
	>=dev-rust/protobuf-2.16.2 <dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.16.2 <dev-rust/protoc-rust-3
"

RDEPEND="sys-apps/dbus"

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run --workspace
}

src_test() {
	cros-rust_src_test --workspace
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
	cros-rust_pkg_preinst
}
