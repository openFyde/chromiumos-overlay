# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_GO_SOURCE="github.com/BurntSushi/toml v${PV}"

inherit cros-go

DESCRIPTION="TOML parser for Golang with reflection."
HOMEPAGE="https://github.com/BurntSushi/toml"
SRC_URI="$(cros-go_src_uri)"


LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND="${DEPEND}"
