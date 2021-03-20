FROM ruby:2.7.0-slim

RUN apt-get update -qq && apt-get install -y build-essential ruby-full ruby-dev libpq-dev nodejs git

WORKDIR /rails_postgres
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

COPY . /rails_postgres

RUN apt install curl -y
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN rm -f tmp/pids/server.pid
RUN yarn install --check-files

CMD ["bundle", "exec", "rails", "s", "-p", "3002", "-b", "0.0.0.0"]

EXPOSE 3002