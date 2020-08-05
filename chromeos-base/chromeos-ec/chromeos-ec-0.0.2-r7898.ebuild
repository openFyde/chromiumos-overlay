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
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("980cf5248b8f5479f4f54f183a55611fbafc9478" "1e2e9d7183f545eefd1a86a07b0ab6f91d837a6c")
CROS_WORKON_TREE=("2ba93b871d5a08f5f5600a8e3fdc2b47b52c1db6" "fdbc51bbd5a7ee9d532ea1aa30cf21e57ca199db")
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
