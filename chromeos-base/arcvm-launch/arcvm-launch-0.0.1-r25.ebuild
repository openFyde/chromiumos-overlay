# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="894142de791f2080a9c92594611c350ccd1d2b7f"
CROS_WORKON_TREE=("96ecb2dad8cd853305974b8e506a17e386c4ee60" "cc82db45fac6bf0985663f2e85b45e1cf8c00207" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
