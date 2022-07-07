# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f5df8ee93ae0efb2aec5d62f9f6de99c5775662e"
CROS_WORKON_TREE="8f3b99818143507b5cc972bdc8e5bf4ae90722d3"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since sound_card_init/Cargo.toml
# is using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="sound_card_init"

inherit cros-workon cros-rust udev user

DESCRIPTION="Sound Card Initializer"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/sound_card_init"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	dev-rust/cc:=
	dev-rust/getopts:=
	dev-rust/sys_util:=
	dev-rust/serde_json:=
	dev-rust/serde_yaml:=
	dev-rust/thiserror:=
	dev-rust/remain:=
	media-sound/audio_streams:=
	media-sound/cros_alsa:=
	media-sound/libcras:=
	media-sound/sof_sys:=
"

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

	cros-rust_pkg_preinst
}
