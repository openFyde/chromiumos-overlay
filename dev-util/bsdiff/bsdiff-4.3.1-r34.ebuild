# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bsdiff/bsdiff-4.3-r2.ebuild,v 1.1 2010/12/13 00:35:03 flameeyes Exp $

EAPI=7

CROS_WORKON_COMMIT=("c4f0fe250331fbc1ad16515f86804cb99a0f6ee9" "c1c7b9eaa75d93663424bb245395fe00ca0ad233")
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7a09dff0a55fec57ae1ba55d023b5deae612d4fb")
inherit cros-constants

# cros-workon expects the repo to be in src/third_party, but is in src/aosp.
CROS_WORKON_LOCALNAME=("../platform2" "../aosp/external/bsdiff")
CROS_WORKON_PROJECT=("chromiumos/platform2" "platform/external/bsdiff")
CROS_WORKON_EGIT_BRANCH=("main" "master")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/bsdiff")
CROS_WORKON_REPO=("${CROS_GIT_HOST_URL}" "${CROS_GIT_AOSP_URL}")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_MANUAL_UPREV=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="bsdiff"

inherit cros-workon platform

DESCRIPTION="bsdiff: Binary Differencer using a suffix alg"
HOMEPAGE="http://www.daemonology.net/bsdiff/"
SRC_URI=""

LICENSE="BSD-2"
KEYWORDS="*"

RDEPEND="
	>=app-arch/brotli-1.0.6:=
	app-arch/bzip2:=
	dev-libs/libdivsufsort:=
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

	local fuzzer_component_id="31714"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bspatch_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/bsdiff_test"

	# Run fuzzer.
	platform_fuzzer_test "${OUT}"/bspatch_fuzzer
}
