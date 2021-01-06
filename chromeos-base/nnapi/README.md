# NNAPI Dependency Updating Instructions

## Background

To fully update the NNAPI dependencies, the following repos need
to be addressed:

* `aosp/platform/frameworks/native`
* `aosp/platform/system/core/libcutils`
* `aosp/platform/system/core/libutils`
* `aosp/platform/system/libbase`
* `aosp/platform/system/libfmq`
* `aosp/platform/system/libhidl`
* `aosp/platform/system/logging`

Most of these can be updated by merging the `upstream` branch of the
repo into the `master` branch. There are however, two cases where this
does not apply.

### The Two Copybara Cases

The NNAPI package depends on some repo's that are copybara'd from another
repo.

Specifically, the following repos:

* `aosp/system/core/libcutils`
* `aosp/system/core/libutils`

Are updated by a copybara process from `aosp/platform/system/core`.

You can see the status of this process on the [Copybara dashboard](https://copybara.corp.google.com/list-jobs?piperConfigPath=%2F%2Fdepot%2Fgoogle3%2Fthird_party%2Fcopybara-gsubtreed%2Faosp%2Fcopy.bara.sky).

In short, whenever the `master` branch of `aosp/platform/system/core` is
updated, the copybara process will (at some point in the future), propagate
those changes into `aosp/system/core/libcutils` and
`aosp/system/core/libutils`.

This means that we can't directly control when the downstream repo
will get updated by the copybara process. It is possible that builds of
NNAPI will start failing if the infrastructure tries to uprev NNAPI to
use updated versions of `libcutils` and `libutils` that are possibly
incompatible.

Due avoid this, and ensure we have explicit control over which version of
these copybara'd directories is built, we have introduced
CROS_WORKON_MANUAL_UPREV to the NNAPI package which means we need to
manually update the commit and tree id's of the non-9999 ebuild.
This decouples the updating of `aosp/platform/system/core` from the NNAPI
package.

## Process

### Update the forked repositories

| Repo | Local Dir | Upstream Branch |
| ---- | --------- | --------------- |
| `aosp/platform/frameworks/native` | `aosp/frameworks/native` | `cros/upstream/master` |
| `aosp/platform/system/libbase`    | `aosp/system/libbase` | `cros/upstream/master` |
| `aosp/platform/system/libfmq`     | `aosp/system/libfmq` | `cros/upstream/master` |
| `aosp/platform/system/libhidl`    | `aosp/system/libhidl` | `cros/upstream/master` |
| `aosp/platform/system/logging`    | `aosp/system/logging` | `cros/upstream/master` |

Steps:

1.  Change into the repo local directory
1.  Create a merge branch from `master`
1.  Do a non-ff git merge from the upstream branch into `master`
1.  `repo upload` to gerrit and process the CL as normal
1.  At this stage you don't need to make any code changes due to
    CROS_WORKON_MANUAL_UPREV. The package won't use this updated
    code yet.

Example:

```bash
cd src/aosp/system/libbase
git checkout -b merge cros/master
# This will ask for an appropriate commit msg
git merge cros/upstream/master --no-ff
# This may give you a scary warning about the number of commits. Say 'y'.
repo upload --cbr . --no-verify
```

### Update the Copybara repo

As described earlier, `aosp/system/core/libcutils` and
`aosp/system/core/libutils` are updated by merging upstream into the master
of `aosp/platform/system/core`. Given the amount of changes in this repo,
it is best to ask the git admins to do this.

#### Raise a bug for Git admins

Use http://go/git-admin-bug to raise an Infra-Git ticket template
with the following details:

> Summary: "Please fast-forward master to upstream for aosp/system/core".

> * googlesource host (e.g. chromium, chrome-internal): chromium
> * name of the repo: https://chromium.googlesource.com/aosp/platform/system/core
> * permissions: default
>
> Please fast-forward master to the tip of upstream, thank you!

### Update the commit id and tree id in the ebuild

TODO once I have the CROS_WORKON_MANUAL_UPREV change committed and can actually
do this and get the steps exactly right.
