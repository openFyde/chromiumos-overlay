# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("b60a603c43372e76a210535c8fb72a6726dec4f1" "98e4da99997a020f8aba11b2cfc7edaf67376677")
CROS_WORKON_TREE=("242875fedc197cb805b586b4e9f90c1e7c672719" "60b047cee412ea058a598434107f50c3c0f54976")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/platform/ec"
)
CROS_WORKON_LOCALNAME=(
	"platform/ec"
	"platform/cr50"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/platform/cr50"
)
CROS_WORKON_EGIT_BRANCH=(
	"master"
	"cr50_stab"
)

CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="Exported headers from the embedded controller codebase."
HOMEPAGE="https://www.chromium.org/chromium-os/ec-development"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND=""

# No configuration or compilation necessary. This is a header only package.
src_configure() { :; }
src_compile() { :; }

src_install() {
	dir_ec=${CROS_WORKON_DESTDIR[0]}
	dir_cr50=${CROS_WORKON_DESTDIR[1]}

	insinto /usr/include/trunks/cr50_headers/
	doins "${dir_cr50}"/include/pinweaver_types.h
	doins "${dir_cr50}"/include/u2f.h
	doins "${dir_cr50}"/board/cr50/tpm2/virtual_nvmem.h
	insinto /usr/include/chromeos/ec/
	doins "${dir_ec}"/include/ec_commands.h
	doins "${dir_ec}"/util/cros_ec_dev.h
}
