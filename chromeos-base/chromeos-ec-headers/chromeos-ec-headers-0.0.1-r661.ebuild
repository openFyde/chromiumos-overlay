# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

CROS_WORKON_COMMIT="c321f0945bebd3e84edab78582fd01785f5e256b"
CROS_WORKON_TREE="8977090c8de4a40756334153e8176f6b6fd90cde"
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
	doins include/compile_time_macros.h
	doins include/ec_commands.h
	doins util/cros_ec_dev.h
}
