<?xml version="1.0" encoding="UTF-8"?>
<!-- New document created with EditiX at Wed Feb 26 15:31:38 CET 2020 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					Pays du monde 
  				</title>
			</head>
			<body style="background-color:white;" >
				<h1>Les pays du monde</h1>
				Mise en forme par : Mathieu Ouvrard, Stefan Ristovski et Andrieu Girard. Binôme (B3430)
 			
				<!--Application du Template MetaDonnees-->
				<xsl:apply-templates select="//metadonnees"/>
				<!--Calcul des pays avec 6 voisins:-->
				<p>
					Pays avec 6 voisins : 
					<xsl:for-each select="//country">
						<xsl:if test="borders[count(neighbour)=6] and preceding::borders[count(neighbour)=6]">, 
						</xsl:if>
						<xsl:value-of select="borders[count(neighbour)=6]/../name/common"/>
					</xsl:for-each>
				</p>
				<!--Calcul de pays ayant le plus de voisins-->
				<xsl:for-each select="//country">
					<xsl:sort select="count(borders/neighbour)" data-type="number" order="descending"/>
					<xsl:if test="position() = 1">
						<xsl:variable name= "maxneigh">
							<xsl:value-of select="count(borders/neighbour)"/>
						</xsl:variable>
						Pays ayant le plus de voisins : 
						<xsl:value-of select="borders[count(neighbour)=$maxneigh]/../name/common"/>, 
						nob de voisins : <xsl:value-of select="$maxneigh"/>
					</xsl:if>
				</xsl:for-each> 
				<p></p>
				<hr/>
				
				<!--Pour chaque continent-->
				<xsl:for-each select="//continent[not(text()=preceding::continent/text())]">
					<xsl:if test="not(current()='')">
						<br/>
						<h3>Pays du contient : <xsl:value-of select="current()"/> par sous-régions :</h3>
					</xsl:if>
					<!--Pour chaque sous region-->
					<xsl:for-each select="//subregion[../continent=current() and not(text()=preceding::subregion/text())]">
						<xsl:apply-templates select="current()"/> <!--Appliquer Template Subregion-->
					</xsl:for-each>
				</xsl:for-each>
			
			</body>
		</html>
	</xsl:template>
	
	<!--TEMPLATE METADONNEES-->
	<xsl:template match="metadonnees">
		<p style="text-align:center; color:blue;">Objectif : <xsl:value-of select="objectif"/></p>
		<hr/>
		<hr/>
	</xsl:template>
	
	<!--TEMPLATE SOUS REGION-->
	<xsl:template match="//subregion">
		<h4>
			<xsl:value-of select="current()"/>
			 (<xsl:value-of select="count(//country[infosContinent/subregion=current()])"/> pays) <!--Affichage du Region avec nb de pays-->
		</h4>
		<table align="center" width="100%" border="3"> <!--Definition du tableau-->
			<tr>
				<th>N°</th>
				<th>Nom</th>
				<th>Capitale</th>
				<th>Voisins</th>
				<th>Coordonnees</th>
				<th>Drapeau</th>
			</tr>
			<xsl:apply-templates select="//country[infosContinent/subregion=current()]"/> <!--Appliquer template Country dans le tableau-->
		</table>
	</xsl:template>
	
	<!--TEMPLATE PAYS-->
	<xsl:template match="//country">
		<tr>
			<td>
				<xsl:value-of select="position()"/> <!--Position du pays dans le tableau-->
			</td>
			<td>
				<span style="color:green;">
					<xsl:value-of select="name/common"/> <!--Nom du pays-->
				</span> 
				(<xsl:value-of select="name/official"/>)
				<br/>
				
				<xsl:if test="name/native_name[@lang='eng']/official">
					<span style="color:blue;">
						Nom Anglais: <xsl:value-of select="name/native_name[@lang='eng']/official"/> <!--Nom Anglais si existe-->
					</span>
				</xsl:if>
			</td>
			<td>
				<xsl:value-of select="capital"/> <!--Affichage capital-->
			</td>
			<td>
				<xsl:if test="not(borders/neighbour) and landlocked[text()='false']"> <!--Test si pays est un ile-->
					Ile
				</xsl:if>
				<xsl:for-each select="borders/neighbour"> <!--Affichage des voisins-->
					<xsl:variable name= "x">
						<xsl:value-of select="."/>
					</xsl:variable>
					<xsl:if test="not(position()=1)">, 
					</xsl:if>
					<xsl:value-of select="//country[codes/cca3=$x]/name/common"/>
				</xsl:for-each>
			</td>
			<td>
				Latitude: <xsl:value-of select="coordinates/@lat"/> <!--Affichage coordonnnes-->
				<br/>
				Longitude: <xsl:value-of select="coordinates/@long"/>
			</td>
			<td>
				<img src="http://www.geonames.org/flags/x/{translate(codes/cca2, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')}.gif" alt="" width="60" height="40"/> <!--Affichage Drapeau-->
			</td>
		</tr>
	</xsl:template>
	
</xsl:stylesheet>
