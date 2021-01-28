# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils prefix

DESCRIPTION="Minecraft's official launcher"
HOMEPAGE="https://www.minecraft.net/"

MY_SRC_URI_BASE="https://launcher.mojang.com/download"
SRC_URI="
	${MY_SRC_URI_BASE}/linux/x86_64/${PN}_${PV}.tar.gz -> ${P}.tar.gz
	${MY_SRC_URI_BASE}/${PN}.svg
"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="narrator"
RESTRICT="bindist mirror strip"

BDEPEND="dev-util/patchelf"

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2[dbus]
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig:1.0
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2[cups]
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libxcb:*
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
	narrator? ( app-accessibility/flite )
"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	patchelf --set-rpath '$ORIGIN' libcef.so liblauncher.so "${PN}" \
		|| die 'Unable to replace the insecure `RPATH`s'
}

src_install() {
	local -r dir="/opt/${PN}"

	dodir "${dir}"
	cp -a * "${ED}/${dir}" || die

	dosym "../${PN}/${PN}" "/opt/bin/${PN}"

	doicon -s scalable "${DISTDIR}/${PN}.svg"
	make_desktop_entry "${PN}" "Minecraft launcher" "${PN}" \
		"Game;ActionGame;AdventureGame;Java" \
		"StartupWMClass=minecraft-launcher"
}
