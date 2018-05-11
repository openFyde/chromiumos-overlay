# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="github.com/godbus/dbus bd29ed602e2cf4207ebcabcd530259169e4289ba"

CROS_GO_PACKAGES=(
	"github.com/godbus/dbus"
	"github.com/godbus/dbus/prop"
	"github.com/godbus/dbus/introspect"
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
