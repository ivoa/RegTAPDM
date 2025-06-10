<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rt="http://www.ivoa.net/xml/RegTAP/v1.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"    
   xmlns:ri="http://www.ivoa.net/xml/RegistryInterface/v1.0" xmlns:vr="http://www.ivoa.net/xml/VOResource/v1.0"
   xmlns:vs="http://www.ivoa.net/xml/VODataService/v1.1"
   xmlns:sia="http://www.ivoa.net/xml/SIA/v1.1" xmlns:stc="http://www.ivoa.net/xml/STC/stc-v1.30.xsd"
   xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
   xmlns="http://www.ivoa.net/xml/RegTAP/v1.0"
   xmlns:l="http://local" xmlns:xsd="http://www.w3.org/2001/XMLSchema"

>
   <!-- change so that namespace not so important -->
   <xsl:output exclude-result-prefixes="#all" indent="yes"
      method="xml"
   >
   </xsl:output>
   <xsl:template match="/">
      <xsl:element name="RegTAPModel"
         namespace="http://www.ivoa.net/xml/RegTAP/v1.0"
      >
         <xsl:apply-templates select="/*/ri:Resource" />
      </xsl:element>
   </xsl:template>
   <xsl:template match="ri:Resource">
      <xsl:element name="resource">
         <ivoid><xsl:value-of select="identifier" /></ivoid>
         <xsl:apply-templates select=".//ri:Capability"/>
         <res_type>
            <xsl:value-of select="@xsi:type" />
         </res_type>
         <created>
            <xsl:value-of select="@created" />
         </created>
          <short_name>
              <xsl:value-of select="shortName" />
          </short_name>
          <res_title>
              <xsl:value-of select="title"/>
          </res_title>
          <updated>
              <xsl:value-of select="@updated" />
          </updated>
          <content_level>
              <xsl:value-of select="content/contentLevel" separator="#"/>
          </content_level>
         <res_description>
            <xsl:value-of select="content/description"/>
         </res_description>
         <reference_url>
            <xsl:value-of select="content/referenceURL"/>
         </reference_url>
         <creator_seq>
           <xsl:value-of select="curation/creator/name"/>
         </creator_seq>
         <content_type>
           <xsl:value-of select="content/type" separator="#"/>
         </content_type>
         <source_format>
           <xsl:value-of select="content/source/@format"/>
         </source_format>
         <source_value>
           <xsl:value-of select="content/source"/>
         </source_value>
         <res_version>
            <xsl:value-of select="curation/version"/>
         </res_version>
          <xsl:apply-templates select="coverage/regionOfRegard"/>
         <waveband>
             <xsl:value-of select="coverage/waveband" separator="#"/>
         </waveband>
         <rights>
            <xsl:value-of select="rights"/>
         </rights>
         <rights_uri>
            <xsl:value-of select="rights/@rightsURI"/>
         </rights_uri>
          <xsl:apply-templates select=".//validationLevel"/>
          <xsl:apply-templates select="altIdentifier" />
          <xsl:apply-templates select="curation/(contact|publisher|creator|contibutor)"/>
          <xsl:apply-templates select="content/subject"/>
          <xsl:apply-templates select="curation/date"/>
          <xsl:apply-templates select="content/relationship"/>

