# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="73b5031a6569fd5328b71e2ba7cd381d73be5374"
CROS_WORKON_TREE=("ef50bf4184c5fd9a70db57729617b66d9fc7ff59" "585af077146f2e4daaaec14eb5814cd8507e862c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk secure_erase_file .gn"

PLATFORM_SUBDIR="secure_erase_file"

inherit cros-workon platform

DESCRIPTION="Secure file erasure for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secure_erase_file/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
"

RDEPEND="
"
