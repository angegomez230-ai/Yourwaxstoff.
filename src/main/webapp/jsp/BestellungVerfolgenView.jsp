<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.BestellungBean" %>

<%-- ============================================================
     BestellungVerfolgenView.jsp
     Eigenständige Seite, unabhängig vom Bestellablauf - jeder kann
     hier jederzeit seine Bestellnummer eingeben und den (statischen)
     Lieferstatus sehen. Erreichbar über den Link "Bestellung
     verfolgen" im Header (siehe header.jspf).
     ============================================================ --%>

<%@ include file="header.jspf" %>

<h1 style="text-align:center; margin-top:2rem;">Bestellung verfolgen</h1>

<%-- Formular sendet per GET an SICH SELBST (action zeigt auf die
     eigene Datei) - beim Absenden lädt sich die Seite also einfach
     mit ?bestellnummer=12 in der URL neu. Kein separater Controller
     nötig, weil hier nichts geändert wird, nur gelesen. --%>
<form class="form-container" method="get" action="BestellungVerfolgenView.jsp">
    <div class="form-group">
        <label for="bestellnummer">Deine Bestellnummer</label>
        <%-- value hält die zuletzt eingegebene Nummer im Feld,
             falls die Seite mit einem Ergebnis neu geladen wurde. --%>
        <input type="number" id="bestellnummer" name="bestellnummer"
               value="<%= request.getParameter("bestellnummer") == null ? "" : request.getParameter("bestellnummer") %>"
               required>
    </div>
    <button type="submit" class="btn-primary" style="width:100%;">Bestellung anzeigen</button>
</form>

<%
    String bestellnummerParam = request.getParameter("bestellnummer");

    // Nur wenn tatsächlich eine Nummer eingegeben wurde (nicht beim
    // allerersten Aufruf der Seite), wird überhaupt in der DB gesucht.
    if (bestellnummerParam != null && !bestellnummerParam.isEmpty()) {
        int bestellnummer = Integer.parseInt(bestellnummerParam);

        BestellungBean bestellungBean = new BestellungBean();

        // getBestellungAlsHtml() gibt entweder das fertige HTML mit
        // allen Artikeln dieser Bestellung zurück, oder null, wenn es
        // gar keine Bestellung mit dieser Nummer gibt.
        String artikelHtml = bestellungBean.getBestellungAlsHtml(bestellnummer);

        if (artikelHtml == null) {
%>
            <div class="confirmation-box">
                <p>Es wurde keine Bestellung mit der Nummer WX-<%= bestellnummer %> gefunden.</p>
            </div>
<%
        } else {
%>
            <div class="confirmation-box" style="text-align:left;">
                <h2>Bestellung WX-<%= bestellnummer %></h2>
                <%= artikelHtml %>
                <%-- Der Lieferstatus-Text ist bewusst FEST hier im
                     JSP hinterlegt, nicht in der Datenbank gespeichert
                     (siehe Projektkonzept.md Kapitel 0, Annahme 5) -
                     es soll keine echte Logistik simuliert werden. --%>
                <div class="lieferhinweis">
                    Lieferung kommt spätestens am Ende der Woche an
                </div>
            </div>
<%
        }
    }
%>

<%@ include file="footer.jspf" %>