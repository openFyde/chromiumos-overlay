# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Remove windows dependencies.
CROS_WORKON_COMMIT="278c84bfd03995394a1639e88c77784df4bf7afb"
CROS_WORKON_TREE=("787a46162f14892a7d2b4920f330f8a4cd750bc5" "fa91eb24f5d1f5d37f2b8765977fb8a265c0f9a6")
CROS_RUST_REMOVE_TARGET_CFG=1

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="cros_async"
CROS_WORKON_SUBDIRS_TO_COPY=("${CROS_RUST_SUBDIR}" .cargo)
CROS_WORKON_SUBTREE="${CROS_WORKON_SUBDIRS_TO_COPY[*]}"

# The version of this crate is pinned. See b/229016539 for details.
CROS_WORKON_MANUAL_UPREV="1"

inherit cros-workon cros-rust

DESCRIPTION="Rust async tools for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/cros_async"
LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/crosvm-base:=
	dev-rust/third-party-crates-src:=
	=dev-rust/anyhow-1*
	=dev-rust/cfg-if-1*
	dev-rust/data_model:=
	dev-rust/io_uring:=
	dev-rust/serde_keyvalue:=
	dev-rust/sync:=
	media-sound/audio_streams:=
"
RDEPEND="${DEPEND}
	!<=dev-rust/cros_async-0.1.0-r38"

src_prepare() {
	cros-rust_src_prepare

	# Use the ChromeOS copy of base instead of the crosvm copy.
	sed -i 's/^base = /crosvm-base = /g' "${S}/Cargo.toml"
	find "${S}" -iname '*.rs' -type f -exec \
		sed -i -e 's/^use base/use crosvm_base/g' \
			-e 's/\([^[:alnum:]_]\)base::/\1crosvm_base::/g' -- {} +

	# Replace the version in the sources with the ebuild version.
	# ${FILESDIR}/chromeos-version.sh sets the minor version 50 ahead to avoid
	# colliding with the version included by path.
	if [[ "${PV}" != 9999 ]]; then
		sed -i '0,/^version/{s/^version = .*$/version = "'"${PV}"'"/}' "${S}/Cargo.toml"
	fi
}

src_test() {
	# The io_uring implementation on kernels older than 5.10 was buggy so skip
	# them if we're running on one of those kernels.
	local cut_version="$(ver_cut 1-2 "$(uname -r)")"
	if ver_test "${cut_version}" -lt 5.10; then
		einfo "Skipping io_uring tests on kernel version < 5.10"
	# TODO: Enable tests on ARM once the emulator supports io_uring.
	elif ! cros_rust_is_direct_exec; then
		einfo "Skipping uring tests on non-x86 platform"
		local skip_tests=(
			ring
			io_ext
			timer::tests::one_shot
		)

		# We want word splitting here.
		# shellcheck disable=SC2046
		cros-rust_src_test -- $(printf -- "--skip %s\n" "${skip_tests[@]}")
	else
		cros-rust_src_test
	fi
}
