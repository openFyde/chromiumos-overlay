# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("712f4c6d9dbd1340250433c0c74b7a362c0c1fe9" "c3bd2094f92d574377f7af2aec147ae181aa5f8e" "8eb12e4466cc73f2a95292073832878814b8ed31" "f979f98b8336ad0908f948aa7fe1d57d0a5b54f8")
CROS_WORKON_TREE=("bf0b6c5a4df7f8dde869d54d120ca702ace875d1" "781df7da13c4275a2328c09e75fd937991d80e29" "049362d45a6362cbdede3ebd10c38ed8d446410a" "5e9b76feda3289dee09bae902ba8d215058ab196")
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/zephyr"
	"chromiumos/third_party/zephyr/cmsis"
	"chromiumos/third_party/zephyr/hal_stm32"
	"chromiumos/platform/ec"
)
CROS_WORKON_LOCALNAME=(
	"third_party/zephyr/main/v2.5"
	"third_party/zephyr/cmsis/v2.5"
	"third_party/zephyr/hal_stm32/v2.5"
	"platform/ec"
)
CROS_WORKON_DESTDIR=(
	"${S}/zephyr-base"
	"${S}/modules/cmsis"
	"${S}/modules/hal_stm32"
	"${S}/modules/ec"
)

inherit cros-workon cros-unibuild coreboot-sdk toolchain-funcs

DESCRIPTION="Zephyr based Embedded Controller firmware"
KEYWORDS="*"
LICENSE="Apache-2.0 BSD-Google"
IUSE="generated_cros_config"

BDEPEND="
	chromeos-base/chromeos-config
	chromeos-base/zephyr-build-tools
	dev-python/docopt
	dev-python/pykwalify
	dev-util/ninja
"

ZEPHYR_EC_BUILD_DIRECTORIES=()

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

		zmake \
			--modules-dir "${S}/modules" \
			--zephyr-base "${S}/zephyr-base" \
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
