# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="53230a2f6406b51fdaa6e388816df6a16e9ef2f7"
CROS_WORKON_TREE="87fd691f44cff0bfb97069288c513c14cff26903"
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
	media-libs/libpng:=
	media-libs/vulkan-loader:=
	virtual/vulkan-icd:=
"
DEPEND="${RDEPEND}"
