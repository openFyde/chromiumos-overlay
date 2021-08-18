# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6569ce6bc084870ba64fe8e942d0de1f0b160062"
CROS_WORKON_TREE=("69b8c728cddfb69a367c26f9058a8a5e62df8753" "28f37cdcfde2883b10b1fc8a01d3b2b91edbce8f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk imageloader .gn"

PLATFORM_SUBDIR="imageloader"

inherit cros-workon platform user

DESCRIPTION="Allow mounting verified utility images"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/imageloader/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	chromeos-base/vboot_reference:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
	sys-fs/lvm2:="

DEPEND="${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]"

src_install() {
	# Install manifest parsing libraries
	dolib.so "${OUT}/lib/libimageloader-manifest.so"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libimageloader-manifest.pc

	insinto "/usr/include/libimageloader"
	doins manifest.h

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/imageloader-seccomp-${ARCH}.policy" imageloader-seccomp.policy
	newins "seccomp/imageloader-helper-seccomp-${ARCH}.policy" imageloader-helper-seccomp.policy
	cd "${OUT}"
	dosbin imageloader
	cd "${S}"
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.ImageLoader.conf
	insinto /usr/share/dbus-1/system-services
	doins dbus_service/org.chromium.ImageLoader.service
	insinto /etc/init
	doins init/imageloader.conf
	doins init/imageloader-init.conf
	doins init/imageloader-shutdown.conf

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/imageloader_helper_process_receiver_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/imageloader_manifest_fuzzer \
		--dict "${S}"/fuzz/manifest.dict
}

platform_pkg_test() {
	platform_test "run" "${OUT}/run_tests"
}

pkg_preinst() {
	enewuser "imageloaderd"
	enewgroup "imageloaderd"
}
