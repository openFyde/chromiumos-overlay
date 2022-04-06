# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("fb671e9f9557d0df18a60e52a673e837fed77c62" "0eef4c5574a033a5584a0711d332b41e01ab50c2" "d16e7a96f91b3946b45b7572bf52f3b240d1f051" "8eb6edf6e05c2328605ad351da806fa37cefc068" "79b72fe36dd386a2ea964617db869248451bd9ff")
CROS_WORKON_TREE=("6b6e5983e8dcbb75a1877745909f1c0e4853d108" "b179ccd74d7d387aea458358f205107cb12fddd9" "46625c98b920e7af4d8ef956b12d29dccc94f20b" "bea004e95973d9e20bbeb07189966519fc74e8e4" "5df2097a5a4a1c7eed1130fcaa5adf34a6c9a460")
CROS_WORKON_USE_VCSID=1
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/zephyr"
	"chromiumos/third_party/zephyr/cmsis"
	"chromiumos/third_party/zephyr/hal_stm32"
	"chromiumos/third_party/zephyr/nanopb"
	"chromiumos/platform/ec"
)

CROS_WORKON_LOCALNAME=(
	"third_party/zephyr/main/"
	"third_party/zephyr/cmsis"
	"third_party/zephyr/hal_stm32"
	"third_party/zephyr/nanopb"
	"platform/ec"
)

CROS_WORKON_DESTDIR=(
	"${S}/zephyr-base"
	"${S}/modules/cmsis"
	"${S}/modules/hal_stm32"
	"${S}/modules/nanopb"
	"${S}/modules/ec"
)

inherit cros-workon cros-unibuild coreboot-sdk toolchain-funcs

DESCRIPTION="Zephyr based Embedded Controller firmware"
KEYWORDS="*"
LICENSE="Apache-2.0 BSD-Google"
IUSE="unibuild"
REQUIRED_USE="unibuild"

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

# Run zmake from the EC source directory, with default arguments for
# modules and Zephyr base location for this ebuild.
run_zmake() {
	PYTHONPATH="${S}/modules/ec/zephyr/zmake" python3 -m zmake -D \
		--modules-dir="${S}/modules" \
		--zephyr-base="${S}/zephyr-base" \
		"$@"
}

src_compile() {
	tc-export CC

	local project
	local root_build_dir="build"
	local projects=()

	while read -r _ && read -r project; do
		if [[ -z "${project}" ]]; then
			continue
		fi

		projects+=("${project}")
	done < <(cros_config_host "get-firmware-build-combinations" zephyr-ec || die)
	run_zmake build -B "${root_build_dir}" "${projects[@]}" \
		|| die "Failed to build ${projects[*]} in ${root_build_dir}."
}

src_install() {
	local firmware_name project
	local root_build_dir="build"

	while read -r firmware_name && read -r project; do
		if [[ -z "${project}" ]]; then
			continue
		fi

		insinto "/firmware/${firmware_name}"
		doins "${root_build_dir}/${project}"/output/*
	done < <(cros_config_host "get-firmware-build-combinations" zephyr-ec || die)
}
