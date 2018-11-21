/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.finaljavaneoservlet;

import javax.ejb.Stateless;
import org.neo4j.cypher.javacompat.ExecutionEngine;
import org.neo4j.cypher.javacompat.ExecutionResult;
import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;

/**
 *
 * @author D064548
 */
@Stateless
public class NeoUtiliSessionBean implements NeoUtilities {

    private String DB_PATH = "";
    private GraphDatabaseService graphDb;
    private ExecutionEngine execEngine;

    public NeoUtiliSessionBean() {
    }

    public NeoUtiliSessionBean(String DB_PATH, GraphDatabaseService graphDb, ExecutionEngine execEngine) {
        this.DB_PATH = DB_PATH;
        this.graphDb = graphDb;
        this.execEngine = execEngine;
    }

    //private graphDB
    @Override
    public void startNeoServer() {
        //graphDb = new GraphDatabaseFactory().newEmbeddedDatabase(DB_PATH);
        //execEngine = new ExecutionEngine(graphDb);
    }

    @Override
    public void registerShutdownHook() {
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                graphDb.shutdown();
            }
        });
    }

    @Override
    public String getQueryResults(String query) {
        ExecutionResult execResult = execEngine.execute(query);
        String results = execResult.dumpToString();
        return results;
    }
}
