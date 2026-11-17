package de.hwg_lu.bwi520.yourwaxstoff.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import de.hwg_lu.bwi520.yourwaxstoff.db.PostgreSQLAccess;


public class KundeBean {

    private int kundeId;
    private String vorname;
    private String nachname;
    private String email;
    private String passwort;
    private String adresse;

    public KundeBean() {
    }

  

    public int getKundeId() {
        return kundeId;
    }

    public void setKundeId(int kundeId) {
        this.kundeId = kundeId;
    }

    public String getVorname() {
        return vorname;
    }

    public void setVorname(String vorname) {
        this.vorname = vorname;
    }

    public String getNachname() {
        return nachname;
    }

    public void setNachname(String nachname) {
        this.nachname = nachname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswort() {
        return passwort;
    }

    public void setPasswort(String passwort) {
        this.passwort = passwort;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

  
    public boolean pruefeLogin(String eingegebeneEmail, String eingegebenesPasswort) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select kunde_id, vorname, nachname, email, passwort, adresse "
                   + "from kunde where email = ? and passwort = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setString(1, eingegebeneEmail);
        dbStmt.setString(2, eingegebenesPasswort);
        ResultSet dbRes = dbStmt.executeQuery();

        boolean erfolgreich = dbRes.next();
        if (erfolgreich) {
            this.kundeId  = dbRes.getInt("kunde_id");
            this.vorname  = dbRes.getString("vorname");
            this.nachname = dbRes.getString("nachname");
            this.email    = dbRes.getString("email");
            this.passwort = dbRes.getString("passwort");
            this.adresse  = dbRes.getString("adresse");
        }

        dbConn.close();
        return erfolgreich;
    }

 
    public boolean emailExistiertBereits(String zuPruefendeEmail) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select kunde_id from kunde where email = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setString(1, zuPruefendeEmail);
        ResultSet dbRes = dbStmt.executeQuery();

        boolean existiert = dbRes.next();

        dbConn.close();
        return existiert;
    }

  
    public void registriere() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "insert into kunde (vorname, nachname, email, passwort, adresse) values (?, ?, ?, ?, ?)";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        dbStmt.setString(1, this.vorname);
        dbStmt.setString(2, this.nachname);
        dbStmt.setString(3, this.email);
        dbStmt.setString(4, this.passwort);
        dbStmt.setString(5, this.adresse);
        dbStmt.executeUpdate();

        ResultSet dbKeys = dbStmt.getGeneratedKeys();
        if (dbKeys.next()) {
            this.kundeId = dbKeys.getInt(1);
        }

        dbConn.close();
    }

    public boolean ladeAusDB(int id) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select kunde_id, vorname, nachname, email, passwort, adresse from kunde where kunde_id = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, id);
        ResultSet dbRes = dbStmt.executeQuery();

        boolean gefunden = dbRes.next();
        if (gefunden) {
            this.kundeId  = dbRes.getInt("kunde_id");
            this.vorname  = dbRes.getString("vorname");
            this.nachname = dbRes.getString("nachname");
            this.email    = dbRes.getString("email");
            this.passwort = dbRes.getString("passwort");
            this.adresse  = dbRes.getString("adresse");
        }

        dbConn.close();
        return gefunden;
    }

    public boolean aktualisiereProfil() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "update kunde set vorname = ?, nachname = ?, email = ?, adresse = ? where kunde_id = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setString(1, this.vorname);
        dbStmt.setString(2, this.nachname);
        dbStmt.setString(3, this.email);
        dbStmt.setString(4, this.adresse);
        dbStmt.setInt(5, this.kundeId);
        int betroffeneZeilen = dbStmt.executeUpdate();

        dbConn.close();
        return betroffeneZeilen > 0;
    }

    public boolean passwortAendern(String altesPasswort, String neuesPasswort) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sqlPruefen = "select kunde_id from kunde where kunde_id = ? and passwort = ?";
        PreparedStatement dbStmtPruefen = dbConn.prepareStatement(sqlPruefen);
        dbStmtPruefen.setInt(1, this.kundeId);
        dbStmtPruefen.setString(2, altesPasswort);
        ResultSet dbRes = dbStmtPruefen.executeQuery();

        if (!dbRes.next()) {
            dbConn.close();
            return false;
        }

        String sqlUpdate = "update kunde set passwort = ? where kunde_id = ?";
        PreparedStatement dbStmtUpdate = dbConn.prepareStatement(sqlUpdate);
        dbStmtUpdate.setString(1, neuesPasswort);
        dbStmtUpdate.setInt(2, this.kundeId);
        dbStmtUpdate.executeUpdate();

        this.passwort = neuesPasswort;
        dbConn.close();
        return true;
    }
}
