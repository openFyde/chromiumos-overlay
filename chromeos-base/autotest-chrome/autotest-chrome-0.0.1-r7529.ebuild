# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="32094cf339ac36bb81f6c8451e15f677afee0d1d"
CROS_WORKON_TREE="1dc175b4ecba4306cf03e948239bcded636b585b"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit toolchain-funcs flag-o-matic cros-workon autotest

DESCRIPTION="Autotest tests that require chrome_binary_test, or telemetry deps"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Enable autotest by default.
IUSE="
	${IUSE}
	android-container-nyc
	android-container-pi
	+autotest
	+cellular
	+shill
	+tpm
	tpm2
	vaapi
"

RDEPEND="
	!chromeos-base/autotest-telemetry
	!<chromeos-base/autotest-tests-0.0.4
	!<chromeos-base/autotest-tests-cellular-0.0.1-r3203
	chromeos-base/autotest-deps-graphics
	chromeos-base/autotest-deps-policy
	chromeos-base/autotest-deps-webgl-mpd
	chromeos-base/chromeos-chrome
	dev-python/mkvparse
	shill? ( chromeos-base/shill-test-scripts )
	chromeos-base/telemetry
	sys-apps/ethtool
	vaapi? ( x11-libs/libva )
	tests_graphics_Sanity? ( media-gfx/imagemagick x11-libs/libdrm )
	tests_graphics_WebGLAquarium? ( app-benchmarks/microbenchmarks dev-util/memory-eater-locked )
	virtual/autotest-private-libs
"

DEPEND="${RDEPEND}"

