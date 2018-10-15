FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /braveproject
WORKDIR /braveproject
COPY Gemfile /braveproject/Gemfile
COPY Gemfile.lock /braveproject/Gemfile.lock
RUN bundle install
COPY . /braveproject