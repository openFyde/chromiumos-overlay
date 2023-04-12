# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="6d2cf50581e3401e7aee179f7e2e1263565dec65"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "f95a8c6f6415e4118a8ca857cc7b19ee75bde542" "8382512685d679dd033d07c31295df8160820113" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "0af044c76f0b25e30f8ac3df39b61e2d513957f8" "8fad85aa9518e1a0f04272ae9e077c4a4036297d" "73889d0041bcd8e88b0b6d54e8d40eb99eaac094")
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
