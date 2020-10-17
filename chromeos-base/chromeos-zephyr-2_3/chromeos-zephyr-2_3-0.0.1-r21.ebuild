# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("d55a1453aa6a4c860682b41bc92c8cc59b708809" "3d45bbfa2d7a20159cc65eefe8be697f3c5ef4f2" "542b2296e6d515b265e25c6b7208e8fea3014f90" "d1bc80d021f4ebc31f6e8b36f14b738cc26c7b03")
CROS_WORKON_TREE=("4d4da5c76d4855588f71ff5485f3779e4a9e8cb3" "c8b449c296158acf7ce11ac65e2ac577247560da" "c7037905e78a10c0920e0834700c2b5888c8d114" "cbfc2404c2e411908f5e8db083daf3041b408522")
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
KEYWORDS="*"
