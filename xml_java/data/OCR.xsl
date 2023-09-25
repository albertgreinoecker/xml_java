<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="/">
		<xsl:apply-templates select="header" />
		<xsl:apply-templates select="paragraph" />
	</xsl:template>

	<xsl:template match="paragraph">
		<xsl:variable name="size_first"
			select="./character[1]/@font_size" />
		<p style="font-size: {$size_first}">
			<xsl:apply-templates select="character" />
		</p>
	</xsl:template>

	<xsl:template match="header">
		<a href="{//info[@key ='pdf_file']/@value}}">
			<img src="{//info[@key ='thumb']/@value}"/>
		</a>
	</xsl:template>

	<xsl:template match="character">
		<xsl:choose>
			<xsl:when test="@attr &gt; 100">
				<span style="background:red">
					<xsl:value-of select="@value"></xsl:value-of>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@value"></xsl:value-of>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template
		match="text()[not(string-length(normalize-space()))]" />

	<xsl:template
		match="text()[string-length(normalize-space()) > 0]">
		<xsl:value-of select="translate(.,'&#xA;&#xD;', '  ')" />
	</xsl:template>

</xsl:stylesheet>