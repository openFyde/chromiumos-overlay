# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3e99e8d0c27d055e37b0fba0d57771e072410abf"
CROS_WORKON_TREE="8b7dbb07ca723d41ef13ea0f317b89696466dc4f"
CROS_WORKON_PROJECT="chromiumos/third_party/rust_crates"
CROS_WORKON_EGIT_BRANCH="main"
CROS_WORKON_LOCALNAME="rust_crates"
CROS_WORKON_OUTOFTREE_BUILD=1

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon cros-rust python-single-r1

DESCRIPTION="Sources of third-party crates used by ChromeOS"
HOMEPAGE='https://chromium.googlesource.com/chromiumos/third_party/rust_crates/+/HEAD/'
KEYWORDS="*"

# There's no obvious need for testing these crates at the moment. Further,
# testing these crates could be complicated, since we're pulling in the union of
# all crates needed for all CrOS projects on all architectures. Future Work(TM).
RESTRICT="test"

EXPECTED_LICENSES=(
	0BSD
	Apache-2.0
	BSD
	ISC
	MIT
	MPL-2.0
	ZLIB
	unicode
)

LICENSE="${EXPECTED_LICENSES[*]}"

# A list of crate versions which we've fully replaced.
# FIXME(b/240953811): Remove this when our migration is done.
RDEPEND="
	!=dev-rust/zeroize_derive-1.3.1
	!=dev-rust/zeroize_derive-1.3.1-r1
	!=dev-rust/zeroize_derive-1.3.1-r2
	!=dev-rust/zeroize_derive-1.3.1-r3
	!=dev-rust/zeroize_derive-1.3.1-r4
	!=dev-rust/zeroize_derive-1.3.1-r5
	!=dev-rust/zeroize_derive-1.2.0
	!=dev-rust/zeroize_derive-1.2.0-r1
	!=dev-rust/zeroize_derive-1.2.0-r2
	!=dev-rust/zeroize_derive-1.2.0-r3
	!=dev-rust/zeroize_derive-1.2.0-r4
	!=dev-rust/vec_map-0.8.2
	!=dev-rust/vec_map-0.8.2-r1
	!=dev-rust/structopt-derive-0.4.18
	!=dev-rust/structopt-derive-0.4.18-r1
	!=dev-rust/structopt-derive-0.4.18-r2
	!=dev-rust/structopt-derive-0.4.18-r3
	!=dev-rust/structopt-derive-0.4.18-r4
	!=dev-rust/structopt-derive-0.4.18-r5
	!=dev-rust/structopt-derive-0.4.13
	!=dev-rust/structopt-derive-0.4.13-r1
	!=dev-rust/structopt-derive-0.4.13-r2
	!=dev-rust/structopt-derive-0.4.13-r3
	!=dev-rust/structopt-derive-0.4.13-r4
	!=dev-rust/structopt-derive-0.4.13-r5
	!=dev-rust/slab-0.4.3
	!=dev-rust/slab-0.4.3-r1
	!=dev-rust/ron-0.5.1
	!=dev-rust/ron-0.5.1-r1
	!=dev-rust/ron-0.5.1-r2
	!=dev-rust/ron-0.5.1-r3
	!=dev-rust/multimap-0.8.3
	!=dev-rust/multimap-0.8.3-r1
	!=dev-rust/failure_derive-0.1.5
	!=dev-rust/failure_derive-0.1.5-r1
	!=dev-rust/failure_derive-0.1.5-r2
	!=dev-rust/failure_derive-0.1.5-r3
	!=dev-rust/failure_derive-0.1.5-r4
	!=dev-rust/failure_derive-0.1.5-r5
	!=dev-rust/either-1.6.1
	!=dev-rust/either-1.6.1-r1
	!=dev-rust/argh-0.1.7
	!=dev-rust/argh-0.1.7-r1
	!=dev-rust/argh-0.1.7-r2
	!=dev-rust/thiserror-1.0.30
	!=dev-rust/thiserror-1.0.30-r1
	!=dev-rust/serde-1.0.136
	!=dev-rust/serde-1.0.125
	!=dev-rust/tokio-macros-1.8.0
	!=dev-rust/tokio-macros-1.8.0-r1
	!=dev-rust/tokio-macros-1.8.0-r2
	!=dev-rust/tokio-macros-1.8.0-r3
	!=dev-rust/thiserror-impl-1.0.30
	!=dev-rust/thiserror-impl-1.0.30-r1
	!=dev-rust/thiserror-impl-1.0.30-r2
	!=dev-rust/thiserror-impl-1.0.30-r3
	!=dev-rust/synstructure-0.12.4
	!=dev-rust/synstructure-0.12.4-r1
	!=dev-rust/synstructure-0.12.4-r2
	!=dev-rust/synstructure-0.12.4-r3
	!=dev-rust/synstructure-0.12.4-r4
	!=dev-rust/serde_derive-1.0.136
	!=dev-rust/serde_derive-1.0.136-r1
	!=dev-rust/serde_derive-1.0.136-r2
	!=dev-rust/serde_derive-1.0.136-r3
	!=dev-rust/serde_derive-1.0.125
	!=dev-rust/serde_derive-1.0.125-r1
	!=dev-rust/serde_derive-1.0.125-r2
	!=dev-rust/serde_derive-1.0.125-r3
	!=dev-rust/rustyline-derive-0.6.0
	!=dev-rust/rustyline-derive-0.6.0-r1
	!=dev-rust/rustyline-derive-0.6.0-r2
	!=dev-rust/remain-0.2.1
	!=dev-rust/remain-0.2.1-r1
	!=dev-rust/remain-0.2.1-r2
	!=dev-rust/remain-0.2.1-r3
	!=dev-rust/proc-macro-error-1.0.4
	!=dev-rust/proc-macro-error-1.0.4-r1
	!=dev-rust/proc-macro-error-1.0.4-r2
	!=dev-rust/proc-macro-error-1.0.4-r3
	!=dev-rust/proc-macro-error-1.0.4-r4
	!=dev-rust/num-derive-0.3.3
	!=dev-rust/num-derive-0.3.3-r1
	!=dev-rust/num-derive-0.3.3-r2
	!=dev-rust/num-derive-0.3.3-r3
	!=dev-rust/enumn-0.1.3
	!=dev-rust/enumn-0.1.3-r1
	!=dev-rust/enumn-0.1.3-r2
	!=dev-rust/enumn-0.1.3-r3
	!=dev-rust/defmt-macros-0.2.3
	!=dev-rust/defmt-macros-0.2.3-r1
	!=dev-rust/defmt-macros-0.2.3-r2
	!=dev-rust/defmt-macros-0.2.3-r3
	!=dev-rust/defmt-macros-0.2.3-r4
	!=dev-rust/async-trait-0.1.36
	!=dev-rust/async-trait-0.1.36-r1
	!=dev-rust/async-trait-0.1.36-r2
	!=dev-rust/async-trait-0.1.36-r3
	!=dev-rust/argh_derive-0.1.7
	!=dev-rust/argh_derive-0.1.7-r1
	!=dev-rust/argh_derive-0.1.7-r2
	!=dev-rust/argh_derive-0.1.7-r3
	!=dev-rust/argh_derive-0.1.7-r4
	!=dev-rust/argh_derive-0.1.7-r5
	!=dev-rust/syn-1.0.91
	!=dev-rust/syn-1.0.91-r1
	!=dev-rust/syn-1.0.91-r2
	!=dev-rust/syn-1.0.91-r3
	!=dev-rust/syn-1.0.72
	!=dev-rust/syn-1.0.72-r1
	!=dev-rust/syn-1.0.72-r2
	!=dev-rust/syn-1.0.72-r3
	!=dev-rust/syn-0.15.26
	!=dev-rust/syn-0.15.26-r1
	!=dev-rust/syn-0.15.26-r2
	!=dev-rust/syn-0.15.26-r3
	!=dev-rust/syn-0.15.26-r4
	!=dev-rust/proc-macro-error-attr-1.0.4
	!=dev-rust/proc-macro-error-attr-1.0.4-r1
	!=dev-rust/proc-macro-error-attr-1.0.4-r2
	!=dev-rust/proc-macro-error-attr-1.0.4-r3
	!=dev-rust/quote-1.0.9
	!=dev-rust/quote-1.0.9-r1
	!=dev-rust/quote-0.6.10
	!=dev-rust/quote-0.6.10-r1
	!=dev-rust/proc-macro2-1.0.37
	!=dev-rust/proc-macro2-1.0.37-r1
	!=dev-rust/proc-macro2-1.0.36
	!=dev-rust/proc-macro2-1.0.36-r1
	!=dev-rust/proc-macro2-1.0.29
	!=dev-rust/proc-macro2-1.0.29-r1
	!=dev-rust/proc-macro2-0.4.21
	!=dev-rust/proc-macro2-0.4.21-r1
	!=dev-rust/cmake-0.1.48
	!=dev-rust/cmake-0.1.48-r1
	!=dev-rust/regex-1.5.5
	!=dev-rust/regex-1.5.5-r1
	!=dev-rust/regex-1.5.5-r2
	!=dev-rust/regex-1.5.5-r3
	!=dev-rust/num-iter-0.1.42
	!=dev-rust/num-iter-0.1.42-r1
	!=dev-rust/num-iter-0.1.42-r2
	!=dev-rust/num-iter-0.1.42-r3
	!=dev-rust/num-iter-0.1.37
	!=dev-rust/intrusive-collections-0.9.0
	!=dev-rust/intrusive-collections-0.9.0-r1
	!=dev-rust/scudo-0.1.2
	!=dev-rust/scudo-0.1.2-r1
	!=dev-rust/scudo-0.1.2-r2
	!=dev-rust/num-integer-0.1.44
	!=dev-rust/num-integer-0.1.44-r1
	!=dev-rust/num-integer-0.1.44-r2
	!=dev-rust/memoffset-0.6.5
	!=dev-rust/memoffset-0.6.5-r1
	!=dev-rust/memoffset-0.6.4
	!=dev-rust/memoffset-0.6.4-r1
	!=dev-rust/memoffset-0.5.6
	!=dev-rust/memoffset-0.5.6-r1
	!=dev-rust/heck-0.4.0
	!=dev-rust/heck-0.4.0-r1
	!=dev-rust/heck-0.3.3
	!=dev-rust/heck-0.3.3-r1
	!=dev-rust/aho-corasick-0.7.18
	!=dev-rust/aho-corasick-0.7.18-r1
	!=dev-rust/walkdir-2.3.2
	!=dev-rust/walkdir-2.3.2-r1
	!=dev-rust/unicode-xid-0.2.2
	!=dev-rust/unicode-xid-0.1.0
	!=dev-rust/unicode-width-0.1.9
	!=dev-rust/unicode-width-0.1.9-r1
	!=dev-rust/unicode-width-0.1.8
	!=dev-rust/unicode-width-0.1.8-r1
	!=dev-rust/unicode-segmentation-1.8.0
	!=dev-rust/sys-info-0.9.1
	!=dev-rust/sys-info-0.9.1-r1
	!=dev-rust/sys-info-0.9.1-r2
	!=dev-rust/shlex-1.1.0
	!=dev-rust/shlex-0.1.1
	!=dev-rust/scudo-sys-0.2.1
	!=dev-rust/scudo-sys-0.2.1-r1
	!=dev-rust/scudo-sys-0.2.1-r2
	!=dev-rust/rustc-demangle-0.1.21
	!=dev-rust/rustc-demangle-0.1.21-r1
	!=dev-rust/miniz_oxide-0.4.4
	!=dev-rust/miniz_oxide-0.4.4-r1
	!=dev-rust/memchr-2.4.1
	!=dev-rust/memchr-2.4.1-r1
	!=dev-rust/memchr-2.4.1-r2
	!=dev-rust/autocfg-1.1.0
	!=dev-rust/autocfg-1.0.1
	!=dev-rust/autocfg-0.1.2
	!=dev-rust/serial-unix-0.4.0
	!=dev-rust/serial-unix-0.4.0-r1
	!=dev-rust/serial-unix-0.4.0-r2
	!=dev-rust/cc-1.0.72
	!=dev-rust/cc-1.0.72-r1
	!=dev-rust/termios-0.2.2
	!=dev-rust/termios-0.2.2-r1
	!=dev-rust/terminal_size-0.1.17
	!=dev-rust/terminal_size-0.1.17-r1
	!=dev-rust/terminal_size-0.1.12
	!=dev-rust/signal-hook-registry-1.4.0
	!=dev-rust/signal-hook-registry-1.4.0-r1
	!=dev-rust/serial-core-0.4.0
	!=dev-rust/serial-core-0.4.0-r1
	!=dev-rust/num_cpus-1.9.0
	!=dev-rust/num_cpus-1.9.0-r1
	!=dev-rust/num_cpus-1.13.0
	!=dev-rust/num_cpus-1.13.0-r1
	!=dev-rust/num_cpus-1.13.0-r2
	!=dev-rust/jobserver-0.1.24
	!=dev-rust/jobserver-0.1.24-r1
	!=dev-rust/jobserver-0.1.16
	!=dev-rust/ioctl-rs-0.1.6
	!=dev-rust/ioctl-rs-0.1.6-r1
	!=dev-rust/hostname-0.3.1
	!=dev-rust/hostname-0.3.1-r1
	!=dev-rust/hostname-0.3.1-r2
	!=dev-rust/dirs-sys-next-0.1.2
	!=dev-rust/dirs-sys-next-0.1.2-r1
	!=dev-rust/atty-0.2.14
	!=dev-rust/atty-0.2.14-r1
	!=dev-rust/libc-0.2.124
	!=dev-rust/libc-0.2.124-r1
	!=dev-rust/libc-0.2.106
	!=dev-rust/libc-0.2.106-r1
	!=dev-rust/bitflags-1.3.2
	!=dev-rust/bitflags-1.3.2-r1
	!=dev-rust/adler32-1.2.0
	!=dev-rust/adler32-1.2.0-r1
	!=dev-rust/rustc-std-workspace-std-1.0.0
	!=dev-rust/rustc-std-workspace-core-1.0.0
	!=dev-rust/rustc-std-workspace-alloc-1.0.0
	!=dev-rust/compiler_builtins-0.1.2
	!=dev-rust/compiler_builtins-0.1.0
	!=dev-rust/unicase-2.6.0
	!=dev-rust/unicase-2.6.0-r1
	!=dev-rust/capnpc-0.14.4
	!=dev-rust/capnp-0.14.2
	!=dev-rust/base64-0.13.0
	!=dev-rust/base64-0.10.1
	!=dev-rust/base64-0.10.1-r1
	!=dev-rust/adler-1.0.2
	!=dev-rust/xml-rs-0.8.3
	!=dev-rust/volatile-register-0.2.0
	!=dev-rust/volatile-register-0.2.0-r1
	!=dev-rust/semver-parser-0.7.0
	!=dev-rust/scoped-tls-1.0.0
	!=dev-rust/remove_dir_all-0.5.1
	!=dev-rust/remove_dir_all-0.5.1-r1
	!=dev-rust/matches-0.1.8
	!=dev-rust/foreign-types-0.3.2
	!=dev-rust/foreign-types-0.3.2-r1
	!=dev-rust/foreign-types-0.3.2-r2
	!=dev-rust/crc-2.0.0
	!=dev-rust/crc-2.0.0-r1
	!=dev-rust/ansi_term-0.11.0
	!=dev-rust/ansi_term-0.11.0-r1
	!=dev-rust/ansi_term-0.11.0-r2
	!=dev-rust/ansi_term-0.11.0-r3
	!=dev-rust/void-1.0.2
	!=dev-rust/vcell-0.1.3
	!=dev-rust/ufmt-write-0.1.0
	!=dev-rust/strsim-0.8.0
	!=dev-rust/strsim-0.8.0-r1
	!=dev-rust/strsim-0.10.0
	!=dev-rust/stable_deref_trait-1.2.0
	!=dev-rust/rtic-monotonic-1.0.0
	!=dev-rust/rtic-core-1.0.0
	!=dev-rust/r0-1.0.0
	!=dev-rust/r0-0.2.2
	!=dev-rust/quick-error-1.2.1
	!=dev-rust/panic-halt-0.2.0
	!=dev-rust/number_prefix-0.4.0
	!=dev-rust/defmt-parser-0.2.2
	!=dev-rust/ct-codecs-1.1.1
	!=dev-rust/crc-catalog-1.1.1
	!=dev-rust/color_quant-1.1.0
	!=dev-rust/cast-0.3.0
	!=dev-rust/bitfield-0.13.2
	!=dev-rust/wasm-bindgen-0.2.68
	!=dev-rust/shell-words-1.0.0
	!=dev-rust/proc-macro-nested-0.1.3
	!=dev-rust/paste-1.0.2
	!=dev-rust/num_threads-0.1.5
	!=dev-rust/num-traits-0.2.12
	!=dev-rust/itoa-1.0.1
	!=dev-rust/itoa-0.4.7
	!=dev-rust/httparse-1.3.4
	!=dev-rust/httparse-1.3.4-r1
	!=dev-rust/hermit-abi-0.1.3
	!=dev-rust/chunked_transfer-1.2.0
	!=dev-rust/bumpalo-3.5.0
	!=dev-rust/async-task-4.0.3
	!=dev-rust/argh_shared-0.1.7
	!=dev-rust/wio-0.2.2
	!=dev-rust/winapi-0.3.9
	!=dev-rust/version_check-0.9.3
	!=dev-rust/utf8parse-0.2.0
	!=dev-rust/tinyvec_macros-0.1.0
	!=dev-rust/scopeguard-1.1.0
	!=dev-rust/same-file-1.0.6
	!=dev-rust/rustc-hash-1.1.0
	!=dev-rust/regex-syntax-0.6.25
	!=dev-rust/ppv-lite86-0.2.10
	!=dev-rust/pin-project-lite-0.2.4
	!=dev-rust/peeking_take_while-0.1.2
	!=dev-rust/pcap-file-1.1.1
	!=dev-rust/minimal-lexical-0.2.1
	!=dev-rust/match_cfg-0.1.0
	!=dev-rust/managed-0.8.0
	!=dev-rust/libslirp-sys-4.2.1
	!=dev-rust/humantime-2.1.0
	!=dev-rust/foreign-types-shared-0.1.1
	!=dev-rust/fnv-1.0.7
	!=dev-rust/endian-type-0.1.2
	!=dev-rust/downcast-rs-1.2.0
	!=dev-rust/byteorder-1.4.3
	!=dev-rust/bit_field-0.10.1
	!=dev-rust/assert_matches-1.5.0
	!=dev-rust/memchr-2.4.0
	!=dev-rust/regex-1.5.4
	!=dev-rust/termcolor-1.1.2
