# Copyright 2012 The ChromiumOS Authors
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
# "cros-ec.eclass" to work around https://issuetracker.google.com/201299127.
#
# eclass bug workaround count: 8

EAPI=7

CROS_WORKON_COMMIT=("3a42279061d17d3a63d4965c90053be93e89e800" "0dd679081b9c8bfa2583d74e3a17a413709ea362" "3564668908afc66351c1c3cc47dca2fcdb91dc12")
CROS_WORKON_TREE=("a55c4fc08b0b084e5818f7aa1c6d083c9765083a" "d99abee3f825248f344c0638d5f9fcdce114b744" "0797c8b1cea2a671b81642618c279994d2275cc6")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/cryptoc"
	"external/gitlab.com/libeigen/eigen"
)
CROS_WORKON_LOCALNAME=(
	"platform/ec"
	"third_party/cryptoc"
	"third_party/eigen3"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/cryptoc"
	"${S}/third_party/eigen3"
)

inherit cros-ec cros-workon

# Make sure config tools use the latest schema.
BDEPEND=">=chromeos-base/chromeos-config-host-0.0.2"

MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
DESCRIPTION="Embedded Controller firmware code"
KEYWORDS="*"

# Restrict strip because chromeos-ec package installs unstrippable firmware.
RESTRICT="strip"
