# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-llvm cros-constants cros-rustc-directories git-r3 python-single-r1

LLVM_HASH="db1978b67431ca3462ad8935bf662c15750b8252" # r465103
LLVM_NEXT_HASH="db1978b67431ca3462ad8935bf662c15750b8252" # r465103

EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project
	${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"
EGIT_BRANCH=main
# shellcheck disable=SC2154 # defined by cros-rustc-directories
EGIT_CHECKOUT_DIR="${CROS_RUSTC_LLVM_SRC_DIR}"
S="${CROS_RUSTC_LLVM_SRC_DIR}"

LICENSE="UoI-NCSA"
SLOT="8"
KEYWORDS="-* amd64"

IUSE="llvm-next llvm-tot"

pkg_setup() {
	# shellcheck disable=SC2154 # defined by cros-rustc-directories
	addwrite "${CROS_RUSTC_DIR}"
	if ! [[ -e "${CROS_RUSTC_DIR}" ]]; then
		# shellcheck disable=SC2174
		mkdir -p -m 755 "${CROS_RUSTC_DIR}"
		chown "${PORTAGE_USERNAME}:${PORTAGE_GRPNAME}" "${CROS_RUSTC_DIR}"
	fi
}

src_unpack() {
	if use llvm-next || use llvm-tot; then
		EGIT_COMMIT="${LLVM_NEXT_HASH}"
	else
		EGIT_COMMIT="${LLVM_HASH}"
	fi

	git-r3_src_unpack

	# git-r3_src_unpack won't freshly unpack sources if they're already
	# there, so we do the following to get to a clean state.
	git -C "${S}" reset --hard HEAD || die
	git -C "${S}" clean -fd || die
}

src_prepare() {
	python_setup
	prepare_patches
	eapply_user
}

src_compile() {
	true
}

src_install() {
	true
}
