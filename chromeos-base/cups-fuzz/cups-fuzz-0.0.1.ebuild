# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-fuzzer cros-sanitizers flag-o-matic libchrome

DESCRIPTION="Fuzzer for CUPS PPD functions"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan fuzzer"

RDEPEND="net-print/cups[fuzzer]"
DEPEND="${RDEPEND}"

# We really don't want to be building this otherwise.
REQUIRED_USE="fuzzer"

S="${WORKDIR}"

src_unpack() {
	default
	cp "${FILESDIR}"/* . || die
}

src_configure() {
	sanitizers-setup-env || die
	fuzzer-setup-binary || die
	append-ldflags "$(${CHOST}-cups-config --libs)"
	append-ldflags "$($(tc-getPKG_CONFIG) --libs libchrome-${BASE_VER})"
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags libchrome-${BASE_VER})"
}

src_compile() {
	emake cups_ppdopen_fuzzer
}

src_install() {
	fuzzer_install "${S}"/OWNERS cups_ppdopen_fuzzer
}
