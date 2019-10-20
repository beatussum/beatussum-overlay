# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="grml-etc-core"
DESCRIPTION="Grmls core configuration files for zsh"
HOMEPAGE="https://grml.org/zsh"
SRC_URI="https://github.com/grml/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~x86-cygwin ~amd64-linux ~arm-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
RESTRICT="primaryuri"

BDEPEND="app-text/txt2tags"

RDEPEND="app-shells/zsh"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=(
	README.md
	debian/changelog
)

src_compile() {
	cd doc
	emake
}

src_install() {
	einstalldocs

	insinto /etc
	doins -r etc/zsh

	insinto /etc/skel
	doins etc/skel/.zshrc

	doman "doc/${PN}.5"

	insinto /usr/share/grml
	doins -r usr_share_grml/zsh
}
