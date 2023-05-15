# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Arc KDE customization"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/arc-kde/"
SRC_URI="https://github.com/PapirusDevelopmentTeam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+ wallpapers? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS="~amd64"
MY_COMPONENTS=(aurorae +color-schemes +konsole konversation +kvantum +plasma +wallpapers +yakuake)
IUSE="${MY_COMPONENTS[*]}"
REQUIRED_USE="|| ( ${MY_COMPONENTS[*]/+} )"

RDEPEND="kvantum? ( x11-themes/kvantum )"

src_install() {
	einstalldocs

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

	emake DESTDIR="${ED}" THEMES="${themes[*]}" install

	find "${ED}/usr/share" \( -name "AUTHORS" -o -name "LICENSE" \) -delete \
		|| die "the cleaning has failed"
}
