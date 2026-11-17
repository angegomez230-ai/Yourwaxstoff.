package de.hwg_lu.bwi520.yourwaxstoff.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import de.hwg_lu.bwi520.yourwaxstoff.db.PostgreSQLAccess;


public class WaxstoffBean {

    // Attribute — entsprechen 1:1 den Spalten der Tabelle "waxstoff"
    private int waxstoffId;
    private String name;
    private String beschreibung;
    private boolean istFertig;
    private String geschlecht;
    private Integer groesseId; // Integer statt int, weil nullable
    private double preis;
    private String bildPfad;
    private String material;
    private String pflegehinweis;
    private String herkunft;

   
    public WaxstoffBean() {
    }


    public int getWaxstoffId() {
        return waxstoffId;
    }

    public void setWaxstoffId(int waxstoffId) {
        this.waxstoffId = waxstoffId;
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

    public boolean isIstFertig() {
        return istFertig;
    }

    public void setIstFertig(boolean istFertig) {
        this.istFertig = istFertig;
    }

    public String getGeschlecht() {
        return geschlecht;
    }

    public void setGeschlecht(String geschlecht) {
        this.geschlecht = geschlecht;
    }

    public Integer getGroesseId() {
        return groesseId;
    }

    public void setGroesseId(Integer groesseId) {
        this.groesseId = groesseId;
    }

    public double getPreis() {
        return preis;
    }

    public void setPreis(double preis) {
        this.preis = preis;
    }

    public String getBildPfad() {
        return bildPfad;
    }

    public void setBildPfad(String bildPfad) {
        this.bildPfad = bildPfad;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getPflegehinweis() {
        return pflegehinweis;
    }

    public void setPflegehinweis(String pflegehinweis) {
        this.pflegehinweis = pflegehinweis;
    }

    public String getHerkunft() {
        return herkunft;
    }

    public void setHerkunft(String herkunft) {
        this.herkunft = herkunft;
    }

    // ------------------------------------------------------------
    // Datenbankzugriff
    // ------------------------------------------------------------

    /**
     * Lädt einen einzelnen Waxstoff anhand seiner ID in die
     * Bean-Attribute. Wird für die Artikel-Detailseite gebraucht.
     *
     * @return true, wenn ein Datensatz gefunden wurde, sonst false
     */
    public boolean ladeAusDB(int id) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select waxstoff_id, name, beschreibung, ist_fertig, geschlecht, groesse_id, preis, bild_pfad, "
                   + "material, pflegehinweis, herkunft "
                   + "from waxstoff where waxstoff_id = ?";
        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        dbStmt.setInt(1, id);
        ResultSet dbRes = dbStmt.executeQuery();

        boolean gefunden = dbRes.next();
        if (gefunden) {
            this.waxstoffId   = dbRes.getInt("waxstoff_id");
            this.name         = dbRes.getString("name");
            this.beschreibung = dbRes.getString("beschreibung");
            this.istFertig    = dbRes.getBoolean("ist_fertig");
            this.geschlecht   = dbRes.getString("geschlecht");

            int groesse = dbRes.getInt("groesse_id");
            this.groesseId = dbRes.wasNull() ? null : groesse;

            this.preis         = dbRes.getDouble("preis");
            this.bildPfad       = dbRes.getString("bild_pfad");
            this.material        = dbRes.getString("material");
            this.pflegehinweis    = dbRes.getString("pflegehinweis");
            this.herkunft          = dbRes.getString("herkunft");
        }

        dbConn.close();
        return gefunden;
    }

  
    public String getKatalogAlsHtml(String filterTyp, String filterGeschlecht, String sortierung) throws SQLException {
        Connection dbConn = new PostgreSQLAccess().getConnection();

        String sql = "select waxstoff_id, name, preis, bild_pfad from waxstoff where 1=1";

        if ("waxstoff".equals(filterTyp)) {
            sql += " and ist_fertig = false";
        } else if ("fertig".equals(filterTyp)) {
            sql += " and ist_fertig = true";
        }

        boolean geschlechtFilterAktiv = "Herren".equals(filterGeschlecht) || "Damen".equals(filterGeschlecht);
        if (geschlechtFilterAktiv) {
            sql += " and geschlecht = ?";
        }

        if ("preisAsc".equals(sortierung)) {
            sql += " order by preis asc";
        } else if ("preisDesc".equals(sortierung)) {
            sql += " order by preis desc";
        } else {
            sql += " order by waxstoff_id";
        }

        PreparedStatement dbStmt = dbConn.prepareStatement(sql);
        if (geschlechtFilterAktiv) {
            dbStmt.setString(1, filterGeschlecht);
        }

        ResultSet dbRes = dbStmt.executeQuery();

        StringBuffer html = new StringBuffer();
        html.append("<div class=\"product-grid\">");

        while (dbRes.next()) {
            int id = dbRes.getInt("waxstoff_id");
            String artikelName = dbRes.getString("name");
            double artikelPreis = dbRes.getDouble("preis");
            String bild = dbRes.getString("bild_pfad");

            html.append("<a class=\"product-card\" href=\"ArtikelDetailView.jsp?waxstoffId=").append(id).append("\">");
            html.append("<img src=\"../").append(bild).append("\" alt=\"").append(artikelName).append("\" />");
            html.append("<div class=\"info\">");
            html.append("<div class=\"name\">").append(artikelName).append("</div>");
            html.append("<div class=\"price\">").append(artikelPreis).append(" €</div>");
            html.append("</div>");
            html.append("</a>");
        }

        html.append("</div>");

        dbConn.close();
        return html.toString();
    }
}
