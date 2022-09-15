# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="70b7c0fe69fc37bf005118386060f202c646d480"
CROS_WORKON_TREE="68ad9dc667dbfc05950eff08092c1b76cb752d3c"
CROS_WORKON_LOCALNAME="platform/vkbench"
CROS_WORKON_PROJECT="chromiumos/platform/vkbench"

inherit cros-workon cmake-utils

DESCRIPTION="Microbenchmark for vulkan"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vkbench/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="vulkan"

REQUIRED_USE="vulkan"

BDEPEND="
	dev-util/glslang
"

RDEPEND="
	dev-libs/libfmt:=
	media-libs/libpng:=
	media-libs/vulkan-loader:=
	virtual/vulkan-icd:=
"
DEPEND="${RDEPEND}"
