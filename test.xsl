<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compact"/>

    <xsl:key name="persID" match="persName" use="@ref"/>

<!--    <xsl:strip-space elements="*"/>-->

    <xsl:template match="/">

        <xsl:for-each select="collection('?select=taxroll_*.xml')">
            <xsl:result-document href="../html/roll_{//date/@when}.html">
            <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
                <link rel="stylesheet" type="text/css" href="../enc.css"/>
            </head>

            <body>
                <!-- Header Links -->
                <xsl:copy-of select="document('./html/header.html')"/>
                
                <!-- Header Section -->
                <div class="container">
                    <h2><xsl:value-of select=".//msIdentifier/msName"/></h2>
                    <xsl:value-of select=".//msIdentifier/settlement"/>, <xsl:value-of
                        select=".//msIdentifier/country"/><br/>
                    <xsl:value-of select=".//msIdentifier/institution"/><br/>
                    <xsl:choose>
                        <xsl:when test=".//msIdentifier[repository]">
                            <xsl:value-of select=".//msIdentifier/repository"/>, <xsl:value-of
                                select=".//msIdentifier/collection"/>&#160;<xsl:value-of
                                    select=".//msIdentifier/idno"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select=".//msIdentifier/collection"/>&#160;<xsl:value-of
                                    select=".//msIdentifier/idno"/>
                        </xsl:otherwise>
                    </xsl:choose>
                 
                    <br/><br/>
                    <hr/>
                    <xsl:apply-templates select="/TEI/text/body"/>
                </div>

            </body>
        </html></xsl:result-document></xsl:for-each>
    </xsl:template>


    <!-- Templates -->

    <xsl:template match="div[@type='parish']//text()">
        <xsl:value-of select="replace(.,'\.',' ')"/>
    </xsl:template>

    <xsl:template match="ex">
        <span class="expan">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="div[@type = 'incipit']">
        <p id="{./head/@xml:id}" class="incipit">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="del[@rend = 'strikethrough']">
        <span class="strikethrough">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="del[@rend = 'expunctuate']">
        <span class="exp"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="del[@rend = 'erased']">
    </xsl:template>
    
    <xsl:template match="seg[@rend = 'superscript']" priority="5">
        <sup><xsl:apply-templates/></sup>
    </xsl:template>

    <xsl:template match="persName | rs[@type='person']">
        <a href="personography.html{@ref}">
            <xsl:apply-templates select="normalize-space(.)"/>
        </a>
    </xsl:template>

    <xsl:template match="item/seg[@type='entry']/descendant::lb">
        <br/><xsl:apply-templates/>
    </xsl:template>
    

    <!-- 
	<xsl:template match="g[@type='initial']">
		 <span class="initial"><xsl:apply-templates /></span>
	</xsl:template>
 -->

    <xsl:template match="g[@ref='#2E3F']">
        <span class="capitulum">&#x2e3f; </span>
    </xsl:template>

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
                    <xsl:value-of select="replace(.,'\.',' ')"/>
                </span>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="replace(.,'\.',' ')"/>
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
        <tr><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
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

    <xsl:template match="seg[@type = 'payment']">
        <td class="table_amount">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="seg[@type = 'status']">
        <td class="status">
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    

<!--    <xsl:template match="measure[not(parent::measureGrp)]">
        <td class="table_amount">
            <xsl:next-match/>
        </td>
    </xsl:template>-->

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
    <xsl:template match="pb[@facs]">
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
