# syntax=docker/dockerfile:1
# Multi-Stage-Build: Jekyll-Build in Ruby, Auslieferung über nginx.
# Dev- und Prod-Ziel sind vollständig containerisiert – kein lokales Ruby nötig.

# ---------- Stage 1: Build-Umgebung mit Jekyll ----------
FROM ruby:3.3-slim AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*

# Gems außerhalb des Workdirs, damit ein Quellcode-Mount sie nicht versteckt
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    JEKYLL_ENV=production

WORKDIR /site

COPY Gemfile ./
RUN bundle install && bundle clean --force

COPY . .
RUN bundle exec jekyll build --trace

# ---------- Stage 2: Dev (Serve mit Livereload) ----------
FROM build AS dev

ENV JEKYLL_ENV=development
EXPOSE 4000 35729
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload", "--force_polling", "--drafts"]

# ---------- Stage 3: Produktions-Image (nginx, statisch) ----------
FROM nginx:1.27-alpine AS prod

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /site/_site /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
