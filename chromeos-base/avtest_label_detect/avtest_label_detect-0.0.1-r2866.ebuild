# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="fca6461b71173517726ea32fd24a552f8392a6cf"
CROS_WORKON_TREE=("b5aa4e3640aa1e5657c8aaeebbc02636b9279212" "f9882c3e110954d1f7a6c8a37e48ff31a2a25081" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk avtest_label_detect .gn"

inherit cros-sanitizers cros-workon cros-common.mk

DESCRIPTION="Autotest label detector for audio/video/camera"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/avtest_label_detect"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan vaapi"

RDEPEND="vaapi? ( x11-libs/libva )"
DEPEND="${RDEPEND}"

src_unpack() {
	cros-workon_src_unpack
	S+="/avtest_label_detect"
}

src_configure() {
	export USE_VAAPI=$(usex vaapi)
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	# Install built tools
	pushd "${OUT}" >/dev/null
	dobin avtest_label_detect
	popd >/dev/null

	insinto /etc
	doins "${S}"/avtest_label_detect.conf
}
