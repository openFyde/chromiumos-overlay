# ti50-sdk

This package is the toolchain for the ti50 effort (go/ti50). It's composed of a
riscv-enabled C/C++ toolchain, and a riscv-enabled Rust toolchain. It's
currently supported by the ti50 team.

# Upgrading

`dev-embedded/ti50-sdk` is logically composed of three parts: clang, newlib, and
rust. It's possible to upgrade each of these independently.

That said, a common point between all of these is how sources are stored: a dev
uses `files/pack_git_tarball.py` to pack a source tarball, then uploads said
tarball to `gs://chromeos-localmirror/distfiles`.

Example per-project invocations of `files/pack_git_tarball.py` are available
below. It's important to keep in mind that **once you upload a new tarball and
point the ti50-sdk ebuild at it, you need to run `ebuild $(equery w
dev-embedded/ti50-sdk) manifest`**. Otherwise, when you try to download these
files from `gs://chromeos-localmirror`, you'll get file integrity errors.

It's important to note that `chromeos-localmirror` is a large, shared bucket.
Things uploaded to it aren't "final" (e.g., feel free to update them) until a
commit depending on them is landed. After such a commit lands, files aren't to
be changed. You can read more
[here](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/archive_mirrors.md).

Additionally, any patches done to upstream sources should be done *explicitly*
in the ebuild. Tarballs uploaded to chromeos-localmirror are expected to be
clean and true mirrors of the sets of sources available upstream.

## Upgrading clang

In order to upgrade clang, you'll need a tarball of [clang's and LLVM's
sources](https://github.com/llvm/llvm-project) at the SHA you're interested in.
Once you have that at `${dir}`, you can create a git tarball:

```
files/pack_git_tarball.py --git-dir "${dir}" --output-prefix /tmp/llvm
```

This should give you a path that looks like `/tmp/llvm-${sha}-src.tar.xz`. You
can now upload that to gs:

```
gsutil cp -n -a public-read /tmp/llvm-${sha}-src.tar.xz \
    gs://chromeos-localmirror/distfiles/llvm-${sha}-src.tar.xz
```

After running `ebuild manifest` as described in the section above, you should be
able to start testing these changes via `sudo emerge dev-embedded/ti50-sdk`.

## Upgrading newlib

In order to upgrade newlib, you'll need to pull it from [its
upstream repo](https://sourceware.org/git/newlib-cygwin.git). With that at
`${dir}`, you can create a git tarball:

```
files/pack_git_tarball.py --git-dir "${dir}" --output-prefix /tmp/newlib
```

This should give you a path that looks like `/tmp/newlib-${sha}-src.tar.xz`. You
can now upload that to gs:

```
gsutil cp -n -a public-read /tmp/newlib-${sha}-src.tar.xz \
    gs://chromeos-localmirror/distfiles/newlib-${sha}-src.tar.xz
```

After running `ebuild manifest` as described in the section above, you should be
able to start testing these changes via `sudo emerge dev-embedded/ti50-sdk`.

## Upgrading rust

In order to upgrade rust, you'll need to pull it from [its upstream
repo](https://github.com/rust-lang/rust). With that at
`${dir}`, you can create a git tarball. **Note** that Rust makes use of two
things that add complexity here:

- Submodules
- Vendored dependencies

A convenient shorthand to ensure all submodules are at the correct revision is
`${dir}/x.py help`. You have to manually ensure all submodules are up-to-date
before trying to pack rust's sources. Without this, things may be at
inconsistent versions, which can lead to build errors.

Dependency vendoring is handled by passing an extra flag to
`files/pack_git_tarball.py`. Your invocation should look something like:

```
files/pack_git_tarball.py --git-dir "${dir}" --output-prefix /tmp/rustc \
    --post-copy-command 'cargo vendor'
```

(Emphasis on "please ensure `--post-copy-command 'cargo vendor'` is specified."
Your build will break otherwise. :) )

This should give you a path that looks like `/tmp/rustc-${sha}-src.tar.xz`. You
can now upload that to gs:

```
gsutil cp -n -a public-read /tmp/rustc-${sha}-src.tar.xz \
    gs://chromeos-localmirror/distfiles/rustc-${sha}-src.tar.xz
```

After running `ebuild manifest` as described in the section above, you should be
able to start testing these changes via `sudo emerge dev-embedded/ti50-sdk`.

## Iterative development

Standard ebuild development practices apply here: `sudo emerge
dev-embedded/ti50-sdk` will clean everything up and start all builds from
scratch. This is desirable in many cases, but not so much when trying to iterate
with a broken toolchain.

The flow the author (gbiv@) used boiled down to `sudo ebuild $(equery w
dev-embedded/ti50-sdk) compile`, which is much more lightweight when e.g.,
trying to figure out why Rust is broken, since it doesn't require a full, fresh
build of LLVM + newlib on every iteration.
