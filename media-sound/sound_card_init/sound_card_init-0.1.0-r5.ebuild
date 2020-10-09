# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="932f912aa5a0c25c1d5806aa4ad9d8d4d4d98e84"
CROS_WORKON_TREE="93882505e057609c52977a58c199d65b8a01980f"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since sound_card_init/Cargo.toml
# is using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="sound_card_init"

inherit cros-workon cros-rust udev user

DESCRIPTION="Sound Card Initializer"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/master/sound_card_init"

LICENSE="BSD-Google"
KEYWORDS="-* amd64"

DEPEND="
	dev-rust/cc:=
	dev-rust/getopts:=
	dev-rust/sys_util:=
	dev-rust/serde_yaml:=
	dev-rust/remain:=
	media-sound/cros_alsa:=
	media-sound/audio_streams:=
	media-sound/libcras:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/sound_card_init"

	cros-rust_src_unpack
}

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/sound_card_init"

	# Add upstart job for sound_card_init.
	insinto /etc/init
	doins sound_card_init.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/sound_card_init-seccomp-${ARCH}.policy" sound_card_init-seccomp.policy

	udev_dorules 99-sound_card_init.rules

}

pkg_preinst() {
	enewuser "sound_card_init"
	enewgroup "sound_card_init"
}
