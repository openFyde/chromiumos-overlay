# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
SRC_URI=""

# shellcheck disable=SC2034
LLVM_HASH="282c83c32384cb2f37030c28650fef4150a8b67c" # r450784
LLVM_NEXT_HASH="282c83c32384cb2f37030c28650fef4150a8b67c" # r450784

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS="~*"
fi
IUSE="+compiler-rt cros_host +libunwind msan llvm-next llvm-tot +static-libs"

RDEPEND=""
DEPEND=""
