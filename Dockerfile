FROM bitwalker/alpine-elixir:1.9 as build

RUN mkdir /app
WORKDIR /app

COPY . .

RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix deps.get && \
    mix release

FROM bitwalker/alpine-erlang:latest

RUN mkdir /app
WORKDIR /app
ENV HOME=/app

COPY --from=build /app/_build/prod/rel/steam_bot ./
RUN chown -R nobody: /app
USER nobody

CMD ["bin/steam_bot", "start"]