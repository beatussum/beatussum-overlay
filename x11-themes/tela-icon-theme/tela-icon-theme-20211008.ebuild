# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/t/T}"
MY_PV="2021-10-08"

inherit xdg

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://www.pling.com/p/1279924/"
SRC_URI="https://github.com/vinceliuice/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
MY_COMPONENTS=(+standard black blue brown green grey orange pink purple red yellow manjaro ubuntu)
IUSE="${MY_COMPONENTS[*]}"
REQUIRED_USE="|| ( ${MY_COMPONENTS[*]/+} )"
RESTRICT="primaryuri"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${P}-fix-cache-update.patch"
)

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
	./install.sh -d "${ED}/usr/share/icons" "${colorvariant[@]}" || die
}
