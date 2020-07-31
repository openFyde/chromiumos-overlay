# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_PROJECT=(
	"chromiumos/platform/zephyr-chrome"
	"chromiumos/third_party/zephyr"
	"chromiumos/third_party/zephyr/cmsis"
	"chromiumos/third_party/zephyr/hal_stm32"
)
CROS_WORKON_LOCALNAME=(
	"platform/zephyr-chrome"
	"third_party/zephyr/main/v2.3"
	"third_party/zephyr/cmsis/v2.3"
	"third_party/zephyr/hal_stm32/v2.3"
)
CROS_WORKON_DESTDIR=(
	"${S}/zephyr-chrome"
	"${S}/zephyr-base"
	"${S}/modules/cmsis"
	"${S}/modules/hal_stm32"
)

inherit cros-zephyr cros-workon

DESCRIPTION="Zephyr v2.3 based embedded controller firmware"
HOMEPAGE="http://src.chromium.org"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
