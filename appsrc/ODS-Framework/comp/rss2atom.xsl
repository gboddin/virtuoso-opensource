<?xml version="1.0"?>
<!--
 -
 -  $Id$
 -
 -  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
 -  project.
 -
 -  Copyright (C) 1998-2013 OpenLink Software
 -
 -  This project is free software; you can redistribute it and/or modify it
 -  under the terms of the GNU General Public License as published by the
 -  Free Software Foundation; only version 2 of the License, dated June 1991.
 -
 -  This program is distributed in the hope that it will be useful, but
 -  WITHOUT ANY WARRANTY; without even the implied warranty of
 -  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 -  General Public License for more details.
 -
 -  You should have received a copy of the GNU General Public License along
 -  with this program; if not, write to the Free Software Foundation, Inc.,
 -  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 -
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:wfw="http://wellformedweb.org/CommentAPI/"
  xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns="http://www.w3.org/2005/Atom"
  xmlns:vi="http://www.openlinksw.com/ods/"
  xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/"
  xmlns:itunes="http://www.itunes.com/DTDs/Podcast-1.0.dtd"
  exclude-result-prefixes="atom"
  version="1.0">

<xsl:output indent="yes" />
<xsl:param name="httpUrl" select="vi:getHttpUrl()"/>
<xsl:param name="isRegularFeed" select="boolean(vi:isRegularFeed())"/>


<!-- general element conversions -->

<xsl:template match="rss/channel">
  <xsl:comment>ATOM based XML document generated By OpenLink Virtuoso</xsl:comment>
  <feed>
      <id><xsl:value-of select="link"/></id>
      <xsl:apply-templates/>
  </feed>
</xsl:template>

<xsl:template match="title">
    <title><xsl:apply-templates /></title>
</xsl:template>

<xsl:template match="link">
    <link href="{.}" type="text/html" rel="alternate"/>
    <xsl:if test="parent::channel">
	<link href="{$httpUrl}" type="application/atom+xml" rel="self"/>
    </xsl:if>
    <xsl:if test="parent::item and not ($isRegularFeed)">
	<xsl:choose>
	    <xsl:when test="parent::item/vi:version">
		<xsl:variable name="ver" select="parent::item/vi:version"/>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:variable name="ver">1</xsl:variable>
	    </xsl:otherwise>
	</xsl:choose>
	<link href="{$httpUrl}/{substring-after (., '?id=')}/{$ver}" rel="edit"/>
    </xsl:if>
</xsl:template>

<xsl:template match="channel/itunes:*" />
<xsl:template match="item/itunes:*" />

<xsl:template match="channel/description[.!='']">
    <subtitle><xsl:apply-templates /></subtitle>
</xsl:template>

<xsl:template match="channel/copyright">
    <xsl:if test=". != ''">
	<rights><xsl:apply-templates /></rights>
    </xsl:if>
</xsl:template>

<xsl:template match="channel/managingEditor[.!='']">
	<xsl:call-template name="author"/>
</xsl:template>

<xsl:template match="channel[not lastBuildDate]/pubDate">
    <updated><xsl:call-template name="date"/></updated>
</xsl:template>

<xsl:template match="channel/lastBuildDate">
    <updated><xsl:call-template name="date"/></updated>
</xsl:template>

<xsl:template match="channel/category[not @text]">
    <category term="{.}" />
</xsl:template>

<xsl:template match="channel/generator">
    <generator>
	<xsl:apply-templates />
    </generator>
</xsl:template>

<xsl:template match="channel/image">
    <logo><xsl:apply-templates select="url"/></logo>
</xsl:template>

<xsl:template match="item/author[.!='' and namespace-uri () = '']">
    <xsl:call-template name="author"/>
</xsl:template>

<xsl:template match="item/description">
    <content>
      <xsl:choose>
	<xsl:when test="@type">
	   <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
	   <xsl:attribute name="type">html</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
    </content>
</xsl:template>

<xsl:template match="item/guid">
    <id><xsl:apply-templates /></id>
</xsl:template>

<xsl:template match="item/pubDate">
    <published><xsl:call-template name="date"/></published>
</xsl:template>

<xsl:template match="item/vi:modified">
    <updated><xsl:call-template name="date"/></updated>
</xsl:template>

<xsl:template match="item">
    <entry>
	<xsl:if test="not (guid) and link">
	    <id><xsl:value-of select="link"/></id>
	</xsl:if>
	<xsl:if test="not (description)">
	    <content type="html">
	      <xsl:value-of select="title"/>
	    </content>
	</xsl:if>
	<xsl:apply-templates />
    </entry>
</xsl:template>

