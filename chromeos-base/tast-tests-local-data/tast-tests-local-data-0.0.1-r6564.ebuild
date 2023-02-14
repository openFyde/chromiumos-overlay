# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="631e9ab9a51f34b1e910ae7c1c83678ee9fde2b8"
CROS_WORKON_TREE="8fcd5763b8233a72639c92e848813b14ee67005e"
CROS_WORKON_PROJECT=("chromiumos/platform/tast-tests")
CROS_WORKON_LOCALNAME=("platform/tast-tests")
CROS_WORKON_DESTDIR=("${S}")
CROS_WORKON_SUBTREE=("src/chromiumos/tast/local")

inherit cros-workon tast-bundle-data

DESCRIPTION="Data files for local Tast tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests"

LICENSE="BSD-Google GPL-3"
SLOT="0/0"
KEYWORDS="*"

DEPEND=""

# data files were pulled from chromeos-base/tast-local-tests-cros in
# https://crrev.com/c/2975193.
RDEPEND="!<chromeos-base/tast-local-tests-cros-0.0.2"