"

# A list of crate versions available in rust_crates, which we can install in
# dev-rust. Logically, this is "all crates, minus those in a blocklist," but we
# have to have this info in `pkg_*` functions, so inspecting `rust_crates`
# sources and our blocklist isn't possible.
#
# FIXME(b/240953811): Remove this when our migration is done.
ALLOWED_CRATE_VERSIONS=(
	# NOTE: This list was generated by
	# ${FILESDIR}/write_allowlisted_crate_versions.py. Any
	# modifications may be overwritten.
	"adler-1.0.2"
	"adler32-1.2.0"
	"aho-corasick-0.7.18"
	"android_system_properties-0.1.5"
	"ansi_term-0.11.0"
	"argh-0.1.8"
	"argh_derive-0.1.8"
	"argh_shared-0.1.8"
	"assert_matches-1.5.0"
	"async-stream-0.3.3"
	"async-stream-impl-0.3.3"
	"async-task-4.3.0"
	"async-trait-0.1.48"
	"atty-0.2.14"
	"autocfg-0.1.7"
	"autocfg-1.1.0"
	"axum-0.5.16"
	"axum-core-0.2.8"
	"base64-0.10.1"
	"base64-0.13.0"
	"bit_field-0.10.1"
	"bitfield-0.13.2"
	"bitflags-1.3.2"
	"bumpalo-3.11.0"
	"bytemuck-1.12.1"
	"byteorder-1.4.3"
	"capnp-0.14.10"
	"capnpc-0.14.9"
	"cast-0.3.0"
	"cc-1.0.73"
	"chunked_transfer-1.4.0"
	"clipboard-win-4.2.1"
	"cloudabi-0.0.3"
	"cmake-0.1.48"
	"color_quant-1.1.0"
	"com_logger-0.1.1"
	"compiler_builtins-0.1.80"
	"configparser-3.0.0"
	"core-foundation-sys-0.8.3"
	"crc-2.1.0"
	"crc-catalog-1.1.1"
	"cstr_core-0.2.6"
	"ct-codecs-1.1.1"
	"ctor-0.1.22"
	"cty-0.2.2"
	"cxx-1.0.42"
	"cxxbridge-flags-1.0.42"
	"cxxbridge-macro-1.0.42"
	"defmt-macros-0.2.3"
	"defmt-parser-0.2.2"
	"derive-into-owned-0.1.0"
	"dirs-sys-next-0.1.2"
	"downcast-rs-1.2.0"
	"either-1.8.0"
	"encode_unicode-0.3.6"
	"endian-type-0.1.2"
	"enumn-0.1.5"
	"errno-0.2.8"
	"errno-dragonfly-0.1.2"
	"error-code-2.3.0"
	"euclid-0.22.7"
	"failure-0.1.8"
	"failure_derive-0.1.8"
	"filedescriptor-0.8.2"
	"fnv-1.0.7"
	"foreign-types-0.3.2"
	"foreign-types-shared-0.1.1"
	"fuchsia-cprng-0.1.1"
	"gag-1.0.0"
	"ghost-0.1.6"
	"grpcio-compiler-0.6.0"
	"h2-0.3.14"
	"hashbrown-0.12.3"
	"heck-0.3.3"
	"heck-0.4.0"
	"hermit-abi-0.1.18"
	"hostname-0.3.1"
	"http-0.2.8"
	"http-body-0.4.5"
	"http-range-header-0.3.0"
	"httparse-1.7.1"
	"httpdate-1.0.2"
	"humantime-2.1.0"
	"hyper-0.14.20"
	"hyper-timeout-0.4.1"
	"iana-time-zone-0.1.47"
	"indoc-0.3.6"
	"indoc-impl-0.3.6"
	"inotify-0.9.3"
	"inotify-sys-0.1.5"
	"intrusive-collections-0.9.4"
	"inventory-0.1.11"
	"inventory-impl-0.1.11"
	"io-lifetimes-0.7.3"
	"io-uring-0.5.4"
	"ioctl-rs-0.1.6"
	"itertools-0.9.0"
	"itertools-0.10.5"
	"itoa-1.0.3"
	"jobserver-0.1.24"
	"js-sys-0.3.59"
	"libc-0.2.132"
	"libfuzzer-sys-0.4.4"
	"libslirp-sys-4.2.1"
	"link-cplusplus-1.0.5"
	"linux-raw-sys-0.0.46"
	"managed-0.8.0"
	"match_cfg-0.1.0"
	"matches-0.1.9"
	"matchit-0.5.0"
	"memchr-2.5.0"
	"memoffset-0.5.6"
	"memoffset-0.6.5"
	"mime-0.3.16"
	"minimal-lexical-0.2.1"
	"miniz_oxide-0.3.7"
	"miniz_oxide-0.4.4"
	"miniz_oxide-0.5.4"
	"miow-0.3.6"
	"multimap-0.8.3"
	"ntapi-0.3.6"
	"num-derive-0.3.3"
	"num-integer-0.1.45"
	"num-iter-0.1.43"
	"num-traits-0.2.14"
	"num_cpus-1.13.0"
	"num_threads-0.1.6"
	"number_prefix-0.4.0"
	"object-0.29.0"
	"panic-halt-0.2.0"
	"paste-0.1.18"
	"paste-1.0.4"
	"paste-impl-0.1.18"
	"pcap-file-1.1.1"
	"peeking_take_while-0.1.2"
	"pin-project-1.0.12"
	"pin-project-internal-1.0.12"
	"pin-project-lite-0.2.9"
	"ppv-lite86-0.2.10"
	"proc-macro-error-1.0.4"
	"proc-macro-error-attr-1.0.4"
	"printf-compat-0.1.1"
	"proc-macro-nested-0.1.7"
	"proc-macro2-0.4.30"
	"proc-macro2-1.0.44"
	"prost-0.11.0"
	"prost-derive-0.11.0"
	"protoc-grpcio-2.0.0"
	"pyo3-0.13.2"
	"pyo3-macros-0.13.2"
	"pyo3-macros-backend-0.13.2"
	"quick-error-1.2.3"
	"quote-0.3.15"
	"quote-0.6.13"
	"quote-1.0.9"
	"r0-0.2.2"
	"r0-1.0.0"
	"rdrand-0.4.0"
	"redox_syscall-0.2.4"
	"redox_users-0.4.0"
	"regex-1.6.0"
	"regex-syntax-0.6.27"
	"remain-0.2.4"
	"remove_dir_all-0.5.3"
	"ron-0.5.1"
	"rtic-core-1.0.0"
	"rtic-monotonic-1.0.0"
	"rustc-demangle-0.1.21"
	"rustc-hash-1.1.0"
	"rustc-std-workspace-alloc-1.0.0"
	"rustc-std-workspace-core-1.0.0"
	"rustc-std-workspace-std-1.0.1"
	"rustix-0.35.9"
	"rustversion-1.0.9"
	"rusty-fork-0.3.0"
	"rustyline-derive-0.4.0"
	"rustyline-derive-0.6.0"
	"same-file-1.0.6"
	"scoped-tls-1.0.0"
	"scopeguard-1.1.0"
	"scudo-0.1.2"
	"scudo-sys-0.2.1"
	"semver-parser-0.7.0"
	"serde-1.0.145"
	"serde_derive-1.0.145"
	"serial-core-0.4.0"
	"serial-unix-0.4.0"
	"shell-words-1.1.0"
	"shlex-0.1.1"
	"shlex-1.1.0"
	"signal-hook-registry-1.4.0"
	"slab-0.4.7"
	"stable_deref_trait-1.2.0"
	"str-buf-1.0.5"
	"strsim-0.10.0"
	"strsim-0.8.0"
	"structopt-derive-0.4.18"
	"syn-0.11.11"
	"syn-0.15.44"
	"syn-1.0.101"
	"sync_wrapper-0.1.1"
	"synom-0.11.3"
	"synstructure-0.12.4"
	"sys-info-0.9.1"
	"termcolor-1.1.2"
	"terminal_size-0.1.17"
	"termios-0.2.2"
	"thiserror-1.0.32"
	"thiserror-impl-1.0.32"
	"tinyvec_macros-0.1.0"
	"tokio-io-timeout-1.2.0"
	"tokio-macros-1.8.0"
	"tokio-stream-0.1.3"
	"tokio-util-0.7.3"
	"tonic-0.8.1"
	"tower-0.4.13"
	"tower-http-0.3.4"
	"tower-layer-0.3.1"
	"tower-service-0.3.2"
	"tracing-0.1.35"
	"tracing-attributes-0.1.22"
	"tracing-core-0.1.29"
	"tracing-futures-0.2.5"
	"try-lock-0.2.3"
	"uart_16550-0.2.18"
	"ucs2-0.3.2"
	"uefi-0.17.0"
	"uefi-macros-0.8.1"
	"uefi-services-0.14.0"
	"ufmt-write-0.1.0"
	"uguid-1.2.1"
	"unicase-2.6.0"
	"unicode-ident-1.0.4"
	"unicode-segmentation-1.10.0"
	"unicode-width-0.1.10"
	"unicode-xid-0.0.4"
	"unicode-xid-0.1.0"
	"unicode-xid-0.2.4"
	"unindent-0.1.10"
	"utf8parse-0.2.0"
	"vcell-0.1.3"
	"vec_map-0.8.2"
	"version_check-0.9.3"
	"void-1.0.2"
	"volatile-0.4.5"
	"volatile-register-0.2.1"
	"wait-timeout-0.2.0"
	"walkdir-2.3.2"
	"want-0.3.0"
	"wasi-0.11.0+wasi-snapshot-preview1"
	"wasm-bindgen-0.2.82"
	"wasm-bindgen-backend-0.2.82"
	"wasm-bindgen-macro-0.2.82"
	"wasm-bindgen-macro-support-0.2.82"
	"wasm-bindgen-shared-0.2.82"
	"winapi-0.3.9"
	"winapi-i686-pc-windows-gnu-0.4.0"
	"winapi-util-0.1.5"
	"winapi-x86_64-pc-windows-gnu-0.4.0"
	"windows-sys-0.36.1"
	"windows_aarch64_msvc-0.36.1"
	"windows_i686_gnu-0.36.1"
	"windows_i686_msvc-0.36.1"
	"windows_x86_64_gnu-0.36.1"
	"windows_x86_64_msvc-0.36.1"
	"wio-0.2.2"
	"x86_64-0.14.10"
	"xml-rs-0.8.4"
	"zeroize_derive-1.3.2"
)

