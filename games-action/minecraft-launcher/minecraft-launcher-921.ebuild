# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

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

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb:*
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
	narrator? ( app-accessibility/flite )
"

S="${WORKDIR}/${PN}"

src_install() {
	exeinto "/opt/bin"
	doexe "${PN}"

	doicon -s scalable "${DISTDIR}/${PN}.svg"
	make_desktop_entry "${PN}" "Minecraft launcher" "${PN}" \
		"Game;ActionGame;AdventureGame;Java" \
		"StartupWMClass=${PN}"
}
