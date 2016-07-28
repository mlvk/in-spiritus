FROM ruby:2.3.1
MAINTAINER Aram Zadikian <if@else.run>

RUN apt-get update && apt-get install -y \
	postgresql-client \
	graphviz \
	--no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

ENV APP_PATH /app/in-spiritus
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH/
COPY Gemfile.lock $APP_PATH/

RUN bundle install
