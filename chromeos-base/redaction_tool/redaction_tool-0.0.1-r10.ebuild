# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("ee11aa653a6e53c49ede4de52ac6f2280f2ffd73" "174dfcd0563ce97925be85006fce0f060d8f08b4")
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "53ddad1dbdc746b8f7e73421d4e9f9d2b5a54f3a")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/redaction_tool"
)

CROS_WORKON_LOCALNAME=(
	"platform2"
	"platform/redaction_tool"
)

CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	# This needs to be platform2/redaction_tool instead of
	# platform/redaction_tool because we are using the
	# platform2 build system.
	"${S}/platform2/redaction_tool"
)

CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="redaction_tool"

inherit cros-workon platform

DESCRIPTION="Redaction tool library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/redaction_tool"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

platform_pkg_test() {
	platform test_all
}
