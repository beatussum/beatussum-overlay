# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fish shell like syntax highlighting for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting/"
SRC_URI="https://github.com/zsh-users/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~x86-cygwin ~amd64-linux ~arm-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="test"
RESTRICT="primaryuri"

RDEPEND=">app-shells/zsh-4.3.11"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" DOC_DIR="${D}/usr/share/doc/${PF}" install
	dosym "../../../${PN}/${PN}.zsh" "/usr/share/zsh/plugins/${PN}/${PN}.zsh"
}

pkg_postinst() {
	einfo "To use syntax highlighting, enable it in the current interactive shell:"
	einfo "\tsource /usr/share/zsh/plugins/${PN}/${PN}.zsh"
	einfo "For further information, please read the doc files."
}
