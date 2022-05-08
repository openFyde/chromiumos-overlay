# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Virtual for the Rust language compiler"
HOMEPAGE=""

LICENSE="metapackage"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE="cros_host"

BDEPEND="
	~dev-lang/rust-host-${PV}:=
	!cros_host? ( ~dev-lang/rust-${PV}:= )
"
