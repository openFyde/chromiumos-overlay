# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="e9477a8c59a05c898b4f924012fd75f8e5a33ac1"
CROS_WORKON_TREE="83a0117e4ee581cff1c75f49a98fceb42acff1f2"
CROS_WORKON_PROJECT="chromiumos/third_party/shellcheck"
CROS_WORKON_LOCALNAME="shellcheck"
CROS_WORKON_DESTDIR="${S}"

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
CABAL_EXTRA_CONFIGURE_FLAGS="--disable-executable-dynamic
	--disable-shared
	--ghc-option=-optl-static
"

inherit cros-workon haskell-cabal

MY_PN="ShellCheck"
MY_P="${MY_PN}-${PV}"

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
