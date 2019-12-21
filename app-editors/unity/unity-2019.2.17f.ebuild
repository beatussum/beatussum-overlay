# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils unpacker xdg

MY_PV="${PV}1"

DESCRIPTION="Editor to create games on the Unity engine"
HOMEPAGE="https://unity3d.com"

HASH="8e603399ca02"
SRC_URI_BASE="https://beta.unity3d.com/download/${HASH}"
SRC_URI="
	${SRC_URI_BASE}/LinuxEditorInstaller/Unity.tar.xz -> ${P}.tar.xz
	android? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-${MY_PV}.pkg -> ${P}-android.pkg )
	doc? ( ${SRC_URI_BASE}/MacDocumentationInstaller/Documentation.pkg -> ${P}-doc.pkg )
	facebook? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Facebook-Games-Support-for-Editor-${MY_PV}.pkg -> ${P}-facebook.pkg )
	ios? ( ${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-${MY_PV}.tar.xz -> ${P}-ios.tar.xz )
	mac? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-${MY_PV}.pkg -> ${P}-mac.pkg )
	webgl? ( ${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-${MY_PV}.tar.xz -> ${P}-webgl.tar.xz )
	windows? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-${MY_PV}.pkg -> ${P}-windows.pkg )
"

LICENSE="Unity-EULA"
SLOT="${PV%%.*}"
KEYWORDS="-* ~amd64"
IUSE="android doc facebook ios mac webgl windows"
REQUIRED_USE="facebook? ( webgl windows )"
RESTRICT="bindist primaryuri strip"

BDEPEND="
	app-arch/cpio
	app-arch/gzip
	app-arch/xar
"

RDEPEND="
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc[multilib]
	sys-libs/libcap
	virtual/glu
	virtual/opengl
	x11-libs/gtk+:3[X]
	x11-libs/libXtst
	x11-misc/xdg-utils
	android? (
		dev-util/android-sdk-update-manager
		virtual/jdk
	)
	webgl? (
		app-arch/gzip
		net-libs/nodejs[npm]
		virtual/ffmpeg
		virtual/jre
	)
"

MY_PNS="${PN}-${SLOT}"

S="${WORKDIR}"
QA_PREBUILT="*"

_checks() {
	local check=3200

	use android && check=$(($check + 1900))
	use doc && check=$(($check + 560))
	use facebook && check=$(($check + 200))
	use ios && check=$(($check + 3400))
	use mac && check=$(($check + 440))
	use webgl && check=$(($check + 1000))
	use windows && check=$(($check + 350))

	CHECKREQS_DISK_BUILD="$(($check / 1000))G"

	check-reqs_pkg_setup
}

pkg_pretend() {
	_checks
}

pkg_setup() {
	_checks
}

src_unpack() {
	unpkg() {
		mkdir "tmp" || die

		xar -C tmp -xf "${DISTDIR}/${1}" || die
		mv tmp/*.pkg.tmp/Payload Payload.cpio.gz || die
		unpacker Payload.cpio.gz

		rm -r tmp Payload.cpio.gz || die
	}

	local src_file dest_dir
	for src_file in $A; do
		dest_dir="$(basename -s .tar.xz "${src_file}")"
		dest_dir="${dest_dir%.pkg}"

		mkdir "${dest_dir}" || die
		pushd "${dest_dir}" || die

		if [[ "${src_file}" = *.pkg ]]; then
			unpkg "${src_file}"
		else
			unpack "${src_file}"
		fi

		popd || die
	done
}

src_prepare() {
	sed -e "s/%SLOT%/${SLOT}/" -e "s/%MY_PNS%/${MY_PNS}/g" \
		"${FILESDIR}/${PN}.desktop" > "${T}/${MY_PNS}.desktop"

	default
}

src_install() {
	local unity_dir="${D}/opt/${MY_PNS}"
	local data_dir="${unity_dir}/Editor/Data"
	local engines_dir="${data_dir}/PlaybackEngines"

	mkdir -p "${unity_dir%$MY_PNS}" || die
	cp -a "${P}" "${unity_dir}" || die
	rm -r "${P}" || die
	if use doc; then
		cp -a "${P}-doc"/* "${data_dir}" || die
		rm -r "${P}-doc" || die
	fi
	if use android; then
		cp -a "${P}-android" "${engines_dir}/AndroidPlayer" || die
		rm -r "${P}-android" || die
	fi
	if use ios; then
		cp -a "${P}-ios"/* "${unity_dir}" || die
		rm -r "${P}-ios" || die
	fi
	if use mac; then
		cp -a "${P}-mac" "${engines_dir}/LinuxStandaloneSupport" || die
		rm -r "${P}-mac" || die
	fi
	if use webgl; then
		cp -a "${P}-webgl"/* "${unity_dir}" || die
		rm -r "${P}-webgl" || die
	fi
	if use windows; then
		cp -a "${P}-windows" "${engines_dir}/WindowsStandaloneSupport" || die
		rm -r "${P}-windows" || die
	fi
	if use facebook; then
		cp -a "${P}-facebook" "${engines_dir}/Facebook" || die
		rm -r "${P}-facebook" || die
	fi

	make_wrapper "${MY_PNS}" "${unity_dir#$D}/Editor/Unity"
	newicon -s 256 "${data_dir}/Resources/LargeUnityIcon.png" "${MY_PNS}.png"
	domenu "${T}/${MY_PNS}.desktop"
}
