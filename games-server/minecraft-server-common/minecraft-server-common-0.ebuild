# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit tmpfiles

MY_PN="${PN%-common}"

DESCRIPTION="Common files for multiple slots of games-server/minecraft-server"
HOMEPAGE="https://www.minecraft.net/"
LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="games-server/minecraft-server"

S="${WORKDIR}"

MY_TMPFILE="${MY_PN}.conf"

src_install() {
	local -r ug="${PN%%-*}"

	newtmpfiles - "${MY_TMPFILE}" <<-EOF
		d /run/${MY_PN} 0755 ${ug} ${ug} - -
	EOF
}

pkg_postinst() {
	tmpfiles_process "${MY_TMPFILE}"
}
