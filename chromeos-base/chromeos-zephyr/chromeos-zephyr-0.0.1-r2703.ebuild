# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("06ae4e8b3b7bede223856b0b766b60cd3d74388b" "0eef4c5574a033a5584a0711d332b41e01ab50c2" "bfa3b34f638375b505004095ea3e7a60b3cc7788" "8eb6edf6e05c2328605ad351da806fa37cefc068" "2f73fa6752a877e27b2ca90aa49c3c3768455b42")
CROS_WORKON_TREE=("715746c619a30d2cbafcc9fd3cf56433ae65dcd4" "b179ccd74d7d387aea458358f205107cb12fddd9" "0806a13ff4dc41aca5ba34176c1b41611c195645" "bea004e95973d9e20bbeb07189966519fc74e8e4" "ac2bb02f969d37ba4f1bdea3d08423d335fd0cbb")
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
