# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="TFLite models and supporting assets used for testing ML & NNAPI."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/main/ml_benchmark/model_zoo/"

inherit cros-workon

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="ml_benchmark/model_zoo"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"

src_install() {
	insinto "/usr/local/share/ml-test-assets"
	cd "platform2/ml_benchmark/model_zoo" || die
	doins -r ./*
}