IUSE_TESTS=(
	# Uses chrome_binary_test dependency.
	+tests_video_JDAPerf
	+tests_video_JEAPerf
	+tests_video_JpegDecodeAccelerator
	+tests_video_JpegEncodeAccelerator
	+tests_video_VideoDecodeAccelerator
	+tests_video_VideoEncodeAccelerator
	+tests_video_VDAPerf
	+tests_video_VDASanity
	+tests_video_VEAPerf

	# Tests that depend on telemetry.
	+tests_accessibility_Sanity
	+tests_accessibility_ChromeVoxSound
	+tests_audio_ActiveStreamStress
	+tests_audio_AudioCorruption
	+tests_audio_CrasSanity
	+tests_audio_PlaybackPower
	+tests_audio_SeekAudioFeedback
	+tests_autoupdate_CrashBrowserAfterUpdate
	+tests_autoupdate_EOL
	+tests_autoupdate_LoginStartUpdateLogout
	+tests_autoupdate_StartOOBEUpdate
	+tests_autoupdate_UserData
	+tests_bluetooth_AdapterReboot
	+tests_bluetooth_AdapterSanity
	+tests_bluetooth_IDCheck
	+tests_bluetooth_RegressionClient
	+tests_bluetooth_TurnOnOffUI
	+tests_cheets_AppCompatTest
	+tests_desktopui_AudioFeedback
	tests_desktopui_CameraApp
	+tests_desktopui_CheckRlzPingSent
	+tests_desktopui_ChromeSanity
	tests_desktopui_ConnectivityDiagnostics
	+tests_desktopui_FilesApp
	+tests_desktopui_FlashSanityCheck
	+tests_desktopui_MediaAudioFeedback
	+tests_desktopui_ScreenLocker
	+tests_desktopui_SimpleLogin
	+tests_desktopui_UrlFetchWithChromeDriver
	+tests_display_ClientChameleonConnection
	+tests_display_DisplayContainEdid
	+tests_dummy_IdleSuspend
	+tests_enterprise_FakeEnrollment
	+tests_enterprise_KioskEnrollment
	+tests_enterprise_OnlineDemoModeEnrollment
	+tests_enterprise_PowerManagement
	+tests_enterprise_RemoraRequisition
	+tests_graphics_Chrome
	+tests_graphics_HwOverlays
	+tests_graphics_Sanity
	+tests_graphics_Stress
	+tests_graphics_VideoRenderingPower
	+tests_graphics_VTSwitch
	+tests_graphics_WebGLAquarium
	+tests_graphics_WebGLManyPlanetsDeep
	tests_logging_AsanCrash
	+tests_logging_CrashServices
	+tests_logging_FeedbackReport
	+tests_login_ChromeProfileSanitary
	+tests_login_CryptohomeDataLeak
	+tests_login_CryptohomeIncognito
	+tests_login_GaiaLogin
	+tests_login_LoginSuccess
	+tests_login_OobeLocalization
	+tests_login_SavePassword
	+tests_login_UnicornLogin
	+tests_longevity_Tracker
	+tests_network_CastTDLS
	+tests_network_ChromeWifiConfigure
	+tests_network_ChromeWifiTDLS
	+tests_platform_AddPrinter
	+tests_platform_ChromeCgroups
	+tests_platform_InitLoginPerf
	+tests_platform_InputBrightness
	+tests_platform_InputBrowserNav
	+tests_platform_InputNewTab
	+tests_platform_InputScreenshot
	+tests_platform_InputVolume
	+tests_platform_LogoutPerf
	+tests_platform_LowMemoryTest
	+tests_platform_MouseScrollTest
	+tests_platform_PrintJob
	+tests_platform_SessionManagerBlockDevmodeSetting
	+tests_platform_ScrollTest
	+tests_policy_AllowDeletingBrowserHistory
	+tests_policy_AllowDinosaurEasterEgg
	+tests_policy_AllowScreenLock
	+tests_policy_AlternateErrorPages
	+tests_policy_ArcAudioCaptureAllowed
	+tests_policy_ArcExternalStorageDisabled
	+tests_policy_ArcVideoCaptureAllowed
	+tests_policy_ArcDisableScreenshots
	+tests_policy_AudioOutputAllowed
	+tests_policy_BookmarkBarEnabled
	+tests_policy_ChromeOsLockOnIdleSuspend
	+tests_policy_CookiesAllowedForUrls
	+tests_policy_CookiesBlockedForUrls
	+tests_policy_CookiesSessionOnlyForUrls
	+tests_policy_DefaultGeolocationSetting
	+tests_policy_DefaultImagesSetting
	+tests_policy_DefaultJavaScriptSetting
	+tests_policy_DefaultNotificationsSetting
	+tests_policy_DefaultSearchProvider
	+tests_policy_DeveloperToolsAvailability
	+tests_policy_DeviceAllowBluetooth
	+tests_policy_DeviceAutoUpdateDisabled
	+tests_policy_DeviceTargetVersionPrefix
	+tests_policy_DisableScreenshots
	+tests_policy_DownloadDirectory
	+tests_policy_DriveDisabled
	+tests_policy_EditBookmarksEnabled
	+tests_policy_DeviceEphemeralUsersEnabled
	+tests_policy_EnrollmentRetainment
	+tests_policy_EnterpriseForceInstallCustom
	+tests_policy_ExtensionAllowedTypes
	+tests_policy_ExtensionControls
	+tests_policy_ExtensionPolicy
	+tests_policy_ExternalStorageDisabled
	+tests_policy_ExternalStorageReadOnly
	+tests_policy_ForceGoogleSafeSearch
	+tests_policy_ForceYouTubeRestrict
	+tests_policy_ForceYouTubeSafetyMode
	+tests_policy_HomepageLocation
	+tests_policy_ImagesAllowedForUrls
	+tests_policy_ImagesBlockedForUrls
	+tests_policy_IncognitoModeAvailability
	+tests_policy_JavaScriptAllowedForUrls
	+tests_policy_JavaScriptBlockedForUrls
	+tests_policy_KeyboardDefaultToFunctionKeys
	+tests_policy_KeyPermissions
	+tests_policy_KioskModeEnabled
	+tests_policy_ManagedBookmarks
	+tests_policy_NativePrintersBulkAccessMode
	+tests_policy_NewTabPageLocation
	+tests_policy_NotificationsAllowedForUrls
	+tests_policy_NotificationsBlockedForUrls
	+tests_policy_PasswordManager
	+tests_policy_PinnedLauncherApps
	+tests_policy_PluginsAllowedForUrls
	+tests_policy_PluginsBlockedForUrls
	+tests_policy_PolicyRefreshRate
	+tests_policy_PopupsAllowedForUrls
	+tests_policy_PopupsBlockedForUrls
	+tests_policy_PowerManagementIdleSettings
	+tests_policy_PrintingEnabled
	+tests_policy_PromptForDownloadLocation
	+tests_policy_ProxySettings
	+tests_policy_ReportUploadFrequency
	+tests_policy_RestoreOnStartupURLs
	+tests_policy_SafeBrowsingEnabled
	+tests_policy_SavingBrowserHistoryDisabled
	+tests_policy_ScreenBrightnessPercent
	+tests_policy_SearchSuggestEnabled
	+tests_policy_SecondaryGoogleAccountSigninAllowed
	+tests_policy_ShowLogoutButtonInTray
	+tests_policy_ShowHomeButton
	+tests_policy_SystemTimezone
	+tests_policy_TranslateEnabled
	+tests_policy_URLBlacklist
	+tests_policy_URLWhitelist
	+tests_policy_UserNativePrintersAllowed
	+tests_power_AudioDetector
	+tests_power_Consumption
	+tests_power_Display
	+tests_power_FlashVideoSuspend
	+tests_power_Idle
	+tests_power_IdleSuspend
	+tests_power_LoadTest
	+tests_power_LowMemorySuspend
	+tests_power_UiResume
	+tests_power_VideoDetector
	+tests_power_VideoPlayback
	+tests_power_VideoSuspend
	+tests_power_WebGL
	+tests_security_BundledExtensions
	+tests_telemetry_AFDOGenerateClient
	+tests_telemetry_Sanity
	+tests_telemetry_UnitTests
	+tests_telemetry_UnitTestsServer
	+tests_touch_GestureNav
	+tests_touch_MouseScroll
	+tests_touch_ScrollDirection
	+tests_touch_TapSettings
	+tests_touch_TabSwitch
	+tests_touch_TouchscreenScroll
	+tests_touch_TouchscreenTaps
	+tests_touch_TouchscreenZoom
	+tests_touch_StylusTaps
	+tests_video_ChromeHWDecodeUsed
	+tests_video_ChromeRTCHWDecodeUsed
	+tests_video_ChromeRTCHWEncodeUsed
	+tests_video_ChromeVidResChangeHWDecode
	+tests_video_GlitchDetection
	+tests_video_HangoutHardwarePerf
	+tests_video_MediaRecorderHWEncodeUsed
	+tests_video_MediaRecorderPerf
	+tests_video_MultiplePlayback
	+tests_video_PlaybackPerf
	+tests_video_VideoCorruption
	+tests_video_VideoDecodeMemoryUsage
	+tests_video_VideoReload
	+tests_video_VideoSanity
	+tests_video_VideoSeek
	+tests_video_WebRtcCamera
	+tests_video_WebRtcMediaRecorder
	+tests_video_WebRtcPerf
	+tests_video_WebRtcPeerConnectionWithCamera
	+tests_video_YouTubeHTML5
	+tests_video_YouTubeMseEme
	+tests_video_YouTubePage
)

