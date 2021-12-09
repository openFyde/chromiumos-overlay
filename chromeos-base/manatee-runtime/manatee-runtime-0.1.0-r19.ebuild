# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3051b58a590e8e6c144b135e77b9cadafb3ddc5d"
CROS_WORKON_TREE="851cf3e29e42b276e6a9f9671db014f4e64838b8"
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
	>=dev-rust/assert_matches-1.5.0 <dev-rust/assert_matches-2.0.0:=
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
