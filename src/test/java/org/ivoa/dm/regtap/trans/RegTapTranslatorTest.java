package org.ivoa.dm.regtap.trans;

import org.ivoa.dm.regtap.RegTAPModel;
import org.ivoa.vodml.validation.XMLValidator;
import org.junit.jupiter.api.Test;

import java.io.InputStream;

import static org.junit.jupiter.api.Assertions.*;

/*
 * Created on 09/06/2025 by Paul Harrison (paul.harrison@manchester.ac.uk).
 */

class RegTapTranslatorTest {

   @Test
   void translate() {
      XMLValidator regValidator = new XMLValidator(new RegTAPModel().management());
      InputStream inp = this.getClass().getResourceAsStream("/VOResource.xml");
      assertNotNull(inp);
      RegTapTranslator translator = new RegTapTranslator();
      String out = translator.translate(inp);
      assertNotNull(out);
      XMLValidator.ValidationResult res = regValidator.validate(out);
      if(!res.isOk)
      {
         res.printValidationErrors(System.err);
      }
      System.out.println(out);
      assertTrue(res.isOk);

   }
}