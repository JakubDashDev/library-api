FROM ruby:3.3.12-slim

WORKDIR /rails

RUN apt-get update -qq && apt-get install --no-install-recommends -y curl build-essential libpq-dev libyaml-dev postgresql-client

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x bin/docker-entrypoint bin/rails

ENTRYPOINT ["./bin/docker-entrypoint"]