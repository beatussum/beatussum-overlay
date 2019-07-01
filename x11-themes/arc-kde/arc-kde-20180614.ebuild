# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Arc KDE customization"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/arc-kde"
SRC_URI="https://github.com/PapirusDevelopmentTeam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+ wallpapers? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS=" ~amd64 ~hppa ~m68k ~mips ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~x86-cygwin ~x86-fbsd ~amd64-linux ~arm-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="aurorae +color-schemes +konsole konversation +kvantum +plasma +wallpapers +yakuake"
REQUIRED_USE="|| ( aurorae color-schemes konsole konversation kvantum plasma wallpapers yakuake )"
RESTRICT="primaryuri"

RDEPEND="kvantum? ( x11-themes/kvantum )"

src_install() {
	local -r themes=(
		$(usev aurorae)
		$(usev color-schemes)
		$(usev konsole)
		$(usev konversation)
		$(usex kvantum Kvantum "")
		$(usev plasma)
		$(usev wallpapers)
		$(usev yakuake)
	)

	emake DESTDIR="${D}" THEMES="${themes[*]}" install

	find "${D}/usr/share" \( -name "AUTHORS" -o -name "LICENSE" \) -delete || die "the cleaning has failed"

	einstalldocs
}