<!--         FIXME do the STC stuff-->

          <xsl:apply-templates select="capability"/>
          <xsl:apply-templates select="capability/interface"/>
          <xsl:apply-templates select="capability/interface/param"/>

          <xsl:apply-templates select="tableset/schema"/>
          <xsl:apply-templates select="tableset/schema/table"/>
          <xsl:apply-templates select="tableset/schema/table/column"/>

          <!-- FIXME - need to add tapTables - not sure how to define this yet. -->
         
          <xsl:call-template name="details"/>

      </xsl:element>
   </xsl:template>

   <xsl:template match="date"><!-- FIXME still need to think about the exact date formatting -->
   <date>
       <xsl:attribute name="value_role" select="@role"/>
      <date_value>
        <xsl:choose>
          <xsl:when test="string-length(.) lt 12">
          <xsl:value-of select="concat(.,'T00:00:00')"/>
          </xsl:when>
          <xsl:otherwise>
          <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </date_value>
   </date>
   </xsl:template>
   <xsl:template match="altIdentifier">
       <altId>
          <xsl:attribute name="alt_identifier" select ="."/>
       </altId>
   </xsl:template>
   <xsl:template match="regionOfRegard">
   <region_of_regard>
     <xsl:value-of select="."/>
   </region_of_regard>
   </xsl:template>
   
   <xsl:template match="relationship">
     <xsl:for-each select="relatedResource">
       <relationship>
         <relationship_type><!-- FIXME need to map these to new vocab -->
           <xsl:value-of select="../relationshipType"/>
         </relationship_type>
         <related_id><xsl:value-of select="../relatedResource/@ivo-id"/></related_id>
         <related_name><xsl:value-of select="../relatedResource"/></related_name>
       </relationship>
     </xsl:for-each>
   </xsl:template>
   
   
   
    <xsl:template match="curation/contact|curation/creator">
    <role>
       <xsl:attribute name="role_ivoid" select="name/@ivo-id"/>
       <xsl:attribute name="base_role" select ="local-name()"/>
       <role_name>
         <xsl:value-of select="name"/>
       </role_name>
       <xsl:apply-templates select="node() except name"/>
    </role>
    </xsl:template>
    <xsl:template match="address">
        <street_address><xsl:value-of select="text()"/></street_address>
    </xsl:template>
    <xsl:template match="curation/publisher|curation/contributor">
     <role>
             <xsl:attribute name="role_ivoid" select="@ivo-id"/>
             <xsl:attribute name="base_role" select ="local-name()"/>
       <role_name>
         <xsl:value-of select="."/>
       </role_name>
    </role>
<!--    FIXME need to add address, email logo?-->
    </xsl:template>
    
     <xsl:template match="subject">
       <subject>
           <xsl:element name="res_subject">
               <xsl:value-of select="."/>
           </xsl:element>
       </subject>
     </xsl:template>
    
    <xsl:template match="capability">
    <capability>

     <xsl:call-template name="capidx"/>
     <cap_type><xsl:value-of select="@xsi:type"/></cap_type>
     <cap_description><xsl:value-of select="description"/></cap_description>
     <standard_id><xsl:value-of select="@standardID"/></standard_id>
     </capability>
    </xsl:template>
    
   <xsl:template match="interface">
      <interface>
          <xsl:element name="cap_index"><xsl:value-of select="count(parent::capability/preceding-sibling::capability)+1"/></xsl:element>
          <xsl:element name="intf_index"><xsl:value-of select="count(preceding::interface[ancestor::ri:Resource/identifier=current()/ancestor::ri:Resource/identifier])+1"/></xsl:element>
         <intf_type><xsl:value-of select="lower-case(@xsi:type)"/></intf_type>
         <intf_role><xsl:value-of select="lower-case(@role)"/></intf_role>
         <std_version><xsl:value-of select="@version"/></std_version>
         <query_type><xsl:value-of select="queryType" separator="#"/></query_type>
         <result_type><xsl:value-of select="lower-case(resultType)"/></result_type>
         <xsl:apply-templates select="wsdlURL" />
         <url_use><xsl:value-of select="accessURL[1]/@use"/></url_use>
         <access_url><xsl:value-of select="accessURL[1]"/></access_url>
         <mirror_url><xsl:value-of select="accessURL[position()!= 1]|mirrorURL" separator="#"/></mirror_url>
         <authenticated_only>
            <xsl:choose>
              <xsl:when test="securityMethod">1</xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
         </authenticated_only>
      </interface>
   </xsl:template>
    <xsl:template match="param">
      <param>
          <xsl:element name="intf_index"><xsl:value-of select="count(preceding::interface[ancestor::ri:Resource/identifier=current()/ancestor::ri:Resource/identifier])+1"/></xsl:element>
          <xsl:element name="name"><xsl:value-of select="name"/></xsl:element>
          <xsl:apply-templates select="(unit,ucd,utype)" />
          <xsl:apply-templates select="@std" />
          <xsl:apply-templates select="dataType"/>
          <xsl:apply-templates select="@use"/>
          <param_description><xsl:value-of select="description"/></param_description>
      </param>
    </xsl:template>
    
    <xsl:template match="@std">
      <std>
        <xsl:choose>
         <xsl:when test=".=true()">1</xsl:when>
         <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </std>
    </xsl:template>
    <xsl:template match="@use">
        <param_use><xsl:value-of select="."/></param_use>
    </xsl:template>
   
   <xsl:template match="validationLevel">
      <validation>
          <validated_by><xsl:value-of select="@validatedBy"/></validated_by>
          <val_level><xsl:value-of select="xsd:integer(.)"/></val_level>
          <xsl:choose>
              <xsl:when test="ancestor-or-self::capability">
                  <cap_index><xsl:value-of select="count(parent::capability/preceding-sibling::capability)+1"/></cap_index>
              </xsl:when>
              <xsl:otherwise>
