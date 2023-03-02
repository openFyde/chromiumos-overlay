# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("bb18a60a31a9063443d8f92e44bf81afb330abc0" "b33a407024d155610da2e8e4d080c697e22f118a")
CROS_WORKON_TREE=("9228f811e4f06fc294b90b285f6e7e78535f7d15" "0f4044624c1fabe638a8289e62ec74756aa62176" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

	cros-go_src_install
}
