# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="b4c0a46f57d17730696b0f26675d0278e985dde7"
CROS_WORKON_TREE="2ce7ae395a96ab4076e63836e793461d8070726b"
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
