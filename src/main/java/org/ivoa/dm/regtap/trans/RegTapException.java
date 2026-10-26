package org.ivoa.dm.regtap.trans;

/**
 * An exception related to RegTAP operations.
 *
 * @author Paul Harrison (paul.harrison@manchester.ac.uk) */
public class RegTapException extends Exception {
   /**
    * Create an exception.
    * @param message The message.
    * @param e the exception.
    */
    public RegTapException(String message, Exception e) {
        super(message, e);
    }
}
