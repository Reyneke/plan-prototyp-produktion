# 6. Pizzeria-Modell: "Pizzeria Pepe et Urinal"

Basierend auf allen bisherigen Anforderungen (1_Grundlegendes, 2_Funktionale Anforderungen, 3_Rahmenbedingungen, 4_Hauptanforderungen) und der Kundenbeschreibung (5_Kunde) entsteht hier ein konkretes Modell der Pizzeria.

---

## 1. Standort (fiktiv, aber realitätsnah)

**Bezirk:** Berlin-Spandau  
**Stadtteil:** Falkenhagener Feld (oder ein vergleichbarer Stadtteil mit günstigen Gewerbemieten)  
**Adresse (fiktiv):** Falkenseer Chaussee 127, 13589 Berlin

### Warum dieser Standort?

| Kriterium | Bewertung |
|---|---|
| **Mietkosten** | Günstige Nebenlage – ca. 8–10 €/m² statt 15–20 €/m² in der Altstadt |
| **Laufkundschaft** | Nahversorgungszentrum mit Schule (Falken-Gymnasium), Jugendclub und Bushaltestelle in direkter Umgebung |
| **Wettbewerb** | Wenige Pizzerien in direkter Umgebung – zwei Dönerläden, ein Asia-Imbiss, aber keine klassische Pizzeria |
| **Erreichbarkeit** | Bushaltestelle vor der Tür (Buslinien X33, M37) – keine U-Bahn, aber gute Busanbindung in die Spandauer Innenstadt |
| **Parkplätze** | Kostenlose Parkplätze am Straßenrand – wichtig für Abholkunden |

### Lokal-Beschreibung

- **Größe:** ca. 60–70 m² (klein, aber ausreichend)
- **Aufteilung:**
  - **Verkaufs-/Thekenbereich:** 25 m² (Theke, Pizza-Auslage, Kasse, Bestellterminal)
  - **Küche:** 20 m² (Pizzaofen, Vorbereitungstische, Kühlung)
  - **Sitzbereich:** 15 m² (5–6 kleine Tische für Gäste, die vor Ort essen)
  - **Lager/WC:** 5–10 m²
- **Zustand:** Renovierungsbedürftig – Fran kann den Vormieter-Zustand günstig übernehmen (ehemaliger Imbiss)

---

## 2. Außenauftritt & Ladenlokal

### Schaufenster

- Große Schaufensterfront zur Straße hin – einsehbar von der Bushaltestelle
- **Beschriftung:** "Pizzeria Pepe et Urinal" (schlicht, aber auffällig)
- **Angebotstafel:** Im Schaufenster hängt eine laminierte Speisekarte (A2-Format) – Passanten können Preise sehen, ohne einzutreten
- **Öffnungszeiten (Klebefolie auf der Tür):**
  - Mo–Sa: 11:00 – 22:00 Uhr
  - So: 14:00 – 21:00 Uhr

### Außenbereich

- Kein eigener Biergarten (zu teuer, zu aufwändig)
- Aber: 2–3 Stehtische draußen (zur Saison), die bei Bedarf hereingeholt werden können

---

## 3. Innenraum & Atmosphäre

### Design

| Element | Beschreibung |
|---|---|
| **Farbkonzept** | Rot-Weiß (klassische Pizzeria-Optik) – rote Tischdecken, weiße Wände |
| **Beleuchtung** | Helle Deckenleuchten (keine Stimmungslampen – Fran will es funktional) |
| **Dekoration** | Sparsam: 2–3 Italien-Poster an der Wand, eine Pflanze (Kunstpflanze, weil Fran keine Zeit für Gießen hat) |
| **Musik** | Radio läuft leise im Hintergrund (keine eigenen Playlists – Fran hat keinen Spotify-Account) |
| **Sitzplätze** | 12–15 Plätze (innen); 6–8 Plätze (draußen, optional) |

### Theke / Bestellbereich

