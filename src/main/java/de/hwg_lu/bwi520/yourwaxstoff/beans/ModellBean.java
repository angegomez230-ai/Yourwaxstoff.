package de.hwg_lu.bwi520.yourwaxstoff.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import de.hwg_lu.bwi520.yourwaxstoff.db.PostgreSQLAccess;


public class ModellBean {

    private int modellId;
    private String name;
    private String beschreibung;
    private String bildPfad;
    private double preis;

    public ModellBean() {
    }

 
    public int getModellId() {
        return modellId;
    }

    public void setModellId(int modellId) {
        this.modellId = modellId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBeschreibung() {
        return beschreibung;
    }

    public void setBeschreibung(String beschreibung) {
        this.beschreibung = beschreibung;
    }

    public String getBildPfad() {
        return bildPfad;
    }

    public void setBildPfad(String bildPfad) {
        this.bildPfad = bildPfad;
    }

    public double getPreis() {
        return preis;
    }

    public void setPreis(double preis) {
        this.preis = preis;
    }

  
    public boolean ladeAusDB(int id) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select modell_id, name, beschreibung, bild_pfad, preis from modell where modell_id = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, id);
        ResultSet dbRes = dbStmt.executeQuery();

        boolean gefunden = dbRes.next();
        if (gefunden) {
            this.modellId     = dbRes.getInt("modell_id");
            this.name         = dbRes.getString("name");
            this.beschreibung = dbRes.getString("beschreibung");
            this.bildPfad     = dbRes.getString("bild_pfad");
            this.preis        = dbRes.getDouble("preis");
        }

        dbConn.close();
        return gefunden;
    }

  
    public String getModelleZweispaltigAlsHtml() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        // Größen-Optionen einmal bauen, für jede der 8 Karten wiederverwenden
        String sqlGroesse = "select groesse_id, bezeichnung from groesse order by reihenfolge";
        PreparedStatement dbStmtGroesse = dbConn.prepareStatement(sqlGroesse);
        ResultSet dbResGroesse = dbStmtGroesse.executeQuery();
        StringBuffer groessenOptionen = new StringBuffer();
        groessenOptionen.append("<option value=\"\">Größe</option>");
        while (dbResGroesse.next()) {
            groessenOptionen.append("<option value=\"").append(dbResGroesse.getInt("groesse_id"))
                             .append("\">").append(dbResGroesse.getString("bezeichnung")).append("</option>");
        }

        StringBuffer html = new StringBuffer();
        html.append("<div class=\"modell-zweispaltig\">");
        html.append(baueModellSpalte(dbConn, "Damen%", "Damen", groessenOptionen.toString()));
        html.append(baueModellSpalte(dbConn, "Herren%", "Herren", groessenOptionen.toString()));
        html.append("</div>");

        dbConn.close();
        return html.toString();
    }

    private String baueModellSpalte(Connection dbConn, String namePraefix, String spaltenTitel,
                                     String groessenOptionen) throws SQLException {
        String sql = "select modell_id, name, bild_pfad, preis from modell where name like ? order by modell_id";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setString(1, namePraefix);
        ResultSet dbRes = dbStmt.executeQuery();

        StringBuffer html = new StringBuffer();
        html.append("<div class=\"modell-spalte\">");
        html.append("<h3>").append(spaltenTitel).append("</h3>");

        while (dbRes.next()) {
            int id = dbRes.getInt("modell_id");
            String name = dbRes.getString("name");
            String bild = dbRes.getString("bild_pfad");
            double preis = dbRes.getDouble("preis");

            html.append("<div class=\"modell-karte-auswahl\">");
            html.append("<img src=\"../").append(bild).append("\" alt=\"").append(name).append("\" />");
            html.append("<div class=\"modell-karte-info\">");
            html.append("<label class=\"modell-checkbox-label\">");
            html.append("<input type=\"checkbox\" name=\"modell_check_").append(id).append("\" value=\"1\">");
            html.append(" ").append(name).append(" — ").append(preis).append(" €");
            html.append("</label>");
            html.append("<select name=\"groesse_").append(id).append("\">").append(groessenOptionen).append("</select>");
            html.append("<input type=\"number\" name=\"menge_").append(id)
                .append("\" value=\"1\" min=\"1\" style=\"width:60px;\" title=\"Anzahl (Stück)\">");
            html.append("</div>");
            html.append("</div>");
        }

        html.append("</div>");
        return html.toString();
    }

   
    public String getGroessenAlsHtmlOptions() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select groesse_id, bezeichnung from groesse order by reihenfolge";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        ResultSet dbRes = dbStmt.executeQuery();

        StringBuffer html = new StringBuffer();
        while (dbRes.next()) {
            int id = dbRes.getInt("groesse_id");
            String bezeichnung = dbRes.getString("bezeichnung");
            html.append("<option value=\"").append(id).append("\">").append(bezeichnung).append("</option>");
        }

        dbConn.close();
        return html.toString();
    }

    public String getGroesseBezeichnung(int groesseId)
            throws SQLException {

        Connection conn =
            new PostgreSQLAccess().getConnection();

        String sql =
            "SELECT bezeichnung FROM groesse WHERE groesse_id = ?";

        try (conn;
             PreparedStatement stmt =
                 conn.prepareStatement(sql)) {

            stmt.setInt(1, groesseId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("bezeichnung");
                }
            }
        }

        throw new IllegalArgumentException(
            "Unbekannte Kleidergröße"
        );
    }
    
}
