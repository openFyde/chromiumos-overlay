# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2215f787f7344ab506df1c9b6fc6f6ea09808103"
CROS_WORKON_TREE="8b9d58909ffde8d8e302618674434a2f62f9d3e8"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_LOCALNAME="aosp/system/update_engine"
CROS_WORKON_PROJECT="aosp/platform/system/update_engine"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon python-r1

DESCRIPTION="Chrome OS Update Engine Update Payload Scripts"
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/system/update_engine"

LICENSE="Apache-2.0"
KEYWORDS="*"

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	!<chromeos-base/devserver-0.0.3
"
DEPEND=""

src_install() {
	# Install update_payload scripts.
	install_update_payload() {
		# TODO(crbug.com/771085): Clear the SYSROOT var as python will use
		# that to define the sitedir which means we end up installing into
		# a path like /build/$BOARD/build/$BOARD/xxx.  This is a bug in the
		# core python logic, but this is breaking moblab, so hack it for now.
		insinto "$(python_get_sitedir | sed "s:^${SYSROOT}::")/update_payload"
		doins $(printf '%s\n' scripts/update_payload/*.py | grep -v unittest)
		doins scripts/update_payload/update-payload-key.pub.pem
	}
	python_foreach_impl install_update_payload

	# Install paycheck.py script as check_update_payload.
	newbin scripts/paycheck.py check_update_payload
}

src_test() {
	# Run update_payload unittests.
	cd "${T}" || die
	unpack "${S}"/sample_images/{sample_payloads.tar.xz,sample_images.tar.bz2}
	cd "${S}"/scripts || die
	python_test() {
		./run_unittests || die
	}
	python_foreach_impl python_test
}
