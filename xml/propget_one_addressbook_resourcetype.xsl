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
        <xs:sequence>
          <xs:element ref="D:resourcetype"/>
        </xs:sequence>
      </xs:complexType>
    </xs:element>
  </xsl:template>

  <xsl:template match="xs:element[@name='resourcetype']">
    <xs:element name="resourcetype">
      <xs:complexType>
        <xs:all minOccurs="1" maxOccurs="1">
          <xs:element ref="C:addressbook"/>
          <xs:element ref="D:collection"/>
        </xs:all>
      </xs:complexType>
    </xs:element>
  </xsl:template>

</xsl:stylesheet>