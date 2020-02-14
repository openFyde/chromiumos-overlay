# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9dabf3d45b587f4a7f963142b1fb6c52b660e776"
CROS_WORKON_TREE="05fdb395c9017a24b0d5f4e219ec4a42311d48db"
CROS_WORKON_PROJECT="chromiumos/chromite"
CROS_WORKON_LOCALNAME="../chromite"
CROS_WORKON_OUTOFTREE_BUILD=1

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit cros-constants cros-workon python-r1

DESCRIPTION="Wrapper for running chromite unit tests"
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
	python_foreach_impl install_python
}
