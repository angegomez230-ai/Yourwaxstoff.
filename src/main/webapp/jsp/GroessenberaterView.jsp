<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="header.jspf" %>
  
<%-- Rein statische Seite - dient nur der Orientierung, greift nicht
     auf die Datenbank zu (die "groesse"-Tabelle selbst enthält nur
      die Bezeichnungen XS-XXL, keine Maße - die stehen bewusst nur
     hier als Hilfetext, nicht in der DB). --%>
 
<div class="confirmation-box" style="text-align:left; max-width:700px;">
    <h1>Gr&ouml;&szlig;enberater</h1>
    <p>
        Unsicher, welche Größe zu dir passt? Hier eine grobe
        Orientierung anhand des Brustumfangs. Miss dazu am besten mit
        einem Maßband die breiteste Stelle deines Brustkorbs.
    </p>
 
    <table style="width:100%; border-collapse: collapse; margin-top: 1.5rem;">
        <thead>
            <tr style="border-bottom: 2px solid var(--color-primary);">
                <th style="text-align:left; padding: 0.6rem;">Größe</th>
                <th style="text-align:left; padding: 0.6rem;">Damen (Brustumfang)</th>
                <th style="text-align:left; padding: 0.6rem;">Herren (Brustumfang)</th>
            </tr>
        </thead>
        <tbody>
            <tr style="border-bottom: 1px solid var(--color-border);">
                <td style="padding: 0.6rem;"><strong>XS</strong></td>
                <td style="padding: 0.6rem;">78–82 cm</td>
                <td style="padding: 0.6rem;">86–90 cm</td>
            </tr>
            <tr style="border-bottom: 1px solid var(--color-border);">
                <td style="padding: 0.6rem;"><strong>S</strong></td>
                <td style="padding: 0.6rem;">82–86 cm</td>
                <td style="padding: 0.6rem;">90–94 cm</td>
            </tr>
            <tr style="border-bottom: 1px solid var(--color-border);">
                <td style="padding: 0.6rem;"><strong>M</strong></td>
                <td style="padding: 0.6rem;">86–90 cm</td>
                <td style="padding: 0.6rem;">94–98 cm</td>
            </tr>
            <tr style="border-bottom: 1px solid var(--color-border);">
                <td style="padding: 0.6rem;"><strong>L</strong></td>
                <td style="padding: 0.6rem;">90–96 cm</td>
                <td style="padding: 0.6rem;">98–104 cm</td>
            </tr>
            <tr style="border-bottom: 1px solid var(--color-border);">
                <td style="padding: 0.6rem;"><strong>XL</strong></td>
                <td style="padding: 0.6rem;">96–102 cm</td>
                <td style="padding: 0.6rem;">104–110 cm</td>
            </tr>
            <tr>
                <td style="padding: 0.6rem;"><strong>XXL</strong></td>
                <td style="padding: 0.6rem;">102–110 cm</td>
                <td style="padding: 0.6rem;">110–118 cm</td>
            </tr>
        </tbody>
    </table>

    <p style="margin-top:1.5rem; font-size:0.9rem; color:var(--color-text);">
        Hinweis: Diese Tabelle dient nur zur groben Orientierung. Bei
        Schneiderei-Bestellungen kannst du deine genauen Wünsche
        zusätzlich im Freitextfeld angeben.
    </p>
</div>

<%@ include file="footer.jspf" %>