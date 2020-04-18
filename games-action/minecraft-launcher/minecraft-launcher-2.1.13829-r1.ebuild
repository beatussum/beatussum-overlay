# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI_BASE="https://launcher.mojang.com/download"

inherit desktop eutils

DESCRIPTION="Minecraft's official launcher"
HOMEPAGE="https://www.minecraft.net/"

SRC_URI="
	${SRC_URI_BASE}/linux/x86_64/${PN}_${PV}.tar.gz -> ${P}.tar.gz
	${SRC_URI_BASE}/${PN}.svg
"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="narrator"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libpcre
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/libglvnd
	net-libs/gnutls[idn]
	x11-libs/gtk+[X,cups]
	x11-libs/libXScrnSaver
	x11-libs/libXtst
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

	make_wrapper "${PN}" "${dir}/${PN}" '${HOME}/.minecraft' "${dir}"
	make_desktop_entry "${PN}" "Minecraft launcher" "${PN}" \
		"Game;ActionGame;AdventureGame;Java" \
		"StartupWMClass=minecraft-launcher"
}
