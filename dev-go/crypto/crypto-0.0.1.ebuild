# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="go.googlesource.com/crypto:golang.org/x/crypto 7e9105388ebff089b3f99f0ef676ea55a6da3a7e"

CROS_GO_PACKAGES=(
	"golang.org/x/crypto/ed25519"
	"golang.org/x/crypto/ed25519/internal/edwards25519"
	"golang.org/x/crypto/curve25519"
	"golang.org/x/crypto/ssh"
	"golang.org/x/crypto/ssh/agent"
	"golang.org/x/crypto/ssh/terminal"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Go supplementary cryptography libraries"
HOMEPAGE="https://golang.org/x/crypto"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
