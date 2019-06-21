# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

MY_PN=${PN/tela/Tela}
DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://www.pling.com/p/1279924 https://github.com/vinceliuice/Tela-icon-theme"
EGIT_REPO_URI="https://github.com/vinceliuice/${MY_PN}.git"
LICENSE="GPL-3+"
SLOT="0"
IUSE="black +blue brown green grey orange pink purple red yellow manjaro ubuntu"
REQUIRED_USE="^^ ( black blue brown green grey orange pink purple red yellow manjaro ubuntu )"

BDEPEND="dev-util/gtk-update-icon-cache"

src_install() {
	local colorvariant=(
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
	./install.sh -d "${D}/usr/share/icons" "${colorvariant[@]/#/-}" || die "The installation has failed"
}
