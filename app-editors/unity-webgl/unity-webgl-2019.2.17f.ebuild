# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs unity-plugins

MY_PV="${PV}1"

DESCRIPTION="A Unity plugin for developing on the WebGL platform"
HOMEPAGE="https://unity3d.com"

HASH="8e603399ca02"
SRC_URI="
	${SRC_URI_BASE}/${HASH}/LinuxEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-${MY_PV}.tar.xz -> ${P}.tar.xz
"

LICENSE="Unity-EULA"
SLOT="2019"
KEYWORDS="~amd64"
RESTRICT="bindist primaryuri strip test"

BDEPEND="$(unity-plugins_src_uri_depends)"

RDEPEND="
	net-libs/nodejs[npm]
	virtual/ffmpeg
	virtual/jre
"

QA_PREBUILT="*"

CHECKREQS_DISK_BUILD="1G"

src_install() {
	insinto "/opt/${UNITY_INS}"
	doins -r *
}
