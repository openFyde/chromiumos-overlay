# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/gcp* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/GoogleCloudPlatform/google-cloud-go:cloud.google.com/go v${PV}"

CROS_GO_PACKAGES=(
	"cloud.google.com/go/internal"
	"cloud.google.com/go/internal/fields"
	"cloud.google.com/go/internal/optional"
	"cloud.google.com/go/internal/trace"
	"cloud.google.com/go/internal/version"
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
RESTRICT="binchecks strip"

DEPEND="
	dev-go/gapi-googleapi
	dev-go/gapi-iterator
	dev-go/gapi-transport
	dev-go/grpc
	dev-go/gax:1
	dev-go/genproto
	dev-go/net
	dev-go/martian
	dev-go/opencensus
	dev-go/protoc-gen-go-grpc
"
RDEPEND="${DEPEND}"
