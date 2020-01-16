# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="7338b6e81106346e14836fe002af53396df08fe4"
CROS_WORKON_TREE=("7010e07aca1a8f5685729ec7fc8a7691a7ae2808" "30f0619881d7ecddd80a18792589cddb2b3c9dd7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/policy/..."
)

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk policy_proto .gn"

PLATFORM_SUBDIR="policy_proto"

inherit cros-go cros-workon toolchain-funcs platform

DESCRIPTION="Chrome OS policy protocol buffer binding for go"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/policy_proto"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="
	>=chromeos-base/protofiles-0.0.35
	dev-go/protobuf
	dev-libs/protobuf
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}
