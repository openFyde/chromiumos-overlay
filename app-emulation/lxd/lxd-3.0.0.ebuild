# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"

CROS_GO_SOURCE=(
	"github.com/CanonicalLtd/dqlite 9334841532709c77fc79e13a08408694e4bb3616"
	"github.com/CanonicalLtd/go-grpc-sql 534b56d0c689ed437e6cff44868964d45d3ec85c"
	"github.com/CanonicalLtd/go-sqlite3 730012cee3364e7717c28f7e9b05ee6dd8684bae"
	"github.com/CanonicalLtd/raft-http e4290d0af830073ec140538e8974aa4393495ea1"
	"github.com/CanonicalLtd/raft-membership 26ef52960f54c472f52fb3701f19f25319e1032e"
	"github.com/CanonicalLtd/raft-test 22441a088d5630ddd2e971eae68074d2b645f1b7"
	"github.com/armon/go-metrics 783273d703149aaeb9897cf58613d5af48861c25"
	"github.com/boltdb/bolt fd01fc79c553a8e99d512a07e8e0c63d4a3ccfc5"
	"github.com/cpuguy83/go-md2man 48d8747a2ca13185e7cc8efe6e9fc196a83f71a5"
	"github.com/davecgh/go-spew 8991bc29aa16c548c550c7ff78260e27b9ab7c73"
	"github.com/dustinkirkland/golang-petname d3c2ba80e75eeef10c5cf2fc76d2c809637376b3"
	"github.com/flosch/pongo2 97eac295f74b5fbb7fd3113e35f4ccf3c816e389"
	"github.com/frankban/quicktest 536e76da5efc46dc247088384c2d2cea7da968aa"
	"github.com/gorilla/mux 4dbd923b0c9e99ff63ad54b0e9705ff92d3cdb06"
	"github.com/gosexy/gettext 74466a0a0c4a62fea38f44aa161d4bbfbe79dd6b"
	"github.com/hashicorp/go-immutable-radix 7f3cd4390caab3250a57f30efdb2a65dd7649ecf"
	"github.com/hashicorp/go-msgpack fa3f63826f7c23912c15263591e65d54d080b458"
	"github.com/hashicorp/golang-lru 0fb14efe8c47ae851c0034ed7a448854d3d34cf3"
	"github.com/hashicorp/raft a3fb4581fb07b16ecf1c3361580d4bdb17de9d98"
	"github.com/hashicorp/raft-boltdb 6e5ba93211eaf8d9a2ad7e41ffad8c6f160f9fe3"
	"github.com/juju/errors c7d06af17c68cd34c835053720b21f6549d9b0ee"
	"github.com/juju/go4 40d72ab9641a2a8c36a9c46a51e28367115c8e59"
	"github.com/juju/gomaasapi 663f786f595ba1707f56f62f7f4f2284c47c0f1d"
	"github.com/juju/httprequest 77d36ac4b71a6095506c0617d5881846478558cb"
	"github.com/juju/idmclient 15392b0e99abe5983297959c737b8d000e43b34c"
	"github.com/juju/loggo 7f1609ff1f3fcf3519ed62ccaaa9e609ea287838"
	"github.com/juju/persistent-cookiejar d5e5a8405ef9633c84af42fbcc734ec8dd73c198"
	"github.com/juju/retry 1998d01ba1c3eeb4a4728c4a50660025b2fe7c8f"
	"github.com/juju/schema e4f08199aa80d3194008c0bd2e14ef5edc0e6be6"
	"github.com/juju/testing 43f926548f91d55be6bae26ecb7d2386c64e887c"
	"github.com/juju/utils 57d958857adc4e7fe33ea74366aeee0f4a3a8dde"
	"github.com/juju/version b64dbd566305c836274f0268fa59183a52906b36"
	"github.com/juju/webbrowser 54b8c57083b4afb7dc75da7f13e2967b2606a507"
	"github.com/kr/pretty cfb55aafdaf3ec08f0db22699ab822c50091b1c4"
	"github.com/kr/text 7cafcd837844e784b526369c9bce262804aebc60"
	"github.com/mattn/go-colorable efa589957cd060542a26d2dd7832fd6a6c6c3ade"
	"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
	"github.com/mattn/go-runewidth a9d6d1e4dc51df2130326793d49971f238839169"
	"github.com/olekukonko/tablewriter b8a9be070da40449e501c3c4730a889e42d87a9e"
	"github.com/pborman/uuid c65b2f87fee37d1c7854c9164a450713c28d50cd"
	"github.com/pkg/errors 816c9085562cd7ee03e7f8188a1cfd942858cded"
	"github.com/pmezard/go-difflib 792786c7400a136282c1664665ae0a8db921c6c2"
	"github.com/rogpeppe/fastuuid 6724a57986aff9bff1a1770e9347036def7c89f6"
	"github.com/russross/blackfriday 670777b536d38a1aef1d517f6330a77d52ceb02e"
	"github.com/ryanfaerman/fsm 3dc1bc0980272fd56d81167a48a641dab8356e29"
	"github.com/shurcooL/sanitized_anchor_name 86672fcb3f950f35f2e675df2240550f2a50762f"
	"github.com/spf13/cobra 4dab30cb33e6633c33c787106bafbfbfdde7842d"
	"github.com/spf13/pflag 1cd4a0c365d95803411bec89fb7b76bade17053b"
	"github.com/stretchr/testify c679ae2cc0cb27ec3293fea7e254e47386f05d69"
	"github.com/syndtr/gocapability 33e07d32887e1e06b7c025f27ce52f62c7990bc0"
	"github.com/go-check/check:gopkg.in/check.v1 20d25e2804050c1cd24a7eea1e7a6447dd0e74ec"
	"github.com/go-errgo/errgo:gopkg.in/errgo.v1 c17903c6b19d5dedb9cfba9fa314c7fae63e554f"
	"github.com/go-httprequest/httprequest:gopkg.in/httprequest.v1 v1.1.1"
	"github.com/go-macaroon-bakery/macaroon-bakery:gopkg.in/macaroon-bakery.v2 v2.0.1"
	"github.com/go-macaroon/macaroon:gopkg.in/macaroon.v2 v2.0.0"
	"github.com/go-mgo/mgo:gopkg.in/mgo.v2 3f83fa5005286a7fe593b055f0d7771a7dce4655"
	"github.com/go-retry/retry:gopkg.in/retry.v1 2d7c7c65cc71d024968d9ff4385d5e7ad3a83fcc"
	"github.com/go-tomb/tomb:gopkg.in/tomb.v2 d5d1b5820637886def9eef33e03a27a9f166942c"
	"github.com/go-yaml/yaml:gopkg.in/yaml.v2 v2.2.1"
	"github.com/juju/environschema:gopkg.in/juju/environschema.v1 7359fc7857abe2b11b5b3e23811a9c64cb6b01e0"
	"github.com/juju/names:gopkg.in/juju/names.v2 54f00845ae470a362430a966fe17f35f8784ac92"
	"github.com/lxc/go-lxc:gopkg.in/lxc/go-lxc.v2 2660c429a942a4a21455765c7046dde612c1baa7"
	"github.com/lxc/lxd lxd-${PV}"
)

