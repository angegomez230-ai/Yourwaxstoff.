package de.hwg_lu.bwi520.yourwaxstoff.db;

import java.sql.SQLException;
import java.sql.Statement;

/**
 * Konkrete Unterklasse von JDBCAccess für den Zugriff auf die
 * PostgreSQL-Datenbank der Hochschule.
 *
 * Nutzung in Beans, z. B.:
 *   Connection newConnection = new PostgreSQLAccess().getConnection();
 */
public class PostgreSQLAccess extends JDBCAccess {

    protected String dbSchema;

    
    private static final boolean VERWENDE_LOKAL = false ;

    public PostgreSQLAccess() throws SQLException {
        super();
    } 

    @Override
    protected void setDBParameter() {
        this.dbDrivername = "org.postgresql.Driver";
        this.dbSchema     = "bwi520_yourwaxstoff";

        if (VERWENDE_LOKAL) {
            // Lokale PostgreSQL-18-Installation auf diesem Rechner
            this.dbServer   = "127.0.0.1";
            this.dbPort     = "5435";
            this.dbName     = "postgres";
            this.dbUserid   = "postgres";
          this.dbPassword = System.getenv("LOCAL_DB_PASSWORD");
         
          
        } 
        
        else if (System.getenv("DB_HOST") != null) {
            // Online-Demo auf Render
            this.dbServer = System.getenv("DB_HOST");
            this.dbPort = System.getenv("DB_PORT");
            this.dbName = System.getenv("DB_NAME");
            this.dbUserid = System.getenv("DB_USER");
            this.dbPassword = System.getenv("DB_PASSWORD");
            }
        
        else {
            // Hochschul-Server — nur nutzbar, wenn per eduVPN erreichbar
            this.dbServer   = "143.93.200.243";
            this.dbPort     = "5435";
            this.dbName     = "BWUEBDB";
            this.dbUserid   = "user1";
            this.dbPassword = System.getenv("UNI_DB_PASSWORD");
            
          
        }
    }

    @Override
    protected void setSchema() throws SQLException {
        Statement stmt = dbConn.createStatement();
        stmt.execute("set schema '" + dbSchema + "'");
        System.out.println("Schema gesetzt auf: " + dbSchema);
    }
 
    public static void main(String[] args) throws SQLException {
        new PostgreSQLAccess();
    }
}
