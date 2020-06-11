# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d80dcfcab1123bfa1bae9fcebcb08521116644f4"
CROS_WORKON_TREE=("1b35c43f4fc972f1ee5ea532c50eec8765d2af3c" "f6e985347a838bbbdd2997e97c4b4940571f2dd2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/policy/..."
)

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk policy_proto .gn"

PLATFORM_SUBDIR="policy_proto"

inherit cros-go cros-workon platform

DESCRIPTION="Chrome OS policy protocol buffer binding for go"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/policy_proto"
LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	>=chromeos-base/protofiles-0.0.35:=
	dev-go/protobuf:=
	dev-libs/protobuf:=
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}
