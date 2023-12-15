<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:key name="supervisorKey" match="ZESPOLY/ROW/PRACOWNICY/ROW" use="ID_PRAC"/>
    <xsl:template match="/">
        <html>
            <body>
                <h1>Zespoly:</h1>
                <ol> <!-- Ordered list element -->
                    <!--                    <xsl:for-each select="ZESPOLY/ROW/NAZWA">-->
                    <!--                        <li> &lt;!&ndash; List item element &ndash;&gt;-->
                    <!--                            <xsl:value-of select="." />-->
                    <!--                        </li>-->
                    <!--                    </xsl:for-each>-->

                    <xsl:apply-templates select="ZESPOLY/ROW" mode="lista"/>
                </ol>
                <xsl:apply-templates select="ZESPOLY/ROW" mode="description"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="*" mode = "lista">
        <li>
            <a href='#{NAZWA}'><xsl:value-of select="NAZWA"/></a>
        </li>
    </xsl:template>
    <xsl:template match="*" mode = "description">

        <h3 id="{NAZWA}" >
            NAZWA: <xsl:value-of select="NAZWA"/> <br/>
            ADRES: <xsl:value-of select="ADRES"/>
        </h3>
        <body>

            <xsl:choose>
                <!-- If supervisor ID is not empty and a match is found, display the name -->
                <xsl:when test="count(PRACOWNICY/ROW) > 0">
                    <table border="1">
                        <tr>
                            <th>Nazwisko</th>
                            <th>Etat</th>
                            <th>Zatrudniony</th>
                            <th>Placa pod</th>
                            <th>Id szefa</th>
                        </tr>
                        <xsl:apply-templates
                                mode = "pracownicy" select="PRACOWNICY/ROW">
                            <xsl:sort select="NAZWISKO"/>
                        </xsl:apply-templates>
                    </table>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
            </xsl:choose>
            <p>Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/></p>

        </body>

    </xsl:template>
    <xsl:template match="*" mode="pracownicy">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:choose>
                    <!-- If supervisor ID is not empty and a match is found, display the name -->
                    <xsl:when test="ID_SZEFA != '' and key('supervisorKey', ID_SZEFA)">
                        <xsl:value-of select="key('supervisorKey', ID_SZEFA)/NAZWISKO"/>
                    </xsl:when>
                    <!-- Otherwise, display 'brak' -->
                    <xsl:otherwise>
                        brak
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>