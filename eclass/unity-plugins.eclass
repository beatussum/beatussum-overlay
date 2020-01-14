# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: unity-plugins
# @MAINTAINER: 
# Mattéo Rossillol‑‑Laruelle <beatussum@protonmail.com>
# @AUTHOR:
# Mattéo Rossillol‑‑Laruelle <beatussum@protonmail.com>
# @BUGREPORTS:
# Please, use the GitHub issue tab of the current repository (see the
# adress below)
# @VCSURL: https://github.com/beatussum/beatussum-overlay
# @BLURB: A useful wrapper for unpacking Unity plugins

inherit unpacker

EXPORT_FUNCTIONS src_unpack

# @ECLASS-VARIABLE: HASH
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION: Hash corresponding to the Unity version

# @ECLASS-VARIABLE: SRC_URI_BASE
# @DESCRIPTION: The URI base to the Unity source
SRC_URI_BASE="https://beta.unity3d.com/download/${HASH}"

RDEPEND="~dev-games/unity-${PV}"

# @ECLASS-VARIABLE: UNITY_INS
# @DESCRIPTION: The name of the Unity installation
UNITY_INS="${PN%-*}-${SLOT}"

# @ECLASS-VARIABLE: UNITY_DIR
# @DESCRIPTION: Location of the Unity installation directory
UNITY_DIR="/opt/${UNITY_INS}"

# @ECLASS-VARIABLE: UNITY_DIR
# @DESCRIPTION: Location of the Unity data directory
UNITY_DATA_DIR="${UNITY_DIR}/Editor/Data"

# @ECLASS-VARIABLE: UNITY_DIR
# @DESCRIPTION: Location of the Unity PlaybackEngines directory
UNITY_ENGINES_DIR="${UNITY_DATA_DIR}/PlaybackEngines"

# @FUNCTION: unity-plugins_unpack
# @USAGE: <file to unpack>
# @DESCRIPTION: A function that unpacks Unity '.pkg' plugins
unity-plugins_unpack() {
	local -r tmp="${T}/$1.tmp"

	mkdir "${tmp}" || die

	xar -C "${tmp}" -xf "${DISTDIR}/$1" || die
	mv "${tmp}"/*.pkg.tmp/Payload Payload.cpio.gz || die
	rm -r "${tmp}" || die
	
	unpacker Payload.cpio.gz
	rm -r Payload.cpio.gz || die
}

# @FUNCTION: unity-plugins_src_unpack
# @DESCRIPTION: Handle unpacking management according to archive format
unity-plugins_src_unpack() {
	for a in "$A"; do
		dest_dir="$(basename -s .tar.xz "$a")"
		dest_dir="${dest_dir%.pkg}"

		mkdir "${dest_dir}" || die
		pushd "${dest_dir}" || die

		if [[ "$a" = *.pkg ]]; then
			unity-plugins_unpack "$a"
		else
			unpack "$a"
		fi

		popd || die
	done
	unset a dest_dir
}

# @FUNCTION: unity-plugins_src_uri_depends
# @RETURN: Dependencies needed to unpack all archives
# @DESCRIPTION: 
# A wrapper for unpacker_src_uri_depends also takes into account the
# dependencies needed to unpack Unity '.pkg' plugins
unity-plugins_src_uri_depends() {
	local deps

	# Disable path expansion for USE conditionals. #654960
	set -f
	set -- "${SRC_URI}"
	set +f

	for i in $@; do
		if [[ "$i" = *.pkg ]]; then
			deps="app-arch/cpio app-arch/xar"
			break
		fi
	done
	unset i

	echo "${deps} $(unpacker_src_uri_depends)"
}
