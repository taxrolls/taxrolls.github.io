<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compact"/>

    <xsl:key name="persID" match="persName" use="@ref"/>

    <xsl:template match="/">

        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
                <link rel="stylesheet" type="text/css" href="enc.css"/>
            </head>

            <body>
                <!-- Header Section -->
                <div class="container">
                    <h2><xsl:value-of select=".//msIdentifier/msName"/></h2>
                    <xsl:value-of select=".//msIdentifier/settlement"/>, <xsl:value-of
                        select=".//msIdentifier/country"/><br/>
                    <xsl:value-of select=".//msIdentifier/institution"/><br/>
                    <xsl:value-of select=".//msIdentifier/repository"/>, <xsl:value-of
                        select=".//msIdentifier/collection"/>&#160;<xsl:value-of
                        select=".//msIdentifier/idno"/><br/><br/>
                    <hr/>
                    <xsl:apply-templates select="/TEI/text/body"/>
                </div>

                <!-- Person Index -->
                <div class="container">
                    <h2>People</h2>
                    <p>Unique Entries: <xsl:value-of select="count(distinct-values(//persName[@ref]))"/></p>
                    <ul class="name_index">
                        <xsl:for-each select=".//persName">
                            <!-- [not(@ref=preceding::persName/@ref)] -->
                            <xsl:sort select="./@ref"/>
                            <xsl:sort select=".//forename" lang="fr-FR"/>
<!--                            <xsl:sort select=".//surname[1]" lang="fr-FR" />-->
                            <li id="{substring(@ref,2,5)}">
                                <xsl:value-of select="./@ref"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="." />
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>



<!--                <!-\- Occupation Index -\->  before trying to add names to occupations 
                <div class="container">
                    <h2>Occupations</h2>
                    <ul>
                        <xsl:for-each-group select="//state" group-by="@role">
                            <xsl:sort select="./@role" lang="fr-FR"/>
                            <li class="occ">
                                <xsl:variable name="count" select="count(current-group())"/>
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:if test="count(current-group()) &gt; 1"> 
                                    (<xsl:value-of select="count(current-group())"/>) 
                                </xsl:if>
                                <ul>
                                    <xsl:for-each-group select="current-group()" group-by="*">
                                        <xsl:sort select="count(current-group())" order="descending"/>
                                        <xsl:sort select="." collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes"/>
                                        <li class="occ_variant">
                                            <xsl:value-of select="."/>
                                            <xsl:if test="count(current-group()) != $count and count(current-group()) != 1">
                                                (<xsl:value-of select="count(current-group())"/>)
                                            </xsl:if>
                                        </li>
                                    </xsl:for-each-group>
                                </ul>
                            </li>
                        </xsl:for-each-group>
                    </ul>
                </div>-->
  
                <!-- Occupation Index -->
                <div class="container">
                    <h2>Occupations</h2>
                    <ul>
                        <xsl:for-each-group select="//rs[@type='occupation']" group-by="@role">
                            <xsl:sort select="./@role" lang="fr-FR"/>
                            <li class="occ">
                                <xsl:variable name="count" select="count(current-group())"/>
                                
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:if test="count(current-group()) &gt; 1"> 
                                    (<xsl:value-of select="count(current-group())"/>) 
                                </xsl:if>
                                <ul>
                                    <xsl:for-each-group select="current-group()" group-by="normalize-space(.)" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes">
                                        <xsl:sort select="count(current-group())" order="descending"/>
                                        <xsl:sort select="." collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes"/>
                                        <li class="occ_variant">
                                            <xsl:value-of select="current-grouping-key()"/>
                                            <xsl:if test="count(current-group()) != $count and count(current-group()) != 1">
                                                (<xsl:value-of select="count(current-group())"/>)
                                            </xsl:if>
                                            <ul>
                                                <xsl:for-each select="current-group()">
                                                    <xsl:sort select="key('persID', @ref)[1]" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes" />
                                                    <xsl:variable name="persRef" select="@ref"/>
                                                    <li><xsl:value-of select="key('persID', @ref)"/></li>
                                                </xsl:for-each>
                                            
                                                
                                                
                                            </ul>
                                            
                                        </li>
                                    </xsl:for-each-group>
                                </ul>
                            </li>
                        </xsl:for-each-group>
                    </ul>
                </div>
  
  
                <!-- Names Index -->
                <div class="container">
                    <h2>Names</h2>
                    <h3>Given Names</h3>
                    <ul>
                        <xsl:for-each-group select="//persName" group-by="forename" collation="http://saxon.sf.net/collation?ignore-case=yes">
                            <xsl:sort select="forename" lang="fr-FR"/>
                            <li>
                                <xsl:variable name="count" select="count(current-group())"/>
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:if test="count(current-group()) &gt; 1"> 
                                    (<xsl:value-of select="count(current-group())"/>) 
                                </xsl:if>
                             </li>
                        </xsl:for-each-group>
                    </ul>
                    <h3>Toponyms</h3>
                    <ul>
                        <xsl:for-each-group select="//persName" group-by="descendant::placeName" collation="http://saxon.sf.net/collation?ignore-case=yes">
                            <xsl:sort select="descendant::placeName" lang="fr-FR"/>
                            <li>
                                <xsl:variable name="count" select="count(current-group())"/>
                                <xsl:value-of select="descendant::placeName"/> <xsl:if test="descendant::nameLink"> (<xsl:value-of select="descendant::nameLink"/>)</xsl:if>
                                <xsl:if test="count(current-group()) &gt; 1"> 
                                    (<xsl:value-of select="count(current-group())"/>) 
                                </xsl:if>
                            </li>
                        </xsl:for-each-group>
                    </ul>
                </div>
                
 
 
            </body>
        </html>
    </xsl:template>


    <!-- Templates -->

    <xsl:template match="ex">
        <span class="expan">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="div[@type = 'incipit']">
        <p class="incipit">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="del[@rend = 'strikethrough']">
        <span class="strikethrough">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="del[@rend = 'expunctuate']">
