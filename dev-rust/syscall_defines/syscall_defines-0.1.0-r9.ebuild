# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="853ecdb355d476d15bcdea4d9f5da9761100ede7"
CROS_WORKON_TREE="9add594cd5c861053853b840d374d4e835d5d734"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="syscall_defines"

inherit cros-workon cros-rust

DESCRIPTION="Linux syscall defines."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/HEAD/crosvm/syscall_defines"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="!!<=dev-rust/syscall_defines-0.1.0-r2"
