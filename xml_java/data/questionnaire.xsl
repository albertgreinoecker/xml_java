<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" encoding="UTF-8" />
	<xsl:template match="/">
		<h1>
			<xsl:value-of select="//header/label" />
		</h1>
		<xsl:for-each select="questionnaire/*">
			<xsl:sort data-type="text" case-order="" ></xsl:sort>
			<xsl:apply-templates select="." />
			<br />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="header">
	</xsl:template>

	<xsl:template name="fragetext">
		<xsl:param name="type"></xsl:param>
		<xsl:value-of select="$type"/>
		<xsl:element name="{$type}">
			<xsl:attribute name="style">background:yellow</xsl:attribute>
			<xsl:value-of select="@disp_id" />
			.
			<xsl:value-of select="text" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="closedEndedQ">
		<xsl:call-template name="fragetext" >
			<xsl:with-param name="type">b</xsl:with-param>
		</xsl:call-template>
		<ul>
			<xsl:variable name="mult" select="choices/@mult" />
			<xsl:for-each select="choices/choice">
				<li>
					<xsl:choose>
						<xsl:when test="$mult='false'">
							<input type="radio" name="var_{../../@id}" value="{@id}" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="var_name">
								var_
								<xsl:value-of select="../../@id" />
								_
								<xsl:value-of select="@id" />
							</xsl:variable>
							<input type="checkbox" name="{$var_name}" value="checked" />
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="text" />
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="textBlock">
		<h3>
			<xsl:copy-of select="xhtml" />
		</h3>
	</xsl:template>

	<xsl:template match="openEndedQ">
		<xsl:call-template name="fragetext" >
			<xsl:with-param name="type">b</xsl:with-param>
		</xsl:call-template>
		<!-- TODO: Bitte hier ein textarea eintragen (die entsprechende id dafuer 
			setzen) -->
	</xsl:template>

	<xsl:template match="openendedMatrixQ">
		<xsl:call-template name="fragetext" >
			<xsl:with-param name="type">u</xsl:with-param>
		</xsl:call-template>
		<!-- TODO: Bitte hier pro questions/question - Eintrag ein textarea eintragen 
			(auch die entsprechende id dafuer setzen) Eine Tabelle waere fuer die Darstellung 
			gut geeignet -->
	</xsl:template>

	<xsl:template match="questionMatrixMult">
		<xsl:call-template name="fragetext" >
			<xsl:with-param name="type">b</xsl:with-param>
		</xsl:call-template>

		<xsl:variable name="mult" select="choices/@mult = 'true'" />

		<xsl:for-each select="choices/choice">
			<xsl:choose>
				<xsl:when test="$mult = 'true'">
					<input type="checkbox" />
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="text"></xsl:value-of>
		</xsl:for-each>

		<xsl:for-each select="questions/question">
			<xsl:for-each select="../../choices/choice">


			</xsl:for-each>

		</xsl:for-each>

		<!-- TODO: Das ist der schwierigste Fragetyp. Hier soll die Frage wie eine 
			closedEndedQ - aber als Tabelle dargestellt werden d.h. es gibt zusaetzlich 
			zu den Questions auch choices/choice. Diese sollen als Ueberschriften der 
			Tabelle angezeigt werden und sie bestimmen auch wie viele Spalten in den 
			Zeilen angezeigt werden sollen (Hinweis: verschachtelte Schleife waere gut) 
			Die grosse Herausforderung (als extra challenge): Wie kann man es schaffen, 
			dass jede Zelle eine eindeutige id bekommt? (Hinweis: Da muss man immer eine 
			Kombination aus choice und question angeben. Man kommt Ebenen hoeher mit 
			z.B: ../../@id -->
	</xsl:template>



</xsl:stylesheet>