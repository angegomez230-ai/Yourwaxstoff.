<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.KundeBean" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.BestellungBean" %>

<%-- ============================================================
     KontoView.jsp
     Konto-Seite: Bestellhistorie ansehen, Name/E-Mail/Adresse
     ändern, Passwort ändern. Erreichbar über "Mein Konto" im
     Kopf-Dropdown (siehe header.jspf), nur wenn eingeloggt.
     ============================================================ --%>

<%@ include file="header.jspf" %>



<% if (eingeloggterKunde == null) { %>
    <div class="confirmation-box">
        <h1>Bitte zuerst anmelden</h1>
        <button class="btn-primary" onclick="openPopup('login-popup')">Anmelden</button>
    </div>
<% } else { %>

    <h1 style="text-align:center; margin-top:2rem;">Mein Konto</h1>

    <%-- Erfolgs-/Fehlermeldungen nach einer Änderung (siehe KundeAppl.jsp) --%>
    <% if ("1".equals(request.getParameter("erfolgProfil"))) { %>
        <p style="text-align:center; color: var(--color-primary); font-weight:600;">
            Deine Daten wurden aktualisiert.
        </p>
    <% } %>
    <% if ("1".equals(request.getParameter("erfolgPasswort"))) { %>
        <p style="text-align:center; color: var(--color-primary); font-weight:600;">
            Dein Passwort wurde geändert.
        </p>
    <% } %>
    <% if ("1".equals(request.getParameter("falschesPasswort"))) { %>
        <p style="text-align:center; color: var(--color-primary); font-weight:600;">
            Das alte Passwort war nicht korrekt.
        </p>
    <% } %>

    <%-- ========================================================
         Block 1: Persönliche Daten ändern
         ======================================================== --%>
    <h2 style="margin: 2rem 2rem 0;">Meine Daten</h2>
    <form class="form-container" method="post" action="KundeAppl.jsp">
        <input type="hidden" name="action" value="profilAktualisieren">

        <div class="form-group">
            <label for="vorname">Vorname</label>
            <input type="text" id="vorname" name="vorname" value="<%= eingeloggterKunde.getVorname() %>" required>
        </div>
        <div class="form-group">
            <label for="nachname">Nachname</label>
            <input type="text" id="nachname" name="nachname" value="<%= eingeloggterKunde.getNachname() %>" required>
        </div>
        <div class="form-group">
            <label for="email">E-Mail</label>
            <input type="email" id="email" name="email" value="<%= eingeloggterKunde.getEmail() %>" required>
        </div>
        <div class="form-group">
            <label for="adresse">Adresse</label>
            <input type="text" id="adresse" name="adresse" value="<%= eingeloggterKunde.getAdresse() %>" required>
        </div>

        <button type="submit" class="btn-primary" style="width:100%;">Speichern</button>
    </form>

    <%-- ========================================================
         Block 2: Passwort ändern
         ======================================================== --%>
    <h2 style="margin: 2rem 2rem 0;">Passwort ändern</h2>
    <form class="form-container" method="post" action="KundeAppl.jsp">
        <input type="hidden" name="action" value="passwortAendern">

        <div class="form-group">
            <label for="altesPasswort">Aktuelles Passwort</label>
            <input type="password" id="altesPasswort" name="altesPasswort" required>
        </div>
        <div class="form-group">
            <label for="neuesPasswort">Neues Passwort</label>
            <input type="password" id="neuesPasswort" name="neuesPasswort" required>
        </div>

        <button type="submit" class="btn-primary" style="width:100%;">Passwort ändern</button>
    </form>

    <%-- ========================================================
         Block 3: Bestellhistorie
         ======================================================== --%>
    <h2 style="margin: 2rem 2rem 0;">Meine Bestellungen</h2>
    <div class="confirmation-box" style="text-align:left;">
        <%
            // Genau wie beim Katalog: das Bean baut die komplette
            // Liste als HTML, keine Schleife hier in der JSP nötig.
            BestellungBean bestellungBean = new BestellungBean();
            out.println(bestellungBean.getBestellungenFuerKundeAlsHtml(eingeloggterKunde.getKundeId()));
        %>
    </div>

<% } %>

<%@ include file="footer.jspf" %>