# 8. Fazit & Umsetzungsplan

## Technologieentscheidung

Nach Abwägung aller Anforderungen, Rahmenbedingungen und Alternativen empfiehlt sich folgende Umsetzung:

| Komponente | Technologie | Begründung |
|---|---|---|
| **Frontend** | Flutter Web | Single Codebase für Web (und später ggf. Mobile); schnelle Entwicklung durch Widgets; gute Supabase-Integration |
| **Backend & Datenbank** | Supabase (statt Firebase) | Open-Source, PostgreSQL, EU-Hosting (DSGVO-konform), Free-Tier ausreichend, Auth + Storage + Realtime inklusive |
| **E-Mail-Marketing** | Brevo (statt MailChimp) | Großzügiger Free-Tier (300 E-Mails/Tag, unbegrenzt Kontakte), EU-Unternehmen, DSGVO-konform |
| **Zahlungs-UI** | Mollie (simuliert) | Europäischer Anbieter, faire Preise, im Projekt nur UI-Demonstration bis zum "Kaufen"-Button |

---

## Abdeckung der README-Anforderungen

### Funktionale Anforderungen

| Anforderung | Umsetzung |
|---|---|
| **CMS** (News & Blogartikel pflegen) | Admin `ArticlesAdminPage` – Artikel erstellen/bearbeiten/löschen mit Rich-Text-Editor, Status (Entwurf/Veröffentlicht), Bestätigungsdialog beim Löschen |
| **CRM** (E-Mail-Newsletter) | `SubscribersAdminPage` (Abonnenten-Liste + Löschen) + `NewsletterAdminPage` (Kampagnen verfassen + versenden) + Anmeldeformular auf der Landing Page |
| **Shop-Funktion** (Produkte ansehen, Warenkorb) | `ProductsAdminPage` (Produkte verwalten) + öffentliche `ShopPage` (Produktliste, Warenkorb, Checkout-Dialog ohne echte Zahlung) |
| **User-Login** (Registrierung & Anmeldung) | `LoginPage` mit Supabase Auth (E-Mail/Passwort), E-Mail-Verifikation, Protected Routes im Admin-Bereich |

### Rahmenbedingungen

| Bedingung | Erfüllung |
|---|---|
| **Zero-Cost** (max. 2 €/Monat) | ✅ Supabase Free-Tier, Brevo Free-Tier, Flutter Web (statisches Hosting kostenlos) |
| **2-Wochen-Deadline** | ✅ Flutter + Supabase SDKs; MVP-Features sind implementiert |

### Hauptanforderungen (Qualität)

| Anforderung | Umsetzung |
|---|---|
| **Fehlerfrei & stabil** | Fehlerbehandlung in allen API-Aufrufen, `flutter analyze`: 0 Fehler |
| **Erweiterbar** | Modulare Architektur (Services, Models, Pages), Supabase PostgreSQL |
| **Verständlich dokumentiert** | Diese Planungsdokumente + Code-Kommentare + README |

---

## Umsetzungsplan (3 Schritte) – Status

### ✅ Schritt 1: Der öffentliche Bereich (abgeschlossen)
- **Landing Page** – Hero rot/weiß, Service-Cards, dynamischer News-Feed aus Supabase
- **Shop** – Produktübersicht mit Kategorie-Filter, Warenkorb (BottomSheet), Checkout-Dialog
- **Login/Registrierung** – Supabase Auth, Fehleranzeige, Umschaltung Login↔Register
- **Artikel-Detail** – Einzelansicht per Slug mit Bild und Veröffentlichungsdatum

### ✅ Schritt 2: Das Admin-Dashboard (abgeschlossen)
- **Dashboard** – Geschützter Bereich, Statistiken (Abonnenten-Zahl), Admin-Menü mit 5 Bereichen
- **CMS** – `ArticlesAdminPage`: Artikel-Liste mit Status-Anzeige, Editor (Titel, Slug, Inhalt, Status), Löschen mit Bestätigungsdialog
- **Shop-Verwaltung** – `ProductsAdminPage`: Produkt-Liste, Editor (Name, Preis, Kategorie, Verfügbarkeit), Kategorie-Auswahl
- **CRM** – `SubscribersAdminPage`: Abonnenten-Liste mit Status, manuelles Löschen
- **Newsletter** – `NewsletterAdminPage`: Kampagnen-Liste, Composer (Betreff + HTML-Inhalt), senden an alle aktiven Abonnenten
- **Bestellungen** – `OrdersAdminPage`: Bestellungen mit Artikeln, Status-Update (Bestätigen → Zubereitung → Bereit → Stornieren)

### ⬜ Schritt 3: Abschluss & Reflexion (offen)
- Deployment aufsetzen (GitHub Actions → Hosting)
- Domain konfigurieren
- Rechtliche Seiten (Impressum, Datenschutz, AGB)
- Reflexion schreiben

---

## Kostenübersicht (pro Jahr)

| Posten | Kosten |
|---|---|
| Domain (z. B. .de) | ca. 10 €/Jahr |
| Supabase Free-Tier | 0 € |
| Brevo Free-Tier | 0 € |
| Hosting (Vercel/Netlify/Firebase) | 0 € |
| **Gesamt** | **ca. 10 €/Jahr** |

→ Deutlich unter dem Maximalbudget von 24 €/Jahr.

---

## Supabase-Tabellenschema

Das vollständige SQL-Schema befindet sich in der Datei **`doc/plan/supabase_schema.sql`**.
Import: Supabase Dashboard → SQL Editor → `doc/plan/supabase_schema.sql` einfügen → Ausführen

