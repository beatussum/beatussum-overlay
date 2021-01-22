# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2 prefix readme.gentoo-r1

DESCRIPTION="The official server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
MY_EGIT_COMMIT="a412fd69db1f81db3f511c1463fd304675244077"
SRC_URI="https://launcher.mojang.com/v1/objects/${MY_EGIT_COMMIT}/server.jar -> ${P}.jar"
LICENSE="Mojang"
SLOT="${PV}"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	acct-group/minecraft
	acct-user/minecraft
	app-misc/dtach
	games-server/minecraft-server-common
	|| (
		>=virtual/jre-1.8
		>=virtual/jdk-1.8
	)
"

S="${WORKDIR}"

MY_CONFD="${PN}.confd-r1"
MY_INITD="${PN}.initd-r2"

src_unpack() { :; }

src_prepare() {
	default

	prefixify_ro "${FILESDIR}/${MY_INITD}"
}

src_install() {
	readme.gentoo_create_doc

	java-pkg_newjar "${DISTDIR}/${P}.jar"
	java-pkg_dolauncher "${P}" --java_args '${JAVA_OPTS}'
	hprefixify -w 1 "${ED}/usr/bin/${P}"

	newconfd "${FILESDIR}/${MY_CONFD}" "${P}"
	newinitd "${T}/${MY_INITD}" "${P}"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
