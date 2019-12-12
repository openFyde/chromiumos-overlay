This package (ldb) has been modified from upstream Gentoo and moved from
portage-stable due to a Samba bug that breaks cross-compilation
(https://bugzilla.samba.org/show_bug.cgi?id=13846). This package can be moved
back to portage-stable once the cross-compilation bug has been fixed.

However, unlike other Samba dependencies (i.e. tdb, tevent, talloc),
net-fs/samba depends on a specific version range for ldb. Therefore, upreving
ldb to a version that fixes the above bug would likely also require upreving
net-fs/samba.
