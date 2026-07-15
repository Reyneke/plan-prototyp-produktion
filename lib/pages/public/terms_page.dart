import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allgemeine Geschäftsbedingungen'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Allgemeine Geschäftsbedingungen (AGB)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Stand: Juli 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            _Section(title: '§1 Geltungsbereich', children: [
              const Text(
                'Diese Allgemeinen Geschäftsbedingungen gelten für alle Bestellungen, die über die Webseite der Pizzeria Pepe et Urinal (Betreiber: Fran Jatzek) aufgegeben werden. '
                'Abweichende Bedingungen des Kunden werden nicht anerkannt.',
              ),
            ]),

            _Section(title: '§2 Vertragsschluss', children: [
              const Text(
                '(1) Die Darstellung der Produkte auf der Webseite stellt kein rechtlich bindendes Angebot, sondern eine unverbindliche Aufforderung zur Bestellung dar.\n\n'
                '(2) Mit dem Klick auf "Bestellung aufgeben" gibt der Kunde ein verbindliches Angebot ab. Der Betreiber bestätigt den Eingang der Bestellung per E-Mail. '
                'Der Vertrag kommt mit der Bestätigungs-E-Mail zustande.\n\n'
                '(3) Der Betreiber behält sich vor, Bestellungen abzulehnen, wenn die Produkte nicht verfügbar sind oder ein begründeter Verdacht auf Missbrauch besteht.',
              ),
            ]),

            _Section(title: '§3 Preise und Zahlung', children: [
              const Text(
                '(1) Alle Preise verstehen sich in Euro inklusive der gesetzlichen Mehrwertsteuer.\n\n'
                '(2) Die Zahlung erfolgt ausschließlich bar bei Abholung. Eine Online-Zahlung ist nicht möglich.\n\n'
                '(3) Der Betreiber ist berechtigt, Preise jederzeit zu ändern. Für bereits aufgegebene Bestellungen gilt der zum Zeitpunkt der Bestellung angegebene Preis.',
              ),
            ]),

            _Section(title: '§4 Abholung', children: [
              const Text(
                '(1) Die Bestellung muss zum vereinbarten Abholzeitpunkt in der Geschäftsstelle abgeholt werden.\n\n'
                '(2) Bei Überschreitung des Abholzeitpunkts um mehr als 30 Minuten verfällt der Anspruch auf die bestellten Produkte. '
                'Eine Rückerstattung erfolgt nicht, da keine Vorauszahlung geleistet wurde.\n\n'
                '(3) Der Betreiber ist bemüht, die Bestellung zum gewünschten Zeitpunkt bereitzustellen. Verzögerungen sind möglich und berechtigen nicht zum Rücktritt vom Vertrag.',
              ),
            ]),

            _Section(title: '§5 Widerrufsrecht', children: [
              const Text(
                'Das gesetzliche Widerrufsrecht besteht nicht, da es sich bei den bestellten Produkten um Lebensmittel handelt, '
                'die nach § 312g Abs. 2 BGB vom Widerrufsrecht ausgeschlossen sind. '
                'Die Produkte werden frisch zubereitet und sind daher nicht zur Rückgabe geeignet.',
              ),
            ]),

            _Section(title: '§6 Haftung', children: [
              const Text(
                '(1) Der Betreiber haftet für Schäden nur bei Vorsatz oder grober Fahrlässigkeit.\n\n'
                '(2) Die Haftung für leichte Fahrlässigkeit ist ausgeschlossen, soweit keine wesentlichen Vertragspflichten verletzt werden.\n\n'
                '(3) Die vorstehenden Haftungsbeschränkungen gelten nicht für Verletzungen von Leben, Körper und Gesundheit.',
              ),
            ]),

            _Section(title: '§7 Datenschutz', children: [
              const Text(
                'Die Erhebung und Verarbeitung personenbezogener Daten erfolgt gemäß unserer Datenschutzerklärung, die auf der Webseite abrufbar ist.',
              ),
            ]),

            _Section(title: '§8 Schlussbestimmungen', children: [
              const Text(
                '(1) Es gilt das Recht der Bundesrepublik Deutschland unter Ausschluss des UN-Kaufrechts.\n\n'
                '(2) Sollte eine Bestimmung dieser AGB unwirksam sein, bleibt die Wirksamkeit der übrigen Bestimmungen unberührt (Salvatorische Klausel).\n\n'
                '(3) Gerichtsstand ist Berlin, soweit der Kunde Kaufmann ist oder keinen allgemeinen Gerichtsstand in Deutschland hat.',
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}