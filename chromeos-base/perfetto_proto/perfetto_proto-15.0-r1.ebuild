# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_GO_PACKAGES=(
	"chromiumos/perfetto/trace_processor/..."
)

CROS_WORKON_COMMIT=("2f35d6fd1fc0e4c68e1e5188dab0de173de724c8" "1404aae9fa36dfcf3f1ae805d3e58f33ff56cdd8")
CROS_WORKON_TREE=("b247aba769f84322900406f9d373e8d7856cf6e0" "a9c7ccacc3f49f80a01bb6dd4d544dbf7d4ef49c")

inherit cros-constants

CROS_WORKON_LOCALNAME=("aosp/external/perfetto" "platform2")
CROS_WORKON_PROJECT=("platform/external/perfetto" "chromiumos/platform2")
CROS_WORKON_REPO=("${CROS_GIT_AOSP_URL}" "${CROS_GIT_HOST_URL}")
CROS_WORKON_DESTDIR=("${S}/aosp/external/perfetto" "${S}/platform2")
CROS_WORKON_EGIT_BRANCH=("master" "main")
CROS_WORKON_SUBTREE=("" "common-mk .gn")

PLATFORM_SUBDIR="./"

inherit cros-go cros-workon platform

DESCRIPTION="Perfetto go proto for Chrome OS"
HOMEPAGE="https://android.googlesource.com/platform/external/perfetto/+/refs/tags/v15.0/protos/perfetto/metrics/android/"

KEYWORDS="*"
IUSE="cros-debug"
LICENSE="Apache-2.0"
SLOT="0"

# protobuf dep is for using protoc at build-time to generate perfetto's headers.
BDEPEND="
	dev-go/protobuf
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_prepare() {
	default
	cp "${FILESDIR}/BUILD.gn" "${S}"
}

src_install() {
	cros-go_src_install
}
