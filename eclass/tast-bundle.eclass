# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tast-bundle.eclass
# @MAINTAINER:
# The Chromium OS Authors <chromium-os-dev@chromium.org>
# @BUGREPORTS:
# Please report bugs via https://crbug.com/new (with component "Tests>Tast")
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: Eclass for building and installing Tast test bundles.
# @DESCRIPTION:
# Installs Tast integration test bundles.
# See https://chromium.googlesource.com/chromiumos/platform/tast/ for details.
# The bundle name (e.g. "cros") and type ("local" or "remote") are derived from
# the package name, which should be of the form "tast-<type>-tests-<name>".

# @ECLASS-VARIABLE: TAST_BUNDLE_PRIVATE
# @DESCRIPTION:
# If set to "1", this test bundle is not installed to images, but is downloaded
# at run time by local_test_runner. Otherwise this test bundle is installed to
# images.
# Only local tests can be marked private; remote test bundles are always
# installed to the chroot.
: ${TAST_BUNDLE_PRIVATE:=0}

inherit cros-go

DEPEND="dev-go/crypto"
RDEPEND="app-arch/tar"

if ! [[ "${PN}" =~ ^tast-(local|remote)-tests-[a-z]+$ ]]; then
	die "Package \"${PN}\" not of form \"tast-<type>-tests-<name>\""
fi

# @FUNCTION: tast-bundle_pkg_setup
# @DESCRIPTION:
# Parses package name to extract bundle info and sets binary target.
tast-bundle_pkg_setup() {
	# Strip off the "tast-" prefix and the "-tests-*" suffix to get the type
	# ("local" or "remote").
	local tmp=${PN#tast-}
	TAST_BUNDLE_TYPE=${tmp%-tests-*}

	# Strip off everything preceding the bundle name.
	TAST_BUNDLE_NAME=${PN#tast-*-tests-}

	# Decide if this is a private bundle.
	TAST_BUNDLE_PREFIX=/usr
	if [[ "${TAST_BUNDLE_PRIVATE}" = 1 ]]; then
		if [[ "${TAST_BUNDLE_TYPE}" != local ]]; then
			die "Remote test bundles can not be marked private"
		fi
		TAST_BUNDLE_PREFIX=/build
	fi

	# The path to the test bundle code relative to the src/ directory.
	TAST_BUNDLE_PATH="chromiumos/tast/${TAST_BUNDLE_TYPE}/bundles/${TAST_BUNDLE_NAME}"

	# Install the bundle under /{usr|build}/libexec/tast/bundles/<type>.
	CROS_GO_BINARIES=(
		"chromiumos/tast/${TAST_BUNDLE_TYPE}/bundles/${TAST_BUNDLE_NAME}:${TAST_BUNDLE_PREFIX}/libexec/tast/bundles/${TAST_BUNDLE_TYPE}/${TAST_BUNDLE_NAME}"
	)

	CROS_GO_VET_FLAGS=(
		# Check printf-style arguments passed to testing.State methods.
		"-printfuncs=Log,Logf,Error,Errorf,Fatal,Fatalf,Wrap,Wrapf"
	)
}

# @FUNCTION: tast-bundle_src_prepare
# @DESCRIPTION:
# Sets up environment variables for the Go toolchain.
tast-bundle_src_prepare() {
	# Disable cgo and PIE on building Tast binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	cros-workon_src_prepare
	default
}

# @FUNCTION: tast-bundle_src_install
# @DESCRIPTION:
# Installs test bundle executable and associated data files.
tast-bundle_src_install() {
	cros-go_src_install

	# The base directory where test data files are installed.
	local basedatadir="${TAST_BUNDLE_PREFIX}/share/tast/data"

	# Install each test category's data dir.
	pushd src >/dev/null || die "failed to pushd src"
	local datadir dest
	for datadir in "${TAST_BUNDLE_PATH}"/*/data; do
		[[ -e "${datadir}" ]] || break

		# Dereference symlinks to support shared files: https://crbug.com/927424
		dest=${ED%/}/${basedatadir#/}/${datadir%/*}
		mkdir -p "${dest}" || die "Failed to create ${dest}"
		cp --preserve=mode --dereference -R "${datadir}" "${dest}" || \
			die "Failed to copy ${datadir} to ${dest}"
		chmod -R u=rwX,go=rX "${dest}" || die "Failed to chmod ${dest}"
	done
	popd >/dev/null
}

EXPORT_FUNCTIONS pkg_setup src_prepare src_install
