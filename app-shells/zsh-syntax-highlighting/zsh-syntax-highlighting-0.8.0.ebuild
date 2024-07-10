# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

DESCRIPTION="Fish shell like syntax highlighting for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting/"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zsh-users/zsh-syntax-highlighting.git"
else
	SRC_URI="https://github.com/zsh-users/zsh-syntax-highlighting/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="binchecks strip !test? ( test )"

RDEPEND=">app-shells/zsh-4.3.11"

DISABLE_AUTOFORMATTING=true

DOC_CONTENTS="\
To use syntax highlighting, enable it in the current interactive shell:
	source ${EROOT}/usr/share/zsh/plugins/${PN}/${PN}.zsh
For further information, please read the documentation files."

src_prepare() {
	default

	sed -i "s/COPYING.md//" Makefile || die
}

src_install() {
	readme.gentoo_create_doc

	emake \
		DESTDIR="${ED}" \
		PREFIX="/usr" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install

	dosym -r \
		"/usr/share/${PN}/${PN}.zsh" \
		"/usr/share/zsh/plugins/${PN}/${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
