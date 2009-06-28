# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/yagsbook/xml/ebuilds/yagsbook/yagsbook-0.0.ebuild,v 1.1 2004/12/08 22:03:48 samuelpenn Exp $

ECVS_SERVER="cvs.sourceforge.net:/cvsroot/yagsbook"
ECVS_MODULE="xml"
inherit cvs

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
DESCRIPTION="XML Stylesheets for PageXML formatting"
SRC_URI=""
HOMEPAGE="http://yagsbook.sourceforge.net"
IUSE=""
RDEPEND="dev-libs/libxslt"

src_unpack() {
	cvs_src_unpack
    cd ${WORKDIR}/xml
    mkdir -p build/bin
    mkdir -p build/xml
}

src_compile() {
    cd ${WORKDIR}/xml/scripts
    make validate yags2html yags2pdf
    mv validate yags2html yags2pdf ../build/bin

	ARTICLE_DIR=${WORKDIR}/xml/build/xml/article
	for xmldir in css xsd xslt
	do
		mkdir -p ${ARTICLE_DIR}/${xmldir}
	done

	for media in html pdf share
	do
		mkdir -p ${ARTICLE_DIR}/xslt/${media}
		cd ${WORKDIR}/xml/xslt/${media}
		find . -name "*.xsl" -exec cp {} ${ARTICLE_DIR}/xslt/${media} \;
	done

	cd ${WORKDIR}/xml/css
	find . -name "*.css" -exec cp {} ${ARTICLE_DIR}/css \;
    
	cd ${WORKDIR}/xml/xsd
	find . -name "*.xsd" -exec cp {} ${ARTICLE_DIR}/xsd \;


	PAGE_DIR=${WORKDIR}/xml/build/xml/pagexml
	mkdir -p ${PAGE_DIR}/xslt

	cd ${WORKDIR}/xml/pagexml
	find . -name "*.xsl" -exec cp {} ${PAGE_DIR}/xslt \;
}

src_install() {
	mkdir -p ${D}/usr/bin
	mkdir -p ${D}/usr/share/xml/yagsbook

	cd ${WORKDIR}/xml/build/bin
	install -m 0555 validate ${D}/usr/bin/validate
	install -m 0555 yags2html ${D}/usr/bin/yags2html
	install -m 0555 yags2pdf ${D}/usr/bin/yags2pdf

	cd ${WORKDIR}/xml/build/xml
    cp -r article ${D}/usr/share/xml/yagsbook
    cp -r pagexml ${D}/usr/share/xml/yagsbook
}
