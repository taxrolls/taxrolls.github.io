<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compact"/>



    <xsl:template match="/">

        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
                <link rel="stylesheet" type="text/css" href="../enc.css"/>
            </head>

            <body>
                <!-- Header Links -->
                <xsl:copy-of select="document('./html/header.html')"/>

                <!-- Header Section -->
                <div class="flexbox">
                    <div class="main">
                        <div class="container">
                            <h1>Personography</h1>
                            <p>Total Unique Entries: <xsl:value-of select="count(.//person)"/></p>
                            <hr/>
                            <xsl:for-each select="//person">
                                <xsl:sort select="(./persName[1]/@key, normalize-space(./persName[1]/forename[1]), normalize-space(./persName[1]/surname[1]))[1]" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes;"/>
                                <xsl:variable name="fullID" select="./@xml:id"/>
                                <xsl:variable name="refID" select="concat('#', $fullID)"/>
        
                                <div class="person">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="$fullID"/>
                                    </xsl:attribute>
                                    <h3>
                                        <xsl:choose>
                                            <xsl:when test="persName[@type][@key]">
                                                <xsl:value-of select="./persName[@type][1]/@key"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="./persName[1]"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </h3>
                                    <p>ID: <xsl:value-of select="$refID"/></p>
                                    <xsl:if test="./sex">
                                        <p>Gender: <xsl:value-of select="./sex/@value"/></p>
                                    </xsl:if>
                                    <xsl:if test="./birth">
                                        <p>Birth: <xsl:value-of select="./birth/@when"/><xsl:if test="not(./birth/@when)"><xsl:value-of select="./birth/@from"/> &#8211; <xsl:value-of select="./birth/@to"/></xsl:if></p>
                                    </xsl:if>
                                    <xsl:if test="./death">
                                        <p>Death: <xsl:value-of select="./death/@when"/><xsl:if test="not(./death/@when) and ./death/@notAfter">before <xsl:value-of select="./death/@notAfter"/></xsl:if></p>
                                    </xsl:if>
                                    <xsl:if test="./state[@type = 'office']">
                                        <xsl:for-each select="./state[@type = 'office']">
                                            <p>Office: <xsl:value-of select="./label"/> (<xsl:value-of select="@from"/> &#8211; <xsl:value-of select="@to"/>)</p>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <xsl:if test="./occupation">
                                        <xsl:for-each select="./occupation">
                                            <p>Occupation:
                                                <xsl:choose>
                                                    <xsl:when test="./desc[@type='reg']">
                                                        <xsl:apply-templates select="./desc[@type='reg']"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:apply-templates select="@role"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:copy-of select="tei:source(@source, @when)"/>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:if>
        
                                    <!-- Add Relations, if any -->
                                    <xsl:if test="(document('relationships.xml')//listRelation/relation[@* = $refID] | document('relationships.xml')//listRelation/relation[contains(@mutual, $refID)])">
                                        <h4>Relationships</h4>
                                        <xsl:for-each select="(document('relationships.xml')//listRelation/relation[@* = $refID] | document('relationships.xml')//listRelation/relation[contains(@mutual, $refID)])">
        
                                            <p>
                                                <xsl:variable name="pers1Ref">
                                                    <xsl:choose>
                                                        <xsl:when test="@mutual">
                                                            <xsl:value-of select="substring-before(./@mutual, ' ')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="@active"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
        
                                                <xsl:variable name="pers2Ref">
                                                    <xsl:choose>
                                                        <xsl:when test="@mutual">
                                                            <xsl:value-of select="substring-after(./@mutual, ' ')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="@passive"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
        
                                                <xsl:variable name="relType" select="@name"/>
        
                                                <xsl:choose>
                                                    <xsl:when test="$pers1Ref = $refID">
                                                        <xsl:value-of select="//category[@xml:id = substring($relType, 2)]/catDesc"/>
                                                        <xsl:text>: </xsl:text>
                                                        <a href="{$pers2Ref}">
                                                            <xsl:value-of select="tei:getName($pers2Ref, 'short')"/>
                                                        </a>
                                                    </xsl:when>
                                                    <xsl:when test="$pers2Ref = $refID">
                                                        <xsl:value-of select="//category[@corresp = $relType]/catDesc"/>
                                                        <xsl:text>: </xsl:text>
                                                        <a href="{$pers1Ref}">
                                                            <xsl:value-of select="tei:getName($pers1Ref, 'short')"/>
                                                        </a>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:if test="@source">
                                                    <xsl:variable name="source" select="substring(@source, 2)"/>
                                                    <xsl:variable name="doc" select="base-uri(collection('?select=taxroll_*.xml')[descendant::item[@xml:id = $source] | descendant::head[@xml:id = $source]])"/>
                                                    <xsl:variable name="date" select="document($doc)//date/@when"/>
                                                    <xsl:copy-of select="tei:source(@source, $date)"/>
                                                </xsl:if>
                                            </p>
        
                                        </xsl:for-each>
        
                                    </xsl:if>
        
                                    <!-- Add Transactions, if any -->
                                    <xsl:if test="document('transactions.xml')//event/desc/@corresp = $refID">
                                        <!--<h4>Transactions</h4>-->
                                        <details>
                                            <xsl:if test="count(document('transactions.xml')//event/desc[@corresp = $refID]) lt 5">
                                                <xsl:attribute name="open"/>
                                            </xsl:if>
                                            <summary>Transactions</summary>
        
                                            <xsl:for-each select="document('transactions.xml')//event/desc[@corresp = $refID]">
                                                <p>
                                                    <xsl:apply-templates select="./ancestor::event" mode="trans"/>
                                                </p>
                                            </xsl:for-each>
                                        </details>
                                    </xsl:if>
                                </div>
                            </xsl:for-each>

                </div></div></div>
            </body>
        </html>

    </xsl:template>

    <xsl:template match="occupation/desc/persName">
        <a href="{@ref}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!-- Get a Name -->
    <xsl:function name="tei:getName">
        <xsl:param name="name"/>
        <xsl:param name="nameType"/>
        <xsl:variable name="nameID" select="
                if (substring($name, 1, 1) = '#') then
                    document('pers2.xml')//person[@xml:id = substring($name, 2)]
                else
                    $name"/>
        <xsl:choose>
            <xsl:when test="$nameType = 'short'">
                <xsl:choose>
                    <xsl:when test="$nameID/persName[@type = 'short']">
                        <xsl:value-of select="normalize-space($nameID/persName[@type = 'short'][1]/@key)"/>
                    </xsl:when>
                    <xsl:when test="$nameID/persName[@type = 'reg']">
                        <xsl:value-of select="normalize-space($nameID/persName[@type = 'reg'][1]/@key)"/>
                    </xsl:when>
                    <!--Gets Anon/AnonGrp-->
                    <xsl:when test="$nameID/persName[@type]">
                        <xsl:value-of select="normalize-space($nameID/persName[@type][1]/@key)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="normalize-space($nameID/persName[1])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

    <!-- List the Names in a transaction -->
    <xsl:function name="tei:listNames">
        <xsl:param name="nameRef"/>
        <xsl:param name="pos"/>
        <xsl:param name="lastpos"/>
        <xsl:element name="a">
            <xsl:attribute name="href" select="$nameRef"/>
            <xsl:value-of select="tei:getName($nameRef, 'short')"/>
        </xsl:element>
        <xsl:if test="$pos &lt; $lastpos">
            <xsl:text> and </xsl:text>
        </xsl:if>
    </xsl:function>

    <!-- Transaction Template -->
    <xsl:template match="event" mode="trans">
        <xsl:text>From </xsl:text>
        <xsl:for-each select="./desc[@type = '#bk:from']">
            <xsl:variable name="currID" select="./@corresp"/>
            <xsl:copy-of select="tei:listNames($currID, position(), last())"/>
        </xsl:for-each>

        <xsl:text> to </xsl:text>

        <xsl:for-each select="./desc[@type = '#bk:to']">
            <xsl:variable name="currID" select="./@corresp"/>
            <xsl:copy-of select="tei:listNames($currID, position(), last())"/>
        </xsl:for-each>

        <xsl:text>, paid </xsl:text>
        <xsl:for-each select="./desc[@type = '#bk:money']/measure">
            <xsl:value-of select="./@quantity"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="./@unit"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:text>in </xsl:text>
        <xsl:variable name="date" select="./desc[@type = '#bk:when']"/>
        <xsl:value-of select="$date"/>
        <xsl:copy-of select="tei:source(@source, $date)"/>
    </xsl:template>

    <!-- Add a Source -->
    <xsl:function name="tei:source">
        <xsl:param name="source"/>
        <xsl:param name="date"/>
        <span class="source">
            <xsl:text> (</xsl:text>
            <a href="roll_{$date}.html{$source}">source</a>
            <xsl:text>)</xsl:text>
        </span>
    </xsl:function>
    
    <!--    <xsl:template match="nameLink[text()='l'] | nameLink[text()='L']">
        <xsl:variable name="lapos">l&#39;</xsl:variable>
        <xsl:value-of select="$lapos"/>


    </xsl:template>    -->


</xsl:stylesheet>
