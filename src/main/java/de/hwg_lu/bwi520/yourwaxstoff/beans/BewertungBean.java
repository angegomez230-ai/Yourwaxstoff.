package de.hwg_lu.bwi520.yourwaxstoff.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import de.hwg_lu.bwi520.yourwaxstoff.db.PostgreSQLAccess;


public class BewertungBean {

    private int bewertungId;
    private int positionId;
    private int artikelBewertung;
    private int bestellprozessBewertung;
    private String kommentar;

    public BewertungBean() {
    }

    public int getBewertungId() {
        return bewertungId;
    }

    public void setBewertungId(int bewertungId) {
        this.bewertungId = bewertungId;
    }

    public int getPositionId() {
        return positionId;
    }

    public void setPositionId(int positionId) {
        this.positionId = positionId;
    }

    public int getArtikelBewertung() {
        return artikelBewertung;
    }

    public void setArtikelBewertung(int artikelBewertung) {
        this.artikelBewertung = artikelBewertung;
    }

    public int getBestellprozessBewertung() {
        return bestellprozessBewertung;
    }

    public void setBestellprozessBewertung(int bestellprozessBewertung) {
        this.bestellprozessBewertung = bestellprozessBewertung;
    }

    public String getKommentar() {
        return kommentar;
    }

    public void setKommentar(String kommentar) {
        this.kommentar = kommentar;
    }

 
    public void speichereBewertung() throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "insert into bewertung (position_id, artikel_bewertung, bestellprozess_bewertung, kommentar) "
                   + "values (?, ?, ?, ?)";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, this.positionId);
        dbStmt.setInt(2, this.artikelBewertung);
        dbStmt.setInt(3, this.bestellprozessBewertung);
        dbStmt.setString(4, this.kommentar);
        dbStmt.executeUpdate();

        dbConn.close();
    }

 
    public String getBewertungenAlsHtml(String typ, int artikelId) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql;
        if ("schneiderei".equals(typ)) {
            sql = "select b.artikel_bewertung, b.bestellprozess_bewertung, b.kommentar "
                + "from bewertung b join position p on b.position_id = p.position_id "
                + "where p.modell_id = ? and p.typ = 'schneiderei'";
        } else {
            sql = "select b.artikel_bewertung, b.bestellprozess_bewertung, b.kommentar "
                + "from bewertung b join position p on b.position_id = p.position_id "
                + "where p.waxstoff_id = ?";
        }

        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, artikelId);
        ResultSet dbRes = dbStmt.executeQuery();

        StringBuffer html = new StringBuffer();
        html.append("<div class=\"bewertungen\">");

        boolean vorhanden = false;
        while (dbRes.next()) {
            vorhanden = true;
            int sterneArtikel = dbRes.getInt("artikel_bewertung");
            String kommentarText = dbRes.getString("kommentar");

            html.append("<div class=\"bewertung-eintrag\">");
            html.append("<span>").append(sterneArtikel).append(" / 5</span>");
            if (kommentarText != null && !kommentarText.isEmpty()) {
                html.append("<p>").append(kommentarText).append("</p>");
            }
            html.append("</div>");
        }

        if (!vorhanden) {
            html.append("<p>Noch keine Bewertungen vorhanden.</p>");
        }

        html.append("</div>");

        dbConn.close();
        return html.toString();
    }
}
