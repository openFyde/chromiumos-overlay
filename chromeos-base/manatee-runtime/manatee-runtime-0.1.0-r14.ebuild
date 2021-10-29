# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cdc3a165042be1689e7914c227366d8779bc709a"
CROS_WORKON_TREE="d8bd1589e31caf545c930268d97122d9a6d41bc2"
CROS_RUST_SUBDIR="sirenia/manatee-runtime"

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Library for TEE apps to interact with sirenia."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-runtime/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="cros_host manatee"

DEPEND="
	chromeos-base/libsirenia:=
	dev-rust/libchromeos:=
	>=dev-rust/serde-1.0.114 <dev-rust/serde-2:=
	dev-rust/sync:=
	dev-rust/sys_util:=
"
RDEPEND="${DEPEND}"

BDEPEND="chromeos-base/sirenia-tools"

src_install() {
	# Install the crate.
	cros-rust_src_install

	# Install demo_app.
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/demo_app"

	# Install app manifest.
	local APP_MANIFEST="${S}/src/demo-app.json"
	tee_app_info_lint -R "${D}" -c "${APP_MANIFEST}" || die
	insinto /usr/share/manatee/templates
	doins "${APP_MANIFEST}"
}
