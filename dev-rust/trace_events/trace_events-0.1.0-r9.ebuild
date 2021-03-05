# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="52f7d224416acd115a8d76bf0258d19bd5b0a1cd"
CROS_WORKON_TREE="e509681943a4a652c4575e6da2260621c04c8500"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=0
CROS_WORKON_SUBTREE="trace_events"

inherit cros-workon cros-rust

DESCRIPTION="Infrastructure for clients to emit trace events."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/trace_events/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="=dev-rust/libc-0.2*:=
	=dev-rust/criterion-0.2*:=
	>=dev-rust/serde_json-1:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!!<=dev-rust/trace_events-0.1.0-r2
"

pkg_setup() {
	cros-rust_pkg_setup trace_events
	cros-rust_pkg_setup json_tracer
	cros-rust_pkg_setup trace_events_macros
}

src_compile() {
	ecargo_build

	use test && ecargo_test --workspace --no-run
}

src_test() {
	cros-rust_src_test --workspace
}

src_install() {
	pushd trace_events > /dev/null || die
	cros-rust_publish trace_events "$(cros-rust_get_crate_version .)"
	popd > /dev/null || die
	pushd json_tracer > /dev/null || die
	cros-rust_publish json_tracer "$(cros-rust_get_crate_version .)"
	popd > /dev/null || die
	pushd trace_events_macros > /dev/null || die
	cros-rust_publish trace_events_macros "$(cros-rust_get_crate_version .)"
}

pkg_postinst() {
	cros-rust_pkg_postinst trace_events
	cros-rust_pkg_postinst json_tracer
	cros-rust_pkg_postinst trace_events_macros
}

pkg_prerm() {
	cros-rust_pkg_prerm trace_events
	cros-rust_pkg_prerm json_tracer
	cros-rust_pkg_prerm trace_events_macros
}
