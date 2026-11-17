package de.hwg_lu.bwi520.yourwaxstoff.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import de.hwg_lu.bwi520.yourwaxstoff.db.PostgreSQLAccess;


public class BenutzerBean {

    private int benutzerId;
    private String vorname;
    private String nachname;
    private String email;
    private String adresse;

    public BenutzerBean() {
    }

    

    public int getBenutzerId() {
        return benutzerId;
    }

    public void setBenutzerId(int benutzerId) {
        this.benutzerId = benutzerId;
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

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

   
    public void speichereBenutzer() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "insert into benutzer (vorname, nachname, email, adresse) values (?, ?, ?, ?)";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        dbStmt.setString(1, this.vorname);
        dbStmt.setString(2, this.nachname);
        dbStmt.setString(3, this.email);
        dbStmt.setString(4, this.adresse);
        dbStmt.executeUpdate();

        ResultSet dbKeys = dbStmt.getGeneratedKeys();
        if (dbKeys.next()) {
            this.benutzerId = dbKeys.getInt(1);
        }

        dbConn.close();
    }
}
