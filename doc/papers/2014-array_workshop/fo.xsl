<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="/home/arcfide/Libraries/Docbook5-XSL/fo/docbook.xsl"/>
  <xsl:import href="./titlepage.xsl" />
  <xsl:param name="body.font.master" select="9" />
  <xsl:param name="body.font.family" select="'FreeSerif'" />
  <xsl:param name="title.font.family" select="'FreeSerif'" />
  <xsl:param name="monospace.font.family" select="'APL385 Unicode,DejaVu Sans'" />
  <xsl:param name="symbol.font.family" select="''" />
  <xsl:param name="generate.toc" select="'article nop'" />
  <xsl:param name="fop1.extensions" select="1" />
  <xsl:param name="column.count.body" select="2"/>
  <xsl:param name="column.gap.body" select="'2pc'"/>
  <xsl:param name="body.start.indent" select="'0pt'"/>
  <xsl:param name="section.autolabel" select="1" />
  <xsl:param name="appendix.autolabel" select="'A'" />
  <xsl:param name="header.rule" select="0" />
  <xsl:param name="footer.rule" select="0" />
  <xsl:param name="page.margin.inner" select="'0.75in'" />
  <xsl:param name="page.margin.outer" select="'0.75in'" />
  <xsl:param name="email.delimiters.enabled" select="0" />
  <xsl:param name="bibliography.numbered" select="1" />
  
  <xsl:template name="footer.content">
    <fo:block></fo:block>
  </xsl:template>

  <xsl:attribute-set name="component.titlepage.properties">
    <xsl:attribute name="span">all</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="abstract.title.properties">
    <xsl:attribute name="text-align">start</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">1.37in</xsl:attribute>
    <xsl:attribute name="space-before.minimum">1.37in</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.37in</xsl:attribute>
    <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="formal.title.properties"
                     use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-indent">0em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">9pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">7pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">10pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">0.3em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.5em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="d:info">
    <xsl:apply-templates select="d:abstract" mode="titlepage.mode"/>
    <xsl:apply-templates select="d:keywordset" mode="titlepage.mode"/>
    <xsl:apply-templates select="d:subjectset" mode="titlepage.mode"/>
    <xsl:apply-templates select="d:legalnotice" mode="titlepage.mode" />
  </xsl:template>

  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    <fo:block></fo:block>
  </xsl:template>
  
  <xsl:attribute-set name="biblioentry.properties">
    <xsl:attribute name="text-indent">0em</xsl:attribute>
    <xsl:attribute name="start-indent">0em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="text-indent">1.5em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">3pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="formal.para.spacing"
                     use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="text-indent">0em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">5pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">3pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">7pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="legalnotice.para.spacing"
                     use-attribute-sets="formal.para.spacing">
    <xsl:attribute name="font-size">7pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="pgwide.properties">
    <xsl:attribute name="span">all</xsl:attribute>
    <xsl:attribute name="padding-top">12pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="formal.title.placement">
    figure after
  </xsl:param>


  <xsl:template match="d:formalpara">  
    <xsl:variable name="keep.together">
      <xsl:call-template name="pi.dbfo_keep-together"/>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="formal.para.spacing">
      <xsl:if test="$keep.together != ''">
        <xsl:attribute name="keep-together.within-column">
          <xsl:value-of select="$keep.together"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>  
  </xsl:template>
                                                        

  <xsl:template match="d:author" mode="titlepage.mode">
    <fo:table-cell>
      <xsl:choose>
        <xsl:when test="d:orgname">
          <fo:block>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block font-size="12pt" space-after="3pt">
            <xsl:call-template name="person.name"/>
          </fo:block>
          <xsl:if test="d:affiliation/d:orgname">
            <fo:block>
              <xsl:apply-templates select="d:affiliation/d:orgname" mode="titlepage.mode"/>
            </fo:block>
          </xsl:if>
          <xsl:if test="d:email|d:affiliation/d:address/d:email">
            <fo:block space-before="2pt">
              <xsl:apply-templates select="(d:email|d:affiliation/d:address/d:email)[1]"/>
            </fo:block>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-cell>
  </xsl:template>

  <xsl:template match="d:authorgroup" mode="titlepage.mode">
    <fo:table table-layout="fixed" width="100%" space-before="2em"
              space-after="4em" space-after.conditionality="retain">
      <fo:table-body>
        <fo:table-row>
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates mode="titlepage.mode"/>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template match="d:section/*[not(self::d:title or
                       self::d:subtitle or
                       self::d:titleabbrev or
                       self::d:info or
                       self::d:indexterm or
                       self::d:remark or
                       self::d:annotation)][1][(self::d:para or self::d:simpara)]">

    <xsl:variable name="keep.together">
      <xsl:call-template name="pi.dbfo_keep-together"/>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="para.properties" text-indent="0pt">
      <xsl:if test="$keep.together != ''">
        <xsl:attribute name="keep-together.within-column"><xsl:value-of
        select="$keep.together"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="d:abstract/*[not(self::d:title or
                       self::d:subtitle or
                       self::d:titleabbrev or
                       self::d:info or
                       self::d:indexterm or
                       self::d:remark or
                       self::d:annotation)][1][(self::d:para or self::d:simpara)]">

    <xsl:variable name="keep.together">
      <xsl:call-template name="pi.dbfo_keep-together"/>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="para.properties" text-indent="0pt">
      <xsl:if test="$keep.together != ''">
        <xsl:attribute name="keep-together.within-column"><xsl:value-of
        select="$keep.together"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="d:legalnotice" mode="titlepage.mode">
    <fo:block-container absolute-position="absolute" bottom="0.35in" left="0pt" 
                        height="1.37in">
      <xsl:apply-templates />
    </fo:block-container>
  </xsl:template>
  
  <xsl:template match="d:legalnotice/*[(self::d:para or self::d:simpara)]">
    <fo:block text-indent="0pt" font-size="7pt" space-after="0pt">
      <xsl:apply-templates />
    </fo:block>  
  </xsl:template>

  <xsl:template match="d:bibliography">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not(parent::*) or parent::d:part or parent::d:book">
        <xsl:variable name="master-reference">
          <xsl:call-template name="select.pagemaster"/>
        </xsl:variable>

        <fo:page-sequence hyphenate="{$hyphenate}"
                          master-reference="{$master-reference}">
          <xsl:attribute name="language">
            <xsl:call-template name="l10n.language"/>
          </xsl:attribute>
          <xsl:attribute name="format">
            <xsl:call-template name="page.number.format">
              <xsl:with-param name="master-reference" select="$master-reference"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="initial-page-number">
            <xsl:call-template name="initial.page.number">
              <xsl:with-param name="master-reference" select="$master-reference"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="force-page-count">
            <xsl:call-template name="force.page.count">
              <xsl:with-param name="master-reference" select="$master-reference"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="hyphenation-character">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'hyphenation-character'"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="hyphenation-push-character-count">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="hyphenation-remain-character-count">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
            </xsl:call-template>
          </xsl:attribute>

          <xsl:apply-templates select="." mode="running.head.mode">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="running.foot.mode">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:apply-templates>

          <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="set.flow.properties">
              <xsl:with-param name="element" select="local-name(.)"/>
              <xsl:with-param name="master-reference" select="$master-reference"/>
            </xsl:call-template>

            <fo:block id="{$id}">
              <xsl:call-template name="bibliography.titlepage"/>
            </fo:block>
            <fo:list-block provisional-label-separation="0.1in"
                           provisional-distance-between-starts="0.27in">
              <xsl:apply-templates/>
            </fo:list-block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:when>
      <xsl:otherwise>
        <fo:block id="{$id}"
                  space-before.minimum="1em"
                  space-before.optimum="1.5em"
                  space-before.maximum="2em"> 
          <xsl:call-template name="bibliography.titlepage"/>
        </fo:block>
        <fo:list-block provisional-label-separation="0.1in"
                       provisional-distance-between-starts="0.27in">
          <xsl:apply-templates/>
        </fo:list-block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:appendix/*[not(self::d:title or
                       self::d:subtitle or
                       self::d:titleabbrev or
                       self::d:info or
                       self::d:indexterm or
                       self::d:remark or
                       self::d:annotation)][1][(self::d:para or self::d:simpara)]">

    <xsl:variable name="keep.together">
      <xsl:call-template name="pi.dbfo_keep-together"/>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="para.properties" text-indent="0pt">
      <xsl:if test="$keep.together != ''">
        <xsl:attribute name="keep-together.within-column"><xsl:value-of
        select="$keep.together"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="d:bibliomixed">
    <xsl:param name="label">
      <xsl:call-template name="biblioentry.label"/>
    </xsl:param>

    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string(.) = ''">
        <xsl:variable name="bib" select="document($bibliography.collection,.)"/>
        <xsl:variable name="entry" select="$bib/d:bibliography//
                                           *[@id=$id or @xml:id=$id][1]"/>
        <xsl:choose>
          <xsl:when test="$entry">
            <xsl:choose>
              <xsl:when test="$bibliography.numbered != 0">
                <xsl:apply-templates select="$entry">
                  <xsl:with-param name="label" select="$label"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="$entry"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>No bibliography entry: </xsl:text>
              <xsl:value-of select="$id"/>
              <xsl:text> found in </xsl:text>
              <xsl:value-of select="$bibliography.collection"/>
            </xsl:message>
            <fo:block id="{$id}" xsl:use-attribute-sets="normal.para.spacing">
              <xsl:text>Error: no bibliography entry: </xsl:text>
              <xsl:value-of select="$id"/>
              <xsl:text> found in </xsl:text>
              <xsl:value-of select="$bibliography.collection"/>
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <fo:list-item id="{$id}" >
          <fo:list-item-label end-indent="label-end()">
            <xsl:copy-of select="$label"/>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block>
              <xsl:apply-templates mode="bibliomixed.mode"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="biblioentry.label">
    <xsl:param name="node" select="."/>

    <xsl:choose> 
      <xsl:when test="$bibliography.numbered != 0">
        <fo:block>
          <xsl:text>[</xsl:text>
          <xsl:number from="d:bibliography" count="d:biblioentry|d:bibliomixed"
                      level="any" format="1"/>
          <xsl:text>] </xsl:text>
        </fo:block>
      </xsl:when>
      <xsl:when test="local-name($node/child::*[1]) = 'abbrev'">
        <fo:block>
          <xsl:text>[</xsl:text>
          <xsl:apply-templates select="$node/d:abbrev[1]"/>
          <xsl:text>] </xsl:text>
        </fo:block>
      </xsl:when>
      <xsl:when test="$node/@xreflabel">
        <fo:block>
          <xsl:text>[</xsl:text>
          <xsl:value-of select="$node/@xreflabel"/>
          <xsl:text>] </xsl:text>
        </fo:block>
      </xsl:when>   
      <xsl:when test="$node/@id or $node/@xml:id">
        <fo:block>
          <xsl:text>[</xsl:text>
          <xsl:value-of select="($node/@id|$node/@xml:id)[1]"/>
          <xsl:text>] </xsl:text>
        </fo:block>
      </xsl:when>
      <xsl:otherwise><!-- nop --></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
