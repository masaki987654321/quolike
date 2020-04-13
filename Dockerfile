FROM ruby:2.5.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs
RUN mkdir /railsApp
WORKDIR /railsApp
ADD Gemfile /railsApp/Gemfile
ADD Gemfile.lock /railsApp/Gemfile.lock
RUN bundle install
ADD . /railsApp

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets