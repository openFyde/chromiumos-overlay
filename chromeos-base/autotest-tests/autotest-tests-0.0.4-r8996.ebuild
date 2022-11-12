# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="68a53bcf159c1c84ea5695263e83d86e1364d8a4"
CROS_WORKON_TREE="9c4c73178e0748fc909fd4de0ec06a4b85db90f9"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit libchrome cros-workon autotest python-any-r1

DESCRIPTION="Autotest tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="arc-camera3 biod -chromeless_tests -chromeless_tty +crash_reporting cups +encrypted_stateful +network_time +passive_metrics +profile vaapi"
# Enable autotest by default.
IUSE="${IUSE} +autotest"

# pygobject is used in the following tests:
#   platform_CrosDisks*
RDEPEND="
	>=chromeos-base/autotest-deps-0.0.3
	!<=chromeos-base/autotest-factory-0.0.1-r4445
	dev-python/numpy
	dev-python/pillow
	dev-python/pydbus
	dev-python/pygobject
	dev-python/pytest
	dev-python/python-uinput
	media-sound/sox
	sys-apps/ethtool
	vaapi? ( x11-libs/libva )
	virtual/autotest-tests
"

RDEPEND="${RDEPEND}
	tests_dbench? ( dev-libs/libaio )
	tests_hardware_MemoryLatency? ( app-benchmarks/lmbench )
	tests_hardware_MemoryThroughput? ( app-benchmarks/lmbench )
	tests_hardware_MemoryZRAMThroughput? ( app-benchmarks/microbenchmarks )
	tests_xfsFilesystemTestSuite? ( app-benchmarks/xfstests )
"

DEPEND="${RDEPEND}"

X86_IUSE_TESTS="
	+tests_xfsFilesystemTestSuite
	+tests_hardware_UnsafeMemory
"

CLIENT_IUSE_TESTS="
	x86? ( ${X86_IUSE_TESTS} )
	amd64? ( ${X86_IUSE_TESTS} )
	+tests_profiler_sync
	+tests_crashme
	+tests_dbench
	+tests_ddtest
	+tests_fsx
	+tests_hackbench
	+tests_iperf
	+tests_iozone
	+tests_kernel_sysrq_info
	+tests_autoupdate_Backoff
	+tests_autoupdate_BadMetadata
	+tests_autoupdate_CannedOmahaUpdate
	+tests_autoupdate_DisconnectReconnectNetwork
	+tests_autoupdate_InstallAndUpdateDLC
	+tests_autoupdate_InvalidateSuccessfulUpdate
	+tests_autoupdate_PeriodicCheck
	+tests_autoupdate_UrlSwitch
	+tests_blktestsSuiteAll
	+tests_blktestsSuiteLoopOverBlk
	+tests_blktestsSuiteLoopOverFile
	+tests_blktestsSuiteRealBlk
	+tests_dummy_Fail
	+tests_stub_Pass
	tests_example_UnitTest
	+tests_firmware_CbfsMcache
	+tests_firmware_LockedME
	+tests_firmware_CheckEOPState
	+tests_firmware_RomSize
	+tests_firmware_SetFWMP
	+tests_firmware_VbootCrypto
	+tests_flaky_test
	+tests_hardware_Badblocks
	+tests_hardware_DiskSize
	+tests_hardware_EC
	+tests_hardware_EepromWriteProtect
	+tests_hardware_GobiGPS
	+tests_hardware_GPIOSwitches
	+tests_hardware_GPS
	+tests_hardware_I2CProbe
	+tests_hardware_Interrupt
	+tests_hardware_Keyboard
	+tests_hardware_MemoryLatency
	+tests_hardware_MemoryThroughput
	+tests_hardware_MemoryZRAMThroughput
	+tests_hardware_Memtester
	+tests_hardware_RamFio
	+tests_hardware_SAT
	+tests_hardware_SsdDetection
	+tests_hardware_StorageFio
	+tests_hardware_StorageFioOther
	+tests_hardware_StorageTrim
	+tests_hardware_StorageWearoutDetect
	+tests_hardware_TrimIntegrity
	+tests_infra_FirmwareAutoupdate
	+tests_kernel_AsyncDriverProbe
	+tests_kernel_fs_Punybench
	+tests_kernel_Memory_Ramoop
	crash_reporting? (
		+tests_logging_KernelCrash
		+tests_logging_UdevCrash
		+tests_logging_UserCrash
	)
	+tests_network_EthernetStressPlug
	+tests_network_Ipv6SimpleNegotiation
	+tests_platform_Crossystem
	+tests_platform_DaemonsRespawn
	encrypted_stateful? ( +tests_platform_EncryptedStateful )
	+tests_platform_FileNum
	+tests_platform_FileSize
	biod? ( +tests_platform_Fingerprint )
	+tests_platform_FullyChargedPowerStatus
	+tests_platform_HighResTimers
	+tests_platform_ImageLoader
	+tests_platform_ImageLoaderServer
	+tests_platform_MemCheck
	+tests_platform_MemoryMonitor
	+tests_platform_NetParms
	cups? ( +tests_platform_PrinterPpds )
	+tests_suite_HWConfig
	+tests_suite_HWQual
	+tests_touch_HasInput
	+tests_touch_WakeupSource
"

IUSE_TESTS="${IUSE_TESTS}
	${CLIENT_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME="third_party/autotest/files"

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
