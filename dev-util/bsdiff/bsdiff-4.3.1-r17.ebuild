# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bsdiff/bsdiff-4.3-r2.ebuild,v 1.1 2010/12/13 00:35:03 flameeyes Exp $

EAPI="5"

CROS_WORKON_COMMIT=("5d04fea5416eff612903c48aff366c9d8087b211" "c35a3dd7996924b9925880f988993faec3449e26")
CROS_WORKON_TREE=("7bcd83907690430e66b5a71e2dc849fa4b3e41b0" "23e60e6f9a85c8a97d188d1e45d42c125bd7e368")
inherit cros-constants

# cros-workon expects the repo to be in src/third_party, but is in src/aosp.
CROS_WORKON_LOCALNAME=("../platform2" "../aosp/external/bsdiff")
CROS_WORKON_PROJECT=("chromiumos/platform2" "platform/external/bsdiff")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/bsdiff")
CROS_WORKON_REPO=("${CROS_GIT_HOST_URL}" "${CROS_GIT_AOSP_URL}")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_BLACKLIST=1
CROS_WORKON_SUBTREE=("common-mk" "")

PLATFORM_SUBDIR="bsdiff"

inherit cros-workon platform

DESCRIPTION="bsdiff: Binary Differencer using a suffix alg"
HOMEPAGE="http://www.daemonology.net/bsdiff/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	app-arch/brotli
	app-arch/bzip2
	dev-libs/libdivsufsort
"
DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}"/lib/libbsdiff.so
	dolib.so "${OUT}"/lib/libbspatch.so
	dobin "${OUT}"/bsdiff
	dobin "${OUT}"/bspatch

	insinto /usr/include/bsdiff
	doins include/bsdiff/*.h

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bspatch_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/bsdiff_unittest"

	# Run fuzzer.
	platform_fuzzer_test "${OUT}"/bspatch_fuzzer
}

pkg_preinst() {
	# We only want libbspatch.so in runtime images.
	if [[ $(cros_target) == "target_image" ]]; then
		rm "${D}"/usr/bin/bsdiff "${D}"/usr/bin/bspatch "${D}"/usr/$(get_libdir)/bsdiff.so
	fi
}
