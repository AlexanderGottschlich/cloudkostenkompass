# CloudKostenKompass

Website und Produkt-Landingpage für die Beratungsmarke **CloudKostenKompass**
(AWS Cost & Architecture Assessment).

Statisches Jekyll-4-Projekt – **vollständig containerisiert**, kein lokales
Ruby/Gem nötig.

## Voraussetzungen

Nur Docker (mit Compose v2).

## Entwicklung

```bash
docker compose up dev
```

- Website: <http://localhost:4000>
- Livereload: Port 35729 (Quelländerungen werden automatisch neu gebaut)

## Produktions-Build (statisch, nginx)

```bash
docker compose up -d web
```

- Website: <http://localhost:8080>

Das Produktions-Image ist ein Multi-Stage-Build: Jekyll baut in
`ruby:3.3-slim`, ausgeliefert wird über `nginx:alpine` mit Gzip,
Cache-Header und Healthcheck. Das Image ist eigenständig und portabel
(`docker build --target prod` → auf jedem Host lauffähig).

## Struktur

| Pfad | Inhalt |
|---|---|
| `index.html` | Homepage |
| `aws-cost-architecture-assessment.html` | Produkt-Landingpage (`/aws-cost-architecture-assessment/`) |
| `ueber-mich.html` | Expertenpositionierung (`/ueber-mich/`) |
| `kontakt.html` | Kontakt/CTA (`/kontakt/`) |
| `impressum.html`, `datenschutz.html` | Rechtliches |
| `_layouts/`, `_includes/` | Layout, Header, Footer |
| `assets/css/main.scss` | Design-System (Tokens, Komponenten) |
| `_config.yml` | Zentrale Markendaten (Domain, E-Mail, Adresse) |

## Checks

- Interne Links: alle 200
- Lighthouse: Accessibility/Best Practices/SEO = 100 (Homepage, Assessment, Über mich)
- Kein Tracking, keine Cookies, keine externen JS-Dependencies

## Offene Punkte vor Go-Live

- Datenschutzerklärung anwaltlich prüfen (Platzhalter für Hosting-Details)
- Google-Webfonts: lokal hosten, um Datenfluss zu vermeiden (siehe `/datenschutz/`)
- Domain-DNS auf Hosting zeigen lassen
