package de.hwg_lu.bwi520.yourwaxstoff.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import de.hwg_lu.bwi520.yourwaxstoff.db.PostgreSQLAccess;


public class BestellungBean {

    private int bestellungId;
    private int kundeId;
    private String vorname;
    private String nachname;
    private String email;
    private String adresse;
    private String zahlungsmethode;
    private double gesamtpreis;

    public BestellungBean() {
    }

  
    public int getBestellungId() {
        return bestellungId;
    }

    public void setBestellungId(int bestellungId) {
        this.bestellungId = bestellungId;
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

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getZahlungsmethode() {
        return zahlungsmethode;
    }

    public void setZahlungsmethode(String zahlungsmethode) {
        this.zahlungsmethode = zahlungsmethode;
    }

    public double getGesamtpreis() {
        return gesamtpreis;
    }

    public void setGesamtpreis(double gesamtpreis) {
        this.gesamtpreis = gesamtpreis;
    }

    // ------------------------------------------------------------
    // Datenbankzugriff
    // ------------------------------------------------------------

    /**
     * Legt den Bestellkopf an. Erwartet, dass VORHER per setKundeId()
     * die ID des bereits eingeloggten Kunden gesetzt wurde (kein
     * automatisches Anlegen eines neuen Kontos mehr - der Kunde
     * existiert ja schon, seit es echte Konten mit Login gibt).
     * Setzt anschließend this.bestellungId auf die neue Bestellnummer.
     */
    public void erstelleBestellung() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "insert into bestellung (kunde_id, vorname, nachname, email, adresse, zahlungsmethode, gesamtpreis) "
                   + "values (?, ?, ?, ?, ?, ?, 0)";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        dbStmt.setInt(1, this.kundeId);
        dbStmt.setString(2, this.vorname);
        dbStmt.setString(3, this.nachname);
        dbStmt.setString(4, this.email);
        dbStmt.setString(5, this.adresse);
        dbStmt.setString(6, this.zahlungsmethode);
        dbStmt.executeUpdate();

        ResultSet dbKeys = dbStmt.getGeneratedKeys();
        if (dbKeys.next()) {
            this.bestellungId = dbKeys.getInt(1);
        }

        dbConn.close();
    }

   
    public int fuegePosition(String typ, Integer waxstoffId, Integer modellId, Integer groesseId,
                              double menge, double einzelpreis) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "insert into position (bestellung_id, typ, waxstoff_id, modell_id, groesse_id, menge, einzelpreis) "
                   + "values (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        dbStmt.setInt(1, this.bestellungId);
        dbStmt.setString(2, typ);

        if (waxstoffId != null) {
            dbStmt.setInt(3, waxstoffId);
        } else {
            dbStmt.setNull(3, Types.INTEGER);
        }

        if (modellId != null) {
            dbStmt.setInt(4, modellId);
        } else {
            dbStmt.setNull(4, Types.INTEGER);
        }

        if (groesseId != null) {
            dbStmt.setInt(5, groesseId);
        } else {
            dbStmt.setNull(5, Types.INTEGER);
        }

        dbStmt.setDouble(6, menge);
        dbStmt.setDouble(7, einzelpreis);
        dbStmt.executeUpdate();

        int neuePositionId = 0;
        ResultSet dbKeys = dbStmt.getGeneratedKeys();
        if (dbKeys.next()) {
            neuePositionId = dbKeys.getInt(1);
        }

        dbConn.close();

        aktualisiereGesamtpreis();

