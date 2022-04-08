# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Abseil - C++ Common Libraries"
HOMEPAGE="https://abseil.io"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE=""

DEPEND="~dev-cpp/abseil-cpp-${PV}"
RDEPEND="${DEPEND}"
