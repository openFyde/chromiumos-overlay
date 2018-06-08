# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# Disable cros-workon auto-uprev since this is an external package.
# Must manage commit hash manually.
CROS_WORKON_BLACKLIST="1"
# The dev-go/gcp* packages are all built from this repo.  They should
# be updated together.
CROS_WORKON_COMMIT="v${PV}"
CROS_WORKON_PROJECT="external/github.com/GoogleCloudPlatform/google-cloud-go"
CROS_WORKON_DESTDIR="${S}/src/cloud.google.com/go"

CROS_GO_PACKAGES=(
	"cloud.google.com/go/bigquery"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-workon cros-go

DESCRIPTION="Google Cloud Client Libraries for Go"
HOMEPAGE="https://code.googlesource.com/gocloud"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
# Disable tests because they talk to the network
RESTRICT="binchecks strip test"

DEPEND="
	dev-go/gapi-bigquery
	dev-go/gapi-googleapi
	dev-go/gapi-iterator
	dev-go/gapi-option
	dev-go/gapi-storage
	dev-go/gapi-transport
	dev-go/gcp-civil
	dev-go/gcp-internal
	dev-go/genproto
"
RDEPEND="${DEPEND}"
