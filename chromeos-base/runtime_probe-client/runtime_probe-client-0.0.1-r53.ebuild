# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="672b55bb3d3a5081b7d2bbdf23b7152068459089"
CROS_WORKON_TREE=("79cdd007ff69259efcaad08803ef2d1498374ec4" "82c0966b4d6a9afd04b53d31dce7ad2c03faa19a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk runtime_probe .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="runtime_probe/client"

inherit cros-workon platform

DESCRIPTION="Runtime Probe D-Bus client library for ChromiumOS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/runtime_probe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/runtime_probe
"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	platform_src_install
	platform_install_dbus_client_lib "runtime_probe"
}
