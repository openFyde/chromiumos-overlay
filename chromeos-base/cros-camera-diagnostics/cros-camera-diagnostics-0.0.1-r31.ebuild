# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="05ab294b418ff95d6328e9f63cb8857cbabb9ff4"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6a208d3bace261bf98c78f08d147fe0e348a362d" "db263a10cec3fc724e82e1f6615e51abad77eae7" "a9a0ffa59bdd3d5f4dbcef883804d59c3b909b69" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "af4c417db66feabd270022c8ba1fd494c37b5543" "b22d37072ba4d5aec5ad10140a826f42281ddd3e" "66d9ece0c55ff21826b4962ffd402f0927467387")
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
