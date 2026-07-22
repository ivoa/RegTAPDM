package org.ivoa.dm.regtap;
/*
 * Created on 10/05/2023 by Paul Harrison (paul.harrison@manchester.ac.uk).
 */

import org.ivoa.vodml.testing.AutoDBRoundTripTest;
import org.ivoa.vodml.testing.AutoRoundTripWithValidationTest;

import java.util.Date;


/**
 * This will run a XML and JSON round trip test on the model inst
 */
public class RegTAPlModelDBTest extends AutoDBRoundTripTest<RegTAPModel, String, Resource> {

    private Resource resource;

    @Override
    public RegTAPModel createModel() {
        // create the model instance here.
        RegTAPModel retval = new RegTAPModel();
        resource = Resource.createResource(r -> {
                  r.ivoid = "ivo://test/something";
                  r.res_type = "vr:Resource";
                  r.created = new Date();
                  r.short_name = "short name";
                  r.res_title = "title";
                  r.updated = new Date();
                  r.content_level = "level";
                  r.res_description = "description";
                  r.reference_url = "reference url";

              }

        );
        retval.addContent(resource);
        return retval;
    }

    @Override
    public void testModel(RegTAPModel mymodelModel) {
        //this could do specialized testing on the model instance
    }

    @Override
    public Resource entityForDb() {
        return resource;
    }

    @Override
    public void testEntity(Resource e) {
       //todo - should test entity
    }

   @Override
   protected String setDbDumpFile() {
      return "regtap_dump.sql";
   }
}
