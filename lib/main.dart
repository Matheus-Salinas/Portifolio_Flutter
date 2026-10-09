import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// CONFIGURAÇÃO: troque pelos seus dados antes de publicar
// ============================================================================
const kNome = 'Matheus Salinas Zancope';
const kGithubUrl = 'https://github.com/Matheus-Salinas/Portifolio_Flutter';
const kDeployUrl = 'https://Matheus-Salinas.github.io/Portifolio_Flutter/';
const kEmail = 'matheussalinonhas@gmail.com';
const kLinkedinUrl = 'https://www.linkedin.com/in/matheus-salinas';

// ============================================================================
// CORES
// ============================================================================
class C {
  static const bg = Color(0xFF0B0F1A);
  static const surface = Color(0xFF141A2B);
  static const primary = Color(0xFF6C63FF);
  static const accent = Color(0xFF22D3EE);
  static const text = Color(0xFFE6E9F2);
  static const muted = Color(0xFF9AA3B8);
}

bool isWide(BuildContext context) => MediaQuery.of(context).size.width >= 800;

Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfólio | $kNome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: C.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: C.primary,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================================
// PÁGINA PRINCIPAL
// ============================================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _projetosKey = GlobalKey();
  final _sobreKey = GlobalKey();
  final _contatoKey = GlobalKey();

  void _go(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.bg,
        surfaceTintColor: Colors.transparent,
        titleSpacing: wide ? 32 : 16,
        title: Row(
          children: [
            const Icon(Icons.code, color: C.accent),
            const SizedBox(width: 8),
            Text(
              kNome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: wide
            ? [
                TextButton(
                    onPressed: () => _go(_projetosKey),
                    child: const Text('Projetos')),
                TextButton(
                    onPressed: () => _go(_sobreKey),
                    child: const Text('Sobre')),
                TextButton(
                    onPressed: () => _go(_contatoKey),
                    child: const Text('Contato')),
                const SizedBox(width: 24),
              ]
            : [
                PopupMenuButton<GlobalKey>(
                  icon: const Icon(Icons.menu),
                  onSelected: _go,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: _projetosKey, child: const Text('Projetos')),
                    PopupMenuItem(
                        value: _sobreKey, child: const Text('Sobre')),
                    PopupMenuItem(
                        value: _contatoKey, child: const Text('Contato')),
                  ],
                ),
              ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Section(key: _projetosKey, child: const FeaturedCard()),
            const Section(child: MockupArea()),
            const Section(child: ProblemSolution()),
            const Section(child: TechSection()),
            const Section(child: FeaturesSection()),
            const Section(child: ResultsSection()),
            Section(key: _sobreKey, child: const AboutSection()),
            Section(key: _contatoKey, child: const CtaSection()),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COMPONENTES BASE
// ============================================================================
class Section extends StatelessWidget {
  final Widget child;
  const Section({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide(context) ? 32 : 16,
            vertical: 14,
          ),
          child: child,
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}

class Tag extends StatelessWidget {
  final String label;
  final IconData? icon;
  const Tag(this.label, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: C.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: C.primary.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: C.accent),
            const SizedBox(width: 6),
          ],
          Text(label,
              style: const TextStyle(fontSize: 12, color: C.text)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String emoji;
  final String text;
  const SectionTitle(this.emoji, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        '$emoji  $text',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: C.text,
        ),
      ),
    );
  }
}

/// Linha no desktop, coluna no celular.
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  const ResponsiveRow({super.key, required this.children, this.gap = 16});

  @override
  Widget build(BuildContext context) {
    if (!isWide(context)) {
      return Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// 🚀 CARD DE DESTAQUE
// ============================================================================
class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(wide ? 40 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            C.primary.withValues(alpha: 0.35),
            C.accent.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Tag('Front-end'),
              Tag('React'),
              Tag('Out 2026', icon: Icons.calendar_today),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '🎯 Desenvolvimento de um Dashboard E-commerce em Tempo Real',
            style: TextStyle(
              fontSize: wide ? 38 : 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: C.text,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Uma aplicação web escalável com atualizações ao vivo, gráficos '
            'interativos e foco total na experiência do usuário (UX).',
            style: TextStyle(fontSize: 16, color: C.muted, height: 1.5),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () => openUrl(kGithubUrl),
                icon: const Icon(Icons.north_east, size: 18),
                label: const Text('Ver Código no GitHub'),
              ),
              FilledButton.icon(
                onPressed: () => openUrl(kDeployUrl),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Acessar Deploy em Produção'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 🖼️ ÁREA VISUAL (mockup animado desenhado com widgets)
// ============================================================================
class MockupArea extends StatefulWidget {
  const MockupArea({super.key});

  @override
  State<MockupArea> createState() => _MockupAreaState();
}

class _MockupAreaState extends State<MockupArea> {
  final _rnd = Random();
  late final Timer _timer;
  List<double> _bars = [];
  int _vendas = 1280;
  double _receita = 48250;

  @override
  void initState() {
    super.initState();
    _bars = List.generate(16, (_) => 0.25 + _rnd.nextDouble() * 0.75);
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() {
        _bars = [..._bars.skip(1), 0.2 + _rnd.nextDouble() * 0.8];
        _vendas += _rnd.nextInt(4);
        _receita += _rnd.nextInt(180);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _kpi(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: C.accent),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Text(label,
                style: const TextStyle(fontSize: 11, color: C.muted)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (final c in [Colors.redAccent, Colors.amber, Colors.green])
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 6),
                      decoration:
                          BoxDecoration(color: c, shape: BoxShape.circle),
                    ),
                  const SizedBox(width: 8),
                  const Text('dashboard.ecommerce / ao vivo',
                      style: TextStyle(fontSize: 12, color: C.muted)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _kpi('Vendas hoje', '$_vendas', Icons.shopping_cart),
                  _kpi('Receita', 'R\$ ${_receita.toStringAsFixed(0)}',
                      Icons.attach_money),
                  _kpi('Online agora', '${320 + _bars.length}', Icons.people),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final v in _bars)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 400),
                            heightFactor: v,
                            alignment: Alignment.bottomCenter,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [C.primary, C.accent],
                                ),
                              ),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Mockup interativo da interface (atualiza a cada 500ms)',
          style: TextStyle(fontSize: 12, color: C.muted),
        ),
      ],
    );
  }
}