<xsl:template match="openSearch:*">
    <xsl:copy>
	<xsl:copy-of select="@*|text()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="channel/language" />
<xsl:template match="channel/webMaster" />
<xsl:template match="channel/cloud" />
<xsl:template match="wfw:*" />
<xsl:template match="dc:*" />
<xsl:template match="slash:*" />
<xsl:template match="item/comments" />
<xsl:template match="item/enclosure" />
<xsl:template match="itunes:*" />
<xsl:template match="vi:version" />

<xsl:template match="@*" />

<xsl:template match="text()">
  <xsl:param name="keep-space"/>
  <xsl:choose>
    <xsl:when test="not $keep-space">
      <xsl:value-of select="normalize-space(.)" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="author">
    <xsl:variable name="author">
	<author>
	    <xsl:choose>
		<xsl:when test="contains (., '&lt;')">
		    <name><xsl:value-of select="normalize-space (substring-before (.,'&lt;'))"/></name>
		    <email><xsl:value-of select="translate (substring-after (.,'&lt;'), '&gt;', '')"/></email>
		</xsl:when>
		<xsl:when test="contains (., '(')">
		    <name><xsl:value-of select="translate (substring-after (.,'('), ')', '')"/></name>
		    <email><xsl:value-of select="normalize-space (substring-before (.,'('))"/></email>
		</xsl:when>
		<xsl:otherwise>
		    <name><xsl:value-of select="."/></name>
		</xsl:otherwise>
	    </xsl:choose>
	</author>
    </xsl:variable>
    <xsl:choose>
	<xsl:when test="$author/author/name[.!=''] and $author/author/email[.!='']">
	    <xsl:copy-of select="$author/author"/>
	</xsl:when>
	<xsl:when test="$author/author/email[.!='']">
	    <author>
		<name>~unknown~</name>
		<xsl:copy-of select="$author/author/email"/>
	    </author>
	</xsl:when>
	<xsl:when test="$author/author/name[.!='']">
	    <author>
		<xsl:copy-of select="$author/author/name"/>
	    </author>
	</xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template name="date">
  <xsl:variable name="m" select="substring(., 9, 3)" />
  <xsl:value-of select="substring(., 13, 4)"
  />-<xsl:choose>
    <xsl:when test="$m='Jan'">01</xsl:when>
    <xsl:when test="$m='Feb'">02</xsl:when>
    <xsl:when test="$m='Mar'">03</xsl:when>
    <xsl:when test="$m='Apr'">04</xsl:when>
    <xsl:when test="$m='May'">05</xsl:when>
    <xsl:when test="$m='Jun'">06</xsl:when>
    <xsl:when test="$m='Jul'">07</xsl:when>
    <xsl:when test="$m='Aug'">08</xsl:when>
    <xsl:when test="$m='Sep'">09</xsl:when>
    <xsl:when test="$m='Oct'">10</xsl:when>
    <xsl:when test="$m='Nov'">11</xsl:when>
    <xsl:when test="$m='Dec'">12</xsl:when>
    <xsl:otherwise>00</xsl:otherwise>
  </xsl:choose>-<xsl:value-of select="substring(., 6, 2)"
  />T<xsl:value-of select="substring(., 18, 8)" /><xsl:text>Z</xsl:text>
</xsl:template>

<xsl:template name="removeTags">
  <xsl:param name="html" select="." />
  <xsl:choose>
    <xsl:when test="contains($html,'&lt;')">
      <xsl:call-template name="removeEntities">
        <xsl:with-param name="html" select="substring-before($html,'&lt;')" />
      </xsl:call-template>
      <xsl:call-template name="removeTags">
        <xsl:with-param name="html" select="substring-after($html, '&gt;')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="removeEntities">
        <xsl:with-param name="html" select="$html" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="removeEntities">
  <xsl:param name="html" select="." />
  <xsl:choose>
    <xsl:when test="contains($html,'&amp;')">
      <xsl:value-of select="substring-before($html,'&amp;')" />
      <xsl:variable name="c" select="substring-before(substring-after($html,'&amp;'),';')" />
      <xsl:choose>
        <xsl:when test="$c='nbsp'">&#160;</xsl:when>
        <xsl:when test="$c='lt'">&lt;</xsl:when>
        <xsl:when test="$c='gt'">&gt;</xsl:when>
        <xsl:when test="$c='amp'">&amp;</xsl:when>
        <xsl:when test="$c='quot'">&quot;</xsl:when>
        <xsl:when test="$c='apos'">&apos;</xsl:when>
        <xsl:otherwise>?</xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="removeTags">
        <xsl:with-param name="html" select="substring-after($html, ';')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$html" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
