# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 systemd udev

DESCRIPTION="Validity fingerprint sensor prototype"
HOMEPAGE="https://github.com/uunicorn/python-validity/"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/uunicorn/python-validity.git"
else
	SRC_URI="https://github.com/uunicorn/python-validity/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="binchecks strip test"

RDEPEND="
	>=app-arch/innoextract-1.6
	$(python_gen_cond_dep '>=dev-python/cryptography-2.1.4[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/pyusb-1.0.0[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]')
	sys-apps/dbus
	>=sys-auth/open-fprintd-0.6[${PYTHON_SINGLE_USEDEP}]
"

DOCS=(
	debian/changelog
	debian/copyright
	README.md
)

src_install() {
	distutils-r1_src_install

	udev_dorules debian/python3-validity.udev
	systemd_dounit debian/python3-validity.service
	doins -r etc
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
