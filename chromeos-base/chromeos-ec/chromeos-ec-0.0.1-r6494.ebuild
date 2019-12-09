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

EAPI=6

CROS_WORKON_COMMIT=("54da7ca73b726fe29a61ee5f7029c4b66619b239" "f4428141132ec85eb255a819fc5bdaea2303f6af" "e05bfa91102dd5137b4027b4f3405e041ffe2c32")
CROS_WORKON_TREE=("2af073ce2c11c8ca77e9fd527379c6e0e04b2d9c" "4b0eaae00da0418755628097981bf4013f92a3a6" "1f42f6d549ba7b3f6bc5d67029984b113787ae0d")
inherit cros-ec cros-workon

CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)
CROS_WORKON_LOCALNAME=(
	"ec"
	"../third_party/tpm2"
	"../third_party/cryptoc"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/tpm2"
	"${S}/third_party/cryptoc"
)

MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
CR50_ROS=(cr50.prod.ro.A.0.0.10 cr50.prod.ro.B.0.0.10)
SRC_URI="${CR50_ROS[@]/#/${MIRROR_PATH}}"
DESCRIPTION="Embedded Controller firmware code"
KEYWORDS="*"
