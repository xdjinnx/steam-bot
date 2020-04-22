FROM joakimk/rpi-erlang:20.2.2 as image
MAINTAINER Joakim Kolsjo <joakim.kolsjo<at>gmail.com>

# This is the same as https://github.com/bitwalker/alpine-elixir except the base image.

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2020-04-22 \
    ELIXIR_VERSION=v1.9.4

WORKDIR /tmp/elixir-build

RUN \
    apk --no-cache --update upgrade && \
    apk add --no-cache --update --virtual .elixir-build \
      make && \
    apk add --no-cache --update \
      git && \
    git clone https://github.com/elixir-lang/elixir --depth 1 --branch $ELIXIR_VERSION && \
    cd elixir && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del .elixir-build

WORKDIR ${HOME}

CMD ["/bin/sh"]