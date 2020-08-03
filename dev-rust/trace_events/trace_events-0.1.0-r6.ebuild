# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d565cc29fe7617433189357337f0010c560bf83c"
CROS_WORKON_TREE="e509681943a4a652c4575e6da2260621c04c8500"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=0
CROS_WORKON_SUBTREE="trace_events"

inherit cros-workon cros-rust

DESCRIPTION="Infrastructure for clients to emit trace events."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/trace_events/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="=dev-rust/libc-0.2*:=
	=dev-rust/criterion-0.2*:=
	>=dev-rust/serde_json-1:=
"

RDEPEND="!!<=dev-rust/trace_events-0.1.0-r2"

pkg_setup() {
	cros-rust_pkg_setup trace_events
	cros-rust_pkg_setup json_tracer
	cros-rust_pkg_setup trace_events_macros
}

src_unpack() {
	cros-workon_src_unpack
	S+="/trace_events"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run
}

src_test() {
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		ecargo_test
	fi
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
