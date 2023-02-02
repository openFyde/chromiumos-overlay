# Copyright 2023 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="8b65f3619734bdfefbd32a6a4c85569190c1b82e"
CROS_WORKON_TREE="795ea8165d135f4af8d6a89a1f12cbcd856f4008"
CROS_RUST_SUBDIR="vm_tools/metric_reporter"

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Disk usage metric reporter for Crostini"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
"
RDEPEND="${DEPEND}"

src_install() {
	cros-rust_src_install

	dobin "$(cros-rust_get_build_dir)/crostini_metric_reporter"
}
