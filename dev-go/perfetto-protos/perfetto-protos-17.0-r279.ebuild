# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("87ea080c1b97459363877de6c924ee6cdbbf768c" "ab48ca8511ca22268315496529c2f7cced1709e8")
CROS_WORKON_TREE=("c6699ca85d910fbe59e08bc9e5a95f0a3af83dcf" "2c293b25dd09e3deae29a0dd7d637fbc1cc44597" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"android.googlesource.com/platform/external/perfetto/protos/perfetto/metrics"
	"android.googlesource.com/platform/external/perfetto/protos/perfetto/trace"
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
HOMEPAGE="https://android.googlesource.com/platform/external/perfetto/+/refs/tags/v15.0/protos/perfetto/metrics/android/"

KEYWORDS="*"
IUSE="cros-debug"
LICENSE="Apache-2.0"
SLOT="0"

# protobuf dep is for using protoc at build-time to generate perfetto's headers.
BDEPEND="
	dev-go/protobuf
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
	echo 'option go_package = "trace";' >> "${S}/../aosp/external/perfetto/protos/perfetto/trace/perfetto_trace.proto"
}

src_install() {
	cros-go_src_install
}
