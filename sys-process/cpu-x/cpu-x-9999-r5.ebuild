# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="CPU-X"

inherit cmake git-r3 xdg

DESCRIPTION="A Free software that gathers information on CPU, motherboard and more"
HOMEPAGE="https://x0rg.github.io/CPU-X/"
EGIT_REPO_URI="https://github.com/X0rg/${MY_PN}.git"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+bandwidth +dmidecode force-libstatgrab +gtk +libcpuid +libpci +ncurses +nls test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	force-libstatgrab? ( sys-libs/libstatgrab )
	!force-libstatgrab? ( sys-process/procps:= )
	gtk? ( >=x11-libs/gtk+-3.12:3 )
	libcpuid? ( >=sys-libs/libcpuid-0.3.0:= )
	libpci? ( sys-apps/pciutils )
	ncurses? ( sys-libs/ncurses:= )
"

DEPEND="
	test? (
		sys-apps/mawk
		sys-apps/nawk
	)

	${COMMON_DEPEND}
"

BDEPEND="
	dev-lang/nasm
	nls? ( sys-devel/gettext )
"

RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GTK=$(usex gtk)
		-DWITH_NCURSES=$(usex ncurses)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_LIBCPUID=$(usex libcpuid)
		-DWITH_LIBPCI=$(usex libpci)
		-DWITH_LIBSTATGRAB=OFF
		-DWITH_DMIDECODE=$(usex dmidecode)
		-DWITH_BANDWIDTH=$(usex bandwidth)
		-DFORCE_LIBSTATGRAB=$(usex force-libstatgrab)
		-DGSETTINGS_COMPILE=OFF
	)

	cmake_src_configure
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_update
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
