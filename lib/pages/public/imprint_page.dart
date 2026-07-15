import 'package:flutter/material.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressum'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Angaben gemäß § 5 TMG', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            _Section(title: 'Betreiber', children: [
              _InfoRow(label: 'Name', value: 'Fran Jatzek'),
              _InfoRow(label: 'Anschrift', value: 'Falkenseer Chaussee 127, 13589 Berlin'),
              _InfoRow(label: 'Telefon', value: '030 / 12345678'),
              _InfoRow(label: 'E-Mail', value: 'info@pepe-et-urinal.de'),
            ]),

            _Section(title: 'Umsatzsteuer-ID', children: [
              const Text('DE123456789'),
              const SizedBox(height: 8),
              const Text('Umsatzsteuer-Identifikationsnummer gemäß § 27 a Umsatzsteuergesetz.', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]),

            _Section(title: 'Aufsichtsbehörde', children: [
              const Text('Bezirksamt Spandau, Ordnungsamt'),
            ]),

            _Section(title: 'Berufsrechtliche Angaben', children: [
              const Text('Gaststättengewerbe nach GastG (Gaststättenerlaubnis erforderlich)'),
            ]),

            _Section(title: 'Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV', children: [
              const Text('Fran Jatzek, Falkenseer Chaussee 127, 13589 Berlin'),
            ]),

            _Section(title: 'Haftungsausschluss', children: [
              const Text(
                'Haftung für Inhalte: Die Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen.\n\n'
                'Haftung für Links: Unser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich.',
              ),
            ]),

            _Section(title: 'Urheberrecht', children: [
              const Text(
                'Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.',
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}