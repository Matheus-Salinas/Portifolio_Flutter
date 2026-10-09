# Portfólio Flutter Web

Portfólio desenvolvido em **Flutter Web**, com layout responsivo e um dashboard de e-commerce animado em tempo real, publicado no **GitHub Pages**.

**Acesse o site:** https://matheus-salinas.github.io/Portifolio_Flutter/

## Sobre o projeto

Aplicação criada para a atividade de portfólio, a partir de uma sugestão de layout. A página apresenta um projeto em destaque e reúne as seções abaixo:

- Card de destaque com tags, título, resumo e links (GitHub e Deploy)
- Mockup de dashboard com gráfico que atualiza a cada 500 ms
- Problema e solução
- Arquitetura e tecnologias utilizadas
- Características principais
- Resultados e lições aprendidas
- Sobre
- Chamada para contato (e-mail e LinkedIn)

O layout se adapta a telas de computador e de celular, com menu de navegação que rola até cada seção.

## Tecnologias

- [Flutter](https://flutter.dev/) (Web) e Dart
- [url_launcher](https://pub.dev/packages/url_launcher) para abrir links e e-mail
- GitHub Pages para hospedagem

## Estrutura

```
portfolio_flutter/
├── lib/
│   └── main.dart      # Toda a interface do portfólio
├── web/               # Arquivos da plataforma web
├── pubspec.yaml       # Dependências do projeto
└── README.md
```

## Como rodar localmente

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.

```bash
git clone https://github.com/Matheus-Salinas/Portifolio_Flutter.git
cd Portifolio_Flutter
flutter pub get
flutter run -d chrome
```

## Como publicar no GitHub Pages

1. Gere o build, usando o nome exato do repositório no `--base-href`:

   ```bash
   flutter build web --base-href /Portifolio_Flutter/ --release
   ```

2. Envie o conteúdo de `build/web` para a branch `gh-pages`:

   ```bash
   cd build/web
   git init
   git add .
   git commit -m "Deploy Flutter Web"
   git branch -m gh-pages
   git remote add origin https://github.com/Matheus-Salinas/Portifolio_Flutter.git
   git push -u origin gh-pages --force
   ```

3. No GitHub, vá em **Settings > Pages**, escolha a branch `gh-pages` com a pasta `/ (root)` e salve.

Para atualizar o site depois de qualquer mudança, repita os passos 1 e 2.

## Autor

**Matheus Salinas**
GitHub: [@Matheus-Salinas](https://github.com/Matheus-Salinas)
