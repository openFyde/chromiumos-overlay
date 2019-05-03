# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="824a54b8fee4c536600a76e7729fbb086fb625f4"
CROS_WORKON_TREE="a1873829a84dc5841b95c2896c6a28a1eddea33e"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="vm_tools/p9"

inherit cros-fuzzer cros-workon cros-rust

DESCRIPTION="Server implementation of the 9P file system protocol"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools/p9/"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="fuzzer test"

DEPEND="
	dev-rust/libc:=
	~dev-rust/proc-macro2-0.4.21:=
	~dev-rust/quote-0.6.10:=
	~dev-rust/syn-0.15.21:=
"

get_crate_version() {
	local crate="$1"
	awk '/^version = / { print $3 }' "$1/Cargo.toml" | head -n1 | tr -d '"'
}

src_unpack() {
	cros-workon_src_unpack
	S+="/vm_tools/p9"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run

	if use fuzzer; then
		cd fuzz
		ecargo_build_fuzzer
	fi
}

src_test() {
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		ecargo_test
	fi
}

src_install() {
	pushd wire_format_derive > /dev/null
	local version="$(get_crate_version .)"
	cros-rust_publish wire_format_derive "${version}"
	popd > /dev/null

	version="$(get_crate_version .)"
	cros-rust_publish p9 "${version}"

	if use fuzzer; then
		fuzzer_install "${S}/fuzz/OWNERS" \
			"$(cros-rust_get_build_dir)/p9_tframe_decode_fuzzer"
	fi
}
