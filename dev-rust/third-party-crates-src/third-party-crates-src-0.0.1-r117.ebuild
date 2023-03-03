# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fca8dbe8847b9c1049f2168b87298bed4ef2051c"
CROS_WORKON_TREE=("8a9cb8bbd319ff3d9d7a936dce6f5646737d3e2f" "9b6f03866a7ce5ab464adab687508dae7d82bb29")
CROS_WORKON_PROJECT="chromiumos/third_party/rust_crates"
CROS_WORKON_EGIT_BRANCH="main"
CROS_WORKON_LOCALNAME="rust_crates"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="vendor vendor_artifacts"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon cros-rust python-single-r1

DESCRIPTION="Sources of third-party crates used by ChromeOS"
HOMEPAGE='https://chromium.googlesource.com/chromiumos/third_party/rust_crates/+/HEAD/'
KEYWORDS="*"

# There's no obvious need for testing these crates at the moment. Further,
# testing these crates could be complicated, since we're pulling in the union of
# all crates needed for all CrOS projects on all architectures. Future Work(TM).
RESTRICT="test"

EXPECTED_LICENSES=(
	0BSD
	Apache-2.0
	BSD
	BSD-2
	ISC
	MIT
	MPL-2.0
	ZLIB
	unicode
)

LICENSE="${EXPECTED_LICENSES[*]}"

# shellcheck disable=SC2154 # this is defined by cros-rust
CRATES_LISTING_INST_LOC="${CROS_RUST_REGISTRY_DIR}/third-party-crates-src-listing"

# Some baremetal crates ship with prebuilt .o files that don't pass
# QA_EXECSTACK. This is intended, so silence those warnings.
_QA_EXECSTACK_ROOT="${CROS_RUST_REGISTRY_DIR:1}"
QA_EXECSTACK="
	${_QA_EXECSTACK_ROOT}/cortex-m-rt-*
	${_QA_EXECSTACK_ROOT}/riscv-*
"

pkg_setup() {
	python-single-r1_pkg_setup
	# This handles calling cros-workon_pkg_setup for us.
	cros-rust_pkg_setup
}

src_unpack() {
	# Do this first so "${S}" is set up as early as possible. This also
	# prevents cros-rust_src_unpack from modifying ${S}.
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	[[ -n "${PATCHES[*]}" ]] && die "User patches are not supported in" \
		"this ebuild. Instead, add patches to" \
		"third_party/rust_crates; please see the README for details."
	# Call eapply_user; otherwise, portage gets upset.
	eapply_user
}

src_configure() {
	:
}

src_compile() {
	# For lack of a better place to put this (since we want it to run when
	# FEATURES=test is not enabled), verify licenses here.
	"${S}/vendor_artifacts/verify_licenses.py" \
		--license-file="${S}/vendor_artifacts/licenses_used.txt" \
		--expected-licenses="${EXPECTED_LICENSES[*]}" \
		|| die
	einfo "License verification complete."

	# If we're working on out-of-tree sources, mirror licenses to make
	# license checks happy. This is a bit hacky, but cheap.
	if [[ "${S}" != "${WORKDIR}"/* ]]; then
		local targ="${WORKDIR}/licenses"
		[[ -e "${targ}" ]] && die "${targ} shouldn't exist"
		einfo "Mirroring licenses from ${S}/vendor to ${targ}..."
		rsync -r --include='*/' --include='LICENSE*' --exclude='*' \
			--prune-empty-dirs "${S}/vendor" "${targ}" || die
	fi

	(cd "${S}/vendor" && echo * > "${T}/third-party-crates-src-listing") || die
}

# Shellcheck thinks CROS_RUST variables are never defined.
# shellcheck disable=SC2154
src_install() {
	insinto "${CROS_RUST_REGISTRY_DIR}"

	# Prebuilt .a files are installed by some packages, and should not be
	# stripped.
	dostrip -x "${CROS_RUST_REGISTRY_DIR}"
	cd "${S}/vendor" || die

	local crates_listing="${T}/third-party-crates-src-listing"
	local crate_versions
	read -r -a crate_versions < "${crates_listing}" || die
	doins "${crates_listing}"

	doins -r "${crate_versions[@]}"
}

should_skip_registry_links() {
	# build_image is set up so that nothing actually gets installed into
	# "${ROOT}${CROS_RUST_REGISTRY_DIR}". Skip all pkg_* functionality if
	# that DNE, in part for speed, and in part because we depend on e.g.,
	# our crates listing.
	! [[ -e "${ROOT}${CROS_RUST_REGISTRY_DIR}" ]]
}

pkg_preinst() {
	should_skip_registry_links && return

	local crate_versions
	read -r -a crate_versions < "${D}${CRATES_LISTING_INST_LOC}" || die
	cros-rust_cleanup_vendor_registry_links "${crate_versions[@]}"
}

pkg_postinst() {
	should_skip_registry_links && return

	local crate_versions
	read -r -a crate_versions < "${ROOT}${CRATES_LISTING_INST_LOC}" || die
	cros-rust_create_vendor_registry_links "${crate_versions[@]}"
}

pkg_prerm() {
	should_skip_registry_links && return

	local crate_versions
	read -r -a crate_versions < "${ROOT}${CRATES_LISTING_INST_LOC}" || die
	cros-rust_cleanup_vendor_registry_links "${crate_versions[@]}"
}
