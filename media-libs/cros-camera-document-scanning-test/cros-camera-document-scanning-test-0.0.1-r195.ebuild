# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="05ab294b418ff95d6328e9f63cb8857cbabb9ff4"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6a208d3bace261bf98c78f08d147fe0e348a362d" "a215e45ca182155f6e3ad1205087f5a88bc2c4df" "b22d37072ba4d5aec5ad10140a826f42281ddd3e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/features/document_scanning common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/document_scanning"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera Document Scanning test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"
