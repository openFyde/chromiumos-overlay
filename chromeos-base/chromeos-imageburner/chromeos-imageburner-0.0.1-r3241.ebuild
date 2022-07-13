# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="0820492ee68f354de8640570fa57daa5e24ef0d6"
CROS_WORKON_TREE=("e747749e00f36b7c255da2376d5f0e9989bcd2f9" "7de555b069d818f590b242435b6c4ec9630b8ead" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk image-burner .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="image-burner"

inherit cros-workon platform user

DESCRIPTION="Image-burning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/image-burner/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="user_session_isolation"

RDEPEND="
	sys-apps/rootdev
"
DEPEND="${RDEPEND}
	chromeos-base/system_api
"

pkg_preinst() {
	# Create user and group for image-burner.
	enewuser "image-burner"
	enewgroup "image-burner"
}

src_install() {
	platform_install

	# TODO(crbug/766130): Remove the following sed block when non-root mount
	# namespace is by default enabled.
	# Remove the env var value related to mount namespace if USE flag
	# user_session_isolation is not present.
	if ! use user_session_isolation; then
		sed -i -e "/env MNT_NS_ARGS=/s:=.*:=:" \
			"${D}"/etc/init/image-burner.conf || die
	fi
}

platform_pkg_test() {
	platform test_all
}
