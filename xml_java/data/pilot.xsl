<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html>
			<head></head>
			<body>
				<table border="1">
					<tr>
						<th>laufende Nummer</th>
						<th>id</th>
						<th>Vorname</th>
						<th>Nachname</th>
						<th>Punkte</th>	
						<th>Rennstallname</th>
						<th>dabeiSeit</th>	
					</tr>
					<xsl:apply-templates select="//Pilot"/>					
				</table>
			</body>	
		</html>
	</xsl:template>
	
	<xsl:template name="text_output">
		<xsl:param name="punkte"/>
		Hallo <xsl:value-of select="$punkte"/>
	</xsl:template>
	
	<xsl:template match="Pilot">
		<xsl:variable name="my_id" >
			Nummer:<xsl:value-of select="@id + 1"/> 
		</xsl:variable>
		<tr>
			<td><xsl:number/></td>
			<td><b><xsl:value-of select="$my_id"/></b></td>
			<td><xsl:value-of select="Vorname"/></td>
			<td><xsl:value-of select="Nachname"/></td>
			
			<td>
			
			<xsl:copy-of select="text"/>
			
			<xsl:choose>
				<xsl:when test="Punkte &gt; 80">
					<xsl:call-template name="text_output">
						<xsl:with-param name="punkte" select="(Punkte + 20) mod 100"/>
					</xsl:call-template> 
				</xsl:when>
				<xsl:when test="Punkte &gt; 50">
					<b><xsl:value-of select="Punkte"/></b>
				</xsl:when>
				<xsl:otherwise>
					<strike><xsl:value-of select="Punkte"/></strike>
				</xsl:otherwise>
			</xsl:choose>
			</td>
			
			<xsl:if test="Punkte &gt; 50">			
				<xsl:apply-templates select="Rennstall"/>
			</xsl:if>	
		</tr>	
	</xsl:template>
	
	<xsl:template match="Rennstall">
		<td><xsl:value-of select="Name"/></td>
		<td><xsl:value-of select="dabeiSeit"/></td>	
	</xsl:template>
	
	
	
</xsl:stylesheet>