<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.ModellBean" %>

<%-- ============================================================
     SchneidereiAuswahlView.jsp
     "Wie willst du gerne schneiden?" - zeigt die 8 festen
     Schneiderei-Modelle als ZWEI Spalten (Damen links, Herren
     rechts, je 4 Modelle). Echte MEHRFACHAUSWAHL per Checkbox:
     man kann z. B. ein Damen-Oberteil UND eine Herrenhose in
     derselben Bestellung ankreuzen. Zahlungsmethode wird direkt
     auf dieser Seite mit abgefragt - kein Zwischenschritt nötig.
     ============================================================ --%>

<%@ include file="header.jspf" %>

<%
    int waxstoffId = Integer.parseInt(request.getParameter("waxstoffId"));

    // Login ist Pflicht fürs Bestellen - ohne eingeloggten Kunden
    // zeigen wir nur einen Anmelden-Hinweis statt der Auswahl.
    Object eingeloggtesObjekt = session.getAttribute("eingeloggterKunde");
%>

<% if (eingeloggtesObjekt == null) { %>
    <div class="confirmation-box">
        <h1>Bitte zuerst anmelden</h1>
        <p>Um eine Schneiderei-Bestellung aufzugeben, musst du eingeloggt sein.</p>
        <button class="btn-primary" onclick="openPopup('login-popup')">Anmelden</button>
    </div>
<% } else { %>

    <h1 class="schneiderei-title">Wie willst du gerne schneiden?</h1>
    <p style="text-align:center; color:var(--color-text);">
        Du kannst mehrere Modelle gleichzeitig auswählen.
    </p>

    <form method="post" action="BestellungAppl.jsp" onsubmit="return pruefeMehrfachauswahl()">
        <input type="hidden" name="action" value="schneidereiBestellen">
        <input type="hidden" name="waxstoffId" value="<%= waxstoffId %>">

        <%
            // Baut beide Spalten (Damen/Herren) fertig als HTML,
            // jede Karte mit eigener Checkbox, Größenauswahl und
            // Mengenfeld.
            ModellBean modellBean = new ModellBean();
            out.println(modellBean.getModelleZweispaltigAlsHtml());
        %>

        <div class="form-container" style="max-width:400px;">
            <div class="form-group">
                <label for="zahlungsmethode">Zahlungsmethode</label>
                <select id="zahlungsmethode" name="zahlungsmethode" required>
                    <option value="Karte">Karte</option>
                    <option value="PayPal">PayPal</option>
                </select>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Jetzt bestellen</button>
        </div>
    </form>

<% } %>

<%@ include file="footer.jspf" %>