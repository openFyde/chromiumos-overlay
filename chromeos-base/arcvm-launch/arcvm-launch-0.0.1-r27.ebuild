# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="3bb8cfb5e428da7f7cad890717c305c4c971ac8f"
CROS_WORKON_TREE=("5d53ff58483685bdf4424a3c8e8496656e9aa83e" "665ee34b6ccecf3baabcdb93e5d92e8103385801" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/launch .gn"

inherit cros-workon

# TODO(b/142424802): Rename the package to e.g. arcvm-common-scripts.
DESCRIPTION="A package to run arcvm."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/launch"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_install() {
	insinto /etc/init
	doins arc/vm/launch/init/arcvm-ureadahead.conf

	insinto /usr/share/arcvm
	doins arc/vm/launch/init/config.json
}
