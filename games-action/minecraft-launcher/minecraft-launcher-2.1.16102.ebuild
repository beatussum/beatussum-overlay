# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

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
	dev-libs/libbsd
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	net-libs/gnutls[idn]
	x11-libs/gtk+:2[cups]
	x11-libs/gtk+:3[cups,X]
	x11-libs/libXScrnSaver
	virtual/jre
	narrator? ( app-accessibility/flite )
"

S="${WORKDIR}"
QA_PREBUILT="opt/${PN}"

src_install() {
	local -r dir="/opt/${PN}"

	dodir "${dir}"
	cp -ar "${PN}"/* "${D}/${dir}" || die
	doicon "${DISTDIR}/${PN}.svg"

	dobin "${FILESDIR}/${PN}"
	make_desktop_entry "${PN}" "Minecraft launcher" "${PN}" \
		"Game;ActionGame;AdventureGame;Java" \
		"StartupWMClass=minecraft-launcher"
}
