# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a9e79d48a02e3c2b8a5728d13c7cfba62b15730e"
CROS_WORKON_TREE="6c56a58a6808e59bd763896a3b4e5fc1228d1c94"
CROS_WORKON_LOCALNAME="third_party/cups"
CROS_WORKON_PROJECT="chromiumos/third_party/cups"
CROS_WORKON_EGIT_BRANCH="cups-2-2-8"
CROS_WORKON_SUBTREE="fuzzers"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-fuzzer cros-sanitizers cros-workon flag-o-matic libchrome toolchain-funcs

DESCRIPTION="Fuzzer for PPD and IPP functions in CUPS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/cups/+/cups-2-2-8/fuzzers/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="asan fuzzer"

COMMON_DEPEND="net-print/cups:=[fuzzer]"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

# We really don't want to be building this otherwise.
REQUIRED_USE="fuzzer"

src_unpack() {
	cros-workon_src_unpack
}

src_configure() {
	sanitizers-setup-env || die
	fuzzer-setup-binary || die
	append-ldflags "$(${CHOST}-cups-config --libs)"
	local v="$(libchrome_ver)"
	append-ldflags "$($(tc-getPKG_CONFIG) --libs libchrome-"${v}")"
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags libchrome-"${v}")"
}

src_compile() {
	local build_dir="$(cros-workon_get_build_dir)"
	VPATH="${S}"/fuzzers emake -C "${build_dir}" cups_ppdopen_fuzzer
	VPATH="${S}"/fuzzers emake -C "${build_dir}" cups_ippreadio_fuzzer
}

src_install() {
	local build_dir="$(cros-workon_get_build_dir)"
	fuzzer_install "${S}"/fuzzers/OWNERS "${build_dir}"/cups_ppdopen_fuzzer
	fuzzer_install "${S}"/fuzzers/OWNERS "${build_dir}"/cups_ippreadio_fuzzer
}
