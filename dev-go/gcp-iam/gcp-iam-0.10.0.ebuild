# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/gcp* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/googleapis/google-cloud-go:cloud.google.com/go iam-v${PV}"

CROS_GO_PACKAGES=(
	"cloud.google.com/go/iam"
	"cloud.google.com/go/iam/apiv1"
	"cloud.google.com/go/iam/apiv1/iampb"
	"cloud.google.com/go/iam/internal"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Google Cloud Client Libraries of IAM APIs for Go"
HOMEPAGE="https://code.googlesource.com/gocloud"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/gapi
	dev-go/gax:1
	dev-go/genproto
	dev-go/grpc
	dev-go/net
	dev-go/protobuf-legacy-api
"
RDEPEND="${DEPEND}"
