# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cryptohome .gn"

PLATFORM_SUBDIR="cryptohome/client"

inherit cros-workon platform

DESCRIPTION="Cryptohome D-Bus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/cryptohome"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="cros_host"

# D-Bus proxies generated by this client library depend on the code generator
# itself (chromeos-dbus-bindings) and produce header files that rely on
# libbrillo library, hence both dependencies. We require the particular
# revision because libbrillo-0.0.1-r1 changed location of header files from
# chromeos/ to brillo/ and chromeos-dbus-bindings-0.0.1-r1058 generates the
# code using the new location.
DEPEND="
	cros_host? ( >=chromeos-base/chromeos-dbus-bindings-0.0.1-r1058 )
"

RDEPEND="
	!<chromeos-base/cryptohome-0.0.1
"

src_install() {
	# Install D-Bus client library.
	platform_install_dbus_client_lib "cryptohome"
}
