# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/t/T}"

inherit git-r3 xdg

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://www.pling.com/p/1279924/"
EGIT_REPO_URI="https://github.com/vinceliuice/${MY_PN}.git"
LICENSE="GPL-3+"
SLOT="0"
MY_COMPONENTS=(+standard black blue brown green grey orange pink purple red yellow manjaro ubuntu)
IUSE="${MY_COMPONENTS[*]}"
REQUIRED_USE="|| ( ${MY_COMPONENTS[*]/+} )"

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
