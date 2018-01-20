FROM elixir:latest

LABEL Melby Baldove <melqbaldove@gmail.com>

RUN mix local.hex --force

RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN mix local.rebar --force

WORKDIR /code