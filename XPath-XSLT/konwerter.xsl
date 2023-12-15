<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <PRACOWNICY>
            <xsl:apply-templates select="//PRACOWNICY/ROW">
                <xsl:sort select="ID_PRAC" data-type="number"/>
            </xsl:apply-templates>
        </PRACOWNICY>
    </xsl:template>

    <xsl:template match="PRACOWNICY/ROW">
        <PRACOWNIK ID_PRAC="{ID_PRAC}" ID_ZESP="{ID_ZESP}" ID_SZEFA="{ID_SZEFA}">
            <xsl:copy-of select="NAZWISKO"/>
            <xsl:copy-of select="ETAT"/>
            <xsl:copy-of select="ZATRUDNIONY"/>
            <xsl:copy-of select="PLACA_POD"/>
            <xsl:copy-of select="PLACA_DOD"/>
        </PRACOWNIK>
    </xsl:template>

</xsl:stylesheet>
