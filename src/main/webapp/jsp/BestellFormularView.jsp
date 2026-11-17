<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.KundeBean" %>
 
<%-- ============================================================
     BestellFormularView.jsp
     Letzter Schritt vor dem Bestellabschluss für EINZELARTIKEL
      (Meterware oder fertiges Kleidungsstück). Seit der Login-
     Pflicht werden Name/E-Mail/Adresse NICHT mehr abgefragt -
     die stehen schon im Konto und kommen aus der Session.
     ============================================================ --%>

<%@ include file="header.jspf" %>

<% 
    // "typ" kommt als Request-Attribut (von BestellungAppl.jsp per
    // forward gesetzt), waxstoffId als normaler Parameter.
    String typ = (String) request.getAttribute("typ");

    String waxstoffId = request.getParameter("waxstoffId");
    if (waxstoffId == null) { waxstoffId = ""; }

    // WICHTIG: "eingeloggterKunde" kommt schon aus header.jspf,
    // NICHT hier neu deklarieren.
%>

<% if (eingeloggterKunde == null) { %>
    <div class="confirmation-box">
        <h1>Bitte zuerst anmelden</h1>
        <p>Um zu bestellen, musst du eingeloggt sein.</p>
        <button class="btn-primary" onclick="openPopup('login-popup')">Anmelden</button>
    </div>
<% } else { %>

    <h1 style="text-align:center; margin-top:2rem;">Bestellung abschließen</h1>

    <form class="form-container" method="post" action="BestellungAppl.jsp">
        <input type="hidden" name="action" value="abschliessen">
        <input type="hidden" name="typ" value="<%= typ %>">
        <input type="hidden" name="waxstoffId" value="<%= waxstoffId %>">

        <p style="margin-bottom:1.5rem;">
            Bestellt als: <strong><%= eingeloggterKunde.getVorname() %> <%= eingeloggterKunde.getNachname() %></strong>
            (<%= eingeloggterKunde.getEmail() %>)
        </p>

        <div class="form-group">
            <label for="menge"><%= "fertig".equals(typ) ? "Anzahl (Stück)" : "Anzahl (m²)" %></label>
            <input type="number" id="menge" name="menge" value="1" min="1" required>
        </div>

        <div class="form-group">
            <label for="zahlungsmethode">Zahlungsmethode</label>
            <select id="zahlungsmethode" name="zahlungsmethode" required>
                <option value="Karte">Karte</option>
                <option value="PayPal">PayPal</option>
            </select>
        </div>

        <button type="submit" class="btn-primary" style="width:100%;">Jetzt bestellen</button>
    </form>

<% } %> 

<%@ include file="footer.jspf" %>