# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="52bb12df7f36925c3913faae70581607c2f3cfc5"
CROS_WORKON_TREE=("8e516de8961c22228293b5d8bc6c23905f116abd" "12af1b9e27ddc397654fbe16460d9dd290ddb285" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
