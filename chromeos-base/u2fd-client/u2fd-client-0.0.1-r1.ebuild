# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3924c79bdc9569c1ebabc185925f0232a30051fe"
CROS_WORKON_TREE=("f7122dee369efc8a9c0fff9f33ad43b0ae9a9aef" "54a82795ad8487a5855a632e5cd94d3d38236927" "94de05f782f31a1b409ff1d2266e170138b762a1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd/client"

inherit cros-workon platform

DESCRIPTION="U2FHID library used by the internal corp U2F library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd/client/"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/trunks:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_install
}
