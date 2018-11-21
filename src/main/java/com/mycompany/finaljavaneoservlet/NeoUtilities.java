/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.finaljavaneoservlet;

import org.neo4j.graphdb.GraphDatabaseService;

/**
 *
 * @author D064548
 */
public interface NeoUtilities {
    void  startNeoServer();
    void registerShutdownHook();
    String getQueryResults(String query);
}
