# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b604ab2d0f18e1adc2b714d53f59a5f5a580c8a3"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "149e3b04ccaf3e228341670f8a51bd9b9d59f316" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
