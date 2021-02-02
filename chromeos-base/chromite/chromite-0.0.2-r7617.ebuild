# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="dec69ad54c6dc0e6f9ddd8306b5a9a241b61866e"
CROS_WORKON_TREE="a9ea01a45e899e95f59a2835b26431f6b113d0d2"
CROS_WORKON_PROJECT="chromiumos/chromite"
CROS_WORKON_LOCALNAME="../chromite"
CROS_WORKON_OUTOFTREE_BUILD=1

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-constants cros-workon python-r1

DESCRIPTION="Subset of chromite libs for importing on DUTs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/chromite/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

# We don't have unittests, so make sure the cros_run_unit_tests script
# doesn't waste time rebuilding us all the time.
RESTRICT="test"

src_install() {
	install_python() {
		# TODO(crbug.com/771085): Figure out this SYSROOT business.
		local dir="$(python_get_sitedir | sed "s:^${SYSROOT}::")/chromite"

		insinto "${dir}"
		doins -r "${S}"/*

		# TODO (crbug.com/346859) Convert to using distutils and a setup.py
		# to specify which files should be installed.
		cd "${D}/${dir}"
		rm -rf \
			api \
			appengine \
			bin \
			cbuildbot/builders \
			cbuildbot/stages \
			cli/cros/cros_{build,firmware}_ap* \
			cli/cros/tests \
			config \
			contrib \
			cidb \
			cros \
			cros_bisect \
			infra \
			lib/datafiles/ \
			lib/firmware/ \
			lib/testdata/ \
			licensing \
			scripts/cbuildbot* \
			sdk \
			service \
			signing \
			test \
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
		find -depth -type d -exec rmdir {} + 2>/dev/null
	}
	python_foreach_impl install_python
}
