# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="github.com/shirou/gopsutil v${PV}"

CROS_GO_PACKAGES=(
	"github.com/shirou/gopsutil/..."
)

CROS_GO_TEST=(
	"github.com/shirou/gopsutil/cpu"
	"github.com/shirou/gopsutil/disk"
	# host fails due to missing /var/run/utmp in chroot.
	"github.com/shirou/gopsutil/internal/..."
	"github.com/shirou/gopsutil/load"
	# mem, net, and process require github.com/stretchr/testify/assert.
)

inherit cros-go

DESCRIPTION="Cross-platform lib for process and system monitoring in Go"
HOMEPAGE="https://github.com/shirou/gopsutil"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="test"
RESTRICT="binchecks strip"

DEPEND="
	dev-go/cmp
	dev-go/errcheck
	dev-go/go-sys
	dev-go/go-sysconf
	dev-go/testify
"
RDEPEND="${DEPEND}"
