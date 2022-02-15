FROM hexpm/elixir:1.13.0-erlang-24.1.7-debian-bullseye-20210902-slim

# install build dependencies
RUN apt-get update -y \
  && apt-get -y install curl gnupg lsb-release build-essential ca-certificates git locales bash unzip libxss1

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y \
  && apt-get install -y docker-ce docker-ce-cli containerd.io

# install node & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update -y \
  && apt-get install -y nodejs \
  && npm install --global yarn

# install chromium & chromium-driver
RUN apt-get install -y chromium-driver

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh \
  && sh /tmp/rustup.sh -y \
  && rm /tmp/rustup.sh

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# apt cleanup
RUN apt-get clean && rm -f /var/lib/apt/lists/*_*