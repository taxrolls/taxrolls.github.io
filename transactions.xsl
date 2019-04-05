<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="3.0">


    <xsl:output method="xml" encoding="UTF-8" indent="yes" exclude-result-prefixes="#all" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"/>

    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="persName"/>

    <xsl:mode on-no-match="shallow-copy"/>


    <!-- Create TEI Body -->
    <xsl:template match="/">
        <xsl:variable name="docList" select="collection('?select=taxroll_*.xml')"/>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="transactionography">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Transactions</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Born digital</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <listEvent>
                        <xsl:for-each select="$docList//item[@ana = '#bk:entry']">
                            <event type="#bk:entry">
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="concat('trans_',generate-id())"/>
                                </xsl:attribute>
                                <xsl:attribute name="source">
                                    <xsl:value-of select="concat('#', @xml:id)"/>
                                </xsl:attribute>
                                
                                <!-- When -->
                                <label>When</label>
                                <desc>
                                    <xsl:attribute name="type">
                                        <xsl:text>#bk:when</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="//.[@ana = '#bk:when'][1]/@when"/>
                                </desc>

                                <!-- From -->
                                <label>From</label>
                                <xsl:for-each select="./seg/(persName | rs)[@ana = '#bk:from']">
                                    <desc>
                                        <xsl:attribute name="type">
                                            <xsl:text>#bk:from</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="corresp">
                                            <xsl:value-of select="./@ref"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </desc>
                                </xsl:for-each>

                                <!-- To -->
                                <!-- Tries descendants first, then looks for any. Copy to from? -->
                                <label>To</label>
                                <xsl:for-each select="./seg/(persName | rs)[@ana = '#bk:to']">
                                    <desc>
                                        <xsl:attribute name="type">
                                            <xsl:text>#bk:to</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="corresp">
                                            <xsl:value-of select="./@ref"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </desc>
                                </xsl:for-each>
                                <xsl:for-each select="//./(persName | rs)[@ana = '#bk:to']">
                                    <desc>
                                        <xsl:attribute name="type">
                                            <xsl:text>#bk:to</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="corresp">
                                            <xsl:value-of select="./@ref"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </desc>
                                </xsl:for-each>

                                <!-- Amount -->
                                <label>Amount</label>
                                <xsl:for-each select="./seg[@type='payment']//measure">
                                    <desc>
                                        <xsl:attribute name="type">
                                            <xsl:text>#bk:money</xsl:text>
                                        </xsl:attribute>
                                        <measure>
                                            <xsl:attribute name="commodity">
                                                <xsl:value-of select="./@commodity"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="./@quantity"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="unit">
                                                <xsl:value-of select="./@unit"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </measure>
                                    </desc>
                                </xsl:for-each>


                            </event>
                            <xsl:text>&#xa;&#xa;</xsl:text>

                        </xsl:for-each>
                    </listEvent>



                    <!--
                    <listPerson>
                        <xsl:for-each select=".//persName | .//rs[@type = 'person']">
                            <xsl:sort select="@ref"/>
                            <!-\-<xsl:sort select=".//forename" lang="fr-FR"/>-\->
                            <xsl:variable name="persRef" select="@ref"/>
                            <xsl:variable name="auth" select="document('authority.xml')//person[@corresp = $persRef]"/>


                            <xsl:if test="not(preceding::persName[@ref = $persRef] | preceding::rs[@ref = $persRef])">
                                <person xml:id="{substring(@ref,2)}">


                                    <!-\- Names -\->
                                    <xsl:copy-of select="$auth/persName"/>

                                    <xsl:for-each select="//persName[@ref = $persRef] | //rs[@ref = $persRef]">
                                        <xsl:apply-templates select="."/>
                                    </xsl:for-each>


                                    <!-\- Choose Sex -\->
                                    <xsl:choose>
                                        <xsl:when test="$auth">
                                            <xsl:copy-of select="$auth/sex"/>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="descendant::nameLink[(text() = 'le')] | descendant::nameLink[(text() = 'Le')] | roleName[(text() = 'Mestre' or text() = 'mestre')]">
                                                    <sex value="male"/>
                                                </xsl:when>
                                                <xsl:when test="descendant::nameLink[(text() = 'la')] | descendant::nameLink[(text() = 'La')] | roleName[(text() = 'Dame' or text() = 'dame')]">
                                                    <sex value="female"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>

                                    <!-\- Birth and Death [authority.xml only atm]-\->
                                    <xsl:if test="$auth/birth">
                                        <xsl:copy-of select="$auth/birth"/>
                                    </xsl:if>
                                    <xsl:if test="$auth/death">
                                        <xsl:copy-of select="$auth/death"/>
                                    </xsl:if>

                                    <!-\- Record Office -\->
                                    <xsl:choose>
                                        <xsl:when test="$auth/state[@type = 'office']">
                                            <xsl:copy-of select="$auth/state[@type = 'office']"/>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:for-each select="//roleName[@ref = $persRef]">
                                                <xsl:if test="//roleName[@ref = $persRef]/@type = 'office'">
                                                    <state type="office">
                                                        <label type="style">
                                                            <xsl:value-of select="current()/@role"/>
                                                            <xsl:if test="descendant::placeName">
                                                                <xsl:text> of </xsl:text>
                                                                <xsl:value-of select="descendant::placeName"/>
                                                            </xsl:if>
                                                        </label>
                                                    </state>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>

                                    <!-\- Record Occupation -\->
                                    <xsl:if test="//roleName[@ref = $persRef]/@type = 'occupation'">
                                        <xsl:for-each select="//roleName[@ref = $persRef]">
                                            <occupation>
                                                <xsl:value-of select="./@role"/>
                                                <xsl:if test=".[persName | rs[@type = 'person']]">
                                                    <xsl:text> to </xsl:text>
                                                    <xsl:variable select="./persName/@ref | rs[@type = 'person']/@ref" name="empl"/>
                                                    <xsl:element name="persName">
                                                        <xsl:attribute name="ref">
                                                            <xsl:value-of select="$empl"/>
                                                        </xsl:attribute>
                                                        <xsl:choose>
                                                            <xsl:when test="document('authority.xml')//person[@corresp = $empl]">
                                                                <xsl:value-of select="document('authority.xml')//person[@corresp = $empl]/persName/@key"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="//persName[@ref = $empl] | //rs[@ref = $empl]"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:element>
                                                </xsl:if>
                                            </occupation>
                                        </xsl:for-each>
                                    </xsl:if>

                                    <!-\- Record Transactions -\->

                                </person>
                                <xsl:text>&#xa;&#xa;</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </listPerson>-->
                </body>
            </text>
        </TEI>
    </xsl:template>


    <!-- Suppress various tags -->
    <xsl:template match="ptr"/>
    <xsl:template match="persName/text()"/>
    <xsl:template match="lb"/>
    <xsl:template match="del"/>
    <xsl:template match="ex | unclear | seg">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!-- Create <persName> for <rs> strings -->
    <!-- <xsl:template match="rs[descendant::roleName | descendant::persName]"> -->
    <xsl:template match="rs[@type = 'person']">
        <persName>
            <!-- AnonNameKey -->
            <xsl:if test=".[@subtype = 'anon_sing']">
                <xsl:attribute name="type">anonymous</xsl:attribute>
                <xsl:attribute name="key">Unnamed Person (<xsl:value-of select="@ref"/>)</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </persName>
    </xsl:template>

    <!--  Remove all/particular attributes from certain elements  -->
    <xsl:template match="roleName/@*"/>
    <xsl:template match="persName/@ref"/>
    <xsl:template match="rs"/>





</xsl:stylesheet>
