# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# A note about this ebuild: this ebuild is Unified Build enabled but
# not in the way in which most other ebuilds with Unified Build
# knowledge are: the primary use for this ebuild is for engineer-local
# work or firmware builder work. In both cases, the build might be
# happening on a branch in which only one of many of the models are
# available to build. The logic in this ebuild succeeds so long as one
# of the many models successfully builds.

# Increment the "eclass bug workaround count" below when you change
# "cros-ec.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 2

EAPI=7

CROS_WORKON_COMMIT=("e26814fbbfb2c89ae4971b4707bbc836f3e8aa3f" "3830fffbc5c5205bb8fb1b9f366fe44559923592")
CROS_WORKON_TREE=("1bdfac763a856510eb66c3414388ead7dc8f64c1" "f3d026c790bd3d7121bb96ed2a4932360d698a73")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/cryptoc"
)
CROS_WORKON_LOCALNAME=(
	"platform/ec"
	"third_party/cryptoc"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/cryptoc"
)

inherit cros-ec cros-workon

# Make sure config tools use the latest schema.
BDEPEND=">=chromeos-base/chromeos-config-host-0.0.2"

MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
DESCRIPTION="Embedded Controller firmware code"
KEYWORDS="*"
