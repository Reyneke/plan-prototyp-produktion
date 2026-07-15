import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenschutzerklärung'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datenschutzerklärung', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Stand: Juli 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            _Section(title: '1. Verantwortlicher', children: [
              const Text('Fran Jatzek\nFalkenseer Chaussee 127\n13589 Berlin\n\nE-Mail: info@pepe-et-urinal.de\nTelefon: 030 / 12345678'),
            ]),

            _Section(title: '2. Erhebung und Speicherung personenbezogener Daten', children: [
              const Text('Beim Besuch unserer Webseite werden folgende Daten verarbeitet:'),
              const SizedBox(height: 8),
              const BulletList(items: [
                'IP-Adresse des anfragenden Endgeräts',
                'Datum und Uhrzeit des Zugriffs',
                'Name und URL der abgerufenen Datei',
                'Website, von der aus der Zugriff erfolgt (Referrer-URL)',
                'Verwendeter Browser und Betriebssystem',
              ]),
              const SizedBox(height: 8),
              const Text('Die Datenverarbeitung erfolgt auf Grundlage von Art. 6 Abs. 1 lit. f DSGVO (berechtigtes Interesse an der technischen Bereitstellung der Webseite).'),
            ]),

            _Section(title: '3. Newsletter', children: [
              const Text(
                'Wenn Sie unseren Newsletter abonnieren, verwenden wir Ihre E-Mail-Adresse, um Ihnen regelmäßig Informationen über unsere Angebote zuzusenden. '
                'Rechtsgrundlage ist Art. 6 Abs. 1 lit. a DSGVO (Einwilligung).\n\n'
                'Die Abmeldung vom Newsletter ist jederzeit möglich. Nutzen Sie dazu den Abmeldelink in jeder Newsletter-E-Mail oder kontaktieren Sie uns direkt.',
              ),
            ]),

            _Section(title: '4. Bestellungen', children: [
              const Text(
                'Bei einer Bestellung über unseren Shop erfassen wir folgende Daten:\n'
                '• Name\n'
                '• E-Mail-Adresse\n'
                '• Telefonnummer (für Rückfragen)\n'
                '• Bestelldaten (Produkte, Menge, Abholzeit)\n\n'
                'Die Verarbeitung erfolgt gemäß Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung).',
              ),
            ]),

            _Section(title: '5. Weitergabe von Daten an Dritte', children: [
              const Text('Eine Weitergabe Ihrer personenbezogenen Daten an Dritte erfolgt nur, wenn:'),
              const SizedBox(height: 8),
              const BulletList(items: [
                'Sie Ihre ausdrückliche Einwilligung erteilt haben (Art. 6 Abs. 1 lit. a DSGVO)',
                'Die Weitergabe zur Vertragserfüllung erforderlich ist (Art. 6 Abs. 1 lit. b DSGVO)',
                'Eine gesetzliche Verpflichtung besteht (Art. 6 Abs. 1 lit. c DSGVO)',
              ]),
              const SizedBox(height: 12),
              const Text('Folgende Dienstleister werden eingesetzt:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const BulletList(items: [
                'Supabase (Datenbank & Authentifizierung) – EU-Hosting, DSGVO-konform',
                'Brevo (E-Mail-Versand für Newsletter) – EU-Unternehmen, Server in Frankfurt',
                'GitHub Pages (Webseiten-Hosting) – US-Anbieter, EU-US Data Privacy Framework zertifiziert',
              ]),
            ]),

            _Section(title: '6. Speicherdauer', children: [
              const Text(
                'Wir speichern Ihre Daten nur so lange, wie dies für die jeweiligen Verarbeitungszwecke erforderlich ist '
                'oder gesetzliche Aufbewahrungsfristen bestehen. Nach Wegfall des Zwecks werden Ihre Daten gelöscht.',
              ),
            ]),

            _Section(title: '7. Betroffenenrechte', children: [
              const Text('Sie haben das Recht:'),
              const SizedBox(height: 8),
              const BulletList(items: [
                'Auskunft über Ihre gespeicherten Daten zu erhalten (Art. 15 DSGVO)',
                'Berichtigung unrichtiger Daten zu verlangen (Art. 16 DSGVO)',
                'Löschung Ihrer Daten zu verlangen (Art. 17 DSGVO)',
                'Einschränkung der Verarbeitung zu verlangen (Art. 18 DSGVO)',
                'Ihre Daten in einem strukturierten Format zu erhalten (Art. 20 DSGVO)',
                'Widerspruch gegen die Verarbeitung einzulegen (Art. 21 DSGVO)',
                'Ihre Einwilligung jederzeit zu widerrufen (Art. 7 Abs. 3 DSGVO)',
              ]),
              const SizedBox(height: 12),
              const Text('Zur Ausübung Ihrer Rechte kontaktieren Sie uns bitte per E-Mail an info@pepe-et-urinal.de.'),
            ]),

            _Section(title: '8. Beschwerderecht', children: [
              const Text(
                'Sie haben das Recht, sich bei einer Aufsichtsbehörde zu beschweren, wenn Sie der Ansicht sind, '
                'dass die Verarbeitung Ihrer Daten gegen die DSGVO verstößt. Zuständig ist die Berliner Beauftragte für Datenschutz und Informationsfreiheit.',
              ),
            ]),

            _Section(title: '9. Hosting', children: [
              const Text(
                'Diese Webseite wird auf GitHub Pages gehostet. GitHub (GitHub Inc., 88 Colin P Kelly Jr St, San Francisco, CA 94107, USA) '
                'verarbeitet als Auftragsverarbeiter Ihre IP-Adresse und Browserdaten beim Aufruf der Seite. '
                'GitHub ist nach dem EU-US Data Privacy Framework (DPF) zertifiziert.',
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

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(item)),
          ],
        ),
      )).toList(),
    );
  }
}