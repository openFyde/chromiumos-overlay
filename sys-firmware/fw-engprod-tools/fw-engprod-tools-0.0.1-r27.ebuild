# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="2bf4943e8b2e375e018d1ad6046b527aa63a4a32"
CROS_WORKON_TREE="8a5842d6c34fe670caa99df271f56ef60dae696f"
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
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crostestutils/+/refs/heads/master/go/src/firmware/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-go/crypto:=
	dev-go/gapi-discovery:=
	dev-go/gapi-option:="
RDEPEND=""