src_unpack() {
	# Do this first so "${S}" is set up as early as possible. This also
	# prevents cros-rust_src_unpack from modifying ${S}.
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	[[ -n "${PATCHES[*]}" ]] && die "User patches are not supported in" \
		"this ebuild. Instead, add patches to" \
		"third_party/rust_crates; please see the README for details."
	# Call eapply_user; otherwise, portage gets upset.
	eapply_user
}

src_configure() {
	:
}

src_compile() {
	# For lack of a better place to put this (since we want it to run when
	# FEATURES=test is not enabled), verify licenses here.
	"${S}/verify_licenses.py" \
		--license-file="${S}/licenses_used.txt" \
		--expected-licenses="${EXPECTED_LICENSES[*]}" \
		|| die
	einfo "License verification complete."

	# If we're working on out-of-tree sources, mirror licenses to make
	# license checks happy. This is a bit hacky, but cheap.
	if [[ "${S}" != "${WORKDIR}"/* ]]; then
		local targ="${WORKDIR}/licenses"
		[[ -e "${targ}" ]] && die "${targ} shouldn't exist"
		einfo "Mirroring licenses from ${S}/vendor to ${targ}..."
		rsync -r --include='*/' --include='LICENSE*' --exclude='*' \
			--prune-empty-dirs "${S}/vendor" "${targ}" || die
	fi
}

# Shellcheck thinks CROS_RUST variables are never defined.
# shellcheck disable=SC2154
src_install() {
	insinto "${CROS_RUST_REGISTRY_DIR}"
	# Prebuilt .a files are installed by some packages, and should not be
	# stripped.
	dostrip -x "${CROS_RUST_REGISTRY_DIR}"
	cd "${S}/vendor" || die
	doins -r "${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_preinst() {
	cros-rust_cleanup_vendor_registry_links "${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_postinst() {
	cros-rust_create_vendor_registry_links "${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_prerm() {
	cros-rust_cleanup_vendor_registry_links "${ALLOWED_CRATE_VERSIONS[@]}"
}
