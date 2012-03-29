<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="node()|@*">
      <xsl:copy>
              <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
  </xsl:template>

  <xsl:template match="xs:element[@name='prop']">
    <xs:element name="prop">
      <xs:complexType>
        <xs:sequence minOccurs="1">
          <xs:element ref="C:supported-address-data" />
        </xs:sequence>
      </xs:complexType>
    </xs:element>

  </xsl:template>

</xsl:stylesheet>