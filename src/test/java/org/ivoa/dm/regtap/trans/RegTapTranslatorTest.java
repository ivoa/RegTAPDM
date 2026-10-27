package org.ivoa.dm.regtap.trans;

import jakarta.xml.bind.*;
import jakarta.xml.bind.util.ValidationEventCollector;
import org.ivoa.dm.regtap.RegTAPModel;
import org.ivoa.dm.regtap.Resource;
import org.ivoa.vodml.validation.AbstractBaseValidation;
import org.ivoa.vodml.validation.XMLValidator;
import org.junit.jupiter.api.Test;

import javax.xml.transform.stream.StreamSource;
import java.io.InputStream;
import java.io.StringReader;
import java.util.Map;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;

/*
 * Created on 09/06/2025 by Paul Harrison (paul.harrison@manchester.ac.uk).
 */

class RegTapTranslatorTest extends AbstractBaseValidation {


   String[] resources = {
        "/0000.xml" ,
        "/VOResource.xml",
        "/complang.xml",
        "/conesearch.xml",
        "/organization.xml",
         "/registry.xml",
        "/sia.xml",
         "/siastd.xml",
         "/ssa.xml",
         "/supercosmos.xml",
         "/ukidss.xml"

   };

//   @Test
//   void intest() {
//      for(String resource : resources) {
//         inputvalidate(resource);
//      }
//   }

   @Test
   void translate() throws JAXBException, RegTapException {
      for(String resource : resources) {
         RegTAPModel res = trans(resource);
      }

   }

   @Test
   void translateSingle() throws JAXBException, RegTapException {
      //inputvalidate("/ukidss.xml");
      RegTAPModel ret = trans("/vizier.xml");
      assertNotNull(ret);
      assertEquals(100, ret.getResource().size());

      Map<String, Resource> map = ret.getResource().stream().collect(Collectors.toMap(r -> r.getIvoid(), r -> r));

      assertTrue(map.containsKey("ivo://CDS.VizieR/I/202"));

      Resource res = map.get("ivo://CDS.VizieR/I/202");
      assertNotNull(res);
   }

   @Test
   void translateAmbigTab() throws JAXBException, RegTapException {
//      inputvalidate("/ambiguousTable.xml");
      RegTAPModel ret = trans("/ambiguousTable.xml");
      assertNotNull(ret);
      assertEquals(1, ret.getResource().size());


   }

   @Test
   void translateStds() throws JAXBException, RegTapException {
      inputvalidate("/stds.xml");
      RegTAPModel ret = trans("/stds.xml");
      assertNotNull(ret);
      assertEquals(26, ret.getResource().size());


   }



   private void inputvalidate(String name) {

      org.javastro.ivoa.schema.XMLValidator validator = new org.javastro.ivoa.schema.XMLValidator();
      InputStream inp = this.getClass().getResourceAsStream(name);
      assertNotNull(inp);
      boolean ok = validator.validate(new StreamSource(inp));
      if(!ok)
      {
         System.err.println("Validation errors for input " + name);
         validator.printErrors(System.err);
      }
      assertTrue(ok);
   }

   private RegTAPModel trans(String name) throws JAXBException, RegTapException {
      System.out.println("translating " + name);
      XMLValidator regValidator = new XMLValidator(new RegTAPModel().management());
      InputStream inp = this.getClass().getResourceAsStream(name);
      assertNotNull(inp);
      RegTapTranslator translator = new RegTapTranslator();
      String out = translator.translateToXML(inp);
      assertNotNull(out);
      XMLValidator.ValidationResult res = regValidator.validate(out);
      if(!res.isOk)
      {
         System.err.println("Validation errors for translated " + name);
         res.printValidationErrors(System.err);
      }

      System.out.println("Translated output for " + name + ":\n" + out);
      assertTrue(res.isOk);

      JAXBContext jc = RegTAPModel.contextFactory();
      Unmarshaller um = jc.createUnmarshaller();
      ValidationEventCollector vc = new jakarta.xml.bind.util.ValidationEventCollector();
      um.setEventHandler(vc);
      JAXBElement<RegTAPModel> el = um.unmarshal(new StreamSource(new StringReader(out)), RegTAPModel.class);
      if (vc.hasEvents()) {
         System.err.println("JAXB Validation errors for translated " + name);
         for (ValidationEvent err : vc.getEvents()) {
            System.err.println(err.getMessage());
         }
      }
      RegTAPModel modelin = el.getValue();
      assertNotNull(modelin,"error creating object for "+name);
      assertTrue(!modelin.getContent(Resource.class).isEmpty(),"no resources found in translated model for "+name);

      jakarta.persistence.EntityManager em = setupH2Db(RegTAPModel.pu_name(), RegTAPModel.modelDescription.allClassNames());
      for(Resource r : modelin.getContent(Resource.class))
      {
         em.getTransaction().begin();
         em.persist(r);
         em.getTransaction().commit();
      }

      dumpDbData(em, name.substring(1).replace(".xml","_dump.sql"));
 //     dumpDbData(em, "test_dump.sql");
      return modelin;
   }
}