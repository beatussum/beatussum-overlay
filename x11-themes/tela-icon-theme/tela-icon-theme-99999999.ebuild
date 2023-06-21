# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/t/T}"

inherit xdg

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://www.pling.com/p/1279924/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vinceliuice/${MY_PN}.git"
else
	MY_PV="${PV::4}-${PV:4:2}-${PV:6:2}"
	SRC_URI="https://github.com/vinceliuice/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

LICENSE="GPL-3+"
SLOT="0"

MY_COMPONENTS=(
	black
	blue
	brown
	dracula
	green
	grey
	manjaro
	nord
	orange
	pink
	purple
	red
	+standard
	ubuntu
	yellow
)

IUSE="${MY_COMPONENTS[*]}"
REQUIRED_USE="|| ( ${MY_COMPONENTS[*]//+} )"
RESTRICT="binchecks strip test"
PATCHES=( "${FILESDIR}/${P}-fix-cache-update.patch" )

src_install() {
	local colorvariant=()

	for v in "${MY_COMPONENTS[@]//+}"; do
		colorvariant+=( $(usev ${v}) )
	done

	einstalldocs

	dodir /usr/share/icons
	./install.sh -d "${ED}/usr/share/icons" "${colorvariant[@]}" || die
}
