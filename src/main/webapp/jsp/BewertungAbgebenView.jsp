<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- ============================================================
     BewertungAbgebenView.jsp
     Bewertungsformular mit zwei Sterne-Skalen (Artikel und
     Bestellprozess) plus optionalem Kommentar. Die Sterne selbst
     sind reines HTML/CSS (Unicode-Sternsymbol &#9733;) - Klicks
     darauf ruft sterneSetzen() aus script.js auf.
     ============================================================ --%>

<%@ include file="header.jspf" %>

<%
    // Welche Position (= welcher gekaufte Artikel) bewertet wird,
    // kommt von der Bestellbestätigungsseite mit.
    String positionId = request.getParameter("positionId");
%>

<h1 style="text-align:center; margin-top:2rem;">Wie war dein Einkauf?</h1>

<form class="form-container" method="post" action="BewertungAppl.jsp">
    <input type="hidden" name="action" value="speichern">
    <input type="hidden" name="positionId" value="<%= positionId %>">

    <%-- Diese zwei Felder starten bei "0" und werden NICHT direkt
         vom Nutzer eingegeben - sterneSetzen() in script.js
         überschreibt ihren Wert, sobald auf einen Stern geklickt
         wird. Beim Absenden landet dann der zuletzt gesetzte Wert
         (1-5) im Controller. --%>
    <input type="hidden" name="artikelBewertungValue" id="artikelBewertungValue" value="0">
    <input type="hidden" name="bestellprozessBewertungValue" id="bestellprozessBewertungValue" value="0">

    <div class="form-group">
        <label>Wie war der Artikel?</label>
        <%-- id="artikelBewertung" muss zum ersten Parameter von
             sterneSetzen('artikelBewertung', ...) passen - so weiß
             script.js, welche Sterne-Gruppe gemeint ist und welches
             hidden-Feld (artikelBewertungValue) es befüllen soll. --%>
        <div class="star-rating" id="artikelBewertung">
            <span class="star" onclick="sterneSetzen('artikelBewertung', 1)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('artikelBewertung', 2)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('artikelBewertung', 3)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('artikelBewertung', 4)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('artikelBewertung', 5)">&#9733;</span>
        </div>
    </div>

    <div class="form-group">
        <label>Wie hast du den Bestellprozess gefunden?</label>
        <div class="star-rating" id="bestellprozessBewertung">
            <span class="star" onclick="sterneSetzen('bestellprozessBewertung', 1)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('bestellprozessBewertung', 2)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('bestellprozessBewertung', 3)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('bestellprozessBewertung', 4)">&#9733;</span>
            <span class="star" onclick="sterneSetzen('bestellprozessBewertung', 5)">&#9733;</span>
        </div>
    </div>

    <div class="form-group">
        <label for="kommentar">Kommentar (optional)</label>
        <textarea id="kommentar" name="kommentar" rows="4"></textarea>
    </div>

    <button type="submit" class="btn-primary" style="width:100%;">Bewertung abschicken</button>
</form>

<%@ include file="footer.jspf" %>