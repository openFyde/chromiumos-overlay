# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("b6fc104b800da83157d1e45eb87f94efe82f0022" "55f338108102e83774454e8ffe8e941ccffd3881")
CROS_WORKON_TREE=("6e4a783f0c499e59d01bf2c3017b9e0154227c77" "1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"android.googlesource.com/platform/external/perfetto/protos/perfetto/metrics/github.com/google/perfetto/perfetto_proto"
	"android.googlesource.com/platform/external/perfetto/protos/perfetto/trace/github.com/google/perfetto/perfetto_proto"
)

inherit cros-constants

CROS_WORKON_LOCALNAME=("../aosp/external/perfetto" "../platform2")
CROS_WORKON_PROJECT=("platform/external/perfetto" "chromiumos/platform2")
CROS_WORKON_REPO=("${CROS_GIT_AOSP_URL}" "${CROS_GIT_HOST_URL}")
CROS_WORKON_DESTDIR=("${S}/aosp/external/perfetto" "${S}/platform2")
CROS_WORKON_EGIT_BRANCH=("master" "main")
CROS_WORKON_SUBTREE=("" "common-mk .gn")

PLATFORM_SUBDIR="./"

inherit cros-go cros-workon platform

DESCRIPTION="Perfetto go proto for Chrome OS"
HOMEPAGE="https://android.googlesource.com/platform/external/perfetto/+/refs/heads/master/protos/perfetto/metrics/android/"

KEYWORDS="*"
IUSE="cros-debug"
LICENSE="Apache-2.0"
SLOT="0"

# protobuf dep is for using protoc at build-time to generate perfetto's headers.
BDEPEND="
	dev-go/protobuf
	dev-go/protobuf-legacy-api
"

RDEPEND="
	!chromeos-base/perfetto_proto
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
