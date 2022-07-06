# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/x}"

DESCRIPTION="An x-cursor theme inspired by macOS and based on KDE Breeze"
HOMEPAGE="https://github.com/keeferrourke/capitaine-cursors/"
SRC_URI="https://github.com/keeferrourke/${MY_PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
MY_DPIS=(lo +tv hd xhd xxhd xxxhd)
MY_VARIANTS=(+dark light)
IUSE="${MY_DPIS[*]} ${MY_VARIANTS[*]}"

REQUIRED_USE="
	^^ ( ${MY_DPIS[*]/+} )
	^^ ( ${MY_VARIANTS[*]/+} )
"

RESTRICT="primaryuri"

BDEPEND="
	>=media-gfx/inkscape-1
	x11-apps/xcursorgen
"

PATCHES=(
	"${FILESDIR}/${P}-fix-integer-size.patch"
	"${FILESDIR}/${P}-fix-inkscape-cli.patch"
)

S="${WORKDIR}/${MY_PN}-r${PV}"

src_prepare() {
	default

	addpredict "${BROOT}/usr/share/inkscape/fonts/.uuid.TMP-XXXXXX"
}

src_compile() {
	for d in "${MY_DPIS[@]/+}"; do
		test -n "${dpi}" || dpi="$(usev $d)"
	done; unset d

	for v in "${MY_VARIANTS[@]/+}"; do
		test -n "${variant}" || variant="$(usev $v)"
	done; unset v

	./build.sh -d "${dpi}" -t "${variant}" || die
}

src_install() {
	einstalldocs

	insinto "/usr/share/cursors/xorg-x11/${PN}"
	doins -r "dist/${variant}"/*
}
