<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.WaxstoffBean" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.ModellBean" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.BestellungBean" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.KundeBean" %>
<%   
     // ============================================================
    // BestellungAppl.jsp — zentraler Controller für den gesamten
    // Bestellablauf.
    // 
    // WICHTIG seit der Login-Pflicht: JEDE Bestellung braucht einen
    // eingeloggten Kunden. Die Kontaktdaten (Name/E-Mail/Adresse)
    // kommen jetzt aus der Session (KundeBean), nicht mehr aus
    // einem Formular - niemand muss seine Daten mehrfach eingeben.
    //
    // Fünf mögliche "action"-Werte:
    //   schneidereiAuswahl   -> weiter zur Modell-Auswahl
    //   waxstoffAuswaehlen   -> weiter zum Formular (Meterware)
    //   fertigAuswaehlen     -> weiter zum Formular (fertig)
    //   abschliessen         -> Einzelartikel-Bestellung anlegen
    //   schneidereiBestellen -> Bestellung mit MEHREREN Modellen anlegen
    // ============================================================

    String action = request.getParameter("action");

    if ("schneidereiAuswahl".equals(action)) {
        // Login-Check passiert direkt in SchneidereiAuswahlView.jsp
        // selbst (zeigt bei fehlendem Login einen Anmelden-Hinweis).
%>
        <jsp:forward page="SchneidereiAuswahlView.jsp" />
<%
    } else if ("waxstoffAuswaehlen".equals(action)) {
        request.setAttribute("typ", "waxstoff");
%>
        <jsp:forward page="BestellFormularView.jsp" />
<%
    } else if ("fertigAuswaehlen".equals(action)) {
        request.setAttribute("typ", "fertig");
%>
        <jsp:forward page="BestellFormularView.jsp" />
<%
    } else if ("abschliessen".equals(action)) {
        // ------------------------------------------------------
        // Einzelartikel-Bestellung (Meterware ODER fertiges
        // Kleidungsstück) - kommt von BestellFormularView.jsp.
        // ------------------------------------------------------

        KundeBean eingeloggterKunde = (KundeBean) session.getAttribute("eingeloggterKunde");

        if (eingeloggterKunde == null) {
            // Sicherheitsnetz, falls jemand die Formular-URL direkt
            // aufruft, ohne eingeloggt zu sein.
            response.sendRedirect("StartseiteView.jsp?bitteEinloggen=1");
        } else {

        String typ = request.getParameter("typ");

        String waxstoffIdParam = request.getParameter("waxstoffId");
        Integer waxstoffId = (waxstoffIdParam != null && !waxstoffIdParam.isEmpty())
                              ? Integer.valueOf(waxstoffIdParam) : null;

        String mengeParam = request.getParameter("menge");
        double menge = (mengeParam != null && !mengeParam.isEmpty())
                        ? Double.parseDouble(mengeParam) : 1;

        WaxstoffBean waxstoffBean = new WaxstoffBean();
        waxstoffBean.ladeAusDB(waxstoffId);
        double einzelpreis = waxstoffBean.getPreis();

        // Kontaktdaten kommen aus der Session - kein Formularfeld
        // dafür mehr nötig.
        BestellungBean bestellungBean = new BestellungBean();
        bestellungBean.setKundeId(eingeloggterKunde.getKundeId());
        bestellungBean.setVorname(eingeloggterKunde.getVorname());
        bestellungBean.setNachname(eingeloggterKunde.getNachname());
        bestellungBean.setEmail(eingeloggterKunde.getEmail());
        bestellungBean.setAdresse(eingeloggterKunde.getAdresse());
        bestellungBean.setZahlungsmethode(request.getParameter("zahlungsmethode"));
        bestellungBean.erstelleBestellung();

        int neuePositionId = bestellungBean.fuegePosition(typ, waxstoffId, null, null, menge, einzelpreis);

        response.sendRedirect("BestellBestaetigungView.jsp?bestellnummer=" + bestellungBean.getBestellungId()
                             + "&positionId=" + neuePositionId);
        }

    } else if ("schneidereiBestellen".equals(action)) {
        // ------------------------------------------------------
        // NEU: Schneiderei-Bestellung mit MEHREREN Modellen auf
        // einmal (z. B. Damen-Oberteil UND Herrenhose gleichzeitig).
        // Kommt direkt von SchneidereiAuswahlView.jsp.
        // ------------------------------------------------------

        KundeBean eingeloggterKunde = (KundeBean) session.getAttribute("eingeloggterKunde");

        if (eingeloggterKunde == null) {
            response.sendRedirect("StartseiteView.jsp?bitteEinloggen=1");
        } else {

        int waxstoffId = Integer.parseInt(request.getParameter("waxstoffId"));

        // Anderungen
        
        WaxstoffBean stoffBean = new WaxstoffBean();

if (!stoffBean.ladeAusDB(waxstoffId)) {
    throw new IllegalArgumentException(
        "Waxstoff nicht gefunden"
    );
}

double preisProMeter = stoffBean.getPreis();
        
        BestellungBean bestellungBean = new BestellungBean();
        bestellungBean.setKundeId(eingeloggterKunde.getKundeId());
        bestellungBean.setVorname(eingeloggterKunde.getVorname());
        bestellungBean.setNachname(eingeloggterKunde.getNachname());
        bestellungBean.setEmail(eingeloggterKunde.getEmail());
        bestellungBean.setAdresse(eingeloggterKunde.getAdresse());
        bestellungBean.setZahlungsmethode(request.getParameter("zahlungsmethode"));
        bestellungBean.erstelleBestellung();

        // Die 8 Modelle sind fest (siehe Datenbankkonzept.md) - eine
        // einfache Schleife von 1 bis 8 reicht, statt die IDs erst
        // aus der Datenbank abzufragen.
        int letztePositionId = 0;

        for (int modellId = 1; modellId <= 8; modellId++) {
            String checkboxWert = request.getParameter("modell_check_" + modellId);

            if (checkboxWert != null) {
                // Diese Checkbox war angekreuzt -> Position anlegen

                String groesseParam = request.getParameter("groesse_" + modellId);
                Integer groesseId = (groesseParam != null && !groesseParam.isEmpty())
                                     ? Integer.valueOf(groesseParam) : null;

                String mengeParam = request.getParameter("menge_" + modellId);
                double menge = (mengeParam != null && !mengeParam.isEmpty())
                                ? Double.parseDouble(mengeParam) : 1;
//Anderungen
      //          ModellBean modellBean = new ModellBean();
        //        modellBean.ladeAusDB(modellId);
//
  //              letztePositionId = bestellungBean.fuegePosition("schneiderei", waxstoffId, modellId,
    //                                                              groesseId, menge, modellBean.getPreis());
            }
        } 
        

        response.sendRedirect("BestellBestaetigungView.jsp?bestellnummer=" + bestellungBean.getBestellungId()
                             + "&positionId=" + letztePositionId);
        }
    }
%>