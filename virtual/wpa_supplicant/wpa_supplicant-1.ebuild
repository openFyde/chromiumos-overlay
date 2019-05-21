EAPI=6

DESCRIPTION="Virtual to select between different wpa_supplicant revisions"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE="wpa_supplicant_next"
RDEPEND="
	!wpa_supplicant_next? (
		net-wireless/wpa_supplicant:=[dbus]
		!net-wireless/wpa_supplicant-2_8
	)
	wpa_supplicant_next? (
		net-wireless/wpa_supplicant-2_8:=[dbus]
		!net-wireless/wpa_supplicant
	)"
DEPEND="${RDEPEND}"