- Große Edelstahl-Theke mit Glasaufsatz – die Pizza kann in der Auslage präsentiert werden
- **Bestellterminal:** Ein älterer Tablet-Ständer (Fran's privates, altes iPad) – darauf läuft die Webseite der Pizzeria im Kiosk-Modus
- **Kasse:** Ein einfaches Kassensystem (Bargeldbasis) – keine Integration in die Webseite

---

## 4. Speisekarte (digital & analog)

### Pizzeria-Konzept

- **Fokus:** Klassische italienische Pizza (Neapolitanischer Stil) – günstig, aber mit guten Zutaten
- **Zusatzangebote:** Pasta, Salate, Getränke (Softdrinks, Wasser, Bier)
- **Keine Lieferung:** Nur Abholung ("Take-Away") und Vor-Ort-Verzehr
- **Preispunkt:** Günstig – Pizza ab 4,50 €, Pasta ab 5,50 €

### Menü-Struktur (für die Website)

| Kategorie | Beispiele | Preisspanne |
|---|---|---|
| **Pizza Klassisch** | Margherita, Salami, Funghi, Prosciutto | 4,50 € – 6,50 € |
| **Pizza Spezial** | Pepe (Salami + Peperoni), Urinal (4 Käsesorten), Calzone | 6,50 € – 8,50 € |
| **Pasta** | Spaghetti Bolognese, Penne Arrabbiata, Tagliatelle Carbonara | 5,50 € – 7,50 € |
| **Salate** | Insalata Mista, Caprese, Caesar | 4,00 € – 6,00 € |
| **Getränke** | Cola, Fanta, Wasser (0,5l), Bier (0,33l) | 2,00 € – 3,50 € |
| **Beilagen** | Knoblauchbrot, Pommes, Oliven | 2,00 € – 3,50 € |

### Besonderheiten der Speisekarte

- **Vegetarisch/Vegan:** Mindestens 3 Optionen pro Kategorie (Fran hat gemerkt, dass Jugendliche darauf achten)
- **Allergene:** In der Fußnote der Speisekarte aufgeführt – als PDF hinterlegt, nicht als Datenbank (zu aufwändig)
- **Tagesgerichte:** Werden auf einer Tafel hinter der Theke notiert und optional in der Website als "Tagesgericht des Tages" eingepflegt

---

## 5. Technische Ausstattung vor Ort

| Gerät | Nutzung | Kosten |
|---|---|---|
| **Router (DSL)** | Bestehender DSL-Anschluss des Vormieters (16.000–50.000er Leitung) | Ca. 25 €/Monat (privat, nicht Teil des IT-Budgets) |
| **Altes iPad (Fran's)** | Zeigt die Website im Kiosk-Modus an der Theke | Bereits vorhanden (keine Anschaffungskosten) |
| **Drucker (Bon)** | Quittungsdrucker für Bestellungen | Ca. 80 € einmalig (Fran's Budget) |
| **Kassenlade** | Bargeldverwaltung | Ca. 50 € einmalig (Fran's Budget) |

### Internetanbindung

- **DSL 16.000** (Vormieter-Leitung) – ausreichend für die Webseiten-Administration
- **WLAN:** Gast-WLAN gibt es nicht (Fran: "Dann sitzen die hier nur rum und saufen mein Internet")

---

## 6. Bestellprozess (aus Fran's Sicht)

### Ablauf: Online-Bestellung

```
[Kunde]            [Website]            [Admin-Dashboard]     [Fran]
   |                   |                       |                 |
   |--> Pizza wählen   |                       |                 |
   |--> Warenkorb      |                       |                 |
   |--> Bestellung aufgeben                    |                 |
   |                   |---> Neue Bestellung --|                 |
   |                   |                       |---> Push/Alert -|
   |                   |                       |                 |--> Pizza
   |                   |                       |                 |--> zubereiten
   |                   |                       |                 |
   |<-- Bestätigung ---|                       |                 |
   |                   |                       |                 |--> Bereit-
   |                   |                       |                 |--> stellung
   |<-- "Bereit"-Mail -|                       |                 |
   |                   |                       |                 |
```

### Wichtige Details

- **Keine Online-Zahlung** – Bezahlung erfolgt bei Abholung (Bar oder Karte vor Ort)
- **Bestätigung:** Kunde erhält eine E-Mail (automatisch via Firebase Cloud Function oder Brevo-API)
- **Bereit-Meldung:** Fran klickt im Admin-Dashboard auf "Bereit zur Abholung" → Kunde bekommt E-Mail
- **Abholfenster:** Kunde wählt einen 30-Minuten-Zeitslot (z. B. 18:00–18:30)

---

## 7. Öffnungszeiten & Personal

| Tag | Öffnungszeit | Personal |
|---|---|---|
| Montag – Freitag | 11:00 – 22:00 Uhr | Fran + 1 Aushilfe (Schüler/Student) |
| Samstag | 11:00 – 22:00 Uhr | Fran + 1 Aushilfe |
| Sonntag | 14:00 – 21:00 Uhr | Fran allein (ruhiger Tag) |

### Personalstruktur

- **Fran Jatzek (Inhaber):** Küche + Theke + Administration (Webseite, Buchhaltung)
- **Aushilfe 1 (Teilzeit):** Bedienung, Abholungskoordination, einfache Küchenarbeit
- **Aushilfe 2 (Minijob):** Samstags-Unterstützung

---

## 8. Marketing & Reichweite (analog)

Da Fran keine laufenden Kosten für Werbung bezahlen will, setzt er auf:

| Maßnahme | Kosten | Beschreibung |
|---|---|---|
| **Flyer** | 30 € (Druckerei, 500 Stück) | Wird an der Schule und im Jugendclub verteilt |
| **Mundpropaganda** | 0 € | Fran hofft auf die Jugendlichen – "wenn's schmeckt, sagen sie's weiter" |
| **Google Maps** | 0 € | Fran trägt die Pizzeria selbst bei Google Maps ein |
| **Instagram (optional)** | 0 € | Aushilfe macht 1x pro Woche ein Foto der Tagesgerichte (auf Fran's altem Smartphone) |
| **Website** | 0 € (Hosting inkl. Domain ist im Projektbudget) | Die Bestell-Webseite ist das zentrale Marketing-Tool |

---

## 9. Verbindung zu den Projektanforderungen

### Abgleich mit funktionalen Anforderungen (FA-01 bis FA-04)

| Anforderung | Relevanz für die Pizzeria |
|---|---|
| **FA-01: CMS** | Fran pflegt die Speisekarte und Tagesgerichte im Admin-Dashboard (statt HTML zu bearbeiten) |
| **FA-02: CRM** | Newsletter für Stammkunden (z. B. "Diese Woche: Pizza + Getränk für 6 €") |
| **FA-03: Shop** | Die Speisekarte wird als Produktkatalog abgebildet; Bestellungen landen im Admin-Dashboard |
| **FA-04: User-Login** | Fran hat einen Admin-Zugang; die Jugendlichen brauchen keinen Login (Gastbestellung) |

### Abgleich mit Hauptanforderungen (4_Hauptanforderungen)

| Hauptanforderung | Umsetzung in der Pizzeria |
|---|---|
| **Stabilität** | Die Bestellseite muss zu Stoßzeiten (11–13 Uhr und 17–20 Uhr) zuverlässig laufen |
| **Erweiterbarkeit** | Falls Fran später doch Lieferung anbieten will, muss der Bestellprozess erweiterbar sein |
| **Dokumentation** | Fran wird die Seite nicht selbst warten – die Dokumentation muss so gut sein, dass die Aushilfe oder ein späterer Entwickler sie versteht |

---

## 10. Zusammenfassung: Die Pizzeria in Zahlen

| Kennzahl | Wert |
|---|---|
| **Ladengröße** | 60–70 m² |
| **Sitzplätze (innen)** | 12–15 |
| **Sitzplätze (außen)** | 6–8 (saisonal) |
| **Mitarbeiter** | 1 Inhaber + 1–2 Aushilfen |
| **Pizza-Preis (günstigste)** | 4,50 € |
| **Pizza-Preis (teuerste)** | 8,50 € |
| **Öffnungstage** | 7 Tage/Woche |
| **Bestellplattform** | Eigene Webseite (kein Lieferando) |
| **Monatliche IT-Kosten** | 0 € (Hosting inkl.) |
| **Website-Erstellung** | 500–800 € einmalig |

---

*// Dieses Dokument dient als konkretes Modell der Pizzeria "Pepe et Urinal". Es kann bei Bedarf erweitert werden (z. B. um Grundriss-Skizzen, konkrete Gerichte-Fotos, Preiskalkulationen).*