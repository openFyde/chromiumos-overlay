# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1bb1e029fcdc2b10ef390dccc82fd5d0053ee2b9"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "a123d999f5847702d61c9c5e9a53aaf7ed401fe2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
inherit cros-constants

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT=("chromiumos/platform2")
CROS_WORKON_EGIT_BRANCH=("main")
CROS_WORKON_LOCALNAME=("platform2")
CROS_WORKON_DESTDIR=("${S}/platform2")
CROS_WORKON_SUBTREE=("common-mk arc/keymint .gn")

inherit cros-workon

DESCRIPTION="ARC KeyMint daemon in ChromiumOS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/keymint"

LICENSE="BSD-Google"
KEYWORDS="*"
