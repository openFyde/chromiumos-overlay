# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="go.googlesource.com/text:golang.org/x/text v${PV}"

CROS_GO_PACKAGES=(
	"golang.org/x/text/encoding"
	"golang.org/x/text/encoding/charmap"
	"golang.org/x/text/encoding/internal"
	"golang.org/x/text/encoding/internal/identifier"
	"golang.org/x/text/internal/gen"
	"golang.org/x/text/internal/testtext"
	"golang.org/x/text/internal/ucd"
	"golang.org/x/text/secure/bidirule"
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/bidi"
	"golang.org/x/text/unicode/cldr"
	"golang.org/x/text/unicode/norm"
	"golang.org/x/text/unicode/rangetable"
	"golang.org/x/text/unicode/runenames"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Go text processing support"
HOMEPAGE="https://golang.org/x/text"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
