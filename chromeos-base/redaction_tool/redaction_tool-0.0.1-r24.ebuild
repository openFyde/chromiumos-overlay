# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("427105b989e24e9cf1c6666a9bf97b6289ff2ecf" "649e9a45c023170ed76b2f7a94cef4fd654cc0d8")
CROS_WORKON_TREE=("71a6d7914cd13df8d299f6853d4488c5b559fa54" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fa2d11ba3f3636d2cf7a6ab3908293c03c2075e")
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
