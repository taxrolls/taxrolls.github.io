<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compact"/>

    <xsl:variable name="doc" select="document('./pers2.xml')"/>
    <xsl:variable name="refs" select="$doc//person"/>
    <xsl:key name="persID" match="persName" use="@ref"/>

    <xsl:template match="/">

        
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
                <link rel="stylesheet" type="text/css" href="../enc.css"/>
            </head>

            <body>
                <!-- Header Links -->
                <xsl:copy-of select="document('./html/header.html')"/>

                <!-- Person Index -->
                <div class="container">
                    <h2>People</h2>
                    <p>Unique Entries: <xsl:value-of select="count(distinct-values($refs/@xml:id))"/></p>
                    <ul class="name_index">
                        <xsl:for-each select="$refs">
                            <xsl:sort select="@xml:id"/>
                            <li>
                                <xsl:value-of select="concat('#',@xml:id)"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="normalize-space(persName[1])"/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>


                <!-- Occupation Index -->
<!--                <div class="container">
                    <h2>Occupations</h2>
                    <ul>
                        <xsl:for-each-group select="$doc//roleName[@type = 'occupation']" group-by="@role">
                            <xsl:sort select="./@role" lang="fr-FR"/>
                            <li class="occ">
                                <xsl:variable name="count" select="count(current-group())"/>

                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:if test="count(current-group()) &gt; 1"> (<xsl:value-of select="count(current-group())"/>) </xsl:if>
                                <ul>
                                    <xsl:for-each-group select="current-group()" group-by="normalize-space(.)" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes">
                                        <xsl:sort select="count(current-group())" order="descending"/>
                                        <xsl:sort select="." collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes"/>
                                        <li class="occ_variant">
                                            <xsl:value-of select="current-grouping-key()"/>
                                            <xsl:if test="count(current-group()) != $count and count(current-group()) != 1"> (<xsl:value-of select="count(current-group())"/>) </xsl:if>
                                            <ul>
                                                <xsl:for-each select="current-group()">
                                                    <xsl:sort select="key('persID', @ref)[1]" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes"/>
                                                    <!-\-<xsl:variable name="persRef" select="@ref"/>-\->
                                                    <li>
                                                        <xsl:value-of select="key('persID', @ref)"/>
                                                    </li>
                                                </xsl:for-each>



                                            </ul>

                                        </li>
                                    </xsl:for-each-group>
                                </ul>
                            </li>
                        </xsl:for-each-group>
                    </ul>
                </div>
-->

                <!-- Names Index -->
                <div class="container">
                    <h2>Names</h2>
                    <h3>Given Names</h3>
                    <xsl:variable name="entries" select="$refs/persName[not(@type='reg')][forename]/lower-case(forename)"/>
                    <p>Unique Entries: <xsl:value-of select="count(distinct-values($entries))"/></p>
                    <ul>
                        <xsl:for-each-group select="$refs" group-by="./persName[not(@type='reg')]/forename" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes">
                            <xsl:sort select="./persName[1]/forename[1]" lang="fr-FR"/>
                            <li>
                                <xsl:variable name="count" select="count(current-group())"/>
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:if test="$count &gt; 1"> (<xsl:value-of select="$count"/>)</xsl:if>
                            </li>
                        </xsl:for-each-group>
                    </ul>
<!--                    <h3>Toponyms</h3>
                    <ul>
                        <xsl:for-each-group select="$refs" group-by="descendant::placeName" collation="http://saxon.sf.net/collation?ignore-case=yes">
                            <xsl:sort select="descendant::placeName" lang="fr-FR"/>
                            <li>
                                <xsl:variable name="count" select="count(current-group())"/>
                                <xsl:value-of select="descendant::placeName"/>
                                <xsl:if test="descendant::nameLink"> (<xsl:value-of select="descendant::nameLink"/>)</xsl:if>
                                <xsl:if test="count(current-group()) &gt; 1"> (<xsl:value-of select="count(current-group())"/>) </xsl:if>
                            </li>
                        </xsl:for-each-group>
                    </ul>-->
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