### Tabellen-Übersicht

| Tabelle | Beschreibung |
|---|---|
| `profiles` | Benutzerprofile (erweitert Supabase Auth) |
| `articles` | Blog-Artikel / News (CMS) |
| `categories` | Produktkategorien (Speisekarten-Gruppen) |
| `products` | Produkte für den Shop (Speisekarte) |
| `subscribers` | Newsletter-Abonnenten (CRM) |
| `orders` | Bestellungen (Shop) |
| `order_items` | Bestellpositionen |
| `newsletter_campaigns` | Newsletter-Kampagnen (CRM) |

### Wichtige Features: RLS-Policies, Auto-Profile-Trigger, `updated_at`-Trigger, Seed-Daten (6 Kategorien + 15 Produkte)

---

## Projektstruktur (lib/)

```
lib/
├── env/                    # Zugangsdaten (lokal, von Git ignoriert)
│   ├── supabase_key.dart
│   └── api_key.dart
├── models/
│   ├── article.dart        # Article-Modell (fromJson/toJson)
│   ├── product.dart        # Product-Modell (formattedPrice)
│   └── category.dart       # Category-Modell
├── services/
│   ├── supabase_service.dart  # Singleton: Auth, CMS, CRM, Shop
│   └── cart_service.dart      # Warenkorb mit LocalStorage
├── pages/
│   ├── public/
│   │   ├── home_page.dart       # Landing Page
│   │   ├── shop_page.dart       # Produkte + Warenkorb
│   │   ├── article_detail_page.dart  # Artikel-Detail
│   │   └── login_page.dart      # Login/Registrierung
│   └── admin/
│       ├── admin_dashboard.dart       # Übersicht + Navigation
│       ├── articles_admin_page.dart   # CMS: CRUD + Editor
│       ├── products_admin_page.dart   # Shop: CRUD + Editor
│       ├── subscribers_admin_page.dart # CRM: Liste + Löschen
│       ├── newsletter_admin_page.dart  # Kampagnen + Composer
│       └── orders_admin_page.dart     # Bestellungen + Status
└── main.dart               # App-Start + Routing
```

## Offene Punkte / Nächste Schritte

1. [X] Supabase-Projekt anlegen und Tabellen-Schema importieren
2. [X] Brevo-API-Key besorgen und in Supabase Edge Function hinterlegen
3. [X] Flutter Web-Projekt initialisieren und Grundstruktur aufbauen
4. [X] Schritt 1 (öffentlicher Bereich) implementieren
5. [X] Schritt 2 (Admin-Dashboard) implementieren
6. [X] Deployment aufsetzen (GitHub Actions → GitHub Pages)
7. [ ] Domain konfigurieren (optional – aktuell unter https://reyneke.github.io/plan-prototyp-produktion/)
8. [X] Rechtliche Seiten (Impressum, Datenschutz, AGB) einbinden
9. [X] Schritt 3: Reflexion schreiben

## Erklärung: Punkt 6 – "Deployment aufsetzen (GitHub Actions → GitHub Pages)"

Dieser Punkt aus der `8_Fazit.md` ist ein offener To-do-Eintrag aus der Liste "Nächste Schritte". Er beschreibt die __Aufgabe, die fertige Flutter Web-App automatisch zu bauen und zu hosten__.

### Was ist gemeint?

- __GitHub Actions__: Ein CI/CD-Dienst von GitHub. Immer wenn Code in den `main`-Branch gepusht wird (z. B. nach einem Merge), soll automatisch ein Workflow starten.
- __Vercel / Netlify__: Zwei Hosting-Plattformen, die sich hervorragend für statische Websites (wie Flutter Web-Builds) eignen. Beide bieten einen __kostenlosen Einstiegstarif__ (Free Tier), was zur "Zero-Cost"-Anforderung des Projekts passt.

### Was wäre notwendig – Schritt-für-Schritt:

1. __GitHub-Repository__ – Das Projekt muss auf GitHub liegen (ist bereits der Fall, siehe Remote-URL).

2. __Build-Befehl testen__ – Lokal prüfen, dass `flutter build web` fehlerfrei funktioniert und einen `build/web/`-Ordner erzeugt.

3. __Vercel/Netlify-Konto erstellen__ – Ein kostenloses Konto anlegen.

4. __GitHub Actions-Workflow anlegen__ – Datei `.github/workflows/deploy.yml` erstellen, die:

   - Bei jedem Push auf `main` ausgelöst wird
   - Die `flutter build web`-Pipeline ausführt (mit `setup-flutter`-Action)
   - Das Build-Artifakt (`build/web/`) an Vercel/Netlify ausliefert

   __Oder einfacher__: Man kann Vercel/Netlify direkt mit dem GitHub-Repo verbinden (ohne eigene `.yml`-Datei). Die Plattform erkennt dann automatisch den Build-Befehl und deployt bei jedem Push.

5. __Domain konfigurieren__ (Punkt 7) – Eine benutzerdefinierte Domain (z. B. `pizzeria-beispiel.de`) mit dem Deployment verknüpfen (DNS + CNAME-Eintrag).

6. __Environment-Variablen__ – Die Supabase-Zugangsdaten (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) sowie den Brevo-API-Key als Secrets in GitHub oder direkt im Hosting-Dashboard hinterlegen, damit die App im Produktivbetrieb funktioniert.

### Warum dieser Punkt wichtig ist:

Ohne Deployment ist die App nur lokal sichtbar. Erst durch diesen Schritt wird die Anwendung für echte Nutzer unter einer öffentlichen URL erreichbar – das ist das finale Ziel des gesamten Projekts.
