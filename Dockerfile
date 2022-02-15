FROM hexpm/elixir:1.13.0-erlang-24.1.7-debian-bullseye-20210902-slim

# install build dependencies
RUN apt-get update -y \
  && apt-get -y install curl build-essential ca-certificates git locales bash unzip

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install node & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update -y \
  && apt-get install -y nodejs \
  && npm install --global yarn

# install chromium & chromium-driver
RUN apt-get install -y chromium-driver

# apt cleanup
RUN apt-get clean && rm -f /var/lib/apt/lists/*_*

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh \
  && sh /tmp/rustup.sh -y \
  && rm /tmp/rustup.sh

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

CMD bash