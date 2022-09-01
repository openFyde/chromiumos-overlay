# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="89d3c0078a4dabc9e83b2e6d0273d6f2e2a53908"
CROS_WORKON_TREE=("f063c143da4054868aadc5be54cc3a45415a698e" "19f36342be7994842e12ce8eadbb21be2e51ae97" "7f338adea3264258ac1947255e6c644a115c089a" "0b343737ed85a0444890f51bc74376c57ba7fdca" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug/1184685): "libhwsec" is not necessary; remove it after solving
# the bug.
CROS_WORKON_SUBTREE="common-mk metrics libhwsec libhwsec-foundation .gn"

PLATFORM_SUBDIR="libhwsec-foundation"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libhwsec-foundation/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="profiling test tpm tpm_dynamic tpm2"

RDEPEND="
	>=chromeos-base/metrics-0.0.1-r3152
	chromeos-base/system_api
	chromeos-base/tpm_manager-client
	"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
