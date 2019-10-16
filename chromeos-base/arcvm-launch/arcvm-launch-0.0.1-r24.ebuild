# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="1b8d6ab14f752db00158450ca45c1a3b88d5809b"
CROS_WORKON_TREE=("96ecb2dad8cd853305974b8e506a17e386c4ee60" "e29ce9cc68b2f96f9f973ee19e88d248eff6780a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
}
