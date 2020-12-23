# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

MY_PN="${PN/d/D}"

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discord.com/"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${P}.tar.gz"
LICENSE="Discord-TOS"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ayatana"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2[dbus]
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X,cups]
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
	ayatana? ( dev-libs/libappindicator:3 )
"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	default

	sed \
		-e "s|/usr/share/discord/Discord|${PN}|g" \
		-e "/^Path=/d" \
		"${PN}.desktop" \
		> "${T}/${PN}.desktop" \
		|| die

	rm "${PN}.desktop" postinst.sh || die "The cleaning has failed"
}

src_install() {
	local -r dir="/opt/${PN}"

	doicon -s 256 "${PN}.png"
	domenu "${T}/${PN}.desktop"

	dodir "${dir}"
	cp -a * "${D}/${dir}" || die
	dosym "../${PN}/${MY_PN}" "/opt/bin/${PN}"
}
