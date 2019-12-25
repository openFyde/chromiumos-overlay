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

CROS_WORKON_COMMIT=("cac35234cfdb2c2c8950afb9379d7038db475318" "f4428141132ec85eb255a819fc5bdaea2303f6af" "e05bfa91102dd5137b4027b4f3405e041ffe2c32")
CROS_WORKON_TREE=("ce5cfbda9d7422013bf4e8525c7fa28fa016f0d4" "4b0eaae00da0418755628097981bf4013f92a3a6" "1f42f6d549ba7b3f6bc5d67029984b113787ae0d")
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

# Make sure config tools use the latest schema.
BDEPEND=">=chromeos-base/chromeos-config-host-0.0.2"

MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
DESCRIPTION="Embedded Controller firmware code"
KEYWORDS="*"
