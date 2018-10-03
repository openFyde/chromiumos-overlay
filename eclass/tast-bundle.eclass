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

# @ECLASS-VARIABLE: TAST_BUNDLE_EXTERNAL_DATA_URLS
# @DESCRIPTION:
# URLs for external data files listed in files/external_data.conf:
#   TAST_BUNDLE_EXTERNAL_DATA_URLS=(
#     "gs://chromiumos-test-assets-public/tast/cros/example/file1.txt"
#     "gs://chromiumos-test-assets-public/tast/cros/example/file2.txt"
#   )
# This ensures that the ebuild file is updated whenever external_data.conf is
# changed, which is needed to make Portage generate and use an updated Manifest
# file.

inherit cros-go

DEPEND="dev-go/crypto"
RDEPEND="app-arch/tar"

if ! [[ "${PN}" =~ ^tast-(local|remote)-tests-[a-z]+$ ]]; then
	die "Package \"${PN}\" not of form \"tast-<type>-tests-<name>\""
fi

# Mangles an external test data URL so it can be used as a destination filename
# in SRC_URI. Slashes are URL-escaped and the package name and an underscore are
# prepended.
_mangle_data_url() {
	local url=$1
	echo "${PN}_${url//\//%2F}"
}

# Reads the supplied external_data.conf file if it exists and prints
# whitespace-separated external data file paths and URLs, one per line. The
# config file also contains whitespace-separated paths and URLs, but may
# additionally contain '#'-prefixed comments.
_get_external_data_paths_and_urls() {
	local conf_file=$1
	[[ -f "${conf_file}" ]] || return

	# Wrap 'sed' and 'grep' in 'command' to avoid Portage QA warnings. It's
	# possible to parse the file only using bash, but sed/grep make for
	# more-readable code.
	local lines=$(command sed -e '/^\s*$/d' -e '/^\s*#/d' "${conf_file}")
	local bad_lines=$(echo "${lines}" | command grep -E -v '^\s*\S+\s+\S+\s*$')
	[[ -n "${bad_lines}" ]] && die "bad line(s) in ${conf_file}:\n${bad_lines}"
	echo "${lines}"
}

# Adds additional entries to SRC_URI for external test data files.
_add_external_data_urls() {
	local basedir="$(dirname "${EBUILD}")"
	local conf="${basedir}/files/external_data.conf"
	local path url

	while read path url; do
		if [[ " ${TAST_BUNDLE_EXTERNAL_DATA_URLS[@]} " != *" ${url} "* ]]; then
			die "'${url}' in ${conf} but not in TAST_BUNDLE_EXTERNAL_DATA_URLS"
		fi
		# Include the package name and the URL in the destination filename to
		# avoid conflicts if multiple tests use files with the same name and to
		# force a re-download when a file's URL changes.
		SRC_URI+=" ${url} -> $(_mangle_data_url "${url}")"
	done < <(_get_external_data_paths_and_urls "${conf}")

	for url in "${TAST_BUNDLE_EXTERNAL_DATA_URLS[@]}"; do
		if [[ " ${SRC_URI} " != *" ${url} "* ]]; then
			die "'${url}' in TAST_BUNDLE_EXTERNAL_DATA_URLS but not in ${conf}"
		fi
	done
}

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

	# The path to the test bundle code relative to the src/ directory.
	TAST_BUNDLE_PATH="chromiumos/tast/${TAST_BUNDLE_TYPE}/bundles/${TAST_BUNDLE_NAME}"

	# Install the bundle under /usr/libexec/tast/bundles/<type>.
	CROS_GO_BINARIES=(
		"chromiumos/tast/${TAST_BUNDLE_TYPE}/bundles/${TAST_BUNDLE_NAME}:/usr/libexec/tast/bundles/${TAST_BUNDLE_TYPE}/${TAST_BUNDLE_NAME}"
	)

	CROS_GO_VET_FLAGS=(
		# Check printf-style arguments passed to testing.State methods.
		"-printfuncs=Log,Logf,Error,Errorf,Fatal,Fatalf,Wrap,Wrapf"
	)
}

# @FUNCTION: tast-bundle_src_install
# @DESCRIPTION:
# Installs test bundle executable and associated data files.
tast-bundle_src_install() {
	cros-go_src_install

	# The base directory where test data files are installed.
	local basedatadir=/usr/share/tast/data

	# Install each test category's data dir.
	pushd src >/dev/null || die "failed to pushd src"
	local datadir
	for datadir in "${TAST_BUNDLE_PATH}"/*/data; do
		[[ -e "${datadir}" ]] || break
		(insinto "${basedatadir}/${datadir%/*}" && doins -r "${datadir}")
	done
	popd >/dev/null

	# Install external data files that were previously downloaded via SRC_URI.
	local conf="${FILESDIR}/external_data.conf"
	local path url srcpath destdir
	while read path url; do
		srcpath="${DISTDIR}/$(_mangle_data_url "${url}")"
		[[ -e "${srcpath}" ]] || die "external data file ${srcpath} does not exist"
		# Follow symlinks in DISTDIR to the real file since newins preserves symlinks.
		srcpath=$(readlink -e "${srcpath}")
		destdir="${basedatadir}/${TAST_BUNDLE_PATH}/$(dirname "${path}")"
		(insinto "${destdir}" && newins "${srcpath}" "$(basename "${path}")")
	done < <(_get_external_data_paths_and_urls "${conf}")
}

EXPORT_FUNCTIONS pkg_setup src_install

# Update SRC_URI to include URLs of external test data.
_add_external_data_urls
