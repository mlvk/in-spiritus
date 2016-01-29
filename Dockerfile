FROM ruby:2.2

RUN apt-get update && apt-get install -y postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

ENV RACK_ENV production
ENV RAILS_ENV production

RUN bundle install --without development test

COPY . /usr/src/app/

EXPOSE 3000

ENTRYPOINT ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
