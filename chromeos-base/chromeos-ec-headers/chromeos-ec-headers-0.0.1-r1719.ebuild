# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

CROS_WORKON_COMMIT="ef56aef9d6eb4d6430109c833dfd5829f2b2117c"
CROS_WORKON_TREE="da717c9ded21d37c02924aaa296821c97b379ae8"
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
	doins include/u2f.h
	doins board/cr50/tpm2/virtual_nvmem.h
	insinto /usr/include/chromeos/ec/
	doins include/ec_commands.h
	doins util/cros_ec_dev.h
}
