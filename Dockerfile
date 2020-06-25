FROM ruby:2.6.6
ENV TZ='Asia/Tokyo'
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mariadb-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /workdir
WORKDIR /workdir
COPY Gemfile /workdir/Gemfile
COPY Gemfile.lock /workdir/Gemfile.lock
RUN gem install bundler:2.1.4
RUN bundle install
COPY . /workdir
