# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

DESCRIPTION="A tool to manage your Unity Projects and installations"
HOMEPAGE="https://unity3d.com"
SRC_URI="https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage -> ${P}.AppImage"
LICENSE="Unity-EULA"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist primaryuri strip test"

S="${WORKDIR}"
QA_PREBUILT="*"

src_unpack() {
	cp "${DISTDIR}/${P}.AppImage" "${T}" || die
	chmod +x "${T}/${P}.AppImage" || die
	"${T}/${P}.AppImage" --appimage-extract || die
}

src_prepare() {
	sed -e "/^X-AppImage/d" -e "s/Exec=AppRun/Exec=${PN}/" \
		"squashfs-root/${PN}.desktop" > "${T}/${PN}.desktop" \
		|| die

	find squashfs-root \( -name "*.txt" -or -name "*.html" \) \
		-exec rm {} \; || die "The cleanup has failed"
	find squashfs-root \( -iname "LICENSE*" -or -iname "README*" \) \
		-exec rm {} \; || die "The cleanup has failed"
	rm squashfs-root/AppRun || die "The cleanup has failed"
	rm "squashfs-root/${PN}".* || die "The cleanup has failed"

	default
}

src_install() {
	local -r dir="/opt/${PN}"

	# To avoid changing permissions
	dodir "${dir}"
	cp -ar squashfs-root/* "${D}/${dir}" || die "The installation has failed"

	make_wrapper "${PN}" "${dir}/${PN}" "" "${dir}:${dir}/usr/lib"
	doicon -s 48 "squashfs-root/usr/share/icons/hicolor/48x48/apps/${PN}.png"
	domenu "${T}/${PN}.desktop"
}
