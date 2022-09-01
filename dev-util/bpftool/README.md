# bpftool

This tool is used to generate eBPF skeleton helpers that are useful for loading,
attaching and communicating with eBPF applications.

## Updating

This package differs from the upstream version in that it depends on the github
mirror rather than pulling down kernel source and patching it. Advantage of this
is that the mirror has a cleaner versioning scheme and does not have python
dependencies for document generation.

Fetch and package a new upstream version (using v6.8.0 as an example):

```
$ TAG=6.8.0 D=$(mktemp -d); \
  git clone -q --depth 1 -b v${TAG} --recurse-submodules https://github.com/libbpf/bpftool.git ${D}/bpftool-${TAG} && \
  tar --exclude-vcs --sort=name --owner=root:0 --group=root:0 --mtime='UTC 2022-01-01' -f - -cJC ${D} . | tee bpftool-${TAG}.tar.xz | sha512sum; \
  rm -rf ${D}
```

Then follow the instructions for
[Updating localmirror](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/archive_mirrors.md#Updating-localmirror-localmirror_private).

CL reviewers are strongly encouraged to follow the same instructions to verify
provenance using the sha512sum in Manifest.
