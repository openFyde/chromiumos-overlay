# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="7a7b1dd6e72bf117d45ebce5106d109bda394a4b"
CROS_WORKON_TREE=("3ad7a81ced8374a286e1c564a6e9c929f971a655" "edeb043b1f6b7c2fa3cac02ea33c7300345ee56c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

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
