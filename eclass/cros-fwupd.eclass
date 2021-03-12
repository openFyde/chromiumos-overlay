# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-fwupd.eclass
# @MAINTAINER:
# The Chromium OS Authors
# @BLURB: Unifies logic for installing fwupd firmware files.

if [[ -z ${_CROS_FWUPD_ECLASS} ]]; then
_CROS_FWUPD_ECLASS=1

inherit udev

S="${WORKDIR}"

case "${EAPI:-0}" in
7) ;;
*) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

# @FUNCTION: cros-fwupd_src_unpack
# @DESCRIPTION:
# Unpack fwupd firmware files to provide license.
cros-fwupd_src_unpack() {
	local file

	for file in ${A}; do
		if [[ ${file} == *.cab ]]; then
			einfo "Unpack firmware ${file}"
			cabextract -F LICENSE.txt "${DISTDIR}"/"${file}" || die
			mv LICENSE.txt license."${file}".txt || \
				ewarn "Missing LICENSE.txt on ${file}"
		fi
	done
}

# @FUNCTION: cros-fwupd_src_install
# @DESCRIPTION:
# Install fwupd firmware files.
cros-fwupd_src_install() {
	local file

	insinto /usr/share/fwupd/remotes.d/vendor/firmware
	for file in ${A}; do
		einfo "Installing firmware ${file}"
		doins "${DISTDIR}"/"${file}"
	done

	# Install udev rules for automatic firmware update.
	local srcdir="${1:-${FILESDIR}}"
	while read -d $'\0' -r file; do
		udev_dorules "${file}"
	done < <(find -H "${srcdir}" -name "*.rules" -maxdepth 1 -mindepth 1 -print0)
}

EXPORT_FUNCTIONS src_unpack src_install

fi
