# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="6f66a0a4ddc1910facc9c82f4e887a45e2f84f9f"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "942e5bce2836cc95b4dc9b416d02e2fee3435359" "a107bda06bdcf45088d2aecf0d50b69804adfd69" "4c9eefb2d1dcc8e84870d96a4012e66afc4b4b92" "017dc03acde851b56f342d16fdc94a5f332ff42e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/diagnostics common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/diagnostics"

inherit cros-camera cros-workon platform

DESCRIPTION="ChromeOS camera diagnostics service."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/libbrillo:="
