# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

# The dev-go/gcp* packages are all built from this repo. They should be updated
# together.
CROS_GO_SOURCE="github.com/GoogleCloudPlatform/google-cloud-go:cloud.google.com/go ae85bf6f82f4807ee46a814b416659cf0a766f0f"

CROS_GO_PACKAGES=(
	"cloud.google.com/go/storage"
	"cloud.google.com/go/storage/internal/apiv2"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Google Cloud Client Libraries for Go"
HOMEPAGE="https://code.googlesource.com/gocloud"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks"

DEPEND="
	dev-go/gapi
	dev-go/gcp-iam
	dev-go/gcp-internal
	dev-go/gcp-trace
	dev-go/genproto
"
RDEPEND="${DEPEND}"
