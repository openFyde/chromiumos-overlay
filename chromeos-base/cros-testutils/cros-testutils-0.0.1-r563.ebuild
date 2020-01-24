# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3f49c6d4c3b028ffb39d83fb42574ea95232a0fc"
CROS_WORKON_TREE="d17537de10cb77bef87d916a0fa03806618ec12c"
CROS_WORKON_PROJECT="chromiumos/platform/crostestutils"
CROS_WORKON_LOCALNAME="platform/crostestutils"

inherit cros-workon

DESCRIPTION="Host test utilities for ChromiumOS"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
KEYWORDS="*"

RDEPEND="app-emulation/qemu
	app-portage/gentoolkit
	app-shells/bash
	chromeos-base/cros-devutils
	dev-python/django
	"

# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

# Use default src_compile and src_install which use Makefile.
