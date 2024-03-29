# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Software Transactional Memory"
HOMEPAGE="http://hackage.haskell.org/package/stm"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE=""

RDEPEND=">=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
"

CABAL_CORE_LIB_GHC_PV="PM:8.6.5-r1 PM:8.6.5-r4 PM:8.6.5-r5"
