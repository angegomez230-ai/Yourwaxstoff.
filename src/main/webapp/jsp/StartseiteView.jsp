<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.WaxstoffBean" %>

<%-- ============================================================
     StartseiteView.jsp
     Das ist die Startseite/der Katalog - die erste Seite, die
     jeder Besucher sieht. Zeigt alle Waxstoffe als Karten-Raster,
     mit einer Filterleiste oben (Typ, Geschlecht, Sortierung).
     ============================================================ --%>

<%@ include file="header.jspf" %>
<%-- header.jspf bindet das <html>, <head> mit CSS-Link, und den
     Seiten-Header mit Navigation ein - so muss das nicht in jeder
     einzelnen Seite wiederholt werden. --%>
  
<%
    // Die Filterleiste sendet ihre Auswahl per GET-Parameter an
    // genau diese Seite zurück (siehe <form> weiter unten).
    // Beim ERSTEN Aufruf (noch nichts ausgewählt) sind alle drei
    // Parameter null - deshalb setzen wir hier sinnvolle Standardwerte.
    String typ = request.getParameter("typ");
    if (typ == null) { typ = "alle"; }

    String geschlecht = request.getParameter("geschlecht");
    if (geschlecht == null) { geschlecht = "alle"; }

    String sortierung = request.getParameter("sortierung");
    if (sortierung == null) { sortierung = "keine"; }
%>

<%-- Die Filterleiste: ein einfaches HTML-Formular mit method="get".
     "get" ist wichtig, weil dadurch die Auswahl als ?typ=...&geschlecht=...
     in der URL landet und die Seite sich einfach selbst neu lädt -
     kein JavaScript nötig. Die Ausgabe-Ausdrücke sorgen dafür,
     dass die aktuell gewählte Option nach dem Neuladen weiterhin
     als "selected" markiert bleibt (sonst würde die Auswahl beim
     Filtern immer wieder auf den ersten Eintrag zurückspringen). --%>
<form class="filter-bar" method="get" action="StartseiteView.jsp">
    <select name="typ">
        <option value="alle"     <%= "alle".equals(typ) ? "selected" : "" %>>Alle Artikel</option>
        <option value="waxstoff" <%= "waxstoff".equals(typ) ? "selected" : "" %>>Nur Waxstoffe</option>
        <option value="fertig"   <%= "fertig".equals(typ) ? "selected" : "" %>>Nur fertige Waxstoffe</option>
    </select>

    <select name="geschlecht">
        <option value="alle"   <%= "alle".equals(geschlecht) ? "selected" : "" %>>Alle</option>
        <option value="Herren" <%= "Herren".equals(geschlecht) ? "selected" : "" %>>Nur Herren</option>
        <option value="Damen"  <%= "Damen".equals(geschlecht) ? "selected" : "" %>>Nur Damen</option>
    </select>

    <select name="sortierung">
        <option value="keine"     <%= "keine".equals(sortierung) ? "selected" : "" %>>Sortierung</option>
        <option value="preisAsc"  <%= "preisAsc".equals(sortierung) ? "selected" : "" %>>Preis aufsteigend</option>
        <option value="preisDesc" <%= "preisDesc".equals(sortierung) ? "selected" : "" %>>Preis absteigend</option>
    </select>

    <button type="submit">Filtern</button>
</form>

<%
    // Hier passiert die eigentliche Arbeit: die JSP selbst enthält
    // KEINE Schleife über die Artikel! Stattdessen fragt sie das
    // WaxstoffBean, das die Datenbank abfragt und direkt fertiges
    // HTML (das komplette Karten-Raster) zurückgibt. Das entspricht
    // dem Vorlesungs-Prinzip "HTML-Erzeugung im Model" - so bleibt
    // die JSP schlank und fast java-code-frei.
    WaxstoffBean waxstoffBean = new WaxstoffBean();
    out.println(waxstoffBean.getKatalogAlsHtml(typ, geschlecht, sortierung));
%>

<%@ include file="footer.jspf" %>
<%-- footer.jspf bindet script.js ein und schliesst </body></html> --%>