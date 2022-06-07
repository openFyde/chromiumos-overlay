# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="7a90e4dc8e5a9122ac5aff93cab4457f512de77f"
CROS_WORKON_TREE="569d2e96c43643a143d081a3ae67824acaf9c002"
CROS_WORKON_PROJECT="chromiumos/platform/graphics"
CROS_WORKON_LOCALNAME="platform/graphics"

INSTALL_DIR="/usr/local/graphics"

CROS_GO_BINARIES=(
	# Add more apps here.
	"hardware_probe/cmd/hardware_probe:${INSTALL_DIR}/hardware_probe"
	"platform_decoding/cmd/ffmpeg_md5sum:${INSTALL_DIR}/ffmpeg_md5sum"
	"platform_decoding/cmd/validate:${INSTALL_DIR}/validate"
	"sanity/cmd/pass:${INSTALL_DIR}/pass"
	"trace_profiling/cmd/analyze:${INSTALL_DIR}/analyze"
	"trace_profiling/cmd/gen_db_result:${INSTALL_DIR}/get_device_info"
	"trace_profiling/cmd/harvest:${INSTALL_DIR}/harvest"
	"trace_profiling/cmd/merge:${INSTALL_DIR}/merge"
	"trace_profiling/cmd/profile:${INSTALL_DIR}/profile"
	"trace_replay/cmd/trace_replay:${INSTALL_DIR}/trace_replay"
)

CROS_GO_TEST=(
	"hardware_probe/cmd/hardware_probe"
	"platform_decoding/cmd/validate"
	"sanity/cmd/pass"
	"trace_profiling/cmd/analyze"
	"trace_profiling/cmd/gen_db_result"
	"trace_profiling/cmd/merge"
	"trace_profiling/cmd/profile"
	"trace_replay/cmd/trace_replay"
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-go cros-workon
SRC_URI="$(cros-go_src_uri)"

DESCRIPTION="Portable graphics utils written in go"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/graphics/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/cros-config-api
	dev-go/crypto
	dev-go/fogleman-gg
	dev-go/go-image
	dev-go/go-pdf
	dev-go/golang-freetype
	dev-go/gonum-plot
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	dev-go/readline
	dev-go/svgo
	dev-go/uuid
"

RDEPEND="${DEPEND}"

src_prepare() {
	# Disable cgo and PIE on building Tast binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	default
}
