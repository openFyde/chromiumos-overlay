# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("c3bd2094f92d574377f7af2aec147ae181aa5f8e" "f8ff8d25aa0a9e65948040c7b47ec67f3fa300df" "5931355809b365a9f061773014da11c1ff7cc4d4" "5a576c3d3e1e2120ceb111d4124b54e3f65ea5bd" "656dcdda8d730d4bbf637b9fd431092663f2545c")
CROS_WORKON_TREE=("781df7da13c4275a2328c09e75fd937991d80e29" "abc18d92d55a64403269f84c59e6db14875edb34" "eebe99e526b785f04f4b95b2d35ad28ec9f69694" "42ac47c0e56a8ea0f3535b8a9261c89c4a86a9a4" "8da768dde14eae840f608f84536a068842d55a2d")
ZEPHYR_VERSIONS=( v2.5 v2.6 )

CROS_WORKON_USE_VCSID=1
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/zephyr/cmsis"
	"chromiumos/third_party/zephyr/hal_stm32"
	"chromiumos/platform/ec"
)
for v in "${ZEPHYR_VERSIONS[@]}"; do
	CROS_WORKON_PROJECT+=("chromiumos/third_party/zephyr")
done

CROS_WORKON_LOCALNAME=(
	"third_party/zephyr/cmsis"
	"third_party/zephyr/hal_stm32"
	"platform/ec"
)
for v in "${ZEPHYR_VERSIONS[@]}"; do
	CROS_WORKON_LOCALNAME+=("third_party/zephyr/main/${v}")
done

CROS_WORKON_DESTDIR=(
	"${S}/modules/cmsis"
	"${S}/modules/hal_stm32"
	"${S}/modules/ec"
)
for v in "${ZEPHYR_VERSIONS[@]}"; do
	CROS_WORKON_DESTDIR+=("${S}/zephyr-base/${v}")
done

inherit cros-workon cros-unibuild coreboot-sdk toolchain-funcs

DESCRIPTION="Zephyr based Embedded Controller firmware"
KEYWORDS="*"
LICENSE="Apache-2.0 BSD-Google"
IUSE="unibuild"
REQUIRED_USE="unibuild"

# Add instances of vX.Y as 'zephyr_vX_Y' to IUSE
IUSE="${IUSE} $(for v in "${ZEPHYR_VERSIONS[@]}"; do echo "zephyr_${v//./_}"; done)"

BDEPEND="
	chromeos-base/zephyr-build-tools
	dev-python/docopt
	dev-python/pykwalify
	dev-util/ninja
"

DEPEND="
	chromeos-base/chromeos-config
"
RDEPEND="${DEPEND}"

ZEPHYR_EC_BUILD_DIRECTORIES=()

get_zephyr_version() {
	local v
	for v in "${ZEPHYR_VERSIONS[@]}"; do
		if use "zephyr_${v//./_}"; then
			echo "${v}"
			return 0
		fi
	done
	ewarn "Defaulting to Zephyr v2.5. Please specify a zephyr_vX_X use flag."
	ewarn "This will error in the future."
	echo "v2.5"
}

src_configure() {
	tc-export CC

	while read -r board && read -r path; do
		if [[ -z "${path}" ]]; then
			continue
		fi
		if [[ ! -d "${S}/modules/ec/zephyr/${path}" ]]; then
			die "Specified path for Zephyr project does not exist."
		fi
		local build_dir="build-${board}"

		local zephyr_base="${S}/zephyr-base/$(get_zephyr_version)"
		zmake \
			--modules-dir "${S}/modules" \
			--zephyr-base "${zephyr_base}" \
			configure \
			"modules/ec/zephyr/${path}" \
			-B "${build_dir}"

		ZEPHYR_EC_BUILD_DIRECTORIES+=("${build_dir}")
	done < <(cros_config_host "get-firmware-build-combinations" zephyr-ec || die)
}

src_compile() {
	tc-export CC

	for build_dir in "${ZEPHYR_EC_BUILD_DIRECTORIES[@]}"; do
		zmake \
			--modules-dir "${S}/modules" \
			--zephyr-base "${S}/zephyr-base" \
			build \
			"${build_dir}"
	done
}

src_install() {
	for build_dir in "${ZEPHYR_EC_BUILD_DIRECTORIES[@]}"; do
		board="$(echo "${build_dir}" |cut -d/ -f1)"
		board="${board#build-}"

		insinto "/firmware/${board}"
		doins "${build_dir}/output/zephyr.bin"
	done
}
