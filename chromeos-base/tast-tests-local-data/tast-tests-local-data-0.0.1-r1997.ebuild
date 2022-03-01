# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="96a3564f8aff668601750a6bd84914a1ef4ed78d"
CROS_WORKON_TREE="7c32e12c7cb7aa612cd25b5ff3f72c9eb24c9feb"
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
