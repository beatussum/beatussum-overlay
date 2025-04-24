# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11,12,13} )

inherit distutils-r1 systemd

DESCRIPTION="fprintd replacement which allows you to have your own backend"
HOMEPAGE="https://github.com/uunicorn/open-fprintd/"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/uunicorn/open-fprintd.git"
else
	SRC_URI="https://github.com/uunicorn/open-fprintd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
	sys-apps/dbus
	!sys-auth/fprintd
"

DOCS=(
	debian/changelog
	debian/copyright
	README.md
)

src_install() {
	distutils-r1_src_install

	systemd_dounit debian/open-fprintd{,-resume,-suspend}.service
}
