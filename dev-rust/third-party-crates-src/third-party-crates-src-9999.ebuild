# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/third_party/rust_crates"
CROS_WORKON_EGIT_BRANCH="main"
CROS_WORKON_LOCALNAME="rust_crates"
CROS_WORKON_OUTOFTREE_BUILD=1

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon cros-rust python-single-r1

DESCRIPTION="Sources of third-party crates used by ChromeOS"
HOMEPAGE='https://chromium.googlesource.com/chromiumos/third_party/rust_crates/+/HEAD/'
KEYWORDS="~*"

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
	!=dev-rust/time-macros-0.2.4
	!=dev-rust/num-cmp-0.1.0
	!=dev-rust/iso8601-0.4.1
	!=dev-rust/iso8601-0.4.1-r1
	!=dev-rust/bytecount-0.6.2
	!=dev-rust/bytecount-0.6.2-r1
	!=dev-rust/bit-vec-0.6.3
	!=dev-rust/bit-vec-0.6.3-r1
	!=dev-rust/pulldown-cmark-0.6.1
	!=dev-rust/pulldown-cmark-0.6.1-r1
	!=dev-rust/pulldown-cmark-0.6.1-r2
	!=dev-rust/pulldown-cmark-0.6.1-r3
	!=dev-rust/pulldown-cmark-0.6.1-r4
	!=dev-rust/tinyvec-1.5.1
	!=dev-rust/tinyvec-1.5.1-r1
	!=dev-rust/tinyvec-1.5.1-r2
	!=dev-rust/tinyvec-1.5.1-r3
	!=dev-rust/mp4parse-0.11.5
	!=dev-rust/getopts-0.2.21
	!=dev-rust/getopts-0.2.21-r1
	!=dev-rust/getopts-0.2.21-r2
	!=dev-rust/getopts-0.2.18
	!=dev-rust/getopts-0.2.18-r1
	!=dev-rust/getopts-0.2.18-r2
	!=dev-rust/flamer-0.1.4
	!=dev-rust/fallible-iterator-0.2.0
	!=dev-rust/dav1d-0.6.0
	!=dev-rust/clang-sys-1.2.0
	!=dev-rust/clang-sys-1.2.0-r1
	!=dev-rust/clang-sys-1.2.0-r2
	!=dev-rust/clang-sys-1.2.0-r3
	!=dev-rust/bytemuck-1.7.3
	!=dev-rust/bytemuck-1.7.3-r1
	!=dev-rust/average-0.9.3
	!=dev-rust/windows-0.10.0
	!=dev-rust/unicode-linebreak-0.1.2
	!=dev-rust/thread-id-4.0.0
	!=dev-rust/thread-id-3.3.0
	!=dev-rust/thread-id-3.3.0-r1
	!=dev-rust/thread-id-3.3.0-r2
	!=dev-rust/thread-id-3.3.0-r3
	!=dev-rust/synstructure_test_traits-0.1.0
	!=dev-rust/slog-2.0.0
	!=dev-rust/skim-0.9.0
	!=dev-rust/rand_xoshiro-0.1.0
	!=dev-rust/mio-extras-2.0.5
	!=dev-rust/maybe-uninit-2.0.0
	!=dev-rust/glob-0.3.0
	!=dev-rust/glob-0.3.0-r1
	!=dev-rust/dcv-color-primitives-0.1.16
	!=dev-rust/cexpr-0.6.0
	!=dev-rust/cexpr-0.6.0-r1
	!=dev-rust/cexpr-0.4.0
	!=dev-rust/cexpr-0.4.0-r1
	!=dev-rust/bencher-0.1.5
	!=dev-rust/wasmparser-0.57.0
	!=dev-rust/security-framework-sys-0.3.3
	!=dev-rust/rgb-0.8.25
	!=dev-rust/redox_syscall-0.1.51
	!=dev-rust/print_bytes-0.5.0
	!=dev-rust/postgres-types-0.2.0
	!=dev-rust/packed_simd_2-0.3.4
	!=dev-rust/nom-7.1.0
	!=dev-rust/nom-7.1.0-r1
	!=dev-rust/nom-7.1.0-r2
	!=dev-rust/nom-5.1.2
	!=dev-rust/nom-5.1.2-r1
	!=dev-rust/nom-5.1.2-r2
	!=dev-rust/nom-5.1.2-r3
	!=dev-rust/nom-5.1.2-r4
	!=dev-rust/nom-5.1.2-r5
	!=dev-rust/multi_log-0.1.2
	!=dev-rust/multi_log-0.1.2-r1
	!=dev-rust/juniper-0.15.0
	!=dev-rust/ed25519-1.2.0
	!=dev-rust/cpp_demangle-0.3.0
	!=dev-rust/arbitrary-1.0.0
	!=dev-rust/arbitrary-0.4.0
	!=dev-rust/tiff-0.6.0
	!=dev-rust/static_assertions-1.1.0
	!=dev-rust/ravif-0.6.0
	!=dev-rust/lazycell-1.3.0
	!=dev-rust/lazycell-1.3.0-r1
	!=dev-rust/lazycell-1.3.0-r2
	!=dev-rust/iovec-0.1.4
	!=dev-rust/iovec-0.1.4-r1
	!=dev-rust/heapsize-0.4.2
	!=dev-rust/gumdrop-0.8.0
	!=dev-rust/git2-0.13.0
	!=dev-rust/gdbstub_arch-0.2.4
	!=dev-rust/gdbstub_arch-0.2.4-r1
	!=dev-rust/gdbstub_arch-0.2.4-r2
	!=dev-rust/futures-0.3.13
	!=dev-rust/futures-0.3.13-r1
	!=dev-rust/futures-0.3.13-r2
	!=dev-rust/futures-0.3.13-r3
	!=dev-rust/futures-0.3.13-r4
	!=dev-rust/futures-0.1.31
	!=dev-rust/env_logger-0.9.0
	!=dev-rust/env_logger-0.9.0-r1
	!=dev-rust/env_logger-0.9.0-r2
	!=dev-rust/env_logger-0.9.0-r3
	!=dev-rust/env_logger-0.9.0-r4
	!=dev-rust/env_logger-0.9.0-r5
	!=dev-rust/env_logger-0.8.3
	!=dev-rust/env_logger-0.8.3-r1
	!=dev-rust/env_logger-0.8.3-r2
	!=dev-rust/env_logger-0.8.3-r3
	!=dev-rust/env_logger-0.8.3-r4
	!=dev-rust/env_logger-0.8.3-r5
	!=dev-rust/deflate-0.8.6
	!=dev-rust/deflate-0.8.6-r1
	!=dev-rust/deflate-0.8.6-r2
	!=dev-rust/deflate-0.8.6-r3
	!=dev-rust/scoped_threadpool-0.1.0
	!=dev-rust/hmac-sha256-0.1.7
	!=dev-rust/hmac-sha256-0.1.7-r1
	!=dev-rust/gzip-header-0.3.0
	!=dev-rust/gif-0.11.1
	!=dev-rust/gdbstub-0.6.3
	!=dev-rust/gdbstub-0.6.3-r1
	!=dev-rust/gdbstub-0.6.3-r2
	!=dev-rust/gdbstub-0.6.3-r3
	!=dev-rust/gdbstub-0.6.3-r4
	!=dev-rust/gdbstub-0.6.3-r5
	!=dev-rust/criterion-0.3.3
	!=dev-rust/const_fn-0.4.3
	!=dev-rust/clippy-0.0.166
	!=dev-rust/bytemuck_derive-1.0.0
	!=dev-rust/android_log-sys-0.2.0
	!=dev-rust/wmi-0.9.0
	!=dev-rust/uniquote-3.0.0
	!=dev-rust/typenum-1.13.0
	!=dev-rust/stdweb-0.4.20
	!=dev-rust/sha1-0.6.0
	!=dev-rust/reqwest-0.11.10
	!=dev-rust/quickcheck_macros-0.8.0
	!=dev-rust/kernel32-sys-0.2.2
	!=dev-rust/jpeg-decoder-0.1.22
	!=dev-rust/cfg-if-0.1.10
	!=dev-rust/term_size-0.3.0
	!=dev-rust/quickcheck-1.0.3
	!=dev-rust/quickcheck-0.9.0
	!=dev-rust/prost-0.7.0
	!=dev-rust/petgraph-0.5.1
	!=dev-rust/openssl-probe-0.1.2
	!=dev-rust/form_urlencoded-1.0.1
	!=dev-rust/form_urlencoded-1.0.1-r1
	!=dev-rust/form_urlencoded-1.0.1-r2
	!=dev-rust/encoding-0.2.33
	!=dev-rust/const-random-0.1.6
	!=dev-rust/const-random-0.1.12
	!=dev-rust/rustc-test-0.3.0
	!=dev-rust/portable-atomic-0.3.0
	!=dev-rust/percent-encoding-2.1.0
	!=dev-rust/percent-encoding-1.0.1
	!=dev-rust/paw-1.0.0
	!=dev-rust/md5-0.7.0
	!=dev-rust/lexical-core-0.6.0
	!=dev-rust/fuchsia-zircon-0.3.2
	!=dev-rust/flame-0.1.12
	!=dev-rust/digest-0.9.0
	!=dev-rust/smawk-0.3.1
	!=dev-rust/once_cell-1.9.0
	!=dev-rust/once_cell-1.7.2
	!=dev-rust/petgraph-0.6.0
	!=dev-rust/log-0.4.14
	!=dev-rust/log-0.4.14-r1
	!=dev-rust/log-0.4.14-r2
	!=dev-rust/futures-executor-0.3.13
	!=dev-rust/futures-executor-0.3.13-r1
	!=dev-rust/futures-executor-0.3.13-r2
	!=dev-rust/futures-executor-0.3.13-r3
	!=dev-rust/futures-util-0.3.13
	!=dev-rust/futures-util-0.3.13-r1
	!=dev-rust/futures-util-0.3.13-r2
	!=dev-rust/futures-util-0.3.13-r3
	!=dev-rust/futures-util-0.3.13-r4
	!=dev-rust/futures-util-0.3.13-r5
	!=dev-rust/futures-util-0.3.13-r6
	!=dev-rust/futures-util-0.3.13-r7
	!=dev-rust/futures-util-0.3.13-r8
	!=dev-rust/futures-util-0.3.13-r9
	!=dev-rust/futures-channel-0.3.13
	!=dev-rust/futures-channel-0.3.13-r1
	!=dev-rust/vcpkg-0.2.11
	!=dev-rust/vcpkg-0.2.11-r1
	!=dev-rust/pin-utils-0.1.0
	!=dev-rust/openssl-macros-0.1.0
	!=dev-rust/openssl-macros-0.1.0-r1
	!=dev-rust/openssl-macros-0.1.0-r2
	!=dev-rust/openssl-macros-0.1.0-r3
	!=dev-rust/futures-task-0.3.13
	!=dev-rust/futures-sink-0.3.13
	!=dev-rust/futures-io-0.3.13
	!=dev-rust/futures-core-0.3.13
	!=dev-rust/futures-macro-0.3.13
	!=dev-rust/futures-macro-0.3.13-r1
	!=dev-rust/futures-macro-0.3.13-r2
	!=dev-rust/futures-macro-0.3.13-r3
	!=dev-rust/futures-macro-0.3.13-r4
	!=dev-rust/proc-macro-hack-0.5.19
	!~dev-rust/proc-macro-hack-0.5.11
	!=dev-rust/spidev-0.5.1
	!=dev-rust/spidev-0.5.1-r1
	!=dev-rust/spidev-0.5.1-r2
	!=dev-rust/i2cdev-0.5.1
	!=dev-rust/i2cdev-0.5.1-r1
	!=dev-rust/i2cdev-0.5.1-r2
	!=dev-rust/i2cdev-0.5.1-r3
	!=dev-rust/nix-0.23.0
	!=dev-rust/nix-0.23.0-r1
	!=dev-rust/nix-0.23.0-r2
	!=dev-rust/nix-0.23.0-r3
	!=dev-rust/nix-0.23.0-r4
	!=dev-rust/libloading-0.7.0
	!=dev-rust/libloading-0.7.0-r1
	!=dev-rust/fd-lock-3.0.2
	!=dev-rust/fd-lock-3.0.2-r1
	!=dev-rust/fd-lock-3.0.2-r2
	!=dev-rust/dirs-next-2.0.0
	!=dev-rust/dirs-next-2.0.0-r1
	!=dev-rust/dirs-next-2.0.0-r2
	!=dev-rust/crc32fast-1.2.1
	!=dev-rust/crc32fast-1.2.1-r1
	!=dev-rust/cfg-if-1.0.0
	!=dev-rust/xmlparser-0.13.3
	!=dev-rust/inflections-1.1.1
	!=dev-rust/which-4.2.1
	!=dev-rust/which-4.2.1-r1
	!=dev-rust/which-4.2.1-r2
	!=dev-rust/which-4.2.1-r3
	!=dev-rust/which-4.2.1-r4
	!=dev-rust/which-3.1.1
	!=dev-rust/which-3.1.1-r1
	!=dev-rust/which-3.1.1-r2
	!=dev-rust/riscv-target-0.1.2
	!=dev-rust/riscv-target-0.1.2-r1
	!=dev-rust/riscv-target-0.1.2-r2
	!=dev-rust/colored-2.0.0
	!=dev-rust/colored-2.0.0-r1
	!=dev-rust/colored-2.0.0-r2
	!=dev-rust/lazy_static-1.4.0
	!=dev-rust/lazy_static-1.4.0-r1
	!=dev-rust/lazy_static-1.4.0-r2
	!=dev-rust/libudev-0.2.0
	!=dev-rust/libudev-0.2.0-r1
	!=dev-rust/libudev-sys-0.1.4
	!=dev-rust/libudev-sys-0.1.4-r1
	!=dev-rust/libudev-sys-0.1.4-r2
	!=dev-rust/pkg-config-0.3.19
	!=dev-rust/cortex-m-rt-macros-0.6.15
	!=dev-rust/cortex-m-rt-macros-0.6.15-r1
	!=dev-rust/cortex-m-rt-macros-0.6.15-r2
	!=dev-rust/cortex-m-rt-macros-0.6.15-r3
	!=dev-rust/zeroize-1.5.1
	!=dev-rust/zeroize-1.5.1-r1
	!=dev-rust/zeroize-1.5.1-r2
	!=dev-rust/itertools-0.8.2
	!=dev-rust/itertools-0.8.2-r1
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
	"android_log-sys-0.2.0"
	"android_system_properties-0.1.5"
	"ansi_term-0.11.0"
	"arbitrary-0.4.7"
	"arbitrary-1.1.6"
	"arg_enum_proc_macro-0.3.2"
	"argh-0.1.8"
	"argh_derive-0.1.8"
	"argh_shared-0.1.8"
	"arrayvec-0.4.12"
	"arrayvec-0.5.2"
	"assert_matches-1.5.0"
	"async-stream-0.3.3"
	"async-stream-impl-0.3.3"
	"async-task-4.3.0"
	"async-trait-0.1.48"
	"atlatl-0.1.2"
	"atty-0.2.14"
	"autocfg-0.1.7"
	"autocfg-1.1.0"
	"average-0.9.4"
	"avif-serialize-0.6.5"
	"axum-0.5.16"
	"axum-core-0.2.8"
	"base-x-0.2.11"
	"base64-0.10.1"
	"base64-0.13.0"
	"beef-0.5.2"
	"bencher-0.1.5"
	"bit-vec-0.6.3"
	"bit_field-0.10.1"
	"bitfield-0.13.2"
	"bitflags-0.9.1"
	"bitflags-1.3.2"
	"bitreader-0.3.6"
	"bitstream-io-1.5.0"
	"block-buffer-0.10.3"
	"bson-1.2.4"
	"bstr-0.2.17"
	"bumpalo-3.11.0"
	"bytecount-0.6.3"
	"bytemuck-1.12.1"
	"bytemuck_derive-1.2.1"
	"byteorder-1.4.3"
	"capnp-0.14.10"
	"capnpc-0.14.9"
	"cargo_metadata-0.2.3"
	"cast-0.2.7"
	"cast-0.3.0"
	"cc-1.0.73"
	"cexpr-0.4.0"
	"cexpr-0.6.0"
	"cfg-expr-0.10.3"
	"cfg-if-0.1.10"
	"cfg-if-1.0.0"
	"chunked_transfer-1.4.0"
	"clang-sys-1.2.0"
	"clipboard-win-4.2.1"
	"clippy-0.0.166"
	"clippy_lints-0.0.166"
	"cloudabi-0.0.3"
	"cmake-0.1.48"
	"color_quant-1.1.0"
	"colored-2.0.0"
	"com_logger-0.1.1"
	"combine-3.8.1"
	"compiler_builtins-0.1.80"
	"configparser-3.0.0"
	"const-random-0.1.13"
	"const-random-macro-0.1.13"
	"const-sha1-0.2.0"
	"const_fn-0.4.9"
	"conv-0.3.3"
	"core-foundation-0.9.3"
	"core-foundation-sys-0.6.2"
	"core-foundation-sys-0.8.3"
	"cortex-m-rt-macros-0.6.15"
	"cpp_demangle-0.3.5"
	"cpufeatures-0.2.5"
	"crc-2.1.0"
	"crc-catalog-1.1.1"
	"crc32fast-1.3.2"
	"criterion-0.3.5"
	"criterion-plot-0.4.5"
	"crossbeam-0.8.2"
	"crunchy-0.2.2"
	"crypto-common-0.1.6"
	"cstr_core-0.2.6"
	"csv-1.1.6"
	"csv-core-0.1.10"
	"ct-codecs-1.1.1"
	"ctor-0.1.22"
	"cty-0.2.2"
	"custom_derive-0.1.7"
	"cxx-1.0.42"
	"cxxbridge-flags-1.0.42"
	"cxxbridge-macro-1.0.42"
	"darling-0.10.2"
	"darling_core-0.10.2"
	"darling_macro-0.10.2"
	"dav1d-0.6.1"
	"dav1d-sys-0.3.5"
	"dcv-color-primitives-0.1.16"
	"defer-drop-1.2.0"
	"deflate-0.8.6"
	"defmt-macros-0.2.3"
	"defmt-parser-0.2.2"
	"derive-into-owned-0.1.0"
	"derive_builder-0.9.0"
	"derive_builder_core-0.9.0"
	"derive_utils-0.11.2"
	"digest-0.10.5"
	"digest-0.9.0"
	"dirs-next-2.0.0"
	"dirs-sys-next-0.1.2"
	"discard-1.0.4"
	"document-features-0.2.6"
	"downcast-rs-1.2.0"
	"dtoa-0.2.2"
	"ed25519-1.5.2"
	"either-1.8.0"
	"encode_unicode-0.3.6"
	"encoding-0.2.33"
	"encoding-index-japanese-1.20141219.5"
	"encoding-index-korean-1.20141219.5"
	"encoding-index-simpchinese-1.20141219.5"
	"encoding-index-singlebyte-1.20141219.5"
	"encoding-index-tradchinese-1.20141219.5"
	"encoding_index_tests-0.1.4"
	"encoding_rs-0.8.31"
	"endian-type-0.1.2"
	"enumn-0.1.5"
	"env_logger-0.7.1"
	"env_logger-0.8.3"
	"env_logger-0.9.0"
	"errno-0.2.8"
	"errno-dragonfly-0.1.2"
	"error-code-2.3.0"
	"euclid-0.22.7"
	"failure-0.1.8"
	"failure_derive-0.1.8"
	"fallible-iterator-0.2.0"
	"fallible_collections-0.3.1"
	"fd-lock-2.0.0"
	"fd-lock-3.0.6"
	"filedescriptor-0.8.2"
	"fixedbitset-0.2.0"
	"fixedbitset-0.4.2"
	"flame-0.1.12"
	"flamer-0.1.4"
	"float-ord-0.2.0"
	"fnv-1.0.7"
	"foreign-types-0.3.2"
	"foreign-types-shared-0.1.1"
	"form_urlencoded-1.0.1"
	"fuchsia-cprng-0.1.1"
	"fuchsia-zircon-0.3.3"
	"fuchsia-zircon-sys-0.3.3"
	"futures-0.1.31"
	"futures-0.3.14"
	"futures-channel-0.3.14"
	"futures-core-0.3.14"
	"futures-enum-0.1.17"
	"futures-executor-0.3.14"
	"futures-io-0.3.14"
	"futures-macro-0.3.14"
	"futures-sink-0.3.14"
	"futures-task-0.3.14"
	"futures-util-0.3.14"
	"fuzzy-matcher-0.3.7"
	"gag-1.0.0"
	"gdbstub-0.6.3"
	"gdbstub_arch-0.2.4"
	"getopts-0.2.21"
	"ghost-0.1.6"
	"gif-0.11.4"
	"git2-0.13.25"
	"glob-0.3.0"
	"graphql-parser-0.3.0"
	"grpcio-compiler-0.6.0"
	"gumdrop-0.8.1"
	"gumdrop_derive-0.8.1"
	"gzip-header-0.3.0"
	"h2-0.3.14"
	"half-1.8.2"
	"hashbrown-0.12.3"
	"heapsize-0.4.2"
	"heck-0.3.3"
	"heck-0.4.0"
	"hermit-abi-0.1.18"
	"hex-0.4.3"
	"hmac-0.12.1"
	"hmac-sha256-0.1.7"
	"hostname-0.3.1"
	"http-0.2.8"
	"http-body-0.4.5"
	"http-range-header-0.3.0"
	"httparse-1.7.1"
	"httpdate-1.0.2"
	"humantime-2.1.0"
	"hyper-0.14.20"
	"hyper-timeout-0.4.1"
	"hyper-tls-0.5.0"
	"hyphenation_commons-0.7.1"
	"i2cdev-0.5.1"
	"iana-time-zone-0.1.47"
	"ident_case-1.0.1"
	"imgref-1.9.4"
	"indoc-0.3.6"
	"indoc-impl-0.3.6"
	"inflections-1.1.1"
	"inotify-0.9.3"
	"inotify-sys-0.1.5"
	"interpolate_name-0.2.3"
	"intrusive-collections-0.9.4"
	"inventory-0.1.11"
	"inventory-impl-0.1.11"
	"io-lifetimes-0.7.3"
	"io-uring-0.5.4"
	"ioctl-rs-0.1.6"
	"iovec-0.1.4"
	"ipnet-2.5.0"
	"iso8601-0.4.2"
	"itertools-0.10.5"
	"itertools-0.6.5"
	"itertools-0.8.2"
	"itertools-0.9.0"
	"itoa-0.1.1"
	"itoa-0.4.8"
	"itoa-1.0.3"
	"jobserver-0.1.24"
	"jpeg-decoder-0.1.22"
	"js-sys-0.3.60"
	"juniper-0.15.10"
	"juniper_codegen-0.15.9"
	"kernel32-sys-0.2.2"
	"lazy_static-0.2.11"
	"lazy_static-1.4.0"
	"lazycell-1.3.0"
	"lexical-core-0.6.8"
	"libc-0.2.132"
	"libfuzzer-sys-0.3.5"
	"libfuzzer-sys-0.4.4"
	"libloading-0.7.0"
	"libm-0.1.4"
	"libslirp-sys-4.2.1"
	"libudev-0.2.0"
	"libudev-sys-0.1.4"
	"link-cplusplus-1.0.5"
	"linux-raw-sys-0.0.46"
	"litrs-0.2.3"
	"log-0.4.14"
	"loop9-0.1.3"
	"managed-0.8.0"
	"match_cfg-0.1.0"
	"matches-0.1.9"
	"matchit-0.5.0"
	"maybe-uninit-2.0.0"
	"md-5-0.10.5"
	"md5-0.7.0"
	"memchr-2.5.0"
	"memoffset-0.5.6"
	"memoffset-0.6.5"
	"mime-0.3.16"
	"minimal-lexical-0.2.1"
	"miniz_oxide-0.3.7"
	"miniz_oxide-0.4.4"
	"miniz_oxide-0.5.4"
	"mio-extras-2.0.6"
	"miow-0.2.2"
	"miow-0.3.6"
	"mp4parse-0.11.5"
	"multi_log-0.1.2"
	"multimap-0.8.3"
	"nasm-rs-0.2.4"
	"native-tls-0.2.10"
	"net2-0.2.37"
	"nix-0.19.1"
	"nix-0.20.0"
	"nix-0.23.1"
	"nix-0.24.2"
	"nodrop-0.1.14"
	"nom-5.1.2"
	"nom-7.1.1"
	"noop_proc_macro-0.3.0"
	"ntapi-0.3.6"
	"num-cmp-0.1.0"
	"num-derive-0.3.3"
	"num-integer-0.1.45"
	"num-iter-0.1.43"
	"num-traits-0.1.43"
	"num-traits-0.2.14"
	"num_cpus-1.13.0"
	"num_threads-0.1.6"
	"number_prefix-0.4.0"
	"object-0.29.0"
	"once_cell-1.13.1"
	"oorandom-11.1.3"
	"openssl-macros-0.1.0"
	"openssl-probe-0.1.5"
	"packed_simd_2-0.3.8"
	"panic-halt-0.2.0"
	"paste-0.1.18"
	"paste-1.0.4"
	"paste-impl-0.1.18"
	"paw-1.0.0"
	"paw-attributes-1.0.2"
	"paw-raw-1.0.0"
	"pcap-file-1.1.1"
	"peeking_take_while-0.1.2"
	"percent-encoding-1.0.1"
	"percent-encoding-2.1.0"
	"pest-2.4.0"
	"petgraph-0.5.1"
	"petgraph-0.6.2"
	"pin-project-1.0.12"
	"pin-project-internal-1.0.12"
	"pin-project-lite-0.2.9"
	"pin-utils-0.1.0"
	"pkg-config-0.3.19"
	"plotters-0.3.4"
	"plotters-backend-0.3.4"
	"plotters-svg-0.3.3"
	"portable-atomic-0.3.15"
	"postgres-protocol-0.6.4"
	"postgres-types-0.2.4"
	"ppv-lite86-0.2.10"
	"prettyplease-0.1.20"
	"print_bytes-0.5.0"
	"printf-compat-0.1.1"
	"proc-macro-error-1.0.4"
	"proc-macro-error-attr-1.0.4"
	"proc-macro-hack-0.5.19"
	"proc-macro-nested-0.1.7"
	"proc-macro2-0.4.30"
	"proc-macro2-1.0.44"
	"prost-0.11.0"
	"prost-0.7.0"
	"prost-build-0.11.1"
	"prost-derive-0.11.0"
	"prost-derive-0.7.0"
	"prost-types-0.11.1"
	"protoc-grpcio-2.0.0"
	"pulldown-cmark-0.0.15"
	"pulldown-cmark-0.6.1"
	"pyo3-0.13.2"
	"pyo3-macros-0.13.2"
	"pyo3-macros-backend-0.13.2"
	"quick-error-1.2.3"
	"quickcheck-0.9.2"
	"quickcheck-1.0.3"
	"quickcheck_macros-0.8.0"
	"quine-mc_cluskey-0.2.4"
	"quote-0.3.15"
	"quote-0.6.13"
	"quote-1.0.9"
	"r0-0.2.2"
	"r0-1.0.0"
	"rand_xoshiro-0.1.0"
	"rav1e-0.4.1"
	"ravif-0.6.4"
	"rdrand-0.4.0"
	"redox_syscall-0.1.57"
	"redox_syscall-0.2.16"
	"redox_users-0.4.0"
	"regex-1.6.0"
	"regex-automata-0.1.10"
	"regex-syntax-0.4.2"
	"regex-syntax-0.6.27"
	"remain-0.2.4"
	"remove_dir_all-0.5.3"
	"reqwest-0.11.12"
	"rgb-0.8.34"
	"riscv-target-0.1.2"
	"ron-0.5.1"
	"rtic-core-1.0.0"
	"rtic-monotonic-1.0.0"
	"rust_hawktracer-0.7.0"
	"rust_hawktracer_normal_macro-0.4.1"
	"rust_hawktracer_proc_macro-0.4.1"
	"rustc-demangle-0.1.21"
	"rustc-hash-1.1.0"
	"rustc-std-workspace-alloc-1.0.0"
	"rustc-std-workspace-core-1.0.0"
	"rustc-std-workspace-std-1.0.1"
	"rustc-test-0.3.1"
	"rustix-0.35.9"
	"rustversion-1.0.9"
	"rusty-fork-0.3.0"
	"rustyline-derive-0.4.0"
	"rustyline-derive-0.6.0"
	"same-file-1.0.6"
	"schannel-0.1.20"
	"scoped-tls-1.0.0"
	"scoped_threadpool-0.1.9"
	"scopeguard-1.1.0"
	"scudo-0.1.2"
	"scudo-sys-0.2.1"
	"security-framework-2.7.0"
	"security-framework-sys-0.3.3"
	"security-framework-sys-2.6.1"
	"semver-parser-0.10.2"
	"semver-parser-0.7.0"
	"serde-0.8.23"
	"serde-1.0.145"
	"serde_cbor-0.11.2"
	"serde_derive-1.0.145"
	"serde_urlencoded-0.7.1"
	"serial-core-0.4.0"
	"serial-unix-0.4.0"
	"sha1-0.6.1"
	"sha1_smol-1.0.0"
	"sha2-0.10.6"
	"shell-words-1.1.0"
	"shlex-0.1.1"
	"shlex-1.1.0"
	"signal-hook-registry-1.4.0"
	"signature-1.6.4"
	"simd_helpers-0.1.0"
	"skim-0.9.4"
	"slab-0.4.7"
	"slog-2.7.0"
	"smartstring-0.2.10"
	"smawk-0.3.1"
	"spidev-0.5.1"
	"stable_deref_trait-1.2.0"
	"standback-0.2.17"
	"static_assertions-0.3.4"
	"static_assertions-1.1.0"
	"stdweb-0.4.20"
	"stdweb-derive-0.5.3"
	"stdweb-internal-macros-0.2.9"
	"stdweb-internal-runtime-0.1.5"
	"str-buf-1.0.5"
	"stringprep-0.1.2"
	"strsim-0.10.0"
	"strsim-0.8.0"
	"strsim-0.9.3"
	"structopt-derive-0.4.18"
	"subtle-2.4.1"
	"syn-0.11.11"
	"syn-0.15.44"
	"syn-1.0.101"
	"sync_wrapper-0.1.1"
	"synom-0.11.3"
	"synstructure-0.12.4"
	"synstructure_test_traits-0.1.0"
	"sys-info-0.9.1"
	"system-deps-6.0.2"
	"term-0.4.6"
	"term-0.7.0"
	"term_size-0.3.2"
	"termcolor-1.1.2"
	"terminal_size-0.1.17"
	"termios-0.2.2"
	"thiserror-1.0.32"
	"thiserror-impl-1.0.32"
	"thread-id-3.3.0"
	"thread-id-4.0.0"
	"tiff-0.6.1"
	"time-macros-0.1.1"
	"time-macros-0.2.4"
	"time-macros-impl-0.1.2"
	"timer-0.2.0"
	"tiny-keccak-2.0.2"
	"tinytemplate-1.2.1"
	"tinyvec-1.6.0"
	"tinyvec_macros-0.1.0"
	"tokio-io-timeout-1.2.0"
	"tokio-macros-1.8.0"
	"tokio-native-tls-0.3.0"
	"tokio-stream-0.1.3"
	"tokio-util-0.7.3"
	"tonic-0.8.1"
	"tonic-build-0.8.2"
	"tower-0.4.13"
	"tower-http-0.3.4"
	"tower-layer-0.3.1"
	"tower-service-0.3.2"
	"tracing-0.1.35"
	"tracing-attributes-0.1.22"
	"tracing-core-0.1.29"
	"tracing-futures-0.2.5"
	"try-lock-0.2.3"
	"tuikit-0.4.6"
	"typenum-1.15.0"
	"uart_16550-0.2.18"
	"ucd-trie-0.1.5"
	"ucs2-0.3.2"
	"uefi-0.17.0"
	"uefi-macros-0.8.1"
	"uefi-services-0.14.0"
	"ufmt-write-0.1.0"
	"uguid-1.2.1"
	"unicase-2.6.0"
	"unicode-ident-1.0.4"
	"unicode-linebreak-0.1.4"
	"unicode-segmentation-1.10.0"
	"unicode-width-0.1.10"
	"unicode-xid-0.0.4"
	"unicode-xid-0.1.0"
	"unicode-xid-0.2.4"
	"unindent-0.1.10"
	"uniquote-3.2.1"
	"unreachable-1.0.0"
	"utf8parse-0.2.0"
	"v_frame-0.2.5"
	"vcell-0.1.3"
	"vcpkg-0.2.11"
	"vec_map-0.8.2"
	"vergen-3.2.0"
	"version-compare-0.1.0"
	"version_check-0.9.3"
	"void-1.0.2"
	"volatile-0.4.5"
	"volatile-register-0.2.1"
	"vte-0.9.0"
	"vte_generate_state_changes-0.1.1"
	"wait-timeout-0.2.0"
	"walkdir-2.3.2"
	"want-0.3.0"
	"wasi-0.11.0+wasi-snapshot-preview1"
	"wasm-bindgen-0.2.83"
	"wasm-bindgen-backend-0.2.83"
	"wasm-bindgen-futures-0.4.33"
	"wasm-bindgen-macro-0.2.83"
	"wasm-bindgen-macro-support-0.2.83"
	"wasm-bindgen-shared-0.2.83"
	"wasmparser-0.57.0"
	"web-sys-0.3.60"
	"weezl-0.1.7"
	"which-3.1.1"
	"which-4.3.0"
	"widestring-0.5.1"
	"winapi-0.2.8"
	"winapi-0.3.9"
	"winapi-build-0.1.1"
	"winapi-i686-pc-windows-gnu-0.4.0"
	"winapi-util-0.1.5"
	"winapi-x86_64-pc-windows-gnu-0.4.0"
	"windows-0.10.0"
	"windows-sys-0.36.1"
	"windows-sys-0.42.0"
	"windows_aarch64_gnullvm-0.42.0"
	"windows_aarch64_msvc-0.36.1"
	"windows_aarch64_msvc-0.42.0"
	"windows_gen-0.10.0"
	"windows_i686_gnu-0.36.1"
	"windows_i686_gnu-0.42.0"
	"windows_i686_msvc-0.36.1"
	"windows_i686_msvc-0.42.0"
	"windows_macros-0.10.0"
	"windows_x86_64_gnu-0.36.1"
	"windows_x86_64_gnu-0.42.0"
	"windows_x86_64_gnullvm-0.42.0"
	"windows_x86_64_msvc-0.36.1"
	"windows_x86_64_msvc-0.42.0"
	"winreg-0.10.1"
	"wio-0.2.2"
	"wmi-0.9.3"
	"ws2_32-sys-0.2.1"
	"x86_64-0.14.10"
	"xml-rs-0.8.4"
	"xmlparser-0.13.3"
	"zeroize-1.5.7"
	"zeroize_derive-1.3.2"
)

pkg_setup() {
	python-single-r1_pkg_setup
	# This handles calling cros-workon_pkg_setup for us.
	cros-rust_pkg_setup
}

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
