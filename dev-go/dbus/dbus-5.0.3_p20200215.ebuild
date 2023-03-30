# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="github.com/godbus/dbus:github.com/godbus/dbus/v5 06fc4b473149e499166adbb9e31c7365a8ea146f"

CROS_GO_PACKAGES=(
	"github.com/godbus/dbus/..."
)

inherit cros-go

DESCRIPTION="Native Go client bindings for the D-Bus message bus system"
HOMEPAGE="https://github.com/godbus/dbus"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# The unit tests try to connect to the dbus on host and fail.
RESTRICT="binchecks strip test"

DEPEND=""
RDEPEND=""
