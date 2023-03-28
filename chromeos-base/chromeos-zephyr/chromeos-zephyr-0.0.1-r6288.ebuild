# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("8a60355b1a14c509eeff03cb5f1ab8ae99e550f8" "4aa3ff8e4f8a21e31cd9831b943acb7a7cd56ac8" "5409dbf10fbde388420df341b37a12060c3ac966" "12b923775846d0bc4b3d77b8cefe9c244e49d8a9" "bb99f17a1b33b8dc4ebda7a4f485fa88d9b866ab")
CROS_WORKON_TREE=("5223c45a11a36a43ff1b3c2b2b5650875b1601b6" "138873733c30ba5508dd4baf0ced9828ec3a2398" "0dea9f3a2c372a86ab2f4eb244223a367cafbcb7" "312779b87ee6f40d9ef20ea0bfdf205042228022" "a83b0bb97b6d0931463ad013bd458f832a77149e")
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

PYTHON_COMPAT=( python3_{8..9} )
unset PYTHON_COMPAT_OVERRIDE

inherit cros-workon cros-unibuild coreboot-sdk toolchain-funcs python-any-r1

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

echoit() {
	echo "$@"
	"$@"
}

# Run zmake from the EC source directory, with default arguments for
# modules and Zephyr base location for this ebuild.
run_zmake() {
	echoit env PYTHONPATH="${S}/modules/ec/zephyr/zmake" "${EPYTHON}" -m zmake -D \
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
	if [[ ${#projects[@]} -eq 0 ]]; then
		einfo "No projects found."
		return
	fi
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
