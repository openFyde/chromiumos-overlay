# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("c9753eb7fb18af1ca0bb791735cf252be5a0a8d2" "0eef4c5574a033a5584a0711d332b41e01ab50c2" "6a51cb90f0fe7af417ccefaffec31e7433d8b1e9" "8eb6edf6e05c2328605ad351da806fa37cefc068" "c12f2212e2580bde4626711045db9d1dfd65f66d")
CROS_WORKON_TREE=("8e0295520ae330625a8819afb8f95f6f0389504a" "b179ccd74d7d387aea458358f205107cb12fddd9" "3d917cf633816369394b66d1e1eab55a8584ab13" "bea004e95973d9e20bbeb07189966519fc74e8e4" "b1b14fa426187d55338b61fd1404512de9891a60")
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
