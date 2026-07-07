# 4. Hauptanforderungen

Dieses Kapitel definiert die **nicht-funktionalen Anforderungen** (Qualitätsanforderungen) an das System. Anders als die funktionalen Anforderungen beschreiben diese nicht, _was_ das System tun soll, sondern _wie_ es sich verhalten und wie es beschaffen sein muss.

Siehe auch: [README.md](../../README.md)

## Stabilität und Zuverlässigkeit

Das System muss **fehlerfrei und stabil** laufen. Dies umfasst:

- **Keine unerwarteten Abstürze oder Laufzeitfehler** – Das System darf zu keinem Zeitpunkt unvorhergesehen abbrechen. Alle potenziellen Fehlerquellen müssen bereits zur Entwicklungszeit abgefangen werden.
- **Robuste Fehlerbehandlung für Randfälle** – Auch bei unerwarteten Eingaben, Netzwerkproblemen oder Systemauslastung muss das System kontrolliert reagieren (z. B. mit aussagekräftigen Fehlermeldungen statt eines Absturzes).
- **Konsistentes und vorhersagbares Verhalten unter Last** – Bei hoher Auslastung (z. B. viele gleichzeitige Benutzer oder große Datenmengen) darf die Stabilität nicht leiden. Das System soll sich deterministisch verhalten, sodass das Verhalten im Voraus abschätzbar ist.

> **Warum das wichtig ist:** Stabilität und Zuverlässigkeit schaffen Vertrauen bei den Benutzern und vermeiden teure Ausfallzeiten. Ein System, das unerwartet abstürzt, ist unbrauchbar – selbst wenn alle Funktionen korrekt implementiert sind.

## Erweiterbarkeit

Die Architektur des Systems muss so ausgelegt sein, dass:

- **Neue Funktionalitäten ohne größere Umbauten hinzugefügt werden können** – Die Codebasis soll so strukturiert sein, dass neue Features modular ergänzt werden, ohne bestehenden Code tiefgreifend ändern zu müssen (Open-Closed-Prinzip).
- **Module lose gekoppelt und einzeln testbar sind** – Jede Komponente soll unabhängig von anderen entwickelt und getestet werden können. Lose Kopplung verhindert, dass Änderungen an einer Stelle unerwartete Seiteneffekte an anderen Stellen auslösen.
- **Klare Schnittstellen (APIs/Contracts) existieren** – Die Kommunikation zwischen Modulen erfolgt über wohldefinierte Schnittstellen. Solange der Vertrag (Contract) eingehalten wird, kann die innere Implementierung eines Moduls jederzeit ausgetauscht werden.

> **Warum das wichtig ist:** Ein erweiterbares System reduziert langfristig die Wartungskosten. Statt bei jeder neuen Anforderung das gesamte System umzubauen, können Änderungen gezielt und isoliert vorgenommen werden.

## Dokumentation

Die Dokumentation muss **verständlich und vollständig** sein, damit:

- **Das System nach Abschluss der Entwicklung ohne erneute Einarbeitung verstanden werden kann** – Die Dokumentation dient als alleinige Wissensquelle und muss so aufbereitet sein, dass eine Person ohne Vorkenntnisse das System verstehen kann.
- **Wartungsarbeiten effizient durchgeführt werden können** – Fehlerbehebungen oder Anpassungen sollen nicht durch mangelhafte oder fehlende Dokumentation verzögert werden. Architekturentscheidungen, Schnittstellenbeschreibungen und Abhängigkeiten müssen klar festgehalten sein.
- **Neue Teammitglieder schnell eingearbeitet werden können** – Die Einarbeitungszeit wird durch eine gute Dokumentation drastisch verkürzt. Neue Entwickler müssen sich nicht durch den gesamten Quellcode kämpfen, um das System zu verstehen.

> **Ziel:** Nach Fertigstellung soll kein grundlegender Änderungsbedarf mehr bestehen.

> **Warum das wichtig ist:** Ohne gute Dokumentation wird das System zu einem "Black Box"-Problem. Wissen geht verloren, wenn Teammitglieder das Projekt verlassen, und Wartung wird zur Fehlerquelle. Vollständige Dokumentation ist eine Investition in die Zukunft des Projekts.
