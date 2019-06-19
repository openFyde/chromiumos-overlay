# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bsdiff/bsdiff-4.3-r2.ebuild,v 1.1 2010/12/13 00:35:03 flameeyes Exp $

EAPI=6

CROS_WORKON_COMMIT=("ceb477360a8012ee38e80746258f4828aad6b4c7" "10118144d0b8a90496db9f97d55bf607db2c8c8b")
CROS_WORKON_TREE=("3d7d9e41d0def5d27f7eb68b079e5ed36fcadefa" "ebe23d95183dfad42797b3d4ffea28ee8af07f92")
inherit cros-constants

# cros-workon expects the repo to be in src/third_party, but is in src/aosp.
CROS_WORKON_LOCALNAME=("../platform2" "../aosp/external/bsdiff")
CROS_WORKON_PROJECT=("chromiumos/platform2" "platform/external/bsdiff")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/bsdiff")
CROS_WORKON_REPO=("${CROS_GIT_HOST_URL}" "${CROS_GIT_AOSP_URL}")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_BLACKLIST=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="bsdiff"

inherit cros-workon platform

DESCRIPTION="bsdiff: Binary Differencer using a suffix alg"
HOMEPAGE="http://www.daemonology.net/bsdiff/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	>=app-arch/brotli-1.0.6
	app-arch/bzip2
	dev-libs/libdivsufsort
"
DEPEND="${RDEPEND}"

src_install() {
	if use cros_host; then
		dobin "${OUT}"/bsdiff
		dobin "${OUT}"/bspatch
	fi
	dolib.a "${OUT}"/libbsdiff.a
	dolib.a "${OUT}"/libbspatch.a

	insinto /usr/include
	doins -r include/bsdiff

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libbsdiff.pc libbspatch.pc

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bspatch_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/bsdiff_test"

	# Run fuzzer.
	platform_fuzzer_test "${OUT}"/bspatch_fuzzer
}
