# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

# @ECLASS: cros-llvm.eclass
# @MAINTAINER:
# ChromeOS toolchain team.<chromeos-toolchain@google.com>

# @DESCRIPTION:
# Functions to set the right toolchains and install prefix for llvm
# related libraries in crossdev stages.

inherit multilib

if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND="
		${CATEGORY}/binutils
		${CATEGORY}/gcc
		sys-devel/llvm
		"
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

setup_cross_toolchain() {
	export CC="${CBUILD}-clang"
	export CXX="${CBUILD}-clang++"
	export PREFIX="/usr"

	if [[ ${CATEGORY} == cross-* ]] ; then
		export CC="${CTARGET}-clang"
		export CXX="${CTARGET}-clang++"
		export PREFIX="/usr/${CTARGET}/usr"
		export AS="$(tc-getAS ${CTARGET})"
		export STRIP="$(tc-getSTRIP ${CTARGET})"
		export OBJCOPY="$(tc-getOBJCOPY ${CTARGET})"
	elif [[ ${CTARGET} != ${CBUILD} ]] ; then
		export CC="${CTARGET}-clang"
		export CXX="${CTARGET}-clang++"
	fi
	unset ABI MULTILIB_ABIS DEFAULT_ABI
	multilib_env ${CTARGET}
}

get_most_recent_revision() {
	local subdir="${S}/llvm"

	# Tries to parse the last revision ID present in the most recent commit
	# with a revision ID attached. We can't simply `grep -m 1`, since it's
	# reasonable for a revert message to include the git-svn-id of the
	# commit it's reverting.
	#
	# Thankfully, LLVM's machinery always makes this ID the last line of
	# each upstream commit, so we just need to search for it, with commit
	# two lines later.
	#
	# Example of revision ID line:
	# llvm-svn: 358929
	#
	# Where 358929 is the revision.
	git -C "${subdir}" log | \
		awk '
			/^commit/ {
				if (most_recent_id != "") {
					print most_recent_id
					exit
				}
			}
			/^\s+llvm-svn: [0-9]+$/ { most_recent_id = $2 }'
}

get_most_recent_sha() {
	local subdir="${S}/llvm"

	# Get the git hash of the most recent commit.
	git -C "${subdir}" rev-parse HEAD
}
