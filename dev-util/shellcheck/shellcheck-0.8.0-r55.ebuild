# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="47a94dcc454c77d3abe86117caa5de679ba8423c"
CROS_WORKON_TREE="8ea56fe87bd3f0babbb46c237cb2ad9830c44771"
CROS_WORKON_PROJECT="chromiumos/third_party/shellcheck"
CROS_WORKON_LOCALNAME="shellcheck"
CROS_WORKON_EGIT_BRANCH="chromeos-0.7"
CROS_WORKON_DESTDIR="${S}"

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
CABAL_EXTRA_CONFIGURE_FLAGS="--disable-executable-dynamic
	--disable-shared
	--ghc-option=-optl-static
"

inherit cros-workon haskell-cabal

DESCRIPTION="Shell script analysis tool"
HOMEPAGE="https://www.shellcheck.net/"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE=""

DEPEND="dev-haskell/aeson:=[profile?]
	>=dev-haskell/diff-0.2.0:=[profile?]
	>=dev-haskell/mtl-2.2.1:=[profile?]
	>=dev-haskell/parsec-3.0:=[profile?]
	>=dev-haskell/quickcheck-2.7.4:2=[template_haskell,profile?]
	dev-haskell/regex-tdfa:=[profile?]
	dev-haskell/semigroups:=[profile?]
	>=dev-lang/ghc-7.8.2:=
	>=dev-haskell/cabal-1.18.1.3 <dev-haskell/cabal-2.5
	dev-libs/gmp[static-libs]
	dev-libs/libffi[static-libs]
"

src_install() {
	cabal_src_install
	# TODO(crbug.com/1000756): Add support for manpage build process (requires pandoc)
	doman "${FILESDIR}/${PN}.1"
}
