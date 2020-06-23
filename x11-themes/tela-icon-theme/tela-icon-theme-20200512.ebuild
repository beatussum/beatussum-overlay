# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/t/T}"
MY_PV="2020-05-12"

inherit xdg

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://www.pling.com/p/1279924/"
SRC_URI="https://github.com/vinceliuice/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+standard black blue brown green grey orange pink purple red yellow manjaro ubuntu"
REQUIRED_USE="|| ( standard black blue brown green grey orange pink purple red yellow manjaro ubuntu )"
RESTRICT="primaryuri"

BDEPEND="dev-util/gtk-update-icon-cache"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_install() {
	local colorvariant=(
		$(usev standard)
		$(usev black)
		$(usev blue)
		$(usev brown)
		$(usev green)
		$(usev grey)
		$(usev orange)
		$(usev pink)
		$(usev purple)
		$(usev red)
		$(usev yellow)
		$(usev ubuntu)
		$(usev manjaro)
	)

	einstalldocs

	dodir /usr/share/icons
	./install.sh -d "${D}/usr/share/icons" "${colorvariant[@]}" || die
}
