# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t adoteumfilhopovo .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name adoteumfilhopovo adoteumfilhopovo

# Make sure RUBY_VERSION matches .ruby-version
ARG RUBY_VERSION=3.4.9
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install base packages
# sqlite3 CLI for db:console; libsqlite3-0 is the runtime shared library
# curl for Kamal health checks; libjemalloc2 for memory optimization
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libjemalloc2 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# ── Build stage ──────────────────────────────────────────────────────────────
FROM base AS build

# Build-time packages: git/build-essential for native gems, pkg-config/libyaml-dev
# for psych, node-build + yarn for JS/CSS asset pipeline
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config libyaml-dev curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js (LTS) and Yarn for the esbuild + sass asset pipeline
ARG NODE_VERSION=22
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

# Install JS packages
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap for faster boots
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Build JS and CSS bundles
RUN yarn build && yarn build:css

# Precompile assets (SECRET_KEY_BASE_DUMMY skips credential requirement)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Remove node_modules from the image (already compiled into assets/builds/)
RUN rm -rf node_modules

# ── Final stage ───────────────────────────────────────────────────────────────
FROM base

# Non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Thruster handles SSL termination and static asset serving in front of Puma
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
