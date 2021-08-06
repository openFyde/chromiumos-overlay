# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("6e9c1b3a27c96267cda3329fdb50114a26bef9c3" "04f5e125aa9bb9d8543828a1a285b52abd0929aa")
CROS_WORKON_TREE=("bcab1a4bf140e7a65a899350a1917c8f6e7b7cf6" "51ece223d8eaa83c70d7e27ae29448aa01f259bf")
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
