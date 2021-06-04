# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="tempfile"

inherit cros-workon cros-rust

DESCRIPTION="A library for managing temporary files and directories"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/tempfile"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="test"

DEPEND="
	=dev-rust/cfg-if-0.1*:=
	>=dev-rust/libc-0.2.27:=
	=dev-rust/rand-0.6*:=
	=dev-rust/redox_syscall-0.1*:=
	=dev-rust/remove_dir_all-0.5*:=
	=dev-rust/winapi-0.3*:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!!<=dev-rust/tempfile-3.0.7-r2
"