<!--         don't do this as the generated java does not allow (just leave out)        <xsl:element name="cap_index"><xsl:attribute name="nil" namespace="http://www.w3.org/2001/XMLSchema-instance">true</xsl:attribute></xsl:element>-->
              </xsl:otherwise>
          </xsl:choose>
      </validation>
   </xsl:template>
   
   <!-- simple name substitutions -->
   <xsl:template match="identifier">
      <xsl:element name="ivorn">
         <xsl:value-of select="." />
      </xsl:element>
   </xsl:template>
   <xsl:template match="shortName">
      <short_name>
         <xsl:value-of select="." />
      </short_name>
   </xsl:template>
   
    
   <xsl:template match="schema">
     <schema>
         <xsl:element name="schema_index" ><xsl:value-of select="count(preceding-sibling::schema)+1" /></xsl:element>
         <xsl:apply-templates select="(description,name,title,type)" mode="schema"/>
    </schema>  
   </xsl:template>
    <xsl:template match="schema/*" mode="schema">
        <xsl:element name="{concat('schema_',name(.))}" namespace="http://www.ivoa.net/xml/RegTAP/v1.0">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="table">
    <table>
        <schema_index><xsl:value-of select="count(../preceding-sibling::schema)+1"/></schema_index>
        <xsl:apply-templates select="(description,name)" mode="table"/>
        <table_index><xsl:value-of select="count(preceding::table[ancestor::ri:Resource/identifier=current()/ancestor::ri:Resource/identifier])+1"/></table_index>
        <xsl:apply-templates select="(title,@type,utype,nrows)" mode="table"/>

    </table>
    </xsl:template>
    <xsl:template match="table/nrows" mode="table">
        <nrows><xsl:value-of select="."/></nrows>
    </xsl:template>
    <xsl:template match="table/*|table/@*" mode="table">
        <xsl:element name="{concat('table_',name(.))}" namespace="http://www.ivoa.net/xml/RegTAP/v1.0">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="column">
    <column>
       <table_index><xsl:value-of select="count(preceding::table[ancestor::ri:Resource/identifier=current()/ancestor::ri:Resource/identifier])+1"/></table_index>
       <xsl:apply-templates select="(name, ucd, unit, utype)" />
       <xsl:call-template name="bool"><xsl:with-param name="att">std</xsl:with-param></xsl:call-template>
        <xsl:apply-templates select="dataType"/>
        <flag><xsl:value-of select="flag" separator="#"/></flag>
        <column_description><xsl:value-of select="description"/> </column_description>

    </column>
    </xsl:template>
    
    <xsl:template match="dataType">
       <datatype><xsl:value-of select="."/></datatype>
       <extended_schema><xsl:value-of select="@extendedSchema"/></extended_schema>
       <extended_type><xsl:value-of select="@extendedType"/></extended_type>
       <arraysize><xsl:value-of select="@arraysize"/></arraysize>
       <delim><xsl:value-of select="@delim"/></delim>
       <xsl:if test="parent::column">
       <type_system><xsl:value-of select="@xsi:type"/></type_system>
       </xsl:if>
    </xsl:template>

    <xsl:template name="capidx">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::capability">
          <xsl:element name="cap_index"><xsl:value-of select="count(parent::capability/preceding-sibling::capability)+1"/></xsl:element>
      </xsl:when>
   </xsl:choose>
    
   </xsl:template>
   
   <xsl:template name="bool">
   <xsl:param name="att"/>
    <xsl:element name="{$att}">
     <xsl:choose>
       <xsl:when test="@*[name()=$att]">
       <xsl:choose>
          <xsl:when test="@*[name()=$att]=true()">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
       </xsl:choose>      
       </xsl:when>


       <xsl:otherwise>
         <!-- VO-DML does not allow NULL expicitly ATM
      <xsl:attribute name="nil" namespace="http://www.w3.org/2001/XMLSchema-instance">true</xsl:attribute>
       -->
           <xsl:value-of select="0"/>
    </xsl:otherwise>

     </xsl:choose>
    </xsl:element>
   </xsl:template>


    <xsl:template name="details">
 
 <!-- list of xpaths from the std document appendix - 
  might be better to do via exclusions or fewer more general xpaths -->  
       <xsl:apply-templates mode="detail" select="
