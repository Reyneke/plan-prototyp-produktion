# Rahmenbedingungen

> *Abgeleitet aus der README.md*

## 1. Budget (Harte Restriktion)

- **Keine monatlichen Serverkosten** – mit Ausnahme der Domain dürfen keine wiederkehrenden Servergebühren anfallen.
- **Maximalbudget:** 2 € pro Monat bzw. 24 € pro Jahr.

## 2. Zeitplan

- **Deadline:** Das System muss innerhalb von maximal **zwei Wochen** betriebsbereit sein (Grund: anstehende Messe).

---

## Auswirkungen auf die Architektur

Diese Rahmenbedingungen haben direkte Konsequenzen für die technische Umsetzung:

| Rahmenbedingung | Konsequenz |
|---|---|
| **€2/Monat Budget** | Erzwingt eine kosten-günstige oder kostenlose Hosting-Lösung (z. B. Static Hosting, Serverless, oder günstiger VPS). Die Domain ist die einzig wiederkehrende Kosten. |
| **2-Wochen-Deadline** | Erfordert schnelles Prototyping – vorzugsweise mit vorhandenen Frameworks/Templates statt Eigenentwicklung. Die knappe Zeit deutet auf einen MVP-Ansatz (Minimum Viable Product) hin. |

Diese Randbedingungen schließen Cloud-Dienste mit laufenden Kosten und lange Entwicklungszyklen aus und lenken das Projekt in Richtung einfacher, leichtgewichtiger und kosteneffizienter Lösungen.
