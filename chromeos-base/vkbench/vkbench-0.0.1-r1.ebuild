# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="93cc68993c8e861c74b565e1537cc497bf9ff4c9"
CROS_WORKON_TREE="55f30b68483e6501125782f788143a6dabf06bab"
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
