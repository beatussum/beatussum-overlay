# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unity-plugins

MY_PV="${PV}1"

DESCRIPTION="Documentation for Unity Editor"
HOMEPAGE="https://unity3d.com"

HASH="8e603399ca02"
SRC_URI="
	${SRC_URI_BASE}/${HASH}/MacDocumentationInstaller/Documentation.pkg -> ${P}.pkg
"

LICENSE="Unity-EULA"
SLOT="2019"
KEYWORDS="-* ~amd64"
RESTRICT="bindist primaryuri strip test"

BDEPEND="$(unity-plugins_src_uri_depends)"

src_install() {
	insinto "/opt/${UNITY_INS}/Editor/Data"
	doins -r *
}
