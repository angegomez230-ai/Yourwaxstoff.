package de.hwg_lu.bwi520.yourwaxstoff.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public abstract class JDBCAccess {

    protected Connection dbConn;

    protected String dbDrivername;
    protected String dbServer;
    protected String dbPort;
    protected String dbName;
    protected String dbUserid;
    protected String dbPassword;

  
    public JDBCAccess() throws SQLException {
        setDBParameter();
        createConnection();
        setSchema();
    }

  
    protected abstract void setSchema() throws SQLException;

    protected void createConnection() throws SQLException {
        try {
            Class.forName(dbDrivername);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Datenbanktreiber nicht gefunden: " + e.getMessage());
        }

        
        
        String dbURL = "jdbc:postgresql://" + dbServer + ":" + dbPort + "/" + dbName;

     // SSL nur für Neon auf Render
     if (System.getenv("DB_HOST") != null) {
         dbURL += "?sslmode=require";
     }

     dbConn = DriverManager.getConnection(dbURL, dbUserid, dbPassword);
        

        System.out.println("Datenbankverbindung erfolgreich hergestellt: " + dbURL);
    }

  
    public Connection getConnection() {
        return dbConn;
    }
}
