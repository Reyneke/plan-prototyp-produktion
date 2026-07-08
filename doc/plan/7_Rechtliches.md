# 7. Rechtliche Anforderungen

Dieses Dokument erfasst alle rechtlichen Rahmenbedingungen, die für die Pizzeria "Pepe et Urinal" und die dazugehörige Webseite relevant sind. Die Recherche dient als Grundlage für die Umsetzung und soll potenzielle rechtliche Fallstricke frühzeitig identifizieren.

> **Hinweis:** Dieses Dokument ersetzt keine anwaltliche Beratung. Es handelt sich um eine Zusammenstellung typischer rechtlicher Anforderungen für Kleingewerbe-Webseiten in Deutschland.

---

## 1. Impressum (§ 5 TMG / § 55 RStV)

Jede geschäftsmäßige Webseite in Deutschland muss ein Impressum enthalten, das leicht erkennbar, unmittelbar erreichbar und ständig verfügbar ist.

### Pflichtangaben

| Angabe | Wert (fiktiv) |
|---|---|
| **Name des Betreibers** | Fran Jatzek |
| **Geschäftsanschrift** | Falkenseer Chaussee 127, 13589 Berlin |
| **Telefonnummer** | 030 / 12345678 |
| **E-Mail-Adresse** | info@pepe-et-urinal.de |
| **Umsatzsteuer-ID** | DE123456789 (wird vom Finanzamt vergeben) |
| **Handelsregister** | Nicht erforderlich (Kleingewerbe, kein eingetragenes Unternehmen) |
| **Zuständige Aufsichtsbehörde** | Bezirksamt Spandau, Ordnungsamt |
| **Berufsrechtliche Angaben** | Gaststättengewerbe nach GastG (Gaststättenerlaubnis erforderlich) |

### Umsetzung auf der Webseite

- **Position:** Fußzeile (Footer) aller Seiten
- **Link-Text:** „Impressum"
- **Erreichbarkeit:** Maximal 2 Klicks von jeder Seite aus
- **Strafen bei Fehlen:** Bußgeld bis zu 50.000 € möglich (bei Wettbewerbsverstößen sogar Abmahnungen)

---

## 2. Datenschutzerklärung (DSGVO / BDSG)

Die Webseite verarbeitet personenbezogene Daten (E-Mail-Adressen für Newsletter, Bestelldaten für Abholung). Daher ist eine **umfassende Datenschutzerklärung** nach Art. 13, 14 DSGVO erforderlich.

### Erforderliche Inhalte

| Punkt | Beschreibung |
|---|---|
| **Verantwortlicher** | Fran Jatzek (Name + Anschrift + Kontaktdaten) |
| **Zwecke der Verarbeitung** | Newsletter-Versand, Bestellabwicklung, Kontaktaufnahme |
| **Rechtsgrundlage** | Art. 6 Abs. 1 lit. a DSGVO (Einwilligung) für Newsletter; Art. 6 Abs. 1 lit. b DSGVO (Vertrag) für Bestellungen |
| **Empfänger der Daten** | Firebase (Google Cloud – US-Anbieter), Brevo/MailChimp (E-Mail-Dienst), ggf. Supabase |
| **Speicherdauer** | Bis zur Löschung des Accounts / Widerruf der Einwilligung |
| **Betroffenenrechte** | Auskunft, Berichtigung, Löschung, Einschränkung, Datenübertragbarkeit, Widerspruch |
| **Beschwerderecht** | Bei der Berliner Beauftragten für Datenschutz und Informationsfreiheit |
| **Bereitstellung der Daten** | Vertraglich erforderlich – ohne Angabe der E-Mail kein Newsletter |

### Besonderheiten

- **Firebase/Google:** Firebase ist ein US-Dienst. Der Einsatz erfordert **Standardvertragsklauseln (SCC)** mit Google – diese sind in den Firebase-AGB enthalten. Ein gesonderter **Auftragsverarbeitungsvertrag (AVV)** muss abgeschlossen werden (wird von Firebase bereitgestellt).
- **Brevo:** Brevo ist ein EU-Unternehmen (Frankreich) und speichert Daten in Frankfurt – datenschutzrechtlich unproblematischer.
- **Einwilligung:** Für den Newsletter ist eine aktive Einwilligung (Double-Opt-In) erforderlich – keine vorangekreuzten Checkboxen.

---

## 3. Cookie-Hinweis / Consent-Banner

### Notwendigkeit

- **Kein Cookie-Banner nötig, wenn:** Nur technisch notwendige Cookies (z. B. Session-Cookies für Firebase Auth) gesetzt werden – diese sind nach § 25 Abs. 2 TTDSG zulässig.
- **Cookie-Banner nötig, wenn:** Tracking-Cookies, Analytics (Google Analytics, Plausible) oder Marketing-Cookies gesetzt werden.

### Entscheidung für die Pizzeria

