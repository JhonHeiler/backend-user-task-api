# syntax=docker/dockerfile:1

################################
# Etapa común: instala Ruby, deps y gems
################################
ARG RUBY_VERSION=3.2
FROM ruby:${RUBY_VERSION} AS base

# Instala Node.js, cliente Postgres y dependencias para compilar pg
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      nodejs \
      postgresql-client \
      libpq-dev \
      build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instala las gems
COPY Gemfile* ./
RUN bundle install

# Copia el resto de la aplicación
COPY . .

################################
# Etapa de desarrollo
################################
FROM base AS dev

EXPOSE 3000

# Arranca Rails en modo desarrollo
CMD ["bash", "-lc", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"]

################################
# Etapa de producción
################################
FROM ruby:${RUBY_VERSION}-slim AS prod

WORKDIR /rails

# Instala solo lo necesario para ejecutar la app en prod
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Variables para deploy con Bundler
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Copia gems y aplicación desde la etapa base
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /app /rails

# Crea un usuario no-root y ajusta permisos
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails

EXPOSE 80

# Prepara la BD y arranca el servidor
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/thrust", "./bin/rails", "server"]
