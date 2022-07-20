# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("0838dd8cb7238027a16743d7eb0c8e29de1df369" "73b4433e502690d622075f47dde18849bfbbb2a5")
CROS_WORKON_TREE=("4055d34d682d2a7ff6bc4285499301674c0779ab" "1ea13e9e3e2cc1fabd9775806e986787d736562b")
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
	"Cave"
	"Chell"
	"Cherry"
	"Coral"
	"Corsola"
	"Dedede"
	"Fizz"
	"Generic"
	"Glados"
	"Gru"
	"Grunt"
	"Hatch"
	"Herobrine"
	"Kalista"
	"Kukui"
	"Lars"
	"Oak"
	"Octopus"
	"Poppy"
	"Puff"
	"Reef"
	"Sarien"
	"Sentry"
	"Strago"
	"Trogdor"
	"Volteer"
	"Zork"
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
IUSE="unibuild vpd_file_cache ${PLATFORM_NAME_USE_FLAGS[*]}"
REQUIRED_USE="^^ ( ${PLATFORM_NAME_USE_FLAGS[*]} )"

RDEPEND="
	vpd_file_cache? ( chromeos-base/vpd )
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
		"$(meson_use vpd_file_cache use_vpd_file_cache)"
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
