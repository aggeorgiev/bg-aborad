<?xml version="1.1" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
    xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
    xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" exclude-result-prefixes="xs ve r v w10 wne wp w o m">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/w:document/w:body">
        <xsl:variable name="phase1">
            <dictionary>
                <!-- xsl:for-each select="./w:p[./w:r[1]/w:rPr/w:b and (count(./w:r[1]/w:rPr/child::*) = 2 or ./w:r[1]/w:rPr/w:sz/@w:val = 20)]" -->
                <xsl:for-each select="./w:p[./w:r[1]/w:rPr/w:b and (./w:pPr[1]/w:pStyle/@w:val = 'BodyText' or ./w:r[1]/w:rPr/w:sz/@w:val = 20)]">
                    <xsl:if test="./w:r[./w:rPr/w:b]">
                        <article>
                            <xsl:variable name="body">
                                <xsl:apply-templates select="."/>
                            </xsl:variable>
                            <xsl:variable name="bodyNorm">
                                <xsl:value-of select="normalize-space($body)"/>
                            </xsl:variable>

                            <body>
                                <xsl:value-of select="$bodyNorm"/>
                            </body>

                            <xsl:variable name="pos">
                                <xsl:value-of select="position()"/>
                            </xsl:variable>

                            <xsl:for-each
                                select="./following-sibling::w:p[not(./w:r[1]/w:rPr/w:sz[@w:val = 16]) and not(./w:r[1]/w:rPr/w:b) and (./w:pPr[1]/w:pStyle/@w:val = 'BodyText' or ./w:r[1]/w:rPr/w:sz/@w:val = 20) and count(preceding-sibling::w:p[./w:r[1]/w:rPr/w:b and (./w:pPr[1]/w:pStyle/@w:val = 'BodyText' or ./w:r[1]/w:rPr/w:sz/@w:val = 20)]) = $pos]">
                                <xsl:variable name="bodys">
                                    <xsl:apply-templates select="."/>
                                </xsl:variable>
                                <xsl:variable name="bodyn">
                                    <xsl:value-of select="normalize-space($bodys)"/>
                                </xsl:variable>
                                <xsl:if test="$bodyn != ''">
                                    <body>
                                        <xsl:value-of select="$bodyn"/>
                                    </body>
                                </xsl:if>
                            </xsl:for-each>


                            <!-- xsl:for-each
                            select="./following-sibling::w:p[./w:r[1]/w:rPr/w:sz[@w:val = 16] and not(./w:pPr[1]/w:jc[@w:val = 'right']) and count(preceding-sibling::w:p[./w:r[1]/w:rPr/w:b and count(./w:r[1]/w:rPr/child::*) = 2]) = $pos]" -->
                            <xsl:for-each
                                select="./following-sibling::w:p[(./w:r[1]/w:rPr/w:sz[@w:val = 16] or ./w:pPr[1]/w:rPr/w:sz[@w:val = 16]) and not(./w:pPr[1]/w:ind[@w:left > 2000]) and not(./w:pPr[1]/w:jc[@w:val = 'right']) and count(preceding-sibling::w:p[./w:r[1]/w:rPr/w:b and (./w:pPr[1]/w:pStyle/@w:val = 'BodyText' or ./w:r[1]/w:rPr/w:sz/@w:val = 20)]) = $pos]">
                                <xsl:variable name="biblio">
                                    <xsl:apply-templates select="."/>
                                </xsl:variable>
                                <biblio>
                                    <xsl:value-of select="normalize-space($biblio)"/>
                                </biblio>
                            </xsl:for-each>

                            <!-- xsl:for-each
                            select="./following-sibling::w:p[./w:r[1]/w:rPr/w:sz[@w:val = 16] and (./w:pPr[1]/w:jc[@w:val = 'right']) and count(preceding-sibling::w:p[./w:r[1]/w:rPr/w:b and count(./w:r[1]/w:rPr/child::*) = 2]) = $pos]" -->
                            <xsl:for-each
                                select="./following-sibling::w:p[./w:r[1]/w:rPr/w:sz[@w:val = 16] and (./w:pPr[1]/w:ind[@w:left > 2000] or ./w:pPr[1]/w:jc[@w:val = 'right']) and count(preceding-sibling::w:p[./w:r[1]/w:rPr/w:b and (./w:pPr[1]/w:pStyle/@w:val = 'BodyText' or ./w:r[1]/w:rPr/w:sz/@w:val = 20)]) = $pos]">
                                <xsl:variable name="author">
                                    <xsl:apply-templates select="."/>
                                </xsl:variable>
                                <author>
                                    <xsl:value-of select="$author"/>
                                </author>
                            </xsl:for-each>
                        </article>
                    </xsl:if>
                </xsl:for-each>
            </dictionary>
        </xsl:variable>
        <xsl:apply-templates mode="phase2" select="$phase1"/>
    </xsl:template>

    <xsl:template name="tdates">
        <xsl:param name="pdates"/>
        <xsl:analyze-string regex="^([\d]+)([^\d])*([\d]+)?$" select="$pdates">
            <xsl:matching-substring>
                <group>
                    <birth>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </birth>
                    <separator>
                        <xsl:value-of select="normalize-space(regex-group(2))"/>
                    </separator>
                    <death>
                        <xsl:choose>
                            <xsl:when
                                test="not(normalize-space(regex-group(3)) = '') and string-length(normalize-space(regex-group(1))) > string-length(normalize-space(regex-group(3)))">
                                <xsl:value-of
                                    select="concat(substring(normalize-space(regex-group(1)), 1, string-length(normalize-space(regex-group(1))) - string-length(normalize-space(regex-group(3)))), normalize-space(regex-group(3)))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(regex-group(3))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </death>
                </group>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="dictionary" mode="phase2">
        <xsl:variable name="phase2">
            <dictionary>
                <xsl:for-each select="./article">
                    <article>
                        <body>
                            <xsl:for-each select="./body">
                                <xsl:if test="not(position() = 1)">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:for-each>
                        </body>
                        <biblio>
                            <xsl:for-each select="./biblio">
                                <xsl:if test="not(. = '')">
                                    <xsl:if test="not(position() = 1)">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:if>
                            </xsl:for-each>
                        </biblio>
                        <author>
                            <xsl:value-of select="./author"/>
                        </author>
                    </article>
                </xsl:for-each>
            </dictionary>
        </xsl:variable>
        <xsl:apply-templates select="$phase2" mode="phase3"/>
    </xsl:template>

    <xsl:template match="dictionary" mode="phase3">
        <xsl:variable name="phase3">
        <dictionary>
            <xsl:for-each select="./article">
                <article>
                    <!-- grep head, person name, birth and death dates, specialities -->
                    <xsl:variable name="groups" as="element(group)*">
                        <xsl:analyze-string regex="^([^(]+)\s+(\([^\d]+\)\s+)?(\([\d\s—]+\))?([\s—]+)?([^\d\.]+\.)?" select="./body">
                            <xsl:matching-substring>
                                <group>
                                    <head>
                                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                                    </head>
                                    <persName>
                                        <xsl:value-of select="normalize-space(translate(regex-group(2), '()', ''))"/>
                                    </persName>
                                    <dates>
                                        <xsl:value-of select="normalize-space(translate(regex-group(3), '()', ''))"/>
                                    </dates>
                                    <befSep>
                                        <xsl:value-of select="regex-group(4)"/>
                                    </befSep>
                                    <specialities>
                                        <xsl:value-of select="regex-group(5)"/>
                                    </specialities>
                                </group>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>

                    <xsl:variable name="dates" as="element(group)*">
                        <xsl:call-template name="tdates">
                            <xsl:with-param name="pdates">
                                <xsl:value-of select="$groups/dates"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:variable name="bodyWithoutHead">
                        <xsl:value-of select="normalize-space(substring-after(./body, $groups/head))"/>
                    </xsl:variable>

                    <xsl:variable name="subaf1">
                        <xsl:choose>
                            <xsl:when test="not($groups/persName = '')">
                                <xsl:value-of select="substring-after($bodyWithoutHead, $groups/persName)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$bodyWithoutHead"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <head>
                        <xsl:value-of select="$groups/head"/>
                    </head>

                    <body>
                        <xsl:choose>
                            <xsl:when test="not($groups/persName = '')">
                                <xsl:value-of select="substring-before($bodyWithoutHead, $groups/persName)"/>
                                <persName>
                                    <xsl:value-of select="$groups/persName"/>
                                </persName>
                            </xsl:when>
                        </xsl:choose>

                        <xsl:choose>
                            <xsl:when test="not($groups/dates = '')">
                                <xsl:value-of select="substring-before($subaf1, $groups/dates)"/>
                                <date>
                                    <xsl:attribute name="when">
                                        <xsl:value-of select="$dates/birth"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="type">
                                        <xsl:text>birth</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="$dates/birth"/>
                                </date>
                                <xsl:if test="not($dates/death = '')">
                                    <xsl:text>—</xsl:text>
                                    <date>
                                        <xsl:attribute name="when">
                                            <xsl:value-of select="$dates/death"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:text>death</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="$dates/death"/>
                                    </date>
                                </xsl:if>
                            </xsl:when>
                        </xsl:choose>

                        <xsl:choose>
                            <xsl:when test="not($groups/specialities = '')">
                                <xsl:value-of select="substring-after(substring-before($subaf1, $groups/specialities), $groups/dates)"/>
                                <xsl:choose>
                                    <xsl:when test="contains($groups/specialities, ',')">
                                        <xsl:for-each select="tokenize(substring($groups/specialities, 1, string-length($groups/specialities) - 1), ',')">
                                            <xsl:if test="not(position() = 1)">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <term type="specialist">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </term>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains($groups/specialities, ' и ')">
                                        <xsl:for-each select="tokenize(substring($groups/specialities, 1, string-length($groups/specialities) - 1), ' и ')">
                                            <xsl:if test="not(position() = 1)">
                                                <xsl:text> и </xsl:text>
                                            </xsl:if>
                                            <term type="specialist">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </term>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <term type="specialist">
                                            <xsl:value-of select="substring-before($groups/specialities, '.')"/>
                                        </term>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>.</xsl:text>
                                <xsl:value-of select="substring-after($subaf1, $groups/specialities)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after($subaf1, $groups/dates)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </body>

                    <xsl:variable name="writings" as="element(writings)*">
                        <writings>
                            <xsl:if test="contains(./biblio, 'СЪЧ.:')">
                                <head>СЪЧ.</head>
                                <body>
                                    <xsl:choose>
                                        <xsl:when test="contains(./biblio, 'ЗА НЕГО:')">
                                            <xsl:value-of select="substring-before(substring-after(./biblio, 'СЪЧ.:'), 'ЗА НЕГО:')"/>
                                        </xsl:when>
                                        <xsl:when test="contains(./biblio, 'ЗА НЕЯ:')">
                                            <xsl:value-of select="substring-before(substring-after(./biblio, 'СЪЧ.:'), 'ЗА НЕЯ:')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after(./biblio, 'СЪЧ.:')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </body>
                            </xsl:if>
                        </writings>
                    </xsl:variable>

                    <xsl:if test="$writings/head">
                        <div type="biblio">
                            <head>
                                <xsl:value-of select="$writings/head"/>
                            </head>
                            <listBibl>
                            <xsl:for-each select="tokenize($writings/body, ';')">
                                <bibl>
                                    <xsl:value-of select="normalize-space(.)"/>
                                    <xsl:text>;</xsl:text>
                                </bibl>
                            </xsl:for-each>
                            </listBibl>
                        </div>
                    </xsl:if>

                    <xsl:variable name="about" as="element(about)*">
                        <about>
                            <xsl:choose>
                                <xsl:when test="contains(./biblio, 'ЗА НЕГО:')">
                                    <head>ЗА НЕГО</head>
                                    <body>
                                        <xsl:value-of select="substring-after(./biblio, 'ЗА НЕГО:')"/>
                                    </body>
                                </xsl:when>
                                <xsl:when test="contains(./biblio, 'ЗА НЕЯ:')">
                                    <head>ЗА НЕЯ</head>
                                    <body>
                                        <xsl:value-of select="substring-after(./biblio, 'ЗА НЕЯ:')"/>
                                    </body>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </about>
                    </xsl:variable>

                    <xsl:if test="$about/head">
                        <div type="about">
                            <head>
                                <xsl:value-of select="$about/head"/>
                            </head>
                            <xsl:for-each select="tokenize($about/body, ';')">
                                <bibl>
                                    <xsl:value-of select="normalize-space(.)"/>
                                    <xsl:text>;</xsl:text>
                                </bibl>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                    <author>
                        <xsl:value-of select="./author"/>
                    </author>
                </article>
            </xsl:for-each>
        </dictionary>
        </xsl:variable>
        <xsl:apply-templates select="$phase3" mode="phase4"/>
    </xsl:template>
    
    <!-- xsl:template match="*" mode="copy-no-namespaces">
        <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="copy-no-namespaces"/>
        </xsl:element>
    </xsl:template -->
    
    
    <xsl:template match="*" mode="copy-no-namespaces">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="copy-no-namespaces"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="dictionary" mode="phase4">
        <xsl:for-each select="./article">
            <xsl:variable name="file">
                <xsl:value-of select="translate(./head, ', ', '')"/>
            </xsl:variable>
            <xsl:result-document xmlns="http://www.tei-c.org/ns/1.0" method="xml" href="{$file}.xml">
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title><xsl:value-of select="./head"/></title>
                                <author><xsl:value-of select="./author"/></author>
                                <respStmt>
                                    <resp>електронно издание и редакция</resp>
                                    <persName>
                                        <forename>Андрей</forename>
                                        <surname>Бояджиев</surname> 
                                    </persName>
                                </respStmt>
                                <respStmt>
                                    <resp>програмиране и уеб дизайн</resp>
                                    <persName>
                                        <forename>Атанас</forename>
                                        <surname>Георгиев</surname> 
                                    </persName>
                                </respStmt>
                            </titleStmt>
                            <publicationStmt>
                                <publisher>Институт за литература, БАН</publisher>
                                <pubPlace>София</pubPlace>
                                <date when="2018-04-20">20 април 2018</date>
                                <availability>
                                    <licence target="https://creativecommons.org/licenses/by/4.0/" notBefore="2016-08-02">
                                        <p>The Creative Commons Attribution 4.0 International (CC BY 4.0) License applies to this text.</p>
                                        <p>The license was added for the print version of this text on August 2, 2016.</p>
                                        <p>The CC BY 4.0 License also applies to this TEI XML file.</p>
                                    </licence>
                                </availability>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Чуждестранна българистика през XX век. Енциклопедичен справочник. София: Академично издателство „Марин Дринов“, 2008.</p>
                            </sourceDesc>
                        </fileDesc>
                        <profileDesc>
                            <textClass />
                        </profileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <div>
                                <head><xsl:value-of select="./head"/></head>
                                <div type="article">
                                    <p><xsl:copy-of select="./body/node()" copy-namespaces="no"/></p>
                                    <!-- p><xsl:apply-templates select="./body/node()" mode="copy-no-namespaces"/></p -->
                                </div>
                                <xsl:if test="./div[@type='biblio']">
                                    <div type="biblio">
                                        <head><xsl:value-of select="./div[@type='biblio']/head"/></head>
                                        <listBibl>
                                            <xsl:for-each select="./div[@type='biblio']/listBibl/bibl"><bibl><xsl:value-of select="."/></bibl></xsl:for-each>
                                        </listBibl>
                                    </div>
                                </xsl:if>
                                <xsl:if test="./div[@type='about']">
                                    <div type="about">
                                        <head><xsl:value-of select="./div[@type='about']/head"/></head>
                                        <xsl:for-each select="./div[@type='about']/bibl"><bibl><xsl:value-of select="."/></bibl></xsl:for-each>
                                    </div>
                                </xsl:if>                                
                            </div>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="w:tab">
        <xsl:text> </xsl:text>
    </xsl:template>


    <xsl:template name="transcyr2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, '', 'ђ')"
        />
    </xsl:template>
    

    <xsl:template name="tmscyr2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, '‑~ƒˆŠŒŽ–—˜šœžŸ¡¢£¥¨ª¯¸¹º¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ', '-˜ѓàЉЊЋ—–ѐљњћџЎўѝòЁЄЇё№єїАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя')"
        />
    </xsl:template>

    <!-- xsl:template name="tmsee2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, '~šœžŸ£¥ª«¯³¹º»¼¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ', '˜šśžźŁĄŞ«Żłąş»ĽľżŔÁÂĂÄĹĆÇČÉȨËĚÍÎĎÐŃŇÓÔŐÖ×ŘŮÚŰÜÝŢßŕáâăäĺćčéęëěíîďđńňóôőö÷řůúűüýţ')"
        />
    </xsl:template -->
    <xsl:template name="tmsee2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, 'ìíîïðñòóôõö÷øùúûüýþ', 'ěíîďđńňóôőö÷řůúűüýţ')"
        />
    </xsl:template>
    

    <xsl:template name="tmsgk2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, 'ÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ', 'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώ')"/>
    </xsl:template>

    <!-- xsl:template name="tmsgkold2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, 'ÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ', 'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώ')"/>
    </xsl:template -->
    <xsl:template name="tmsgkold2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="$txt"/>
    </xsl:template>
    

    <xsl:template name="tmsclassic2utf8">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate($txt, 'ÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ', 'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώ')"/>
    </xsl:template>

    <xsl:template match="w:t[preceding-sibling::w:rPr[./w:rFonts[@w:ascii = 'TmsEe'][1]]]/text()">
        <xsl:call-template name="tmsee2utf8">
            <xsl:with-param name="txt">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="w:t[preceding-sibling::w:rPr[./w:rFonts[@w:ascii = 'TmsGk'][1]]]/text()">
        <xsl:call-template name="tmsgk2utf8">
            <xsl:with-param name="txt">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="w:t[preceding-sibling::w:rPr[./w:rFonts[@w:ascii = 'TmsGk Old'][1]]]/text()">
        <xsl:call-template name="tmsgkold2utf8">
            <xsl:with-param name="txt">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="w:t[preceding-sibling::w:rPr[./w:rFonts[@w:ascii = 'TmsGk Classic'][1]]]/text()">
        <xsl:call-template name="tmsclassic2utf8">
            <xsl:with-param name="txt">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="w:t[preceding-sibling::w:rPr[./w:rFonts[@w:ascii = 'TransCyrillic'][1]]]/text()">
        <xsl:call-template name="transcyr2utf8">
            <xsl:with-param name="txt">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>    

    <xsl:template
        match="w:t[preceding-sibling::w:rPr[./w:rFonts[not(@w:ascii = 'TransCyrillic') and not(@w:ascii = 'TmsEe') and not(@w:ascii = 'TmsGk') and not(@w:ascii = 'TmsGk Old') and not(@w:ascii = 'TmsGk Classic')][1]] or preceding-sibling::w:rPr[not(./w:rFonts)][1]]/text()">
        <!-- xsl:if test="./preceding-sibling::w:rPr/w:rFonts[not(@w:ascii = 'TmsEe')]"/ -->
        <xsl:call-template name="tmscyr2utf8">
            <xsl:with-param name="txt">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()">
        <!-- skip it -->
    </xsl:template>
</xsl:stylesheet>
