# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="524fc3b5d46ca8fb7025cf29457592862e6c6d0c"
CROS_WORKON_TREE="59333df2557725480b2562db5ce43587955a56ab"
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
