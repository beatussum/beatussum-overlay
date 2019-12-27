# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An OpenRC service for restoring the last brightness level on reboot"
HOMEPAGE="https://github.com/beatussum/backlight-restorer"
SRC_URI="https://github.com/beatussum/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
RESTRICT="primaryuri test"

RDEPEND="sys-apps/openrc"

src_compile() { :; }

src_install() {
	emake PREFIX="" DESTDIR="${D}" install
}

pkg_postinst() {
	ewarn "Please, do not start directly this service; but just"
	ewarn "add it to the default runlevel."
}
