# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="e93a07e6c5d3b49aa7fe4c12d9fed9b037bd08e9"
CROS_WORKON_TREE="38114c518052d6fee43c2d75a95654c62240c5b9"
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
