# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="27e629bce33cf4b9adfd72353e7b1205ced202c9"
CROS_WORKON_TREE=("55939c6ae7e4e501ab2d3534ef3c746607fcc2cd" "01c316e34cd075b8d7f86d551d131d29f541a3f1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
