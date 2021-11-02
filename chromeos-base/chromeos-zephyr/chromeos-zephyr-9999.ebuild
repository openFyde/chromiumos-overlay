# Copyright (C) 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

ZEPHYR_VERSIONS=( v2.7 )

CROS_WORKON_USE_VCSID=1
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/zephyr/cmsis"
	"chromiumos/third_party/zephyr/hal_stm32"
	"chromiumos/third_party/zephyr/nanopb"
	"chromiumos/platform/ec"
)
for v in "${ZEPHYR_VERSIONS[@]}"; do
	CROS_WORKON_PROJECT+=("chromiumos/third_party/zephyr")
done

CROS_WORKON_LOCALNAME=(
	"third_party/zephyr/cmsis"
	"third_party/zephyr/hal_stm32"
	"third_party/zephyr/nanopb"
	"platform/ec"
)
for v in "${ZEPHYR_VERSIONS[@]}"; do
	CROS_WORKON_LOCALNAME+=("third_party/zephyr/main/${v}")
done

CROS_WORKON_DESTDIR=(
	"${S}/modules/cmsis"
	"${S}/modules/hal_stm32"
	"${S}/modules/nanopb"
	"${S}/modules/ec"
)
for v in "${ZEPHYR_VERSIONS[@]}"; do
	CROS_WORKON_DESTDIR+=("${S}/zephyr-base/${v}")
done

inherit cros-workon cros-unibuild coreboot-sdk toolchain-funcs

DESCRIPTION="Zephyr based Embedded Controller firmware"
KEYWORDS="~*"
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

	die "Please specify a zephyr_vX_X USE flag."
}

# Run zmake from the EC source directory, with default arguments for
# modules and Zephyr base location for this ebuild.
run_zmake() {
	PYTHONPATH="${S}/modules/ec/zephyr/zmake" python3 -m zmake -D \
		--modules-dir="${S}/modules" \
		--zephyr-base="${S}/zephyr-base/$(get_zephyr_version)" \
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
