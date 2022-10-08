# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="306edb5a3e9b84e22b2b1e19b56330f87f05480f"
CROS_WORKON_TREE="8575bca0d1552392004e380023f4220582ec516f"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/balloon_control"
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
