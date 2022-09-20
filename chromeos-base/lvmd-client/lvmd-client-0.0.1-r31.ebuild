# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81c85c7ca40e9e50f90d05d741f3bd385c3f8448"
CROS_WORKON_TREE=("c70c24e7eeb0c8aad6108bedde29b6984f63cd54" "ce84baf98e58eae6fdd4ea2a1dd539ced96f9c6b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk lvmd .gn"

# This is where BUILD.gn is located.
# For platform2 projects, this indicates that GN should be used to build this
# package.
PLATFORM_SUBDIR="lvmd/client"

inherit cros-workon platform

DESCRIPTION="Lvmd DBus client library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/lvmd/"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""
DEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	# Install DBus client library.
	platform_install_dbus_client_lib "lvmd"
}
