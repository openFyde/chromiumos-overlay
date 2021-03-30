# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="dfc74cb0dd7a30a12bed776a13713b730a149d5b"
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "0e4135d4dc8325b7f1b1a60191fe49310872e4cc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk sirenia .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="sirenia/manatee-client"

inherit cros-workon platform

DESCRIPTION="Chrome OS ManaTEE D-Bus client library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings
"

src_install() {
	# Install D-Bus client library.
	platform_install_dbus_client_lib "manatee"
}
