# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

MY_BIN="${PN/d/D}"

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com/"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${P}.tar.gz"
LICENSE="Discord-TOS"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ayatana"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-accessibility/at-spi2-core[X]
	dev-libs/libffi
	dev-libs/libpcre
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/harfbuzz[graphite]
	net-dns/libidn2
	net-libs/gnutls[idn]
	x11-libs/gtk+:3[cups,X]
	x11-libs/libXScrnSaver
	x11-libs/pango[X]
	x11-libs/pixman
	ayatana? ( dev-libs/libappindicator:3 )
"

S="${WORKDIR}"
QA_PREBUILT="
	opt/${PN}/${MY_BIN}
	opt/${PN}/lib*
	opt/${PN}/swiftshader/*
"

src_prepare() {
	default

	sed "s:/usr/share/discord/Discord:${PN}:g" \
		"${MY_BIN}/${PN}.desktop" \
		> "${T}/${PN}.desktop" \
		|| die "Unable to create the desktop file from the template"
	mv "${MY_BIN}/${PN}.png" "${T}" || die

	rm "${MY_BIN}/${PN}.desktop" || die "The cleaning has failed"
	rm "${MY_BIN}/postinst.sh" || die "The cleaning has failed"
}

src_install() {
	local -r dir="/opt/${PN}"

	doicon -s 256 "${T}/${PN}.png"
	domenu "${T}/${PN}.desktop"

	insinto "${dir}"
	doins -r "${MY_BIN}"/*
	fperms +x "${dir}/${MY_BIN}"
	fperms 4755 "${dir}/chrome-sandbox"

	make_wrapper "${PN}" "${dir}/${MY_BIN}" "" "${dir}"
}
