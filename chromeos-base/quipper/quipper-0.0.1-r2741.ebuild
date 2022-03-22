# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Don't use Makefile.external here as it fetches from the network.
EAPI=7

CROS_WORKON_COMMIT="2e5c421c335d5e5750149a486d4b63bc5e158517"
CROS_WORKON_TREE=("beaa23ddfa8fcd0c80807667abfa09780522b3ad" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
# chromiumos-wide-profiling directory is in $SRC_URI, not in platform2.
CROS_WORKON_SUBTREE="common-mk .gn"

PLATFORM_SUBDIR="chromiumos-wide-profiling"

inherit cros-workon platform

DESCRIPTION="quipper: chromiumos wide profiling"
HOMEPAGE="http://www.chromium.org/chromium-os/profiling-in-chromeos"

GIT_SHA1="9e1c26cb7912122f0a61a41fea86453b1aebeed1"
SRC="quipper-${GIT_SHA1}.tar.gz"
SRC_URI="gs://chromeos-localmirror/distfiles/${SRC}"
SRC_DIR="src/${PN}"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	>=dev-cpp/gflags-2.0:=
	>=dev-libs/glib-2.30:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	dev-util/perf:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/protofiles:=
	test? ( app-shells/dash )
"

src_unpack() {
	platform_src_unpack
	mkdir "${S}"

	pushd "${S}" >/dev/null
	unpack ${SRC}
	mv "${SRC_DIR}"/{.[!.],}* ./ || die
	eapply "${FILESDIR}"/quipper-disable-flaky-tests.patch
	eapply "${FILESDIR}"/quipper-arraysize.patch
	eapply "${FILESDIR}"/quipper-check-header.patch
	popd >/dev/null
}

src_compile() {
	# ARM tests run on qemu which is much slower. Exclude some large test
	# data files for non-x86 boards.
	if use x86 || use amd64 ; then
		append-cppflags -DTEST_LARGE_PERF_DATA
	fi

	platform_src_compile
}

src_install() {
	dobin "${OUT}"/quipper
}

platform_pkg_test() {
	local tests=(
		integration_tests
		perf_recorder_test
		unit_tests
	)
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}" "1"
	done
}
