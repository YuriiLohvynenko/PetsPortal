# Dockerfile

FROM ruby:2.7.6

# Install Node.js 14.x
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y yarn

RUN mkdir /pets_portal
WORKDIR /pets_portal

COPY Gemfile /pets_portal/Gemfile
COPY Gemfile.lock /pets_portal/Gemfile.lock

RUN bundle install
RUN gem install rails

COPY . /pets_portal
