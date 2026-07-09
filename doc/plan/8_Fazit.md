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
| **CMS** (News & Blogartikel pflegen) | Supabase-Datenbank (Tabelle `articles`) + Admin-Dashboard mit Rich-Text-Editor + Bild-Upload via Supabase Storage |
| **CRM** (E-Mail-Newsletter) | Brevo-API für Double-Opt-In, Abonnentenverwaltung und Newsletter-Versand; Anmeldeformular im Frontend |
| **Shop-Funktion** (Produkte ansehen, Warenkorb) | Supabase-Tabelle `products` + clientseitiger Warenkorb (LocalStorage) + Checkout-UI ohne echte Zahlung |
| **User-Login** (Registrierung & Anmeldung) | Supabase Auth (E-Mail/Passwort) + E-Mail-Verifikation + Protected Routes für Admin-Bereich |

### Rahmenbedingungen

| Bedingung | Erfüllung |
|---|---|
| **Zero-Cost** (max. 2 €/Monat) | ✅ Supabase Free-Tier, Brevo Free-Tier, Flutter Web (statisches Hosting z. B. auf Vercel/Netlify/Firebase Hosting – alles kostenlos) |
| **2-Wochen-Deadline** | ✅ Flutter + Supabase bieten fertige SDKs und Boilerplate-Reduktion; Fokus auf MVP-Features |

### Hauptanforderungen (Qualität)

| Anforderung | Umsetzung |
|---|---|
| **Fehlerfrei & stabil** | Fehlerbehandlung in allen API-Aufrufen; Supabase Realtime für konsistente Daten; Sentry (Free-Tier) für Fehlerüberwachung |
| **Erweiterbar** | Modulare Architektur (Services für Auth, DB, Mail); Supabase PostgreSQL erlaubt spätere Erweiterungen ohne Migration |
| **Verständlich dokumentiert** | Diese Planungsdokumente + Code-Kommentare + README mit Setup-Anleitung |

---

## Umsetzungsplan (3 Schritte)

### Schritt 1: Der öffentliche Bereich (Tag 1–5)
- Flutter Web-Projekt aufsetzen (mit Supabase SDK)
- Landing Page: Hero, Services, Über uns
- Dynamischer News-Feed aus Supabase (Tabelle `articles`)
- Shop-Bereich: Produktübersicht, Detailansicht, Warenkorb (LocalStorage)
- Login/Registrierung (Supabase Auth)
- Newsletter-Anmeldeformular (Brevo-API via Supabase Edge Function)

### Schritt 2: Das Admin-Dashboard (Tag 6–9)
- Geschützter Bereich unter `/admin` (Protected Routes)
- Dashboard-Startseite mit Statistiken (Abonnenten-Zahl, Artikel-Anzahl)
- CMS: Artikel erstellen/bearbeiten/löschen mit Rich-Text-Editor und Bild-Upload
- CRM: Abonnenten-Liste einsehen, manuell löschen, Newsletter verfassen und versenden

### Schritt 3: Abschluss & Reflexion (Tag 10)
- Feinschliff, Testing, Deployment
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

Das vollständige SQL-Schema befindet sich in der Datei **`doc/plan/supabase_schema.sql`** und kann direkt in den Supabase SQL Editor importiert werden.

### Tabellen-Übersicht

| Tabelle | Beschreibung | Wichtigste Spalten |
|---|---|---|
| **`profiles`** | Benutzerprofile (erweitert Supabase Auth) | `id` (UUID, verknüpft mit auth.users), `email`, `full_name`, `role` (admin/user) |
| **`articles`** | Blog-Artikel / News (CMS) | `title`, `slug`, `content` (Rich-Text), `featured_image`, `author_id`, `status` (draft/published), `published_at` |
| **`categories`** | Produktkategorien (Speisekarten-Gruppen) | `name`, `slug`, `description`, `sort_order` |
| **`products`** | Produkte für den Shop (Speisekarte) | `name`, `slug`, `description`, `price`, `compare_price`, `image_url`, `category_id`, `is_available`, `is_featured` |
| **`subscribers`** | Newsletter-Abonnenten (CRM) | `email`, `name`, `status` (pending/active/unsubscribed/bounced), `brevo_id` |
| **`orders`** | Bestellungen (Shop) | `customer_name`, `customer_email`, `customer_phone`, `status`, `pickup_time`, `notes`, `total_amount` |
| **`order_items`** | Bestellpositionen | `order_id`, `product_id`, `product_name`, `quantity`, `unit_price`, `total_price` |
| **`newsletter_campaigns`** | Newsletter-Kampagnen (CRM) | `subject`, `content` (HTML), `sent_at`, `recipient_count`, `created_by` |

### Wichtige Features des Schemas

- **Row-Level-Security (RLS):** Jede Tabelle hat Policies, die festlegen, wer lesen/schreiben darf
- **Automatische Profile-Erstellung:** Trigger legt Profil bei Registrierung an
- **`updated_at`-Trigger:** Automatische Timestamp-Aktualisierung
- **Seed-Daten:** 6 Kategorien + 15 Beispiel-Produkte (komplette Speisekarte)

### So importieren Sie das Schema in Supabase

1. Supabase Dashboard → SQL Editor → New Query
2. `doc/plan/supabase_schema.sql` einfügen → Ausführen

---

## Offene Punkte / Nächste Schritte

1. [X] Supabase-Projekt anlegen und Tabellen-Schema importieren (`doc/plan/supabase_schema.sql`)
2. [X] Brevo-API-Key besorgen und in Supabase Edge Function hinterlegen
3. [X] Flutter Web-Projekt initialisieren und Grundstruktur aufbauen
   - `.gitignore` um `.env/` und `lib/env/` erweitert (Zugangsdaten bleiben lokal, nicht in GitHub)
   - `supabase_flutter` als Dependency hinzugefügt
   - Projektstruktur: `lib/models/`, `lib/services/`, `lib/pages/public/`, `lib/pages/admin/`
   - Model-Klassen: `Article`, `Product`, `Category`
   - Services: `SupabaseService` (Auth, CMS, CRM, Shop), `CartService` (Warenkorb mit LocalStorage)
   - Pages: `HomePage` (Hero, Services, News-Feed, Newsletter), `ShopPage` (Produkte, Warenkorb, Checkout-UI), `ArticleDetailPage`, `LoginPage`, `AdminDashboard`
   - Zugangsdaten aus `.env/` werden nach `lib/env/` kopiert (von Git ignoriert)
4. [ ] Schritt 1 (öffentlicher Bereich) implementieren
5. [ ] Schritt 2 (Admin-Dashboard) implementieren
6. [ ] Deployment aufsetzen (GitHub Actions → Vercel/Netlify)
7. [ ] Domain konfigurieren
8. [ ] Rechtliche Seiten (Impressum, Datenschutz, AGB) einbinden
9. [ ] Schritt 3: Reflexion schreiben