# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0dc3b083454e0b25bfceff09c2f5d33f1652b28b"
CROS_WORKON_TREE="2d598ac3b388b2d28382d7df8e543afb8d59b7bd"
CROS_RUST_SUBDIR="common/balloon_control"

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"
CROS_WORKON_SUBDIRS_TO_COPY="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="APIs to allow external control of a virtio balloon device"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/common/balloon_control"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

src_unpack() {
	# Copy the CROS_RUST_SUBDIR to a new location in the $S dir to make sure cargo will not
	# try to build it as apart of the crosvm workspace.
	cros-workon_src_unpack
	if [ ! -e "${S}/${PN}" ]; then
		(cd "${S}" && ln -s "./${CROS_RUST_SUBDIR}" "./${PN}") || die
	fi
	S+="/${PN}"

	cros-rust_src_unpack
}
