# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 java-pkg-2

DESCRIPTION="The official server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
MY_EGIT_COMMIT="7361a24df069a06748844cc7483c35d4abd2d80c"
SRC_URI="https://launcher.mojang.com/v1/objects/${MY_EGIT_COMMIT}/server.jar -> ${P}.jar"
LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"

RDEPEND="
	acct-group/minecraft
	acct-user/minecraft
	app-misc/dtach
	|| (
		>=virtual/jre-1.8
		>=virtual/jdk-1.8
	)
"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_install() {
	java-pkg_newjar "${P}.jar" "${PN}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" \
		--java_args '${JAVA_OPTS}'

	newinitd "${FILESDIR}/${PN}.initd-r1" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-r1" "${PN}"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