# This list includes the subset of packages required for the LXD client library
# to build.
CROS_GO_PACKAGES=(
	"github.com/gosexy/gettext"
	"github.com/juju/loggo"
	"github.com/juju/webbrowser"
	"github.com/lxc/lxd/client"
	"github.com/lxc/lxd/shared/..."
	"github.com/mattn/go-colorable"
	"github.com/mattn/go-isatty"
	"github.com/rogpeppe/fastuuid"
	"gopkg.in/errgo.v1"
	"gopkg.in/httprequest.v1"
	"gopkg.in/macaroon-bakery.v2/bakery"
	"gopkg.in/macaroon-bakery.v2/bakery/checkers"
	"gopkg.in/macaroon-bakery.v2/bakery/internal/macaroonpb"
	"gopkg.in/macaroon-bakery.v2/httpbakery"
	"gopkg.in/macaroon-bakery.v2/internal/httputil"
	"gopkg.in/macaroon.v2"
)

LICENSE="Apache-2.0 BSD BSD-2 LGPL-2.1 LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="-* amd64 arm"

IUSE="+daemon +ipv6 +dnsmasq nls test"

inherit bash-completion-r1 user cros-go

SRC_URI="$(cros-go_src_uri)"

DEPEND="
	>=dev-lang/go-1.7.1
	dev-go/cmp
	dev-go/crypto
	dev-go/genproto
	dev-go/glog
	dev-go/go-sys
	dev-go/httprouter
	dev-go/net
	dev-go/text
	dev-go/websocket
	dev-libs/protobuf:=
	nls? ( sys-devel/gettext )
	test? (
		app-misc/jq
		dev-db/sqlite
		net-misc/curl
		sys-devel/gettext
	)
