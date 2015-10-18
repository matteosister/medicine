FROM matteosister/elixir

# base
RUN apt-get update && apt-get -qqy install git && rm -r /var/lib/apt/lists/*

# app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix hex.info
WORKDIR /app

CMD ["./startup.sh"]
