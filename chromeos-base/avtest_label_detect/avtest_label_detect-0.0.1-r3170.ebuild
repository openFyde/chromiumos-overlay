# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="b493dd5021f363e786ae38e91cf1aacac4be09cd"
CROS_WORKON_TREE=("f905fe98db2d0449c22fbe838b6fd28cc89e5443" "83769ba7e15d5ed840caad27a192109f6aa46d5c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk avtest_label_detect .gn"

inherit cros-sanitizers cros-workon cros-common.mk

DESCRIPTION="Autotest label detector for audio/video/camera"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/avtest_label_detect"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan v4l2_codec vaapi"

RDEPEND="vaapi? ( x11-libs/libva )"
DEPEND="${RDEPEND}"

src_unpack() {
	cros-workon_src_unpack
	S+="/avtest_label_detect"
}

src_configure() {
	export USE_VAAPI=$(usex vaapi)
	export USE_V4L2_CODEC=$(usex v4l2_codec)
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
