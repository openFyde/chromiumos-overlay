# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

# This package has been _functionally_ removed. We let it hang around to avoid
# needing toolchain package rebuilds. It should be removed entirely once we
# update Rust again. See b/271306977 for more context.

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-llvm cros-constants cros-rustc-directories git-r3 python-single-r1

LICENSE="UoI-NCSA"
SLOT="8"
KEYWORDS="-* amd64"
S="${T}/no-sources"

IUSE="llvm-next llvm-tot"

src_unpack() {
	mkdir -p "${S}" || die
}

src_prepare() {
	eapply_user
}

src_compile() {
	true
}

src_install() {
	true
}
