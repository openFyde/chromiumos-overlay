# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="a956e6592ab743c710ad40602b21c3519e3c5feb"
CROS_WORKON_TREE="37e6e5c6036263030a215e50daed6233274097a4"
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
	media-libs/vulkan-loader
	virtual/vulkan-icd
"
DEPEND="${RDEPEND}"
