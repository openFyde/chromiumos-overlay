# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="f682b7f5e291fe4165ff2687bb94f8ac27ef53f8"
CROS_WORKON_TREE="655ba0fa445d8e6982c97efde814b07aa778422c"
CROS_WORKON_PROJECT="chromiumos/platform/crostestutils"
CROS_WORKON_LOCALNAME="../platform/crostestutils"

CROS_GO_WORKSPACE="${S}/go"
CROS_GO_BINARIES=(
	"firmware/cmd/dut_info:/usr/bin/fw_dut_info"
	"firmware/cmd/e2e_coverage_summarizer:/usr/bin/fw_e2e_coverage_summarizer"
	"firmware/cmd/lab_triage_helper:/usr/bin/fw_lab_triage_helper"
)

inherit cros-go cros-workon

DESCRIPTION="Tooling related to firmware release testing."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crostestutils/+/HEAD/go/src/firmware/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-go/crypto:=
	dev-go/gapi-discovery:=
	dev-go/gapi-option:="
RDEPEND=""
