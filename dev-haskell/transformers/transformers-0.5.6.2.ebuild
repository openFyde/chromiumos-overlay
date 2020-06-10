# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.4.7.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Concrete functor and monad transformers"
HOMEPAGE="http://hackage.haskell.org/package/transformers"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
#keep in sync with ghc-8.0.2_rc2
KEYWORDS="*"
IUSE=""

RDEPEND=">=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6
"

CABAL_CORE_LIB_GHC_PV="PM:8.0.1_rc3 PM:8.0.1_rc4 PM:8.0.1 PM:8.0.2_rc1 PM:8.0.2_rc2 PM:8.0.2 PM:8.6.5-r1 PM:9999"
