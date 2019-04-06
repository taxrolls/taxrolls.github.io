<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="3.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" exclude-result-prefixes="#all" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"/>

    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="persName"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:variable name="docs" select="collection('?select=taxroll_*.xml')"/>
    <xsl:variable name="refs" select="$docs//persName | $docs//rs[@type='person']"/>


    <!-- Create TEI Body -->
    <xsl:template match="/">
        <xsl:variable name="docList" select="collection('?select=taxroll_*.xml')"/>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="personography">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Title</title>
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
                    <listPerson>
                        <xsl:for-each-group select="$refs" group-by="@ref">
                            <xsl:sort select="@ref"/>
                            <!--<xsl:sort select=".//forename" lang="fr-FR"/>-->
                            <xsl:variable name="persRef" select="@ref"/>
                            <xsl:variable name="auth" select="document('authority.xml')//person[@corresp = $persRef]"/>

                          <!--  <xsl:for-each-group select="$refs" >-->
                            <!--<xsl:if test="not(preceding::persName[@ref = $persRef] | preceding::rs[@ref = $persRef])">-->
                                <person xml:id="{substring(@ref,2)}">


                                    <!-- Names -->
                                    <xsl:copy-of select="$auth/persName"/>
                                    
                                    <xsl:for-each select="current-group()">
                                        <xsl:apply-templates select="."/>
                                    </xsl:for-each>


                                    <!-- Choose Sex -->
                                    <xsl:choose>
                                        <xsl:when test="$auth">
                                            <xsl:copy-of select="$auth/sex"/>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="current-group()/descendant::nameLink[(text() = 'le')] | current-group()/descendant::nameLink[(text() = 'Le')] | current-group()/roleName[(text() = 'Mestre' or text() = 'mestre')] | current-group()[@type='person'][starts-with(.,'Le ') or starts-with(.,'le ')] | current-group()[@type='person'][starts-with(.,'Son ') or starts-with(.,'son ')]">
                                                    <sex value="male"/>
                                                </xsl:when>
                                                <xsl:when test="current-group()/descendant::nameLink[(text() = 'la')] | current-group()/descendant::nameLink[(text() = 'La')] | current-group()/roleName[(text() = 'Dame' or text() = 'dame')] | current-group()[@type='person'][starts-with(.,'La ') or starts-with(.,'la ')] | current-group()[@type='person'][starts-with(.,'Sa ') or starts-with(.,'sa ')]">
                                                    <sex value="female"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>

                                    <!-- Birth and Death [authority.xml only atm]-->
                                    <xsl:if test="$auth/birth">
                                        <xsl:copy-of select="$auth/birth"/>
                                    </xsl:if>
                                    <xsl:if test="$auth/death">
                                        <xsl:copy-of select="$auth/death"/>
                                    </xsl:if>

                                    <!-- Record Office -->
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

                                    <!-- Record Occupation -->
                                    <xsl:if test="//roleName[@ref = $persRef]/@type = 'occupation'">
                                        <xsl:for-each select="//roleName[@ref = $persRef]">
                                            <occupation>
                                                <xsl:value-of select="./@role"/>
                                                <xsl:if test="document('relationships.xml')//relation[@active = $persRef] | document('relationships.xml')//relation[@passive = $persRef]">
                                                    <xsl:text> to </xsl:text>
                                                    <xsl:variable name="empl" select="document('relationships.xml')//relation[@active = $persRef]/@passive | document('relationships.xml')//relation[@passive = $persRef]/@active"/>
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
                                                
                                                
                                                <!--<xsl:if test=".[persName | rs[@type = 'person']]">
                                                    <xsl:text> to </xsl:text>
                                                    <xsl:variable name="empl" select="./persName/@ref | rs[@type = 'person']/@ref"/>
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
                                                </xsl:if>-->
                                            </occupation>
                                        </xsl:for-each>
                                    </xsl:if>
                                    

                                </person>
                                <xsl:text>&#xa;&#xa;</xsl:text>
                            <!--</xsl:if>-->
                        </xsl:for-each-group>
                    </listPerson>
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
            <xsl:if test=".[@subtype = 'anon_group']">
                <xsl:attribute name="type">anonymous_group</xsl:attribute>
                <xsl:attribute name="key">Unnamed Group (<xsl:value-of select="@ref"/>)</xsl:attribute>
            </xsl:if>            
            <xsl:apply-templates select="node()"/>
        </persName>
    </xsl:template>

    <!--  Remove all/particular attributes from certain elements  -->
    <xsl:template match="roleName/@*"/>
    <xsl:template match="persName/@ref"/>
    <xsl:template match="persName/@ana"/>
    
    <xsl:template match="rs"/>



</xsl:stylesheet>
