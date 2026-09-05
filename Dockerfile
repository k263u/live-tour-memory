FROM ruby:3.4.8

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . /app

RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

ENTRYPOINT ["/app/bin/docker-entrypoint"]

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]