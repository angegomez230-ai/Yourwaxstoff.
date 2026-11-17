<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.WaxstoffBean" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.BewertungBean" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.KundeBean" %>


  
<%@ include file="header.jspf" %>
  


<% if (!gefunden) { %>
    <%-- Fallback, falls die ID nicht existiert - verhindert eine
         hässliche Fehlerseite und zeigt stattdessen eine klare Meldung. --%>
    <p style="padding:2rem;">Dieser Artikel wurde nicht gefunden.</p>
<% } else { %>

    <%-- Ab hier: der Artikel wurde gefunden, also zeigen wir ihn an.
         Zweispaltiges Layout (siehe .detail-page in style.css):
         links das große Bild, rechts alle Informationen. --%>
    <div class="detail-page">
        <div class="image-col">
            <img src="../<%= waxstoffBean.getBildPfad() %>" alt="<%= waxstoffBean.getName() %>">
        </div>
        <div class="info-col">
            <h1><%= waxstoffBean.getName() %></h1>
            <p class="beschreibung"><%= waxstoffBean.getBeschreibung() %></p>

            <%-- Die drei Zusatzinfos aus dem Team-Feedback (Material,
                 Pflegehinweis, Herkunft) - einfache zusätzliche Textzeilen,
                 keine eigene Tabelle nötig. --%>
            <p class="ts"><strong>Material:</strong> <%= waxstoffBean.getMaterial() %></p>
            <p class="ts"><strong>Pflegehinweis:</strong> <%= waxstoffBean.getPflegehinweis() %></p>
            <p class="ts"><strong>Herkunft:</strong> <%= waxstoffBean.getHerkunft() %></p>
            <div class="price"><%= waxstoffBean.getPreis() %> €</div>

            <%-- HIER trennen sich die Wege, je nachdem ob es sich um
                 ein fertiges Kleidungsstück oder Meterware handelt
                 (siehe Projektkonzept.md Kapitel 3) - UND ob der
                 Besucher eingeloggt ist (seit der Login-Pflicht): --%>
            <% if (eingeloggterKunde == null) { %>
                <%-- Nicht eingeloggt: kein Bestellen möglich, nur
                     ein Button, der das Login-Popup öffnet. --%>
                <button class="btn-primary" onclick="openPopup('login-popup')">
                    Zum Bestellen anmelden
                </button>
            <% } else if (waxstoffBean.isIstFertig()) { %>
                <%-- Fertiges Kleidungsstück: die Größe steht schon fest
                     (siehe groesse_id in der waxstoff-Tabelle), also
                     reicht ein einfacher Link direkt zum Controller -
                     kein Popup, keine weitere Auswahl nötig. --%>
                <a class="btn-primary" href="BestellungAppl.jsp?action=fertigAuswaehlen&waxstoffId=<%= waxstoffId %>">
                    Bestellen
                </a>
            <% } else { %>
                <%-- Normaler Waxstoff (Meterware): hier MUSS erst
                     gefragt werden, ob der Stoff genäht werden soll.
                     Der Button ruft nur die JavaScript-Funktion
                     vorSchneidenFragen() aus script.js auf, die das
                     Popup ganz unten in dieser Seite öffnet - es
                     passiert also (noch) gar nichts auf Server-Seite. --%>
                <button class="btn-primary" onclick="vorSchneidenFragen(<%= waxstoffId %>)">
                    Bestellen
                </button>
            <% } %>

            <h2 style="margin-top:2rem;">Bewertungen</h2>
            <%
                // Genau wie beim Katalog: das Bean baut das komplette
                // HTML für die Bewertungsliste selbst, die JSP muss
                // nicht über die Ergebnisse loopen.
                BewertungBean bewertungBean = new BewertungBean();
                out.println(bewertungBean.getBewertungenAlsHtml("waxstoff", waxstoffId));
            %>
        </div>
    </div>

<% } %>

<%-- ============================================================
     Das Schneiden-Popup selbst. Es steht die ganze Zeit im HTML,
     ist aber standardmäßig unsichtbar (Klasse "hidden" in
     style.css setzt display:none). vorSchneidenFragen() aus
     script.js entfernt diese Klasse und macht es sichtbar.
     Die zwei Buttons rufen schneidenJa()/schneidenNein() auf,
     die dann zum passenden Controller-Aufruf weiterleiten.
     ============================================================ --%>
<div id="schneiden-popup" class="popup-overlay hidden">
    <div class="popup-box">
        <h2>Willst du das schneiden lassen?</h2>
        <div class="popup-actions">
            <button class="btn-primary" onclick="schneidenJa()">Ja</button>
            <button class="btn-secondary" onclick="schneidenNein()">Nein</button>
        </div>
    </div>
</div>

<%@ include file="footer.jspf" %>
