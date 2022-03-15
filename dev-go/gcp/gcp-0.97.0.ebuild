# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

# The dev-go/gcp* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/GoogleCloudPlatform/google-cloud-go:cloud.google.com/go v${PV}"

CROS_GO_PACKAGES=(
	"cloud.google.com/go/civil"
	"cloud.google.com/go/internal"
	"cloud.google.com/go/internal/fields"
	"cloud.google.com/go/internal/optional"
	"cloud.google.com/go/internal/trace"
	"cloud.google.com/go/internal/version"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

# temporary cyclic dep workaround until we switch to modules mode
CROS_GO_SKIP_DEP_CHECK="1"

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
	dev-go/cmp
	dev-go/gapi
	dev-go/genproto
	dev-go/net
	dev-go/protoc-gen-go-grpc
"
RDEPEND="
	${DEPEND}
	!dev-go/gcp-internal
	!dev-go/gcp-civil
"
