# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5106cfd0d4eeae62b70cad2fe296f27f7e172e72"
CROS_WORKON_TREE="ecd02dadf294b42f30f1c832c2befcea5db554bf"
CROS_RUST_SUBDIR="libchromeos-rs"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="A Rust utility library for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libchromeos-rs/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="chromeos-base/system_api:=
	sys-apps/dbus:=
	dev-rust/data_model:=
	=dev-rust/futures-0.3*:=
	=dev-rust/getopts-0.2*:=
	=dev-rust/intrusive-collections-0.9*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	>=dev-rust/protobuf-2.1:=
	!>=dev-rust/protobuf-3.0:=
"

RDEPEND="!!<=dev-rust/libchromeos-0.1.0-r2"

src_test() {
	# TODO(1157860) Portage already runs tests in parallel and these tests appear
	# to be load sensitive. Decide if the failures need fixes or if --test-threads=1
	# should stay.
	cros-rust_src_test -- --test-threads=1
}
