# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="43fc871f777ee41e6e0404714f896588d79a9d14"
CROS_WORKON_TREE="e3cb4ee5d12923a8ef6c204656f39b828dcf126b"
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
