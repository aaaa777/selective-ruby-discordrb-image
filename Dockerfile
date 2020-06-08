FROM debian:stable

ENV DEBCONF_NOWARNINGS yes

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    apt-transport-https \
    ca-certificates \
 && useradd -m ruby

USER ruby

ENV PATH $HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH

WORKDIR /home/ruby

RUN touch main.rb \
 && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile \
 && echo 'eval "$(rbenv init -)"' >> ~/.bash_profile \
 && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
 && git clone http://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
 && RUBY_CONFIGURE_OPTS=--disable-install-doc ~/.rbenv/bin/rbenv install 2.5.8 \
 && RUBY_CONFIGURE_OPTS=--disable-install-doc ~/.rbenv/bin/rbenv install 2.6.6 \
 && RUBY_CONFIGURE_OPTS=--disable-install-doc ~/.rbenv/bin/rbenv install 2.7.1 \
 && ~/.rbenv/bin/rbenv global 2.7.1 \
 && RBENV_VERSION=2.5.8 ~/.rbenv/shims/gem install discordrb \
 && RBENV_VERSION=2.6.6 ~/.rbenv/shims/gem install discordrb \
 && RBENV_VERSION=2.7.1 ~/.rbenv/shims/gem install discordrb

CMD ["timeout" "60" "ruby" "/home/ruby/main.rb"]