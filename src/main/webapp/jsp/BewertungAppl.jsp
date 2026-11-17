<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.BewertungBean" %>
<%
    // ============================================================
    // BewertungAppl.jsp — Controller zum Speichern einer Bewertung.
    // Kommt per POST von BewertungAbgebenView.jsp.
    // ============================================================

    String action = request.getParameter("action"); 

    if ("speichern".equals(action)) {
        // Alle Werte aus dem Formular (siehe BewertungAbgebenView.jsp)
        // in ein neues Bean-Objekt füllen und in einem Rutsch
        // speichern lassen - speichereBewertung() macht das INSERT.
        BewertungBean bewertungBean = new BewertungBean();
        bewertungBean.setPositionId(Integer.parseInt(request.getParameter("positionId")));
        bewertungBean.setArtikelBewertung(Integer.parseInt(request.getParameter("artikelBewertungValue")));
        bewertungBean.setBestellprozessBewertung(Integer.parseInt(request.getParameter("bestellprozessBewertungValue")));
        bewertungBean.setKommentar(request.getParameter("kommentar"));
        bewertungBean.speichereBewertung();
%>
        <%-- Anders als bei BestellungAppl.jsp zeigen wir hier direkt
             eine kleine Erfolgsmeldung an, statt weiterzuleiten -
             deshalb wird header.jspf/footer.jspf erst HIER, INNERHALB
             des if-Blocks eingebunden (nur wenn wirklich gespeichert
             wurde, gibt es überhaupt eine Seite zum Anzeigen). --%>
<%@ include file="header.jspf" %>
        <div class="confirmation-box">
            <h1>Danke für deine Bewertung!</h1>
            <a class="btn-primary" href="StartseiteView.jsp">Zurück zur Startseite</a>
        </div>
<%@ include file="footer.jspf" %>
<%
    }
%>