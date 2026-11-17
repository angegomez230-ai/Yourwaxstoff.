/* ============================================================
   Wax-Plattform — script.js
   Reines Vanilla-JS, bewusst einfach gehalten (kein Framework).
   Deckt drei Interaktionen ab: Schneiden-Popup, Modell-Auswahl,
   Sterne-Bewertung.
   ============================================================ */


/* ------------------------------------------------------------
   1. ALLGEMEINE POPUP-STEUERUNG
   Wiederverwendbar für jedes Popup mit der Klasse "popup-overlay"
   und "hidden" (siehe style.css).
   ------------------------------------------------------------ */

function openPopup(popupId) {
    var popup = document.getElementById(popupId);
    if (popup) {
        popup.classList.remove("hidden");
    }
}

function closePopup(popupId) {
    var popup = document.getElementById(popupId);
    if (popup) {
        popup.classList.add("hidden");
    }
}


/* ------------------------------------------------------------
   2. SCHNEIDEN-POPUP
   Wird auf ArtikelDetailView.jsp beim Bestellen-Button eines
   NORMALEN Waxstoffs (ist_fertig = false) aufgerufen.
   ------------------------------------------------------------ */

// Merkt sich, für welchen Waxstoff der Popup gerade offen ist
var aktuellerWaxstoffId = null;

function vorSchneidenFragen(waxstoffId) {
    aktuellerWaxstoffId = waxstoffId;
    openPopup("schneiden-popup");
}

// Antwort "Ja" -> Weiterleitung zur Schneiderei-Auswahlseite
function schneidenJa() {
    if (aktuellerWaxstoffId !== null) {
        window.location.href = "BestellungAppl.jsp?action=schneidereiAuswahl&waxstoffId=" + aktuellerWaxstoffId;
    }
}

// Antwort "Nein" -> Artikel direkt als Meterware bestellen
function schneidenNein() {
    if (aktuellerWaxstoffId !== null) {
        window.location.href = "BestellungAppl.jsp?action=waxstoffAuswaehlen&waxstoffId=" + aktuellerWaxstoffId;
    }
    closePopup("schneiden-popup");
}


/* ------------------------------------------------------------
   3. MODELL-MEHRFACHAUSWAHL (SchneidereiAuswahlView.jsp)
   Jedes Modell hat jetzt eine eigene Checkbox (statt nur eine Karte
   klickbar zu machen) - so können mehrere Modelle gleichzeitig
   bestellt werden.
   ------------------------------------------------------------ */

// Verhindert das Abschicken, solange KEIN Modell angekreuzt wurde
function pruefeMehrfachauswahl() {
    var checkboxen = document.querySelectorAll('input[type="checkbox"][name^="modell_check_"]');
    var mindestensEinsAusgewaehlt = false;

    for (var i = 0; i < checkboxen.length; i++) {
        if (checkboxen[i].checked) {
            mindestensEinsAusgewaehlt = true;
            break;
        }
    }

    if (!mindestensEinsAusgewaehlt) {
        alert("Bitte wähle mindestens ein Modell aus.");
        return false;
    }
    return true;
}

// Verhindert das Abschicken der Bewertung, solange nicht BEIDE
// Sterne-Gruppen angeklickt wurden (siehe BewertungAbgebenView.jsp).
// Ohne diese Prüfung bliebe ein Feld bei seinem Startwert "0" -
// das verletzt die CHECK-Regel in der Tabelle "bewertung"
// (Werte müssen zwischen 1 und 5 liegen).
function pruefeBewertungAusgefuellt() {
    var artikelWert = document.getElementById("artikelBewertungValue").value;
    var prozessWert = document.getElementById("bestellprozessBewertungValue").value;

    if (artikelWert === "0" || prozessWert === "0") {
        alert("Bitte vergib für beide Fragen mindestens 1 Stern.");
        return false;
    }
    return true;
}

// Prüft vor dem Absenden des Bestellformulars, ob eine gültige
// E-Mail-Adresse eingegeben wurde (siehe BestellFormularView.jsp).
function pruefeBestellformular() {
    var email = document.getElementById("email").value.trim();
    if (email === "" || email.indexOf("@") === -1) {
        alert("Bitte gib eine gültige E-Mail-Adresse ein.");
        return false;
    }
    return true;
}


/* ------------------------------------------------------------
   5. KONTO-MENÜ UND LOGIN/REGISTRIERUNG (header.jspf)
   ------------------------------------------------------------ */

// Öffnet/schließt das kleine Dropdown unter dem Kopf-Symbol
function toggleKontoMenu() {
    var dropdown = document.getElementById("konto-dropdown");
    if (dropdown) {
        dropdown.classList.toggle("hidden");
    }
}

// Für die Links "Anmelden"/"Registrieren" im Dropdown: Dropdown
// schließen UND das jeweilige Popup öffnen.
function closeDropdownAndOpenPopup(popupId) {
    var dropdown = document.getElementById("konto-dropdown");
    if (dropdown) {
        dropdown.classList.add("hidden");
    }
    openPopup(popupId);
}

// Prüft vor dem Absenden des Login-Formulars, ob eine gültige
// E-Mail eingegeben wurde (das eigentliche Passwort wird erst vom
// Server in KundeAppl.jsp geprüft, das kann JS ja nicht wissen).
function pruefeLoginFormular() {
    var email = document.getElementById("login-email").value.trim();
    if (email === "" || email.indexOf("@") === -1) {
        alert("Bitte gib eine gültige E-Mail-Adresse ein.");
        return false;
    }
    return true;
}

// Prüft vor dem Absenden der Registrierung: gültige E-Mail, und
// dass beide Passwort-Felder übereinstimmen (Tippfehler-Schutz).
function pruefeRegistrierungsformular() {
    var email = document.getElementById("reg-email").value.trim();
    if (email === "" || email.indexOf("@") === -1) {
        alert("Bitte gib eine gültige E-Mail-Adresse ein.");
        return false;
    }

    var passwort = document.getElementById("reg-passwort").value;
    var wiederholung = document.getElementById("reg-passwort-wiederholung").value;

    if (passwort.length < 4) {
        alert("Das Passwort sollte mindestens 4 Zeichen lang sein.");
        return false;
    }
    if (passwort !== wiederholung) {
        alert("Die beiden Passwörter stimmen nicht überein.");
        return false;
    }
    return true;
}


/* ------------------------------------------------------------
   4. STERNE-BEWERTUNG (BewertungAbgebenView.jsp)
   Zwei getrennte Sterne-Gruppen: Artikel-Bewertung und
   Bestellprozess-Bewertung. groupId = ID des umgebenden <div>.
   ------------------------------------------------------------ */

function sterneSetzen(groupId, wert) {
    var gruppe = document.getElementById(groupId);
    if (!gruppe) {
        return;
    }

    var sterne = gruppe.querySelectorAll(".star");
    for (var i = 0; i < sterne.length; i++) {
        if (i < wert) {
            sterne[i].classList.add("active");
        } else {
            sterne[i].classList.remove("active");
        }
    }

    // Wert im versteckten Formularfeld speichern
    // (Feld-ID = groupId + "Value", z. B. "artikelBewertungValue")
    var verstecktesFeld = document.getElementById(groupId + "Value");
    if (verstecktesFeld) {
        verstecktesFeld.value = wert;
    }
}