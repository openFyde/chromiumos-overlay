# Migration instructions

The migration to `dev-rust/third-party-crates-src` is relatively complex. This
doc describes how to migrate things.

Conceptually, migration for a crate is relatively simple:

1. Make the crate available in `third_party/rust_crates`
2. Remove the crate from our depgraph
3. Done! Woohoo!

However, there are complications in reality:

- Some crates require patches.
- Some crates depend on other crates which are not yet migrated.
- Ebuilds can't always be removed immediately, as we may need `cros_workon` to
  uprev some 9999 ebuilds.

So mechanically, the simple case for updating is:

1. Ensure the crate to migrate `DEPEND`s on nothing but
   `dev-rust/third-party-crates-src:=`. Sometimes, this may require bubbling
   dependencies up to users of the crate you're interested in. In some cases, we
   may simply keep the crate in its state of "doing nothing but providing
   `DEPENDS`." If the crate `DEPEND`s on other third-party `dev-rust/` crates,
   those should be migrated first for the sake of simplicity.
2. Ensure that a compatible version of the crate is available in `rust_crates`.
   Compatibility is somewhat difficult to determine, since it depends on users:
   if the users require a very specific version of a crate, then that exact
   crate must be available in `rust_crates`. Otherwise, a [symver-compatible
   version](https://docs.rs/semver/latest/semver/) that is at least as new as
   the `dev-rust` version may be used.
3. Empty the crate's ebuild out using `./automigrate_crate.py`. This should
   essentially replace the ebuild with a nop, leaving its `DEPEND` variables
   in-tact, and incrementing its revision.
4. Run `./write_allowlisted_crate_versions.py` to update third-party-crates-src
   to add relevant `RDEPEND` blockers and update blocklist entries.
5. Mark `third-party-crates-src` as stable with:

```
~/chromiumos/chromite/scripts/cros_uprev --force --overlay-type public \
  --packages dev-rust/third-party-crates-src
```

You have now migrated a single version of a crate. If this is the last
unmigrated version of said crate in-tree, you can proceed below. Otherwise,
you'll need to empty out the other available versions of the crate before
proceeding. (Technically, if you're careful, you can move on to the below, but
the tooling might not guide you in the right direction, since it was designed to
wipe out a directory at a time.)

1. Run `./remove_crates_from_depgraph.py` to locate all users of the crate, and
   remove their `DEPEND` on the crate. Note that since `DEPEND` updating in the
   general case is difficult, you'll have to go in and actually update these.
   The script inserts `'>>> '` before every expected `DEPEND`ency, so finding
   them should be straightforward. Note that in each of the ebuilds touched by
   this, you will also have to ensure that `dev-rust/third-party-crates-src:=`
   is in the `DEPEND` line.
2. Update the revisions for all of the ebuilds modified by step 5.
3. **If you modified zero `-9999` ebuilds** above, you may delete the crate's
   directory. If not, you will need to delete the directory in a later commit;
   the crate ebuilds must stick around until all `-9999` ebuilds are marked as
   stable.
4. Commit the result, and upload for review.

## Figuring out candidates to delete

To find candidates for immediate deletion (e.g., ones where you can start at
"Run `./remove_crates_from_depgraph.py`" above),
`./find_dep_removal_candidates.py` should give you the info you need.

## `-r{N+1}` assistance

`./bump_modified_file_revs.py` autodetects all modified ebuilds in `git` and
adds one to their revision (adding -r1 if none previously existed). It takes
symlinks into account. Note that `modified` here literally means "`git status`
printed `modified:`."
