# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A customizable and extensible shell"
HOMEPAGE="https://aylur.github.io/ags-docs/"

SRC_URI="
	https://github.com/Aylur/ags/releases/download/v${PV}/ags-v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Aylur/ags/releases/download/v${PV}/node_modules-v${PV}.tar.gz -> ${P}-node_modules.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="
	dev-libs/gjs
	dev-libs/glib:2
	dev-libs/libffi:=
	dev-libs/libpcre2:=
	gui-libs/gtk-layer-shell[introspection]
	media-libs/flac:=
	media-libs/libogg
	media-libs/libpulse
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/opus
	media-sound/lame
	media-sound/mpg123-base
	net-libs/libasyncns
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/pam
	sys-libs/zlib
	x11-libs/gtk+:3
	x11-libs/libXau
	x11-libs/libxcb:=
	x11-libs/libXdmcp
"

BDEPEND="
	dev-lang/typescript
	dev-libs/gobject-introspection
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${P}-fix-tsc-call.patch" )

src_prepare() {
	default_src_prepare

	ln -sr "${WORKDIR}/node_modules" "${S}/node_modules" || die
}
