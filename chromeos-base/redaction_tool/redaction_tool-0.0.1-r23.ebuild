# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("e364b159e56f23ece2af994214187c650908d14f" "649e9a45c023170ed76b2f7a94cef4fd654cc0d8")
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fa2d11ba3f3636d2cf7a6ab3908293c03c2075e")
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
