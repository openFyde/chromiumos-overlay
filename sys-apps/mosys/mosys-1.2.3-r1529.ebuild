# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("07142f9f6a43b6ea73aae8e8a763eacc6bb13391" "e342db685f2901707f50b40c38eeea0b867db754")
CROS_WORKON_TREE=("850bb15d6483ae4ed294e5a64907e57835f3232d" "9ed705728649b768cc7c5511a97baa2692e9393c")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/mosys"
)
CROS_WORKON_LOCALNAME=(
	"../platform2"
	"../platform/mosys"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform/mosys"
)
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=(
	"common-mk"
	""
)

WANT_LIBCHROME="no"
WANT_LIBBRILLO="no"

inherit meson flag-o-matic toolchain-funcs cros-unibuild cros-workon platform

PLATFORM_NAMES=(
	"Asuka"
	"Asurada"
	"Caroline"
	"Chell"
	"Cherry"
	"Corsola"
	"Generic"
	"Gru"
	"Herobrine"
	"Kukui"
	"Oak"
	"Trogdor"
)
PLATFORM_NAME_USE_FLAGS=()
for platform_name in "${PLATFORM_NAMES[@]}"; do
	PLATFORM_NAME_USE_FLAGS+=("mosys_platform_${platform_name,,}")
done

DESCRIPTION="Utility for obtaining various bits of low-level system info"
HOMEPAGE="http://mosys.googlecode.com/"

LICENSE="BSD-Google BSD Apache-2.0 MIT ISC Unlicense"
SLOT="0/0"
KEYWORDS="*"
IUSE="unibuild ${PLATFORM_NAME_USE_FLAGS[*]}"
REQUIRED_USE="^^ ( ${PLATFORM_NAME_USE_FLAGS[*]} )"

RDEPEND="
	dev-util/cmocka
	chromeos-base/minijail:="
DEPEND="${RDEPEND}"

src_unpack() {
	cros-workon_src_unpack
	PLATFORM_TOOLDIR="${S}/platform2/common-mk"
	S+="/platform/mosys"
}

src_configure() {
	local platform_intf=""
	local emesonargs=(
		"$(meson_use unibuild)"
		-Darch=$(tc-arch)
	)

	for ((i = 0; i < ${#PLATFORM_NAMES[@]}; i++)); do
		if use "${PLATFORM_NAME_USE_FLAGS[${i}]}"; then
			platform_intf="${PLATFORM_NAMES[${i}]}"
			break
		fi
	done

	if [[ -n "${platform_intf}" ]]; then
		emesonargs+=(
			"-Dplatform_intf=${platform_intf}"
		)
	fi

	# Necessary to enable LTO.  See crbug.com/1082378.
	append-ldflags "-O2"

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

platform_pkg_test() {
	local tests=(
		file_unittest
		math_unittest
		vpd_unittest
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" \
			"${BUILD_DIR}/unittests/${test_bin}"
	done
}

src_install() {
	dosbin "${BUILD_DIR}/mains/mosys"

	insinto /usr/share/policy
	newins "seccomp/mosys-seccomp-${ARCH}.policy" mosys-seccomp.policy
	dodoc README
}
