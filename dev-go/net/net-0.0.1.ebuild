# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="go.googlesource.com/net:golang.org/x/net 66aacef3dd8a676686c7ae3716979581e8b03c47"

CROS_GO_PACKAGES=(
	"golang.org/x/net/bpf"
	"golang.org/x/net/context"
	"golang.org/x/net/context/ctxhttp"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/hpack"
	"golang.org/x/net/idna"
	"golang.org/x/net/internal/iana"
	"golang.org/x/net/internal/socket"
	"golang.org/x/net/internal/timeseries"
	"golang.org/x/net/ipv4"
	"golang.org/x/net/ipv6"
	"golang.org/x/net/lex/httplex"
	"golang.org/x/net/netutil"
	"golang.org/x/net/trace"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Go supplementary network libraries"
HOMEPAGE="https://golang.org/x/net"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND="dev-go/text"
