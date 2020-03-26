# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="github.com/alfg/mp4 3ca65fbae6c4a69c81de063961460b056535498a"

CROS_GO_PACKAGES=(
	"github.com/alfg/mp4/..."
)

inherit cros-go

DESCRIPTION="Golang Package for ISO/IEC 14496-12 - ISO Base Media File Format (QuickTime, MPEG-4, etc)"
HOMEPAGE="https://github.com/alfg/mp4"
SRC_URI="$(cros-go_src_uri)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
