# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="go.googlesource.com/oauth2:golang.org/x/oauth2 d3ed0bb246c8d3c75b63937d9a5eecff9c74d7fe"

CROS_GO_PACKAGES=(
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/authhandler"
	"golang.org/x/oauth2/internal"
	"golang.org/x/oauth2/jws"
	"golang.org/x/oauth2/jwt"
	"golang.org/x/oauth2/google"
	"golang.org/x/oauth2/google/internal/externalaccount"
)

CROS_GO_TEST=(
	"golang.org/x/oauth2"
	#Flaky: "golang.org/x/oauth2/internal"
	"golang.org/x/oauth2/jws"
	"golang.org/x/oauth2/jwt"
	# Needs to import "google.golang.org/appengine", which we don't have.
	# "golang.org/x/oauth2/google"
)

inherit cros-go

DESCRIPTION="Go packages for oauth2"
HOMEPAGE="https://golang.org/x/oauth2"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/gcp
	dev-go/gcp-compute
	dev-go/net
	dev-go/yaml:0
"
RDEPEND="${DEPEND}"