"

RDEPEND="
	daemon? (
		app-arch/xz-utils
		>=app-emulation/lxc-2.0.7[seccomp]
		dnsmasq? (
			net-dns/dnsmasq[dhcp,ipv6?]
		)
		net-misc/rsync[xattr]
		sys-apps/iproute2[ipv6?]
		sys-fs/squashfs-tools
		virtual/acl
	)
"

src_prepare() {
	cd "src/github.com/lxc/lxd" || die "can't cd into ${S}/src/github.com/lxc/lxd"
	eapply "${FILESDIR}/2.21-unprivileged-only.patch"
	eapply "${FILESDIR}/3.00-tcp-keepalive.patch"
	eapply "${FILESDIR}/3.00-unprivileged-idmap.patch"
	eapply "${FILESDIR}/3.0.0-lxd-expose-syslog-flag-via-CLI.patch"
	eapply_user
}

src_compile() {
	CROS_GO_BINARIES=(
		"github.com/lxc/lxd/lxc"
	)
	if use daemon; then
		CROS_GO_BINARIES+=(
			"github.com/lxc/lxd/lxd"
			"github.com/lxc/lxd/fuidshift"
		)
	fi

	cros-go_src_compile
	if use nls; then
		cd "${S}/src/github.com/lxc/lxd" || die
		emake build-mo
	fi
}

src_install() {
	cros-go_src_install

	cd "src/github.com/lxc/lxd" || die "can't cd into ${S}/src/github.com/lxc/lxd"

	if use nls; then
		domo po/*.mo
	fi

	newbashcomp scripts/bash/lxd-client lxc

	dodoc AUTHORS README.md doc/*
}

pkg_postinst() {
	cros-go_pkg_postinst
	einfo
	einfo "Consult https://wiki.gentoo.org/wiki/LXD for more information,"
	einfo "including a Quick Start."

	# The messaging below only applies to daemon installs
	use daemon || return 0

	# The control socket will be owned by (and writeable by) this group.
	enewgroup lxd

	# Ubuntu also defines an lxd user but it appears unused (the daemon
	# must run as root)

	einfo
	einfo "Though not strictly required, some features are enabled at run-time"
	einfo "when the relevant helper programs are detected:"
	einfo "- sys-apps/apparmor"
	einfo "- sys-fs/btrfs-progs"
	einfo "- sys-fs/lvm2"
	einfo "- sys-fs/lxcfs"
	einfo "- sys-fs/zfs"
	einfo "- sys-process/criu"
	einfo
	einfo "Since these features can't be disabled at build-time they are"
	einfo "not USE-conditional."
	einfo
	einfo "Networks with bridge.mode=fan are unsupported due to requiring"
	einfo "a patched kernel and iproute2."
}
