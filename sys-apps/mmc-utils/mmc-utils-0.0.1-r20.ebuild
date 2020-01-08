# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="329c5cade4d639803c0c356da250f8314617956c"
CROS_WORKON_TREE="b5cee99ddc49c334164b14205467470d203dceac"
CROS_WORKON_PROJECT="chromiumos/third_party/mmc-utils"

inherit cros-workon toolchain-funcs

# original Announcement of project:
#	http://permalink.gmane.org/gmane.linux.kernel.mmc/12766
#
# Upstream GIT:
#   https://git.kernel.org/cgit/linux/kernel/git/cjb/mmc-utils.git/
#
# To grab a local copy of the mmc-utils source tree:
#   git clone git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git
#
# or to reference upstream in local mmc-utils tree:
#   git remote add upstream git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git
#   git remote update

DESCRIPTION="Userspace tools for MMC/SD devices"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/mmc-utils"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="*"
IUSE="static"

src_configure() {
	use static && append-ldflags -static
	cros-workon_src_configure
	tc-export CC
	export prefix=/usr
}
