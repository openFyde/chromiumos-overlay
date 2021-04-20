# Copyright 2012 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild is *pending deletion* (see crrev.com/c/2837523 for the
# CL that actually does the deletion).  Set to the empty project so
# cros-workon stops trying to uprev it and we can delete it without
# constantly fighting merge conflicts.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

DESCRIPTION="coreboot's coreinfo payload"
HOMEPAGE="http://www.coreboot.org"
LICENSE="GPL-2"
KEYWORDS="-* ~amd64 ~x86"

inherit cros-workon
