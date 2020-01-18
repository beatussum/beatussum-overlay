# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

MY_BIN="${PN/d/D}"

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${P}.tar.gz"
LICENSE="Discord-TOS"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ayatana +system-ffmpeg"
RESTRICT="bindist strip test"

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
	system-ffmpeg? ( media-video/ffmpeg[chromium] )
"

S="${WORKDIR}"

QA_PREBUILT="
	opt/discord/${MY_BIN}
	opt/discord/libVkICD_mock_icd.so
	opt/discord/libffmpeg.so
"

src_prepare() {
	default

	sed "s:/usr/share/discord/Discord:${PN}:g" \
		"${MY_BIN}/${PN}.desktop" \
		> "${T}/${PN}.desktop" || die
	mv "${MY_BIN}/${PN}.png" "${T}" || die

	rm "${MY_BIN}/${PN}.desktop" || die
	rm "${MY_BIN}/postinst.sh" || die
	rm "${MY_BIN}"/lib*GL*.so || die
	rm -r "${MY_BIN}/swiftshader" || die

	if use system-ffmpeg; then
		rm "${MY_BIN}/libffmpeg.so" || die
	fi
}

src_install() {
	doicon -s 256 "${T}/${PN}.png"
	domenu "${T}/${PN}.desktop"

	insinto "/opt/${PN}"
	doins -r "${MY_BIN}"/*
	fperms +x "/opt/${PN}/${MY_BIN}"

	use system-ffmpeg && local -r libpath="/usr/lib64/chromium"
	make_wrapper "${PN}" "/opt/${PN}/${MY_BIN}" "" \
		"${libpath}"
}
