# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Op-Tee non-secure side client library and tee-supplicant"
HOMEPAGE="https://github.com/OP-TEE/optee_client"
SRC_URI="https://github.com/OP-TEE/optee_client/archive/refs/tags/${PV}.zip -> ${P}.zip"

LICENSE="BSD"
KEYWORDS="*"
SLOT="0"
IUSE=""

src_configure() {
	export CFG_TEE_FS_PARENT_PATH="/var/lib/oemcrypto/tee-supplicant"
}

# TODO(jkardatzke): Add an /etc/init file for tee-supplicant so it actually
# runs the daemon.