accessURL|
capability/executionDuration/hard|
capability/complianceLevel|
capability/creationType|
capability/dataModel|
capability/dataModel/@ivo-id|
capability/dataSource|
capability/defaultMaxRecords|
capability/executionDuration/default|
capability/imageServiceType|
capability/interface/securityMethod/@standardID|
capability/interface/testQueryString|
capability/language/name|
capability/language/version/@ivo-id|
capability/maxAperture|
capability/maxFileSize|
capability/maxImageExtent/lat|
capability/maxImageExtent/long|
capability/maxImageSize/lat|
capability/maxImageSize/long|
capability/maxImageSize|
capability/maxQueryRegionSize/lat|
capability/maxQueryRegionSize/long|
capability/maxRecords|
capability/maxSearchRadius|
capability/maxSR|
capability/outputFormat/@ivo-id|
capability/outputFormat/alias|
capability/outputFormat/mime|
capability/outputLimit/default|
capability/outputLimit/default/@unit|
capability/outputLimit/hard|
capability/outputLimit/hard/@unit|
capability/retentionPeriod/default|
capability/retentionPeriod/hard|
capability/supportedFrame|
capability/testQuery/catalog|
capability/testQuery/dec|
capability/testQuery/extras|
capability/testQuery/pos/lat|
capability/testQuery/pos/long|
capability/testQuery/pos/refframe|
capability/testQuery/queryDataCmd|
capability/testQuery/ra|
capability/testQuery/size|
capability/testQuery/size/lat|
capability/testQuery/size/long|
capability/testQuery/sr|
capability/testQuery/verb|
capability/uploadLimit/default|
capability/uploadLimit/default/@unit|
capability/uploadLimit/hard|
capability/uploadLimit/hard/@unit|
capability/uploadMethod/@ivo-id|
capability/verbosity|
coverage/footprint|
coverage/footprint/@ivo-id|
deprecated|
endorsedVersion|
facility|
format|
format/@isMIMEType|
full|
instrument|
instrument/@ivo-id|
managedAuthority|
managingOrg|
rights|
rights/@rightsURI|
schema/@namespace" />
     
    </xsl:template>
  
  <xsl:template match="*|@*" mode="detail">
  <detail>
     <xsl:call-template name="capidx"/>
     <detail_xpath><xsl:value-of select="l:generateXPath(current())"/></detail_xpath>
     <detail_value><xsl:value-of select="."/></detail_value>
  </detail>
  </xsl:template>
  
   <!-- copy everything else without namespace declarations... -->
   <xsl:template match="*">
      <xsl:element name="{name(.)}" namespace="http://www.ivoa.net/xml/RegTAP/v1.0">
         <xsl:apply-templates select="@*" />
         <xsl:apply-templates />
      </xsl:element>
   </xsl:template>
   <xsl:template match="@*"> <!-- turn into element -->
       <xsl:element name="{name(.)}" namespace="http://www.ivoa.net/xml/RegTAP/v1.0">
         <xsl:value-of select="."/>
      </xsl:element>
   </xsl:template>
<xsl:function name="l:generateXPath" as="xsd:string" >
  <xsl:param name="pNode" as="node()"/>
  <xsl:variable name="head" >
  <xsl:value-of select="$pNode/ancestor::*[local-name() !=  'Resource' and local-name() !=  'VOResources' ]/name()" separator="/" />
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$pNode instance of element()"><xsl:value-of select="($head, name($pNode))" separator="/"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="($head, name($pNode))" separator="@"/></xsl:otherwise>
  </xsl:choose>
</xsl:function>    
</xsl:stylesheet>