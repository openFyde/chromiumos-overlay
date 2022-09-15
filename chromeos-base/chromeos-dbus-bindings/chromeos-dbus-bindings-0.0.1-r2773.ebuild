# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60"
CROS_WORKON_TREE="9d848131b84c38eca29f0b578a479d3b567225a9"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="chromeos-dbus-bindings"

inherit cros-go cros-workon

DESCRIPTION="Utility for building Chrome D-Bus bindings from an XML description"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-dbus-bindings"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

CROS_GO_BINARIES=(
	"go.chromium.org/chromiumos/dbusbindings/cmd/generator:/usr/bin/go-generate-chromeos-dbus-bindings"
)
CROS_GO_TEST=(
	"go.chromium.org/chromiumos/dbusbindings/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

RDEPEND="dev-go/cmp"
DEPEND="${RDEPEND}"

src_unpack() {
	cros-workon_src_unpack
	CROS_GO_WORKSPACE="${S}/chromeos-dbus-bindings/go"
}
