<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="de.hwg_lu.bwi520.yourwaxstoff.beans.KundeBean" %>
<%
    // ============================================================
    // KundeAppl.jsp — Controller für Login, Registrierung und Logout.
    //
    // Drei mögliche "action"-Werte:
    //   login         -> prüft E-Mail+Passwort, legt Kunde in Session
    //   registrieren  -> legt neues Konto an, loggt danach direkt ein
    //   abmelden      -> entfernt den Kunden aus der Session
    // ============================================================
  
    String action = request.getParameter("action");

    if ("login".equals(action)) {
        String email = request.getParameter("email");
        String passwort = request.getParameter("passwort");

        KundeBean kundeBean = new KundeBean();
        boolean erfolgreich = kundeBean.pruefeLogin(email, passwort);

        if (erfolgreich) {
            session.setAttribute("eingeloggterKunde", kundeBean);
            response.sendRedirect("StartseiteView.jsp");
        } else {
            response.sendRedirect("StartseiteView.jsp?loginFehler=1");
        }

    } else if ("registrieren".equals(action)) {
        String email = request.getParameter("email");

        KundeBean kundeBean = new KundeBean();

        if (kundeBean.emailExistiertBereits(email)) {
            response.sendRedirect("StartseiteView.jsp?registrierungFehler=1");
        } else {
            kundeBean.setVorname(request.getParameter("vorname"));
            kundeBean.setNachname(request.getParameter("nachname"));
            kundeBean.setEmail(email);
            kundeBean.setPasswort(request.getParameter("passwort"));
            kundeBean.setAdresse(request.getParameter("adresse"));
            kundeBean.registriere();

            session.setAttribute("eingeloggterKunde", kundeBean);
            response.sendRedirect("StartseiteView.jsp");
        }

    } else if ("abmelden".equals(action)) {
        session.removeAttribute("eingeloggterKunde");
        response.sendRedirect("StartseiteView.jsp");

    } else if ("profilAktualisieren".equals(action)) {
        KundeBean eingeloggterKunde = (KundeBean) session.getAttribute("eingeloggterKunde");

        if (eingeloggterKunde == null) {
            response.sendRedirect("StartseiteView.jsp?bitteEinloggen=1");
        } else {
            eingeloggterKunde.setVorname(request.getParameter("vorname"));
            eingeloggterKunde.setNachname(request.getParameter("nachname"));
            eingeloggterKunde.setEmail(request.getParameter("email"));
            eingeloggterKunde.setAdresse(request.getParameter("adresse"));
            eingeloggterKunde.aktualisiereProfil();

            session.setAttribute("eingeloggterKunde", eingeloggterKunde);
            response.sendRedirect("KontoView.jsp?erfolgProfil=1");
        }

    } else if ("passwortAendern".equals(action)) {
        KundeBean eingeloggterKunde = (KundeBean) session.getAttribute("eingeloggterKunde");

        if (eingeloggterKunde == null) {
            response.sendRedirect("StartseiteView.jsp?bitteEinloggen=1");
        } else {
            String altesPasswort = request.getParameter("altesPasswort");
            String neuesPasswort = request.getParameter("neuesPasswort");
            boolean erfolgreich = eingeloggterKunde.passwortAendern(altesPasswort, neuesPasswort);

            if (erfolgreich) {
                response.sendRedirect("KontoView.jsp?erfolgPasswort=1");
            } else {
                response.sendRedirect("KontoView.jsp?falschesPasswort=1");
            }
        }
    }
%>