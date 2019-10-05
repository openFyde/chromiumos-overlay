# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="7d4da15b405a450628fa6c47abe95f2eaec2b771"
CROS_WORKON_TREE="9398b0a6b8699905c1082e51dedf67b2349f6315"
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

# We don't have unittests, so make sure the cros_run_unit_tests script
# doesn't waste time rebuilding us all the time.
RESTRICT="test"

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
