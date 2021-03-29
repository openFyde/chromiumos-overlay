# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="9d14f8b297985ec80f05d14afd6378e3350e2c41"
CROS_WORKON_TREE="e5e0d0ca30d0ce803ca251a36026c0c2b6a47624"
CROS_WORKON_PROJECT="chromiumos/platform/go-seccomp"
CROS_WORKON_LOCALNAME="../platform/go-seccomp"

CROS_GO_PACKAGES=(
	"chromiumos/seccomp"
)

inherit cros-workon cros-go

DESCRIPTION="Go support for Chromium OS Seccomp-BPF policy files"
HOMEPAGE="https://chromium.org/chromium-os/developer-guide/chromium-os-sandboxing"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
