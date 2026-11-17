<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- ============================================================
     BestellBestaetigungView.jsp
     Letzte Seite des Bestellvorgangs: zeigt die Bestellnummer und
     bietet einen Link zur Bewertung an. Wird per response.sendRedirect()
     aus BestellungAppl.jsp aufgerufen (nicht per forward!) - das ist
     bewusst so gewählt, damit ein Neuladen der Seite (F5) NICHT
     versehentlich nochmal eine Bestellung auslöst
     (Post-Redirect-Get-Muster).
     ============================================================ --%>
  
<%@ include file="header.jspf" %>  

<%
    // Beide Werte kommen als normale URL-Parameter mit, weil der
    // Redirect eine komplett neue URL aufruft:
    // BestellBestaetigungView.jsp?bestellnummer=12&positionId=7
    String bestellnummer = request.getParameter("bestellnummer");
    String positionId = request.getParameter("positionId");
%>

<div class="confirmation-box">
    <h1>Bestellung erfolgreich!</h1>
    <p>Vielen Dank für deine Bestellung.</p>
    <div class="bestellnummer">Bestellnummer: WX-<%= bestellnummer %></div>

    <%-- positionId wird hier weitergereicht, damit die Bewertung auf
         der nächsten Seite genau diesem einen gekauften Artikel
         zugeordnet werden kann (siehe BEWERTUNG-Tabelle: sie
         referenziert position_id, nicht bestellung_id). --%>
    <a class="btn-primary" href="BewertungAbgebenView.jsp?positionId=<%= positionId %>">
        Jetzt bewerten
    </a>
    <br><br>
    <a class="btn-secondary" href="StartseiteView.jsp">Weiter einkaufen</a>
</div>

<%@ include file="footer.jspf" %>