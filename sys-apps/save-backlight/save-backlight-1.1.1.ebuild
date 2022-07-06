# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An OpenRC service for restoring the last brightness level on reboot"
HOMEPAGE="https://github.com/beatussum/save-backlight/"
SRC_URI="https://github.com/beatussum/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="primaryuri"

RDEPEND="sys-apps/openrc"

src_compile() { :; }

src_install() {
	einstalldocs
	emake PREFIX="" DESTDIR="${D}" install
}
