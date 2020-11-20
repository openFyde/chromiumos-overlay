# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="6765a858b2d59373393b99d12aa0d21d5bebb85e"
CROS_WORKON_TREE="3f9b6d760774186b4ab09f2532da94991e6c64b1"
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
