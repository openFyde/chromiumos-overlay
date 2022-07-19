# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="9ee9b6c607d6ffefd1fa79709080a8a29ca77735"
CROS_WORKON_TREE=("89089130f6bfed5a958ea1add13c9b55e9258be8" "c895728ecb9b4c7bfb05f5af695e8da01e0bbacd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install
	platform_install_dbus_client_lib "runtime_probe"
}
