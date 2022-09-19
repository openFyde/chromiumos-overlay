# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=7

CROS_WORKON_COMMIT=("846346485935f43b32dfd69dafcd6baf73593926" "c399a99704a564b9999825703b580fd77417a272" "5db03c9bca230294a8823110483931d28f0a6dd6" "0cdcea9140d23ce6f739850f93dcf3a2f4f6e4d4" "e85108001be41a93a6bbfc0e44390a1c7dde8c6c")
CROS_WORKON_TREE=("79870dc7622b4fa3e2a349ca62eb95337e73713e" "3e12f640d18b79a983eaf2a2a4bdf1b9ff128f15" "546d11b8021d2f0fd96093aeba43e72856267c56" "b7cd5b19f195084b4849c677b63f4e4288042998" "604ef6f121cbc706fad5995ef0c9df86f75b8173")
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

echoit() {
	echo "$@"
	"$@"
}

# Run zmake from the EC source directory, with default arguments for
# modules and Zephyr base location for this ebuild.
run_zmake() {
	echoit env PYTHONPATH="${S}/modules/ec/zephyr/zmake" python3 -m zmake -D \
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
