package org.ivoa.dm.regtap;
/*
 * Created on 10/05/2023 by Paul Harrison (paul.harrison@manchester.ac.uk).
 */

import org.ivoa.vodml.testing.AutoRoundTripWithValidationTest;

/**
 * This will run a XML and JSON round trip test on the model inst
 */
public class RegTAPBasiclModelTest extends AutoRoundTripWithValidationTest<RegTAPModel> {
    @Override
    public RegTAPModel createModel() {
        // create the model instance here.
        RegTAPModel retval = new RegTAPModel();
        retval.addContent(Resource.createResource( r -> {
            r.ivoid="ivo://test/something";
            //TODO add more to make a realistic example
              }

        ));
        return retval;
    }

    @Override
    public void testModel(RegTAPModel mymodelModel) {
        //this could do specialized testing on the model instance
    }
}
