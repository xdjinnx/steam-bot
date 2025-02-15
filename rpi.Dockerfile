FROM rpi-elixir as build

RUN mkdir /app
WORKDIR /app

COPY . .

ENV MIX_ENV=prod

RUN rm -Rf _build
RUN mix deps.get
RUN mix compile

CMD mix run --no-halt