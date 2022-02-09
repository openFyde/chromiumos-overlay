# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="chromium.googlesource.com/chromiumos/infra/proto:go.chromium.org/chromiumos/infra/proto 3b9d473de0fec93ded28a89eaf1776ebcf200ccf"

CROS_GO_PACKAGES=(
	"go.chromium.org/chromiumos/infra/proto/go/chromite/api"
	"go.chromium.org/chromiumos/infra/proto/go/chromiumos"
	"go.chromium.org/chromiumos/infra/proto/go/device"
	"go.chromium.org/chromiumos/infra/proto/go/lab"
	"go.chromium.org/chromiumos/infra/proto/go/manufacturing"
	"go.chromium.org/chromiumos/infra/proto/go/testplans"
	"go.chromium.org/chromiumos/infra/proto/go/test_platform"
	"go.chromium.org/chromiumos/infra/proto/go/test_platform/execution"
)

inherit cros-go

DESCRIPTION="Go bindings for ChromiumOS infra protocol buffers."
HOMEPAGE="chromium.googlesource.com/chromiumos/infra/proto"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
"
RDEPEND="${DEPEND}"
