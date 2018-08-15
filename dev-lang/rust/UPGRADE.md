# Upgrading the Rust Toolchain on Chrome OS

> **WARNING**: These steps are only general in nature. Sometimes things can go
> wrong, especially with applying patches. This is expected to happen and best
> judgement should be used.

Follow these steps to upgrade the rust ebuild.

1. `git mv rust-<old version>.ebuild rust-<new version>.ebuild`
2. Add mirror to the `RESTRICT` variable.
3. Set `STAGE0_DATE` to date from `https://github.com/rust-lang/rust/blob/<new version>/src/stage0.txt`.
4. `ebuild rust-<new version>.ebuild manifest`
5. Remove mirror from `RESTRICT` variable.
6. `ebuild rust-<new version>.ebuild compile`
7. Update vendored library checksums.
8. `ebuild rust-<new version>.ebuild compile`
9. `sudo ebuild rust-<new version>.ebuild merge`
10. Upload change for review. CC reviewers from previous upgrade.

> Before sending to CQ, ensure every file in the `Manifest` is in localmirror
> or gentoo mirror. First check for the file in
> `gs://chromeos-mirror/gentoo/distfiles/` and then check in
> `gs://chromeos-localmirror/distfiles/`. If the file is not in either one,
> upload it using:

```shell
gsutil cp -a public-read \
    /var/cache/chromeos-cache/distfiles/host/<file from manifest> \
    gs://chromeos-localmirror/distfiles/
```
