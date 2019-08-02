# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="c40e52fce50c066dd582c69795079b58a4e6b750"
CROS_WORKON_TREE="ba23b10060115f6503e409a68e6c6b6b2552022d"
CROS_WORKON_PROJECT="chromiumos/chromite"
CROS_WORKON_LOCALNAME="../../chromite"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-constants cros-workon python

DESCRIPTION="Wrapper for running chromite unit tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/chromite/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

src_install() {
	use cros_host && return
	insinto "$(python_get_sitedir)/chromite"
	doins -r "${S}"/*
	# TODO (crbug.com/346859) Convert to using distutils and a setup.py
	# to specify which files should be installed.
	cd "${D}/$(python_get_sitedir)/chromite"
	rm -rf \
		appengine \
		contrib \
		cidb \
		infra \
		lib/datafiles/ \
		third_party/pyelftools/examples \
		third_party/pyelftools/test \
		mobmonitor \
		venv
	find '(' \
		-name 'OWNERS*' -o \
		-name '*.py[co]' -o \
		-name '*unittest.py' -o \
		-name '*unittest' -o \
		-name '*.go' -o \
		-name '*.md' \
		')' -delete || die
	find -name '.git' -exec rm -rf {} + || die
}

src_test() {
	# Run the chromite unit tests, resetting the environment to the standard
	# one using a sudo invocation. Currently the tests assume they run from a
	# repo checkout, so they need to be run from the real source dir.
	# TODO(davidjames): Fix that, and run the tests from ${S} instead.
	cd "${CHROMITE_DIR}" && sudo -u "${PORTAGE_USERNAME}" \
		PATH="${CROS_WORKON_SRCROOT}/../depot_tools:${PATH}" ./run_tests || die
}
