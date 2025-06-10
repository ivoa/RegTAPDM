/*
 * $Id$
 * 
 * Created on 21 Jan 2013 by Paul Harrison (paul.harrison@manchester.ac.uk)
 * Copyright 2013 Manchester University. All rights reserved.
 *
 * This software is published under the terms of the Academic 
 * Free License, a copy of which has been included 
 * with this distribution in the LICENSE.txt file.  
 *
 */ 

package org.ivoa.dm.regtap.trans;



import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.s9api.*;


/**
 * Translate a VOResource to  RegTAP DM XML representation.
 * @author Paul Harrison (paul.harrison@manchester.ac.uk) 21 Jan 2013
 * @version $Revision$ $date$
 *
 * note that this class directly uses the saxon S9API
 */
public class RegTapTranslator {

    /** logger for this class */
    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory
            .getLogger(RegTapTranslator.class);
    private final XsltExecutable exp;
    private final Processor processor;

   /**
    * construct a Translator.
    */
   public RegTapTranslator() {
       processor = new Processor(false);
       XsltCompiler compiler = processor.newXsltCompiler();
       try (InputStream xslFileStream = RegTapTranslator.class
             .getResourceAsStream("/convertToRegTap.xsl")) {
          assert xslFileStream != null : "could not find the convertToRegTap.xsl";
          exp = compiler.compile(new StreamSource(xslFileStream));
       } catch (IOException | SaxonApiException e) {
          throw new RuntimeException(e);
       }
    }

   /**
    * Translate a VOResource instance to RegTAP XML instance.
    * @param is stream with VOResource XML instance.
    * @return string of RegTAP instance
    */
    public String translate(InputStream is) {
        Xslt30Transformer xsltTransformer = exp.load30();
        StringWriter sw = new StringWriter();
        Serializer out = processor.newSerializer(sw);
       try {
          xsltTransformer.transform(new StreamSource(is),out);
          return sw.toString();
       } catch (SaxonApiException e) {
          throw new RuntimeException(e); // TODO will possibly want to make this a checked exception.
       }

    }



}


/*
 * $Log$
 */
