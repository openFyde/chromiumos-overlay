# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_GO_SOURCE="android.googlesource.com/platform/external/perfetto v4.1"
CROS_GO_PACKAGES=(
	"android.googlesource.com/platform/external/perfetto/protos/perfetto/trace"
)

inherit cros-go

DESCRIPTION="Go bindings for Perfetto protocol buffers"
HOMEPAGE="https://android.googlesource.com/platform/external/perfetto"
SRC_URI="$(cros-go_src_uri)"
LICENSE="Apache-2.0"
KEYWORDS="*"
SLOT="0"
RDEPEND="
	dev-libs/protobuf:=
"
DEPEND="
	${RDEPEND}
	dev-go/protobuf:=
"
src_prepare() {
	default
	local repo_path="android.googlesource.com/platform/external/perfetto"
	local go_package_path="${S}/src/${repo_path}"
	local source_path="${S}/${P}"

	# cros-go-src_unpack() unpacks the entire perfetto source archive at
	# $go_package_path, since it expects it to be a Go package. Because it
	# is not, we must move the source out of $go_package_path before
	# generating Go files to that destination, or unwanted perfetto source
	# files will end up installed on the target.
	mv "${go_package_path}" "${source_path}" || die
	mkdir -p "${go_package_path}" || die

	local proto_file="${source_path}/protos/perfetto/trace/perfetto_trace.proto"

	# Add go_package option to proto
	echo 'option go_package = "trace";' >> "${proto_file}"

	# Generate Go source
	protoc --go_out="${go_package_path}" -I"${source_path}" "${proto_file}"  || die
}
