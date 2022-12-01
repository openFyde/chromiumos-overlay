Chromium DEPS pulls in a versioned copy of the [Chrome OS third_party/libdrm](https://source.chromium.org/chromium/chromium/src/+/main:DEPS?q=%22chromiumos%2Fthird_party%2Flibdrm.git%22%20file:DEPS&ss=chromium).
Ideally the hash should be rolled with each ebuild uprev (but not essential for
each local patch).

Please monitor after each libdrm uprev the [Chrome OS LKGM builds](https://chromium-review.googlesource.com/q/Automated+Commit:+LKGM+for+chromeos).
Look for amd64-generic and betty failures in ozone_unittests, especially
failures affecting Display and DRM. If such failures appear this may indicate a
need to [adjust the structures in mock_drm_device.h](http://b/222614515).

Example Chromium roll created with:
~/chromium/src$ roll-dep --roll-to b9ca37b3134861048986b75896c0915cbf2e97f9 -b b:247687324 src/third_party/libdrm/src
