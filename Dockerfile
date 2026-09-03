FROM ruby:3.4.8

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . /app