# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Proton Technologies keyring plugins for linux"
HOMEPAGE="https://github.com/ProtonVPN/python-proton-keyring-linux"
SRC_URI="https://github.com/ProtonVPN/python-proton-keyring-linux/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-${P}"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	${PYTHON_DEPS}

	$(python_gen_cond_dep '
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/proton-core[${PYTHON_USEDEP}]
	')
"

BDEPEND="
	${COMMON_DEPEND}

	test? (
		$(python_gen_cond_dep '
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/pylint[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
		')
	)
"

RDEPEND="${COMMON_DEPEND}"

distutils_enable_tests pytest

python_test() {
	epytest -p flake8 -p pytest_cov
}
