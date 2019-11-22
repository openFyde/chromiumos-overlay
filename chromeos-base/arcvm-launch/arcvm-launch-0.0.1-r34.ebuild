# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="aa87ba1a4b38be2ffb16f363e76f0f0fe2eb61bc"
CROS_WORKON_TREE=("c5e851c0a9f693b39a3385a86e1075e6de1ce2e9" "2822c12aff73ad311bb921794d0f5b6557558313" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"

src_install() {
	insinto /etc/init
	doins arc/vm/launch/init/arcvm-ureadahead.conf

	insinto /usr/share/arcvm
	doins arc/vm/launch/init/config.json
}
