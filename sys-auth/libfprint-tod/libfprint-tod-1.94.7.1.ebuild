# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson udev

MY_PN="${PN%-tod}"
MY_PV="v$(ver_cut 1-3)+tod$(ver_cut 4)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Library to add support for consumer fingerprint readers"
HOMEPAGE="https://fprint.freedesktop.org/"
SRC_URI="https://gitlab.freedesktop.org/3v1n0/libfprint/-/archive/${MY_PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="-* ~amd64"
IUSE="doc examples +introspection test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	dev-libs/libgudev
	dev-libs/nss
	dev-python/pygobject
	dev-libs/libgusb
	!sys-auth/libfprint
	x11-libs/pixman

	examples? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
"

BDEPEND="
	virtual/pkgconfig

	doc? ( dev-util/gtk-doc )

	introspection? (
		dev-libs/gobject-introspection
		dev-libs/libgusb[introspection]
	)
"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	use introspection && eapply "${FILESDIR}/${PN}-increase-test-timeout.patch"
}

src_configure() {
	local emesonargs=(
		-Ddrivers=all
		$(meson_use introspection)
		-Dudev_rules=enabled
		-Dudev_rules_dir="$(get_udevdir)/rules.d/"
		-Dudev_hwdb=enabled
		-Dudev_hwdb_dir="$(get_udevdir)/hwdb.d/"
		$(meson_use examples gtk-examples)
		$(meson_use doc)
		-Dinstalled-tests=false
		-Dtod=true
	)

	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