| Cookie-Typ | Verwendung | Banner nötig? |
|---|---|---|
| **Firebase Auth (Session)** | Login-Status für Admin | ❌ Nein (technisch notwendig) |
| **LocalStorage (Warenkorb)** | Shop-Warenkorb (clientseitig) | ❌ Nein (kein Cookie, nur LocalStorage) |
| **Plausible Analytics** | Besucherstatistik | ✅ Ja, wenn aktiviert (aber Plausible kommt ohne Cookies aus – Banner optional) |
| **Google Analytics** | Besucherstatistik | ✅ Ja, zwingend |

### Empfehlung

- **Verwendung von Plausible (oder Umami)** – diese Analytics-Tools benötigen keine Cookies und sind DSGVO-konform ohne Banner nutzbar.
- Falls doch ein Banner benötigt wird: Open-Source-Lösungen wie **Cookiebot** oder **Klaro** (kostenlos für kleine Webseiten) verwenden.

---

## 4. Auftragsverarbeitungsverträge (AVV)

Gemäß Art. 28 DSGVO muss mit jedem Dienstleister, der personenbezogene Daten verarbeitet, ein Auftragsverarbeitungsvertrag abgeschlossen werden.

### Übersicht

| Dienstleister | AVV vorhanden? | Hinweis |
|---|---|---|
| **Firebase (Google Cloud)** | ✅ Wird von Google standardmäßig angeboten (im Firebase Console aktivierbar) | Standardvertragsklauseln (SCC) enthalten |
| **Brevo / Sendinblue** | ✅ Wird von Brevo bereitgestellt (EU-Standard) | EU-Unternehmen, Server in Frankfurt |
| **MailChimp** | ✅ Wird von MailChimp bereitgestellt | US-Unternehmen – SCC erforderlich |
| **Supabase** | ✅ Wird von Supabase bereitgestellt | SCC verfügbar |
| **GitHub** | ✅ Wird von GitHub/Microsoft bereitgestellt | Für Code-Hosting, nicht für personenbezogene Daten |

### Relevanz für Fran

- Fran müsste diese Verträge nicht selbst abschließen – das übernimmt der Entwickler im Rahmen der Projekteinrichtung.
- Die AVVs gelten als abgeschlossen, sobald der Dienst genutzt wird (bei Firebase z. B. durch Aktivierung der Firebase-Sicherheitsregeln).

---

## 5. E-Commerce / Fernabsatzrecht

Die Pizzeria bietet keine Lieferung an, sondern nur Abholung. Daher gelten **eingeschränkte** Fernabsatzregeln.

### Relevanz

| Rechtsbereich | Relevant? | Begründung |
|---|---|---|
| **Fernabsatzrecht (§ 312b BGB)** | ⚠️ Teilweise | Kunde bestellt online, holt aber vor Ort ab → hybrid |
| **Widerrufsrecht (§ 355 BGB)** | ⚠️ Teilweise | Bei Lebensmitteln (Frischwaren) gilt kein Widerrufsrecht (§ 312g Abs. 2 BGB) |
| **Preisangabenverordnung (PAngV)** | ✅ Ja | Preise müssen klar und deutlich angegeben werden (inkl. Mehrwertsteuer) |
| **Lebensmittel-Informationsverordnung (LMIV)** | ✅ Ja | Allergene, Zutatenliste, Nährwertangaben müssen ersichtlich sein |

### Konsequenzen

