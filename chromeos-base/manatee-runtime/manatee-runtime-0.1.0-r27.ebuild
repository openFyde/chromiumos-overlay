# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="dfd81ad0b536a7a262dd724d71d2ba3435ed6509"
CROS_WORKON_TREE="58043d0f51323129adf2a3ebee19a7347fac6035"
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
	=dev-rust/anyhow-1*:=
	=dev-rust/assert_matches-1*:=
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*:=
	=dev-rust/once_cell-1*:=
	=dev-rust/serde-1*:=
	=dev-rust/serde_bytes-0.10*:=
	=dev-rust/stderrlog-0.5*:=
	dev-rust/sync:=
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
