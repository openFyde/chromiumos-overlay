# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("a611ee12a8f3deacc59fc0dcf10d9992288e4e94" "12c2bca14efb85ce9c76c51be7a65629520cad2a")
CROS_WORKON_TREE=("bfb6ecc4da4dc2d7aafa35ed314e5d2fb8f2f8a6" "dd17a346abfc171b5740ddb450d79fede1903611")
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