        return neuePositionId;
    }

    public void aktualisiereGesamtpreis() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "update bestellung set gesamtpreis = "
                   + "(select coalesce(sum(menge * einzelpreis), 0) from position where bestellung_id = ?) "
                   + "where bestellung_id = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, this.bestellungId);
        dbStmt.setInt(2, this.bestellungId);
        dbStmt.executeUpdate();

        dbConn.close();
    }

  
    public String getBestellungAlsHtml(int bestellnummer) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        // 1. Prüfen, ob die Bestellung existiert
        String sqlBestellung = "select bestellung_id from bestellung where bestellung_id = ?";
        PreparedStatement dbStmtBestellung = dbConn.prepareStatement(sqlBestellung);
        dbStmtBestellung.setInt(1, bestellnummer);
        ResultSet dbResBestellung = dbStmtBestellung.executeQuery();

        if (!dbResBestellung.next()) {
            dbConn.close();
            return null;
        }

        // 2. Alle Positionen dieser Bestellung laden
        String sqlPositionen = "select typ, waxstoff_id, modell_id, menge, einzelpreis "
                              + "from position where bestellung_id = ?";
        PreparedStatement dbStmtPositionen = dbConn.prepareStatement(sqlPositionen);
        dbStmtPositionen.setInt(1, bestellnummer);
        ResultSet dbResPositionen = dbStmtPositionen.executeQuery();

        StringBuffer html = new StringBuffer();

        while (dbResPositionen.next()) {
            String typ = dbResPositionen.getString("typ");
            double einzelpreis = dbResPositionen.getDouble("einzelpreis");

            String artikelName = "";
            String artikelBeschreibung = "";

            if ("schneiderei".equals(typ)) {
                int modellId = dbResPositionen.getInt("modell_id");
                String sqlModell = "select name, beschreibung from modell where modell_id = ?";
                PreparedStatement dbStmtModell = dbConn.prepareStatement(sqlModell);
                dbStmtModell.setInt(1, modellId);
                ResultSet dbResModell = dbStmtModell.executeQuery();
                if (dbResModell.next()) {
                    artikelName = dbResModell.getString("name");
                    artikelBeschreibung = dbResModell.getString("beschreibung");
                }
            } else {
                int waxstoffId = dbResPositionen.getInt("waxstoff_id");
                String sqlWaxstoff = "select name, beschreibung from waxstoff where waxstoff_id = ?";
                PreparedStatement dbStmtWaxstoff = dbConn.prepareStatement(sqlWaxstoff);
                dbStmtWaxstoff.setInt(1, waxstoffId);
                ResultSet dbResWaxstoff = dbStmtWaxstoff.executeQuery();
                if (dbResWaxstoff.next()) {
                    artikelName = dbResWaxstoff.getString("name");
                    artikelBeschreibung = dbResWaxstoff.getString("beschreibung");
                }
            }

            html.append("<div class=\"tracking-item\">");
            html.append("<div><strong>").append(artikelName).append("</strong><br/>")
                .append(artikelBeschreibung).append("</div>");
            html.append("<div>").append(einzelpreis).append(" €</div>");
            html.append("</div>");
        }

        dbConn.close();
        return html.toString();
    }

  
    public String getBestellungenFuerKundeAlsHtml(int kundeId) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select bestellung_id, gesamtpreis, zahlungsmethode, erstellt_am "
                   + "from bestellung where kunde_id = ? order by erstellt_am desc";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, kundeId);
        ResultSet dbRes = dbStmt.executeQuery();

        StringBuffer html = new StringBuffer();
        boolean vorhanden = false;

        while (dbRes.next()) {
            vorhanden = true;
            int id = dbRes.getInt("bestellung_id");
            double gesamtpreis = dbRes.getDouble("gesamtpreis");
            String zahlungsmethode = dbRes.getString("zahlungsmethode");
            String datum = dbRes.getTimestamp("erstellt_am").toString();

            html.append("<div class=\"tracking-item\">");
            html.append("<div><strong>Bestellung WX-").append(id).append("</strong><br/>")
                .append(datum).append(" · ").append(zahlungsmethode).append("</div>");
            html.append("<div>").append(gesamtpreis).append(" €</div>");
            html.append("</div>");
        }

        if (!vorhanden) {
            html.append("<p>Noch keine Bestellungen vorhanden.</p>");
        }

        dbConn.close();
        return html.toString();
    }
}