// ============================================================================
// 💡 PROBLEMA E SOLUÇÃO
// ============================================================================
class ProblemSolution extends StatelessWidget {
  const ProblemSolution({super.key});

  Widget _block(IconData icon, Color color, String title, String body) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(color: C.muted, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('💡', 'O Problema e a Solução'),
        ResponsiveRow(
          children: [
            _block(
              Icons.report_problem_outlined,
              Colors.orangeAccent,
              'O Desafio',
              'Lojistas precisavam monitorar vendas sem atualizar a página '
                  'manualmente, perdendo oportunidades em momentos de pico.',
            ),
            _block(
              Icons.lightbulb_outline,
              C.accent,
              'A Solução',
              'Criação de um pipeline de dados com WebSockets e renderização '
                  'otimizada, entregando métricas ao vivo com baixa latência.',
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// 🛠️ ARQUITETURA E TECNOLOGIAS
// ============================================================================
class TechSection extends StatelessWidget {
  const TechSection({super.key});

  static const _techs = [
    ('React.js', Icons.web, 'Componentização e ecossistema maduro para UIs reativas.'),
    ('Node.js', Icons.dns, 'Servidor leve e ideal para conexões WebSocket em tempo real.'),
    ('Tailwind CSS', Icons.brush, 'Estilização rápida, consistente e responsiva.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('🛠️', 'Arquitetura e Tecnologias Utilizadas'),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < _techs.length; i++) ...[
                if (i > 0)
                  Divider(color: Colors.white.withValues(alpha: 0.08)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: C.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_techs[i].$2, color: C.accent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_techs[i].$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(_techs[i].$3,
                                style: const TextStyle(color: C.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ⚡ FEATURES
// ============================================================================
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget _feature(IconData icon, String title, String body) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: C.accent, size: 30),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: C.muted, height: 1.4)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('⚡', 'Características Principais'),
        ResponsiveRow(
          children: [
            _feature(Icons.devices, 'UI/UX Responsivo',
                'Se adapta a qualquer tamanho de tela.'),
            _feature(Icons.bar_chart, 'Gráficos Dinâmicos',
                'Atualização a cada 500ms usando ApexCharts.'),
            _feature(Icons.lock_outline, 'Autenticação',
                'Proteção de rotas com JWT.'),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// 📈 RESULTADOS
// ============================================================================
class ResultsSection extends StatelessWidget {
  const ResultsSection({super.key});

  Widget _item(IconData icon, String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '$title: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: body, style: const TextStyle(color: C.muted)),
                ],
              ),
              style: const TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('📈', 'Resultados e Lições Aprendidas'),
        AppCard(
          child: Column(
            children: [
              _item(Icons.speed, 'Desempenho',
                  'Redução de 40% no tempo de carregamento inicial (LCP).'),
              _item(Icons.school, 'Aprendizado',
                  'Implementação profunda de gerenciamento de estado global.'),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SOBRE
// ============================================================================
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('👤', 'Sobre'),
        AppCard(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: C.primary,
                child: Icon(Icons.person, size: 36),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Text(
                  'Olá! Sou $kNome, desenvolvedor(a) apaixonado(a) por criar '
                  'interfaces rápidas, acessíveis e agradáveis de usar. '
                  'Este portfólio foi construído com Flutter Web.',
                  style: TextStyle(color: C.muted, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 🤝 CALL TO ACTION
// ============================================================================
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [C.primary, Color(0xFF3B82F6)]),
      ),
      child: Column(
        children: [
          const Text('🤝 Vamos trabalhar juntos?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text(
            'Gostou do projeto? Estou disponível para novos desafios e contratos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: C.bg,
                ),
                onPressed: () => openUrl('mailto:$kEmail'),
                icon: const Icon(Icons.email_outlined),
                label: const Text('Enviar Mensagem por E-mail'),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () => openUrl(kLinkedinUrl),
                icon: const Icon(Icons.link),
                label: const Text('Conectar no LinkedIn'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text(
        '© 2026 · Feito com Flutter',
        style: TextStyle(color: C.muted, fontSize: 12),
      ),
    );
  }
}