# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils fdo-mime

DESCRIPTION="Visual programming language for multimedia"
HOMEPAGE="http://msp.ucsd.edu/software.html"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pure-data/${PN}.git"
	KEYWORDS=""
else
	MY_PN="pd"
	MY_PV=${PV/_p/-}
	MY_P="${MY_PN}-${MY_PV}"
	SRC_URI="http://msp.ucsd.edu/Software/${MY_P}.src.tar.gz
		https://puredata.info/portal_css/Plone%20Default/logo.png -> ${PN}.png"
	KEYWORDS="~amd64"
fi
LICENSE="BSD"
SLOT="0"

IUSE="alsa fftw jack"

RDEPEND="
	dev-lang/tcl
	dev-lang/tk[truetype]
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	fftw? ( >=sci-libs/fftw-3 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-weakjack-on-osx-only.patch"
)

src_prepare() {
	default
	eautoreconf
}

# disable portaudio and portmidi broken
# because oterwhise pd's local sources get installed
src_configure() {
	econf --disable-portaudio \
		--disable-portmidi \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable fftw)
}

src_install() {
	default

	doicon -s 48 "${DISTDIR}"/${PN}.png
	make_desktop_entry pd "pure data" "${PN}" "AudioVideo;AudioVideoEditing"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