IUSE_TESTS_CELLULAR="
	cellular? (
		+tests_cellular_ModemControl
		+tests_cellular_SuspendResume
		+tests_network_ChromeCellularEndToEnd
		+tests_network_ChromeCellularNetworkPresent
		+tests_network_ChromeCellularNetworkProperties
		+tests_network_ChromeCellularSmokeTest
	)
"

IUSE_TESTS_SHILL="
	shill? (
		+tests_network_ChromeWifiEndToEnd
		+tests_network_FirewallHolePunch
		+tests_network_RackWiFiConnect
		+tests_network_RoamSuspendEndToEnd
		+tests_network_RoamWifiEndToEnd
		+tests_policy_GlobalNetworkSettings
		+tests_policy_WiFiAutoconnect
		+tests_policy_WiFiPrecedence
		+tests_policy_WiFiTypes
	)
"

# This is here instead of in autotest-tests-tpm because it would be far more
# work and duplication to add telemetry dependencies there.
IUSE_TESTS_TPM="
	tpm? ( +tests_platform_Pkcs11InitOnLogin )
	tpm2? ( +tests_platform_Pkcs11InitOnLogin )
"

# TODO(ihf): unify N and P tests once they pass reliably.
IUSE_TESTS_ARC="
	android-container-pi? (
		+tests_graphics_Idle_P
	)
	android-container-nyc? (
		+tests_graphics_Idle
	)
"

IUSE_TESTS="
	${IUSE_TESTS[*]}
	${IUSE_TESTS_CELLULAR}
	${IUSE_TESTS_SHILL}
	${IUSE_TESTS_TPM}
	${IUSE_TESTS_ARC}
"

IUSE="
	${IUSE}
	${IUSE_TESTS}
"

CROS_WORKON_LOCALNAME=../third_party/autotest/files

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_prepare() {
	# Telemetry tests require the path to telemetry source to exist in order to
	# build. Copy the telemetry source to a temporary directory that is writable,
	# so that file removals in Telemetry source can be performed properly.
	export TMP_DIR="$(mktemp -d)"
	rsync -a --exclude=third_party/trace-viewer/test_data/ \
		"${SYSROOT}"/usr/local/telemetry/src/ "${TMP_DIR}"
	export PYTHONPATH="${TMP_DIR}/third_party/catapult/telemetry"
	autotest_src_prepare
}

src_configure() {
	cros-workon_src_configure
}
