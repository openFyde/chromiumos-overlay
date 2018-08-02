# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

CROS_WORKON_COMMIT="7a4c1d07ea6e836d9bbf9717d0e862550601d5bb"
CROS_WORKON_TREE="bfe5f399261ae7dee8e42d7a27dd1574bae265a1"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="ec"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Exported headers from the embedded controller codebase."
HOMEPAGE="https://www.chromium.org/chromium-os/ec-development"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND=""

# No configuration or compilation necessary. This is a header only package.
src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/include/trunks/cr50_headers/
	doins include/pinweaver_types.h
}