<!--        <span class="exp">
            <xsl:apply-templates/>
        </span>-->
    </xsl:template>

    <xsl:template match="del[@rend = 'erased']">
    </xsl:template>
    
    <xsl:template match="seg[@rend = 'superscript']" priority="5">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="persName">
        <a href="{@ref}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>


    <!-- 
	<xsl:template match="g[@type='initial']">
		 <span class="initial"><xsl:apply-templates /></span>
	</xsl:template>
 -->

    <xsl:template match="div[@type = 'parish']">
        <div class="parish">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="div[@type = 'quête']">
        <div class="queste">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="div[@type = 'street']">
        <div class="street">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="head[@type = 'quête_title']">
        <h3 class="queste_title">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="div[@type = 'street']/head">
        <h4 class="street_desc">
            <xsl:apply-templates/>
        </h4>
    </xsl:template>


<!--    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>-->
    

    <xsl:template match="measure">
        <xsl:analyze-string select="." regex="[ivxlLcC]+[^b]">
            <xsl:matching-substring>
                <span class="num">
                    <xsl:copy-of select="."/>
                </span>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

   

    <!-- Items Table -->
    <xsl:template match="list[@type = 'payers']">
        <table class="name_table">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="list/item">
        <tr>
            <td class="list_num">
                <span class="n">
                    <xsl:if test="./not(descendant::del[@rend = 'erased'])">
                        <xsl:value-of select="count(preceding::item)+1"/>
                    </xsl:if>
                </span>
            </td>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="item/seg[@type = 'entry']">
        <td class="table_item">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="measureGrp">
        <td class="table_amount">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="measure[not(parent::measureGrp)]">
        <td class="table_amount">
            <xsl:next-match/>
        </td>
    </xsl:template>

    <!-- Sum Table -->
    <xsl:template match="div[@type = 'sum']">
        <div class="sum">
            <table class="sum">
                <tr>
                    <xsl:apply-templates/>
                </tr>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="seg[@type = 'sum_desc']">
        <td class="sum_desc">
            <xsl:apply-templates/>
        </td>
    </xsl:template>


    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <!-- Marginal IIIF Thumbnails -->
    <xsl:template match="pb">
        <div class="container thumbnail">
            <xsl:choose>
                <xsl:when test="@type = 'recto'">
                    <a href="{@facs}/pct:48,3,50,92/pct:50/0/default.jpg" target="_blank"><img class="thumbnail-img" src="{@facs}/pct:48,3,50,92/pct:5/0/default.jpg" align="left" height="200"/></a>
                    <p class="thumbnail-caption"><a href="{@facs}/pct:48,3,50,92/pct:50/0/default.jpg" target="_blank">Fol. <xsl:value-of select="@n"/></a></p>
                </xsl:when>
                <xsl:when test="@type = 'verso'">
                    <a href="{@facs}/pct:2,3,50,92/pct:50/0/default.jpg" target="_blank"><img class="thumbnail-img" src="{@facs}/pct:2,3,50,92/pct:5/0/default.jpg" align="left" height="200"/></a>
                    <p class="thumbnail-caption"><a href="{@facs}/pct:2,3,50,92/pct:50/0/default.jpg" target="_blank">Fol. <xsl:value-of select="@n"/></a></p>
                </xsl:when>
            </xsl:choose>
            
            <xsl:apply-templates/>
        </div>
    </xsl:template>

</xsl:stylesheet>
