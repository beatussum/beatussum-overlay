# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/x}"

DESCRIPTION="An x-cursor theme inspired by macOS and based on KDE Breeze"
HOMEPAGE="https://github.com/keeferrourke/capitaine-cursors/"
SRC_URI="https://github.com/keeferrourke/${MY_PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~x86-cygwin ~amd64-linux ~arm-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
VARIANTS=(+dark light)
DPIS=(lo +tv hd xhd xxhd xxxhd)
IUSE="${VARIANTS[*]} ${DPIS[*]}"

REQUIRED_USE="
	^^ ( ${VARIANTS[*]/+} )
	^^ ( ${DPIS[*]/+} )
"

RESTRICT="primaryuri"

BDEPEND="
	media-gfx/inkscape
	x11-apps/xcursorgen
"

S="${WORKDIR}/${MY_PN}-r${PV}"

src_compile() {
	for v in "${VARIANTS[@]/+}"; do
		test -n "${variant}" || variant="$(usev $v)"
	done
	unset v

	for d in "${DPIS[@]/+}"; do
		test -n "${dpi}" || dpi="$(usev $d)"
	done
	unset d

	./build.sh -t "${variant}" -d "${dpi}" || die
}

src_install() {
	einstalldocs

	insinto "/usr/share/cursors/xorg-x11/${PN}"
	doins -r "dist/${variant}"/*
}