1. **Kein Widerrufsrecht** – Die pizza wird frisch zubereitet, ist also nicht widerrufbar. Ein Hinweis auf das fehlende Widerrufsrecht muss in den AGB/der Bestellseite stehen.
2. **Preise inkl. MwSt.** – Alle Preise auf der Webseite müssen als Bruttopreise (inkl. 19% MwSt.) ausgewiesen sein.
3. **Allergene** – Die Speisekarte muss einen Hinweis enthalten, wo Allergene eingesehen werden können (z. B. „Allergene auf Nachfrage" oder als PDF-Link).

---

## 6. Allgemeine Geschäftsbedingungen (AGB)

Für die Bestellseite sind AGB erforderlich, auch wenn nur Abholung angeboten wird.

### Minimal-AGB für die Pizzeria

| Klausel | Inhalt |
|---|---|
| **Vertragsschluss** | Mit Klick auf „Bestellung aufgeben" gibt der Kunde ein verbindliches Angebot ab. Fran bestätigt die Bestellung per E-Mail. Der Vertrag kommt mit der Bestätigung zustande. |
| **Preise** | Alle Preise in Euro inkl. gesetzlicher Mehrwertsteuer. |
| **Abholung** | Die Bestellung muss zum gewählten Zeitfenster abgeholt werden. Bei Nichtabholung verfällt der Anspruch (keine Rückerstattung – entfällt, da keine Bezahlung online). |
| **Haftung** | Fran haftet nur für grobe Fahrlässigkeit (Standardklausel für Kleinunternehmen). |
| **Datenschutz** | Verweis auf die Datenschutzerklärung. |
| **Salvatorische Klausel** | Sollte eine Klausel unwirksam sein, bleibt der Rest des Vertrags gültig. |

### Umsetzung

- AGB werden als eigener Menüpunkt im Footer verlinkt (neben Impressum und Datenschutz).
- Der Kunde akzeptiert die AGB beim Absenden der Bestellung (Checkbox – darf nicht vorangekreuzt sein).

---

## 7. Domain & Hosting

| Aspekt | Anforderung |
|---|---|
| **Domain-Whitelist** | Bei der Domain-Registrierung wird die Adresse von Fran öffentlich (Whois-Daten) – wer möchte, dass seine Daten nicht sichtbar sind, kann eine **Whois-Sperre** (Domain-Privacy) bestellen (ca. 2–5 €/Jahr extra) |
| **Hosting-Standort** | Firebase Hosting nutzt Google-Cloud-Server – Standort kann auf EU-Region (z. B. Frankfurt) eingestellt werden |
| **SSL-Zertifikat** | Firebase Hosting stellt automatisch ein SSL-Zertifikat (Let's Encrypt) aus – HTTPS ist verpflichtend für DSGVO-konforme Webseiten |

---

## 8. Urheberrecht & Bildmaterial

| Quelle | Lizenz | Hinweis |
|---|---|---|
| **Stock-Fotos (Unsplash/Pexels)** | CC0 / Unsplash-Lizenz | Keine Namensnennung nötig – aber keine geschützten Marken abbilden |
| **Eigene Fotos (Fran's Handy)** | Keine Lizenz nötig (Eigenwerk) | Qualität kann schlecht sein – lieber Stock-Fotos verwenden |
| **Logo „Pepe et Urinal"** | Wird vom Entwickler erstellt | Urheberrecht verbleibt beim Entwickler (einfaches Nutzungsrecht für Fran) |
| **Schriftarten (Google Fonts)** | Open-Source (OFL-Lizenz) | Datenschutz: Google Fonts lokal einbinden (nicht via API laden, sonst DSGVO-Problem) |

---

## 9. Besonderheiten bei Firebase / US-Diensten

### Privacy-Shield / EU-US Data Transfer Framework

- **Altes Privacy-Shield:** 2020 vom EuGH für ungültig erklärt („Schrems-II-Urteil").
- **Neues EU-US Data Privacy Framework (DPF):** Seit Juli 2023 in Kraft – Firebase (Google) ist zertifiziert.
- **Bedeutung für Fran:** Solange Google am DPF teilnimmt, ist der Datentransfer in die USA legal. Google muss die DPF-Zertifizierung aufrechterhalten.

### Empfehlung

- **Supabase als Alternative** – Supabase hostet in der EU (z. B. Frankfurt oder Stockholm) und vermeidet das US-Datenproblem vollständig.
- Falls Firebase verwendet wird: Hinweis in der Datenschutzerklärung, dass Daten in die USA übermittelt werden können (Standardvertragsklauseln + DPF).

---

## 10. Checkliste für die Umsetzung

- [ ] **Impressum** – Ins Footer eingebaut, alle Pflichtangaben enthalten (Name, Anschrift, Telefon, E-Mail)
- [ ] **Datenschutzerklärung** – Umfassend, mit allen Verarbeitungszwecken und Dienstleistern
- [ ] **AVV (Auftragsverarbeitung)** – Mit Firebase, Brevo/MailChimp, ggf. Supabase abgeschlossen
- [ ] **Cookie-Banner** – Nur nötig, wenn Analytics mit Cookies verwendet wird (Plausible/Umami optional)
- [ ] **AGB** – Mit Widerrufsbelehrung (Hinweis auf fehlendes Widerrufsrecht bei Lebensmitteln)
- [ ] **Allergene** – Hinweis in der Speisekarte (als PDF-Link oder Text)
- [ ] **Preisangabe** – Alle Preise inkl. MwSt., klar lesbar
- [ ] **SSL/HTTPS** – Automatisch durch Firebase Hosting
- [ ] **Google Fonts** – Lokal einbinden (nicht per API)
- [ ] **Bildmaterial** – Nur lizenzfreie Bilder (Unsplash/Pexels) oder Eigenwerke verwenden

---

## 11. Kosten für rechtliche Absicherung

| Posten | Kosten | Hinweis |
|---|---|---|
| **Datenschutzerklärung (Generator)** | 0–50 € | Z. B. eRecht24 oder Datenschutz-Generator (DSGVO-konform) |
| **Impressum** | 0 € | Selbst erstellt |
| **AGB (Vorlage)** | 0–30 € | Z. B. von der IHK oder Online-Generator |
| **AVV (Firebase/Supabase)** | 0 € | Vom Dienstleister bereitgestellt |
| **Anwaltliche Prüfung (optional)** | 150–300 € | Nur empfohlen, wenn Fran rechtlich auf Nummer sicher gehen will |

**Gesamt (Minimal):** 0 € (alles selbst erstellt mit DSGVO-konformen Vorlagen)  
**Gesamt (mit Generatoren):** Ca. 50–80 € einmalig

---

*// Weiter ausarbeiten und ergänzen – insbesondere, wenn sich die Technologiewahl ändert (z. B. Wechsel von Firebase zu Supabase). Dieses Dokument dient als rechtliche Recherchegrundlage für die Projektplanung.*