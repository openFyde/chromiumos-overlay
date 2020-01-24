# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("190698abfb8ac2206c1df57e1b9a66db04cae53f" "49dfc58d6c4c66f5d0b0d06f0161da4e602a1293")
CROS_WORKON_TREE=("34e736b2ee0acc1681bb3c37947454b3459bea88" "9cc2c3d3cfcdace7acfd2b22a419c76f3ffbcf3d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "6dbc19849752c206e135ab59349ebb1cc62bb435")
inherit cros-constants

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT=("chromiumos/platform2" "platform/system/keymaster")
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_AOSP_URL}"
)
CROS_WORKON_LOCALNAME=("platform2" "aosp/system/keymaster")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/aosp/system/keymaster")
CROS_WORKON_SUBTREE=("common-mk arc/keymaster .gn" "")

PLATFORM_SUBDIR="arc/keymaster"

# This BoringSSL integration follows go/boringssl-cros.
# DO NOT COPY TO OTHER PACKAGES WITHOUT CONSULTING SECURITY TEAM.
BORINGSSL_PN="boringssl"
BORINGSSL_PV="3359"
BORINGSSL_P="${BORINGSSL_PN}-${BORINGSSL_PV}"
BORINGSSL_OUTDIR="${WORKDIR}/boringssl_outputs/"

CMAKE_USE_DIR="${WORKDIR}/${BORINGSSL_P}"
BUILD_DIR="${WORKDIR}/${BORINGSSL_P}_build"

inherit flag-o-matic cmake-utils multilib cros-workon platform user

DESCRIPTION="Android keymaster service in Chrome OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/keymaster"
SRC_URI="https://github.com/google/${BORINGSSL_PN}/archive/${BORINGSSL_PV}.tar.gz -> ${BORINGSSL_P}.tar.gz"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

RDEPEND="
	chromeos-base/minijail
"

DEPEND="
	chromeos-base/system_api:=
"

HEADER_TAINT="#ifdef CHROMEOS_OPENSSL_IS_OPENSSL
#error \"Do not mix OpenSSL and BoringSSL headers.\"
#endif
#define CHROMEOS_OPENSSL_IS_BORINGSSL\n"

src_unpack() {
	platform_src_unpack
	unpack "${BORINGSSL_P}.tar.gz"
	# Taint BoringSSL headers so they don't silently mix with OpenSSL.
	find "${BORINGSSL_P}/include/openssl" -type f -exec awk -i inplace -v \
		"taint=${HEADER_TAINT}" 'NR == 1 {print taint} {print}' {} \;
}

src_prepare() {
	cmake-utils_src_prepare

	# Expose libhardware headers from arc-toolchain-p.
	local arc_arch="${ARCH}"
	# arm needs to use arm64 directory, which provides combined arm/arm64
	# headers.
	if [[ "${ARCH}" == "arm" ]]; then
		arc_arch="arm64"
	fi
	mkdir -p "${WORKDIR}/libhardware/include" || die
	cp -rfp "/opt/android-p/${arc_arch}/usr/include/hardware" "${WORKDIR}/libhardware/include" || die
	append-cxxflags "-I${WORKDIR}/libhardware/include"

	# Expose BoringSSL headers and outputs.
	append-cxxflags "-I${WORKDIR}/${BORINGSSL_P}/include"
	append-ldflags "-L${BORINGSSL_OUTDIR}"
	# Backport clang fallthru patches to fix newer clang builds.
	# https://boringssl-review.googlesource.com/c/boringssl/+/37244
	# https://boringssl-review.googlesource.com/c/boringssl/+/37247
	cd "${WORKDIR}/${BORINGSSL_P}" || die
	epatch "${FILESDIR}"/boringssl-clang-fallthru.patch
	# Patch keymaster context.
	cd "${WORKDIR}/${P}/aosp/system/keymaster" || die
	epatch "${FILESDIR}/keymaster-context-hooks.patch"
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_BUILD_TYPE=Release"
		"-DCMAKE_SYSTEM_PROCESSOR=${CHOST%%-*}"
		"-DBUILD_SHARED_LIBS=OFF"
	)
	cmake-utils_src_configure
	platform_src_configure
}

src_compile() {
	# Compile BoringSSL and expose libcrypto.a.
	cmake-utils_src_compile
	mkdir -p "${BORINGSSL_OUTDIR}" || die
	cp -p "${BUILD_DIR}/crypto/libcrypto.a" "${BORINGSSL_OUTDIR}/libboringcrypto.a" || die

	platform_src_compile
}

src_install() {
	insinto /etc/init
	doins init/arc-keymasterd.conf

	# Install DBUS configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.ArcKeymaster.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins \
		"seccomp/arc-keymasterd-seccomp-${ARCH}.policy" \
		arc-keymasterd-seccomp.policy

	# Install shared libs and binary.
	dolib.so "${OUT}/lib/libarckeymaster_context.so"
	dolib.so "${OUT}/lib/libkeymaster.so"
	dosbin "${OUT}/arc-keymasterd"

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_keymasterd_fuzzer
}

pkg_preinst() {
	enewuser "arc-keymasterd"
	enewgroup "arc-keymasterd"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-keymasterd_testrunner"
}
