# Schritt 3: Abschluss-Reflexion

## Projekt: Pizzeria Pepe et Urinal – Webseite mit CMS, CRM und Shop

### 1. Gedanken zum Projekt

Die Aufgabe war es, eine professionelle Webpräsenz für eine kleine Pizzeria zu erstellen – mit CMS für Blog-Artikel, CRM für Newsletter, einem kleinen Shop und User-Login. Alles unter der harten Restriktion von **maximal 2 Euro monatlichen Kosten**.

#### Was hat gut funktioniert?

- **Flutter Web + Supabase** erwies sich als extrem effektives Duo. Die schnelle Entwicklung durch Widgets und das integrierte Supabase SDK (Auth, Datenbank, Storage) haben es ermöglicht, innerhalb weniger Tage ein funktionsfähiges MVP zu bauen.
- **Supabase als Firebase-Alternative** – PostgreSQL-basiert, EU-Hosting, großzügiger Free-Tier. Die RLS-Policies (Row Level Security) sind ein echtes Plus für die Sicherheit.
- **Die modulare Architektur** (Services, Models, Pages) macht das Projekt erweiterbar und wartbar.
- **GitHub Pages als Hosting** – kostenlos, CI/CD via GitHub Actions, SSL inklusive.

#### Was war herausfordernd?

- **Die Zero-Cost-Anforderung** – viele Dienste haben Free-Tier, aber die Limits müssen genau im Auge behalten werden (Supabase: 500 MB Datenbank, Brevo: 300 E-Mails/Tag).
- **Env-Dateien und CI/CD** – da die Zugangsdaten in `.gitignore` ausgeschlossen sind, mussten GitHub Secrets für den CI-Build konfiguriert werden.
- **Merge-Konflikte beim Hinzufügen des zweiten Repositories** – die Zusammenführung zweier Git-Historien erforderte manuelle Konfliktlösung.

### 2. Kann man damit eine ganze Agentur ersetzen?

**Ja – aber mit Einschränkungen.**

Für ein klares, gut definiertes Projekt wie dieses (Pizzeria-Webseite mit Standard-Features) kann AI-First + Low-Code/No-Code tatsächlich das leisten, wofür früher eine kleine Webagentur beauftragt wurde:

| Aspekt | Agentur (früher) | AI-First (heute) |
|---|---|---|
| **Kosten** | 5.000–15.000 € | 0–50 € (nur Domain) |
| **Zeit** | 1–3 Monate | 1–2 Wochen |
| **Flexibilität** | Individuell, aber teuer | Individuell, schnell anpassbar |
| **Wartung** | Wartungsvertrag nötig | Selbst betreibbar (CI/CD) |
| **Rechtssicherheit** | Anwalt geprüft | Eigenrecherche nötig |

**Grenzen der AI-First-Methode:**

1. **Komplexe Business-Logik** – Sobald es um individuelle Workflows, Schnittstellen zu externen Systemen (z.B. Kassensysteme, Lieferdienste) oder spezielle Compliance-Anforderungen geht, stößt die AI-First-Methode an Grenzen.
2. **Rechtssicherheit** – Impressum, DSGVO, AGB – das muss ein Mensch prüfen. AI kann Vorlagen liefern, aber keine Haftung übernehmen.
3. **Design-Qualität** – Eine Agentur liefert durchdachtes UI/UX-Design. Flutter Material Design ist solide, aber nicht auf dem Niveau einer spezialisierten Design-Agentur.
4. **Support & Betrieb** – Wenn etwas kaputt geht, muss der Kunde selbst troubleshooten können oder einen Entwickler engagieren.

### 3. Fazit

**AI-First ist ideal für Minimal-Viable-Products, Prototypen und kleine Unternehmen mit begrenztem Budget.** Für die Pizzeria "Pepe et Urinal" war dieser Ansatz perfekt: niedrige Kosten, schnelle Umsetzung, und die Webseite erfüllt alle Anforderungen.

Für größere Projekte mit komplexen Anforderungen, hohem Traffic oder rechtlichen Risiken würde ich weiterhin eine professionelle Agentur empfehlen. Aber für 80% der kleinen Unternehmen ist AI-First die deutlich effizientere Lösung.

---

*Reflexion erstellt am 15. Juli 2026*