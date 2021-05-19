# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b15630d225145b9dc8603b8f500e68954c25fd3f"
CROS_WORKON_TREE="d82e84546e6140f16431633e392a549997ff27f9"
CROS_RUST_SUBDIR="sirenia/manatee-runtime"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Library for TEE apps to interact with sirenia."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-runtime/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="cros_host manatee"

RDEPEND=""

DEPEND="${RDEPEND}
	chromeos-base/libsirenia:=
	dev-rust/libchromeos:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	dev-rust/sync:=
	dev-rust/sys_util:=
"

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"

	# Needed for initramfs, but not for the root-fs.
	if use cros_host ; then
		# /build is not allowed when installing to the host.
		exeinto "/bin"
	else
		exeinto "/build/initramfs"
	fi

	if use manatee ;  then
		doexe "${build_dir}/demo_app"
	else
		dobin "${build_dir}/demo_app"
	fi
}
