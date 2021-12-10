# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("7536021d56e14052a39c4bd3e33732ee01ae2ccc" "bfdc3dda56217570f94e31820b2b3741848f0ce4" "e71eed8d2f89fa1904836963b1a787a77c551c27" "32a21483d6586851edfa1d8491beb3df442e90c6" "454d2a2e159e4f61e47f6948ee919d4a13a03c30")
CROS_WORKON_TREE=("db5e821433b072da37b21a675453902e0b086843" "0ae11b7eabea480cedbd8344f4974ebe775f63ac" "9e47e03e4a4fdbd61fb468fa86ecbbb36b830415" "719a42d9d98358f9123acf2d8916ed9c1821d60b" "0a8334a6cb6fee4bf89ae8115834d0c3cb2c2a6d")
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

ZEPHYR_EC_BUILD_DIRECTORIES=()

# Run zmake from the EC source directory, with default arguments for
# modules and Zephyr base location for this ebuild.
run_zmake() {
	PYTHONPATH="${S}/modules/ec/zephyr/zmake" python3 -m zmake -D \
		--modules-dir="${S}/modules" \
		--zephyr-base="${S}/zephyr-base" \
		"$@"
}

src_configure() {
	tc-export CC

	local board project project_dir

	while read -r board && read -r project; do
		if [[ -z "${project}" ]]; then
			continue
		fi

		# TODO(jrosenth): remove below once all configs using project
		# name instead of path.
		project_dir="${S}/modules/ec/zephyr/${project}"
		if [[ -d "${project_dir}" ]]; then
			ewarn "Config zephyr-ec=${project} needs migrated to project name"
			project="${project_dir}"
		fi

		local build_dir="build-${board}"

		run_zmake configure "${project}" -B "${build_dir}" \
			|| die "Failed to configure ${build_dir}."

		ZEPHYR_EC_BUILD_DIRECTORIES+=("${build_dir}")
	done < <(cros_config_host "get-firmware-build-combinations" zephyr-ec || die)
}

src_compile() {
	tc-export CC

	for build_dir in "${ZEPHYR_EC_BUILD_DIRECTORIES[@]}"; do
		run_zmake build "${build_dir}" || die "Failed to build ${build_dir}."
	done
}

src_install() {
	for build_dir in "${ZEPHYR_EC_BUILD_DIRECTORIES[@]}"; do
		board="$(echo "${build_dir}" |cut -d/ -f1)"
		board="${board#build-}"

		insinto "/firmware/${board}"
		doins "${build_dir}"/output/*
	done
}
