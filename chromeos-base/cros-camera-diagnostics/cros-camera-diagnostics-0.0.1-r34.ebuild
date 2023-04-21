# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="578002e99847450c1acf5fbdc217348022a7b6cb"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6c6fe21162ea08ec90c2c7d7674913fa726d72af" "d6fd3b776e23a8c6357d764ac884d2d4059ee377" "a9a0ffa59bdd3d5f4dbcef883804d59c3b909b69" "5e629c67fd59365eaddcda399ebb829ff0360349" "af4c417db66feabd270022c8ba1fd494c37b5543" "c5a3f846afdfb5f37be5520c63a756807a6b31c4" "66d9ece0c55ff21826b4962ffd402f0927467387")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo camera/diagnostics common-mk mojo_service_manager"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/diagnostics"

inherit cros-camera cros-workon platform

DESCRIPTION="ChromeOS camera diagnostics service."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/mojo_service_manager:="

DEPEND="${RDEPEND}"
