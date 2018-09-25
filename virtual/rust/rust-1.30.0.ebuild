# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

DESCRIPTION="Virtual for the Rust language compiler"
HOMEPAGE=""

ABI_VER="$(get_version_component_range 1-2)"

LICENSE=""
SLOT="0/${ABI_VER}"
KEYWORDS="*"

DEPEND="
	=dev-lang/rust-${PV}:=
"
