# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

# f7b830d8df9f5578c748aa0283d44c59ea7eeb25 is the current version as of Sep 10, 2019.
CROS_GO_SOURCE="boringssl.googlesource.com/boringssl f7b830d8df9f5578c748aa0283d44c59ea7eeb25"

CROS_GO_PACKAGES=(
	"boringssl.googlesource.com/boringssl/util/fipstools/acvp/acvptool/acvp"
	"boringssl.googlesource.com/boringssl/util/fipstools/acvp/acvptool/subprocess"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="A tool for speaking to the NIST ACVP server."
HOMEPAGE="https://boringssl.googlesource.com/boringssl/+/master/util/fipstools/acvp/acvptool/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google SSLeay"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
