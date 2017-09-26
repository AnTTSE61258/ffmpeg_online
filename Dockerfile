FROM ruby:2.4.2
WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y nodejs \
                       mysql-client \
                       postgresql-client \
                       sqlite3 \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY ./Gemfile $APP_ROOT
#COPY Gemfile.lock $APP_ROOT

RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem
COPY . $APP_ROOT
RUN gem install rubygems-bundler
RUN gem regenerate_binstubs
RUN gem update --system
RUN bundle install
RUN /tmp/pids/server.pid
EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0"]